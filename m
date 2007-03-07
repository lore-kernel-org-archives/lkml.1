Return-Path: <linux-kernel-owner+w=401wt.eu-S2992622AbXCGVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992622AbXCGVf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992628AbXCGVf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:35:29 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42753 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992622AbXCGVf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:35:28 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 13:35:25 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <45EF2DFF.4060209@goop.org>
Message-ID: <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
 <20070307233833.f1482f86.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
 <45EF20F7.1050307@goop.org> <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
 <45EF2DFF.4060209@goop.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Jeremy Fitzhardinge wrote:

> Davide Libenzi wrote:
> > If you think a signal as a generic event source, than you see how more 
> > instances can attach to it and receive them.
> > You can have multiple signalfd with whatever sigmasks, even intersecting. 
> > You can pass the fd around, w/out the fear that a standard signal delivery 
> > would race with you on dequeue_signal (making you block after you got a 
> > POLLIN).
> Well, I think using both this mechanism and normal signal delivery would
> be pretty much insane.  But if you do, then the only sane way to use the
> interface is if each signal is delivered once - and only once - by
> whatever mechanism (otherwise how would you be able to distinguish
> between the same signal duplicated vs two signals which look very
> similar?).  If you're really worried about losing a signal between poll
> and read you can always make the fd nonblocking.

You have the *choice* to do that:

1) You want standard delivery only:

   - Just dont use signalfd

2) you want signalfd only:

   - Do a sigprocmask(SIG_BLOCK) of the same mask you pass to signalfd

If you want both, you can have it. Race free.



> >  You can have both standard and file based devliery, or you can 
> > not. Up to you. If you don't want to, you block them, otherwise you 
> > don't. It's flexible, and the code is like 20 lines more, and race-free.
> >   
> 
> OK, but if you allow the kernel to duplicate along different delivery
> paths, usermode pretty much has to go to the effort of making sure
> there's only one delivery path in order to keep track of how many
> signals really appeared.
> 
> The only way to make duplication sane is to guarantee that if a signal
> path *can* deliver a signal, it *will* deliver the signal, so that
> usermode has some chance of correlating queued signals along each path.
> 
> But if you do that, then you end up with bad results.  If you have a
> signal blocked, then it means you're obligated to keep the signal queued
> forever in case the signal gets unblocked, even if usermode already got
> it via a signalfd and has no intention of ever unblocking the signal. 
> Similarly with a signalfd that never gets read.  And if you fill the
> pending signal queue, do you start dropping signals?

In the next patch set (v2), if a GFP_ATOMIC slab alloc fails in allocate a 
queue item, I incrememt a lost_sigs variable in the context, and poll(2) 
will return POLLERR.



> > Since the siginfo needed to be delivered too, at that point doing it over 
> > a read(2) would have messed up things [1], so I added a new syscall:
> >
> > int signalfd_dequeue(int fd, siginfo_t *info, long timeo);
> >
> > And the compat_ counter-part.
> >
> >
> >
> > [1] I thought about having a compat-free siginfo to be pulled from 
> >     read(2), but that resulted to be messy, while we already have code to 
> >     ship siginfos to userspace.
> >   
> 
> Hm.  Yeah, that's tough.  If you have a 32-bit and 64-bit process
> reading from the same signalfd source, would you expect them to return
> the same format or different?

The signalfd_dequeue() has a compat layer that uses "struct compat_siginfo".



- Davide


