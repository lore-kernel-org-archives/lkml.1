Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYLTVcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYLTVcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 16:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYLTVcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 16:32:00 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:51576 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbYLTVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 16:31:59 -0500
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: "APIC error on CPU1: 00(40)" during resume
Date: Sat, 20 Dec 2008 22:31:52 +0100
User-Agent: KMail/1.9.9
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
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812100819570.3340@localhost.localdomain> <20081210173343.GA1120@elte.hu>
In-Reply-To: <20081210173343.GA1120@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812202231.55784.elendil@planet.nl>
X-OriginalArrivalTime: 20 Dec 2008 21:31:56.0439 (UTC) FILETIME=[62182A70:01C962EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008, Ingo Molnar wrote:
> regarding those APIC error messages:
> >        ACPI: Waking up from system sleep state S3
> >        APIC error on CPU1: 00(40)
> >        ACPI: EC: non-query interrupt received, switching to interrupt
>
> that does suggest that the APIC was re-enabled (we dont get any APIC
> error exceptions otherwise!), and its LVT was programmed as well, but
> somehow we got an erroneous APIC message from an illegal vector.

I wonder if this may help tracing the cause. Today I got a KERN_ERR in the 
middle of those messages:

ACPI: Waking up from system sleep state S3
BUG: sleeping function called from invalid context at kernel/sched.c:5571
in_atomic(): 0, irqs_disabled(): 1, pid: 70, name: kacpid
Pid: 70, comm: kacpid Not tainted 2.6.28-rc7-rjw #77
Call Trace:
 [<ffffffff80345013>] ? acpi_os_release_object+0x9/0xd
 [<ffffffff8022d588>] __might_sleep+0xcf/0xd1
 [<ffffffff80234e32>] __cond_resched+0x15/0x4b
 [<ffffffff8043b1d7>] _cond_resched+0x2d/0x38
 [<ffffffff80357bc9>] acpi_ps_complete_op+0x235/0x24b
 [<ffffffff803582de>] acpi_ps_parse_loop+0x6ff/0x859
 [<ffffffff803574db>] acpi_ps_parse_aml+0x7c/0x2bb
 [<ffffffff80358a35>] acpi_ps_execute_method+0x144/0x213
 [<ffffffff80354e9e>] acpi_ns_evaluate+0x152/0x230
 [<ffffffff803452d0>] ? acpi_os_execute_deferred+0x0/0x39
 [<ffffffff8034c6a6>] acpi_ev_asynch_execute_gpe_method+0xc1/0x119
 [<ffffffff803452fc>] acpi_os_execute_deferred+0x2c/0x39
 [<ffffffff802480c7>] run_workqueue+0x95/0x12a
 [<ffffffff80248251>] worker_thread+0xf5/0x109
 [<ffffffff8024b9cb>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8024815c>] ? worker_thread+0x0/0x109
 [<ffffffff8024b678>] kthread+0x49/0x76
 [<ffffffff8020d009>] child_rip+0xa/0x11
 [<ffffffff8022da41>] ? pick_next_task_fair+0x8b/0x93
 [<ffffffff8024b62f>] ? kthread+0x0/0x76
 [<ffffffff8020cfff>] ? child_rip+0x0/0x11
APIC error on CPU1: 00(40)
ACPI: EC: non-query interrupt received, switching to interrupt mode

This is the first time I've seen this error. Kernel is based on commit 
f6f7b52e2f61 (just after -rc7) and includes the final versions of the 
patches Rafael posted in this thread [1].

More complete log available on request.

Cheers,
FJP

[1] http://lkml.org/lkml/2008/12/6/69
