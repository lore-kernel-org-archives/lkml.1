Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbYH2D2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbYH2D2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 23:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYH2D2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 23:28:36 -0400
Received: from gw.goop.org ([64.81.55.164]:38656 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYH2D2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 23:28:35 -0400
Message-ID: <48B76CE0.5010309@goop.org>
Date: Thu, 28 Aug 2008 20:28:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org> <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
In-Reply-To: <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, Aug 28, 2008 at 12:52 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Some BIOSes have been observed to corrupt memory in the low 64k.  This
>> patch does two things:
>>  - Reserves all memory which does not have to be in that area, to
>>   prevent it from being used as general memory by the kernel.  Things
>>   like the SMP trampoline are still in the memory, however.
>>  - Clears the reserved memory so we can observe changes to it.
>>  - Adds a function check_for_bios_corruption() which checks and reports on
>>   memory becoming unexpectedly non-zero.  Currently it's called in the
>>   x86 fault handler, and the powermanagement debug output.
>>
>> RFC: What other places should we check for corruption in?
>>
>> [ Alan, Rafa³: could you check you see:
>>   1: corruption messages
>>   2: no crashes
>>  Thanks -J
>> ]
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>> Cc: Hugh Dickens <hugh@veritas.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Rafa³ Mi³ecki <zajec5@gmail.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> ---
>>  Documentation/kernel-parameters.txt |    5 ++
>>  arch/x86/Kconfig                    |    3 +
>>  arch/x86/kernel/setup.c             |   86 +++++++++++++++++++++++++++++++++++
>>  arch/x86/mm/fault.c                 |    2
>>  drivers/base/power/main.c           |    1
>>  include/linux/kernel.h              |   12 ++++
>>  6 files changed, 109 insertions(+)
>>
>> ===================================================================
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -359,6 +359,11 @@
>>                        BayCom Serial Port AX.25 Modem (Half Duplex Mode)
>>                        Format: <io>,<irq>,<mode>
>>                        See header of drivers/net/hamradio/baycom_ser_hdx.c.
>> +
>> +       bios_corruption_check=0/1 [X86]
>> +                       Some BIOSes seem to corrupt the first 64k of memory
>> +                       when doing things like suspend/resume.  Setting this
>> +                       option will scan the memory looking for corruption.
>>
>>        boot_delay=     Milliseconds to delay each printk during boot.
>>                        Values larger than 10 seconds (10000) are changed to
>> ===================================================================
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -203,6 +203,9 @@
>>        bool
>>        depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
>>        default y
>> +
>> +config X86_CHECK_BIOS_CORRUPTION
>> +        def_bool y
>>
>>  config KTIME_SCALAR
>>        def_bool X86_32
>> ===================================================================
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -582,6 +582,88 @@
>>  struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
>>
>>  /*
>> + * Some BIOSes seem to corrupt the low 64k of memory during events
>> + * like suspend/resume and unplugging an HDMI cable.  Reserve all
>> + * remaining free memory in that area and fill it with a distinct
>> + * pattern.
>> + */
>> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
>> +#define MAX_SCAN_AREAS 8
>> +static struct e820entry scan_areas[MAX_SCAN_AREAS];
>> +static int num_scan_areas;
>> +
>> +static void __init setup_bios_corruption_check(void)
>> +{
>> +       u64 addr = PAGE_SIZE;   /* assume first page is reserved anyway */
>> +
>>     
>
> can you please not punish systems without this bios problem?
>
> if (!bios_corruption_check)
>    return;
>   

Yeah, OK, but I think it should default to ON for now.  The problem is
that we had two very different systems (Sony Vaio and Intel desktop)
exhibit the same problem in two different ways.  These systems worked
fine until we slightly changed the way that pagetable memory was
allocated.  We just don't know how many other systems are doing this
kind of subtle corruption of low memory.

    J
