Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839Ab0AIWv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0AIWv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 17:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040Ab0AIWv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 17:51:27 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:48499 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0AIWv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 17:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SopWOGo5oPjHEgBFt6LETZOW1RMLPoq4mL95+1eXtGD+RJQAyoDevZhpK2B4NCDkZc
         YbAEEU2C4A3PSkkaeyAG2oJijYgj7lwgm7G9LUbrsdA1Qtura1KsdFDZi0d/Uid10Axg
         ioip8WZ/+xYVLhR7bh8/D8VvMbv0agrwjgOUc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001091007150.7821@localhost.localdomain>
References: <20100109101038.GA17555@in.ibm.com>
	 <alpine.LFD.2.00.1001091007150.7821@localhost.localdomain>
Date: Sat, 9 Jan 2010 14:51:26 -0800
X-Google-Sender-Auth: 7fe1a32c0f28d999
Message-ID: <86802c441001091451t1edcfd26m9368628b6cc4f711@mail.gmail.com>
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>, suresh.b.siddha@intel.com,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 9, 2010 at 10:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 9 Jan 2010, Ananth N Mavinakayanahalli wrote:
>>
>> On an 8-way system with Intel Xeon X7350 CPUs, booting 2.6.32 or newer
>> kernels fails at:
>>
>> ...
>> CPU0: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz stepping 0b
>> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
>> Brought up 8 CPUs
>> Total of 8 processors activated (46906.05 BogoMIPS).
>>
>> Git bisect showed 2fbd07a5f as the offending commit.
>
> Ok, that commit definitely is buggy.
>
>> With the patch below, I am able to boot the latest Linus' git tree on
>> the machine. If this patch is correct, it needs to get into the stable
>> tree too.
>
> I don't think the patch is correct, though. The thing is, the AMD check
> seems to be the correct one: you can only use 'apic_flat' if all the APIC
> ID's are < 8.
>
> It doesn't matter _how_ many CPU's you have. If you have two CPU's, but
> one of them has an APIC ID >= 8, then you cannot use the flat APIC model,
> since it depends on a 8-bit bitfield.
>
> So your patch doesn't seem right either, because it still tests
> num_processors, which is bogus.
>
> In fact, I can't for the life of me understand why it treats different
> vendors differently. Why is that code not just a simple
>
>        /* Flat apic mode requires that all APIC ID's are in the range 0..7 */
>        if (apic == &apic_flat && max_physical_apicid >= 8)
>                apic = &apic_physflat;
>
> instead, with no crazy vendor tests.
>
> What am I missing?

according to Suresh, intel CPUs could use logical flat mode when total
num_cpus <=8 even some cpu's physical apicid > 0.

and init_apic_ldr should set ldr to the cpu to map cpu index to the cpu.

static void flat_init_apic_ldr(void)
{
        unsigned long val;
        unsigned long num, id;

        num = smp_processor_id();
        id = 1UL << num;
        apic_write(APIC_DFR, APIC_DFR_FLAT);
        val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
        val |= SET_APIC_LOGICAL_ID(id);
        apic_write(APIC_LDR, val);
}

in Ananth's case, APs are started, so LDR should be set correctly.

YH
