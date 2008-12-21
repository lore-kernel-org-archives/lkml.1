Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYLUIal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYLUIal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 03:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYLUIac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 03:30:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42209 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYLUIab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 03:30:31 -0500
Date: Sun, 21 Dec 2008 09:29:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>, Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>, lenb@kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       jbarnes@virtuousgeek.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: "APIC error on CPU1: 00(40)" during resume
Message-ID: <20081221082947.GB6395@elte.hu>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812100819570.3340@localhost.localdomain> <20081210173343.GA1120@elte.hu> <200812202231.55784.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812202231.55784.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> On Wednesday 10 December 2008, Ingo Molnar wrote:
> > regarding those APIC error messages:
> > >        ACPI: Waking up from system sleep state S3
> > >        APIC error on CPU1: 00(40)
> > >        ACPI: EC: non-query interrupt received, switching to interrupt
> >
> > that does suggest that the APIC was re-enabled (we dont get any APIC
> > error exceptions otherwise!), and its LVT was programmed as well, but
> > somehow we got an erroneous APIC message from an illegal vector.
> 
> I wonder if this may help tracing the cause. Today I got a KERN_ERR in the 
> middle of those messages:
> 
> ACPI: Waking up from system sleep state S3
> BUG: sleeping function called from invalid context at kernel/sched.c:5571
> in_atomic(): 0, irqs_disabled(): 1, pid: 70, name: kacpid
> Pid: 70, comm: kacpid Not tainted 2.6.28-rc7-rjw #77
> Call Trace:
>  [<ffffffff80345013>] ? acpi_os_release_object+0x9/0xd
>  [<ffffffff8022d588>] __might_sleep+0xcf/0xd1
>  [<ffffffff80234e32>] __cond_resched+0x15/0x4b
>  [<ffffffff8043b1d7>] _cond_resched+0x2d/0x38
>  [<ffffffff80357bc9>] acpi_ps_complete_op+0x235/0x24b
>  [<ffffffff803582de>] acpi_ps_parse_loop+0x6ff/0x859
>  [<ffffffff803574db>] acpi_ps_parse_aml+0x7c/0x2bb
>  [<ffffffff80358a35>] acpi_ps_execute_method+0x144/0x213
>  [<ffffffff80354e9e>] acpi_ns_evaluate+0x152/0x230
>  [<ffffffff803452d0>] ? acpi_os_execute_deferred+0x0/0x39
>  [<ffffffff8034c6a6>] acpi_ev_asynch_execute_gpe_method+0xc1/0x119
>  [<ffffffff803452fc>] acpi_os_execute_deferred+0x2c/0x39
>  [<ffffffff802480c7>] run_workqueue+0x95/0x12a
>  [<ffffffff80248251>] worker_thread+0xf5/0x109
>  [<ffffffff8024b9cb>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffff8024815c>] ? worker_thread+0x0/0x109
>  [<ffffffff8024b678>] kthread+0x49/0x76
>  [<ffffffff8020d009>] child_rip+0xa/0x11
>  [<ffffffff8022da41>] ? pick_next_task_fair+0x8b/0x93
>  [<ffffffff8024b62f>] ? kthread+0x0/0x76
>  [<ffffffff8020cfff>] ? child_rip+0x0/0x11
> APIC error on CPU1: 00(40)
> ACPI: EC: non-query interrupt received, switching to interrupt mode
> 
> This is the first time I've seen this error. Kernel is based on commit 
> f6f7b52e2f61 (just after -rc7) and includes the final versions of the 
> patches Rafael posted in this thread [1].
> 
> More complete log available on request.

hm, that warning seems to show an ACPI bug (Len Cc:-ed): we preempt in an 
atomic section - right during executing an AML scriptlet. Executing ACPI 
AMLs is a rather fragile moment of the kernel: they are used by the BIOS 
to indirectly instruct the kernel to tweak lowlevel chipset registers and 
other platform details.

The kernel executes AMLs 'blindly' - they tweak details that Linux 
typically has no knowledge about via any driver - so these things must 
absolutely run atomic, and scheduling away in the wrong moment (which 
means implicitly re-enabling interrupts) can leave the system in an 
inconsistent state.

This 'blindness' and opaqueness of AML execution is perhaps the nastiest 
aspect of the whole ACPI engine (because their opacity makes them 
undebuggable and unfixable in essence). Nevertheless, it still might be 
some unrelated phenomenon to your APIC illegal vector errors.

	Ingo
