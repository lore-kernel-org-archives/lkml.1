Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYDPR7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYDPR7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYDPR7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:59:25 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:54203 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbYDPR7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:59:24 -0400
Date: Wed, 16 Apr 2008 20:59:02 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, nouveau@lists.freedesktop.org
Subject: Re: [BUG/PATCH] x86 mmiotrace: dynamically disable non-boot CPUs
Message-ID: <20080416205902.6186d349@daedalus.pq.iki.fi>
In-Reply-To: <20080416114609.GA20054@elte.hu>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
	<20080413230552.33ca587a@daedalus.pq.iki.fi>
	<20080414065713.GB16163@elte.hu>
	<20080414210242.2329997d@daedalus.pq.iki.fi>
	<20080416114609.GA20054@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 13:46:09 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Pekka Paalanen <pq@iki.fi> wrote:
> 
> > > we should fix this restriction ASAP. Forcibly dropping to UP will 
> > > cause mmiotrace to be much less useful for diagnostic purposes of 
> > > Linux
> > 
> > Ok, how do you propose we solve this?
> > 
> > I have asked the question before, and then I had two ideas. Well, the
> > first one was actually your idea (so I hear) to solve the same problem for
> > kmemcheck.
> > - per-cpu page tables
> > - instead of single-stepping, emulate the faulting instruction and never
> > disarm pages during tracing. (Use and modify code from KVM.)
> > 
> > I don't believe either of these is easy or fast to implement. Given 
> > some months, I might be able to achieve emulation. Page tables are 
> > still magic to me.
> 
> yeah - it looks complex. Not a showstopper for now :-)
> 
> but given that Xorg is usually just a single task, do we _really_ need 
> this?

We're not tracing Xorg at all. Mmiotrace still cannot catch accesses
originating in user space. It is tracing MMIO accesses from within
the kernel, and this means that IRQ services and device syscalls
may be accessing the hardware at the same time. Vblank interrupts
happen quite often, some GPU commands are actually emulated in
kernel via interrupts and whatnot. The nvidia proprietary kernel blob
is many times bigger than my bzImage!

(A simple X startup and quit creates in the order of 1-2 million
MMIO events.)

As do we really need this, I think it might save a lot of head
scratching when someone is reverse engineering a feature and gets
every time a different trace due to some events being missed.
But this is theory. So far everyone has been tracing with UP,
and this has not been a problem. I have no idea if it would make
a real difference.

[Recap for nouveau@ list:
mmiotrace has a race on SMP, where during instruction single stepping
other CPUs can run freely on the page which the faulted instruction
accessed. This causes some of the simultaneous accesses to the same
page of the same iomem-mapping to be missed.]

It does sound very rare. Nouveau people, what do you think, can this
be a problem?

> > > i suspect the bug is that you bring the CPU down from an atomic 
> > > (spinlocked or irq disabled) context.
> > 
> > Hmm, it should not be... I have to double-check, but all the other 
> > code, too, from where enter_uniprocessor() is called, may sleep. The 
> > first thing the caller does is to acquire a mutex, which I assume 
> > would complain loudly if spinlocked or irq-disabled.
> > 
> > Ingo, thank you for fixing this patch, though I'd like to suggest to 
> > leave it out for now, since there clearly are worse problems with it 
> > than without it. And if we can solve the SMP issue, this is not 
> > needed. For the time being we can just instruct users to disable all 
> > but one CPU when try want to trace.
> 
> i think we still need to make this as 'transparent' to users as 
> possible. Disabling CPUs can be tedious.

Compared to the out-of-tree mmiotrace, the in-kernel version is already
a lot easier to use. Instructing people to drop to UP before tracing
is simple compared to what it was.

> i'm leaving out this patch from the series for now.

Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
