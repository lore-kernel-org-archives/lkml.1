Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZJ0Rqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZJ0Rqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZJ0Rqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:46:31 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61413 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZJ0Rqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HjYppNFlOjYQ1s2mlmpsHMN5kZenX3NbmPjFqtlnOPkwI2eKCRO+RXRR8x4FVXWEcn
         vpDGZjyFBbNgpPWaqWRMYEj73kFZsbAljxFdXiUXjnq5Ty2fX5CClgSBqoWAa44nu1h+
         DHmXPgODHyCM55JbdX7yIc5vy8enB7iDk/anc=
MIME-Version: 1.0
In-Reply-To: <c62985530910271039u6abd166dvcac48da098bf201f@mail.gmail.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <cover.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
	 <6ad82af0c2ec8ef7b9f536b0a97bf65d385c3945.1256483735.git.wuzhangjin@gmail.com>
	 <c62985530910251736ye7551c4l1a62a1ba242a191f@mail.gmail.com>
	 <1256542000.5642.118.camel@falcon>
	 <c62985530910271039u6abd166dvcac48da098bf201f@mail.gmail.com>
Date: Tue, 27 Oct 2009 18:46:34 +0100
Message-ID: <c62985530910271046p36866698l20597b90e3b826e6@mail.gmail.com>
Subject: Re: [PATCH -v5 09/11] tracing: add IRQENTRY_EXIT for MIPS
From: Frederic Weisbecker <fweisbec@gmail.com>
To: wuzhangjin@gmail.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/27 Frederic Weisbecker <fweisbec@gmail.com>:
> 2009/10/26 Wu Zhangjin <wuzhangjin@gmail.com>:
>> ooh, Sorry, only this patch added(I stopped after fixing the compiling
>> errors, no more check! so lazy a guy!).
>>
>> Just checked the source code of MIPS, the do_IRQ() is defined as a
>> macro, so, I must move the macro to a C file, and also, there is a
>> irq_enter...irq_exit block in a "big" function, I need to split it out.
>>
>> [...]
>> /*
>>  * do_IRQ handles all normal device IRQ's (the special
>>  * SMP cross-CPU interrupts have their own specific
>>  * handlers).
>>  *
>>  * Ideally there should be away to get this into kernel/irq/handle.c to
>>  * avoid the overhead of a call for just a tiny function ...
>>  */
>> #define do_IRQ(irq)
>> \
>> do {
>> \
>>        irq_enter();
>> \
>>        __DO_IRQ_SMTC_HOOK(irq);
>> \
>>        generic_handle_irq(irq);
>> \
>>        irq_exit();
>> \
>> } while (0)
>> [...]
>>
>> But The comment told us: do not make this tiny function be a standalone
>> function, so???
>
>
> I can't check that currently. But may be the caller of this m


Sorry, my message has been sent in the middle. I'm dealing with a
strange keyboard where
I am (and also with my strange hands).

So, may be the caller of this macro can take the irqentry tag?


>
>
>>
>> the same to do_IRQ_no_affinity.
>>
>> and, about the following function, I need to split the
>> irq_enter()...irq_exit() block out.
>>
>> void ipi_decode(struct smtc_ipi *pipi)
>> {
>>        [...]
>>        switch (type_copy) {
>>        case SMTC_CLOCK_TICK:
>>                irq_enter();
>>                kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
>>                cd = &per_cpu(mips_clockevent_device, cpu);
>>                cd->event_handler(cd);
>>                irq_exit();
>>                break;
>>
>>        case LINUX_SMP_IPI:
>>                switch ((int)arg_copy) {
>>                case SMP_RESCHEDULE_YOURSELF:
>>                        ipi_resched_interrupt();
>>                        break;
>>                case SMP_CALL_FUNCTION:
>>                        ipi_call_interrupt();
>>                        break;
>>        [...]
>>


Oh right, this one is more tricky. Well, if that's important for
someone, we can deal with that later.
