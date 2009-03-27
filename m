Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZC0MEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZC0MEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZC0MEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:04:21 -0400
Received: from www.tglx.de ([62.245.132.106]:39565 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZC0MEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:04:20 -0400
Date: Fri, 27 Mar 2009 13:04:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Philippe Reynes <philippe.reynes@isismpp.fr>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Announce] 2.6.29-rt1
In-Reply-To: <gqic7t$c27$1@ger.gmane.org>
Message-ID: <alpine.LFD.2.00.0903271236270.3397@localhost.localdomain>
References: <49b7c2350903260354p6eaf50ebo87985dcfb8d48ba0@mail.gmail.com> <gqi6oc$1s3$1@ger.gmane.org> <gqic7t$c27$1@ger.gmane.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, Philippe Reynes wrote:

> Hi all
> 
> I've tried to remove the mlockall(MCL_CURRENT|MCL_FUTURE)
> and now, the kernel don't crash. But a data corruption 
> appear in the data saved by the application. Such corruption
> never occurs with other kernel (2.6.28 and 2.6.29). I'll
> investigate if it could be an application bug.

I don't think that mlockall or the application is the culprit. The bug
happens in the middle of the slab cache code.

> > server calling Oops: Exception in kernel mode, sig: 5 [#1] PREEMPT
> > MPC837x RR605
> > Modules linked in:
> > NIP: c0075b08 LR: c0075a50 CTR: c00d7d90 REGS: dbb6dcb0 TRAP: 0700   Not
> > tainted  (2.6.29-rt1) MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 24002488  XER:
> > 00000000 TASK = dddea1e0[1769] 'vsftpd' THREAD: dbb6c000 GPR00: 00000001
> > dbb6dd60 dddea1e0 df803e24 df803e10 df803e08 00000000 ddc72020
> > GPR08: 00000000 0000001b dddea1e0 df803e24 24000482 100bf094 00000000
> > c04aa6fc
> > GPR16: 00200200 00100100 c04e5958 c04e595c dbb6dd68 c04e0000 c04e0000
> > c04aa6bc
> > GPR24: 00000020 dbb6ddd8 00000010 df80ae00 00000000 dbb6de38 df816800
> > df803e00
> > NIP [c0075b08] cache_alloc_refill+0x180/0x62c

addr2line -e vmlinux c0075b08
linux-2.6.29/mm/slab.c:3150

That's BUG_ON(slabp->inuse >= cachep->num);

> > LR [c0075a50] cache_alloc_refill+0xc8/0x62c
> > Call Trace:
> > [dbb6dd60] [c038878c] preempt_schedule_irq+0x5c/0x80 (unreliable)

Hmm. This one is interesting. Might be we got preempted here - which
should be fine, but who knows what we missed when we reworked the
locking.

Thanks,

	tglx
