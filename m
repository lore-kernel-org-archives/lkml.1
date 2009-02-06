Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZBFTfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZBFTfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZBFTfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:35:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:36535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZBFTfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:35:31 -0500
Message-ID: <498C90D5.9030400@kernel.org>
Date: Fri, 06 Feb 2009 11:34:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Ben Greear <greearb@candelatech.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: Re: PATCH:  (v2) Allow over-ride of smp_found_cfg with kernel cmd-line
 option.
References: <498B421D.9090609@candelatech.com> <20090205195832.GD3129@elte.hu> <498C8DB7.3000005@candelatech.com> <498C8FE8.8090608@oracle.com>
In-Reply-To: <498C8FE8.8090608@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Ben Greear wrote:
>> Ingo Molnar wrote:
>>> * Ben Greear <greearb@candelatech.com> wrote:
>>>
>>>> Allow user to keep smp_found_cfg set to 1 even if MADT
>>>> cannot be parsed.  This works around funky BIOS on FWA-7304
>>>> (VIA CN700 chipset) system, and possibly other systems as well.
>>>> Without this override, performance drops by around 15% on
>>>> network throughput tests on this system.
>>> I'd _much_ rather have a warning message printed and have a default,
>>> unconditional fallback to mptable parsing in this case.
>>>
>>> I.e. same end result just no ugly and inconvenient force_smp_found_cfg.
>>>
>>> The mptable works fine in most such cases to enumerate apic details.
>>> (as it does in your case, evidently)
>>>
>>> And if both the ACPI and the MPTABLE is hosed on a box, it cannot be
>>> of much use on other OSs either, right?
>>>
>>> So please do a patch that removes the 'smp_found_config' and which
>>> changes the warning message to warn about no ACPI table in the MADT
>>> table. Ok?
>> An updated patch is attached.  It's also inline below, but I'm sure the
>> inline version is white-space corrupted.
>>
>> Do not disable mptable parsing just because there is no ACPI table
>> in the MADT table.  This effectively backs out changeset
>> 7b37b5fd9ba32c0c5afc3537eed7e7466f2173e2
>>
>> Signed-Off-By:  Ben Greear<greearb@candelatech.com>
>>
>> Thanks,
>> Ben
>>
>>
>> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
>> index d37593c..74a50b6 100644
>> --- a/arch/x86/kernel/acpi/boot.c
>> +++ b/arch/x86/kernel/acpi/boot.c
>> @@ -1379,12 +1379,14 @@ static void __init acpi_process_madt(void)
>>            * ACPI found no MADT, and so ACPI wants UP PIC mode.
>>            * In the event an MPS table was found, forget it.
>>            * Boot with "acpi=off" to use MPS on such a system.
>> +         *
>> +         * NOTE:  This assumption seems wrong in at least some cases,
>> perhaps
>> +         *  when ACPI is off in the BIOS.  Changing to a warning without
>> +         *  setting smp_found_config to zero.
>>            */
>> -        if (smp_found_config) {
>> +        if (smp_found_config)
>>              printk(KERN_WARNING PREFIX
>> -                "No APIC-table, disabling MPS\n");
>> -            smp_found_config = 0;
>> -        }
>> +                "WARNING: No ACPI-table found in the MADT\n");
> 
> 		                APIC table
> 

APIC-table == MADT

could just use

WARNING: No APIC-table found

YH
