Return-Path: <linux-kernel-owner+w=401wt.eu-S965658AbXCGV01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658AbXCGV01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965659AbXCGV01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:26:27 -0500
Received: from gw.goop.org ([64.81.55.164]:51836 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965658AbXCGV00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:26:26 -0500
Message-ID: <45EF2DFF.4060209@goop.org>
Date: Wed, 07 Mar 2007 13:26:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com> <20070307155553.06c82ca1.sfr@canb.auug.org.au> <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com> <20070307233833.f1482f86.sfr@canb.auug.org.au> <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org> <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com> <45EF20F7.1050307@goop.org> <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> If you think a signal as a generic event source, than you see how more 
> instances can attach to it and receive them.
> You can have multiple signalfd with whatever sigmasks, even intersecting. 
> You can pass the fd around, w/out the fear that a standard signal delivery 
> would race with you on dequeue_signal (making you block after you got a 
> POLLIN).
Well, I think using both this mechanism and normal signal delivery would
be pretty much insane.  But if you do, then the only sane way to use the
interface is if each signal is delivered once - and only once - by
whatever mechanism (otherwise how would you be able to distinguish
between the same signal duplicated vs two signals which look very
similar?).  If you're really worried about losing a signal between poll
and read you can always make the fd nonblocking.

>  You can have both standard and file based devliery, or you can 
> not. Up to you. If you don't want to, you block them, otherwise you 
> don't. It's flexible, and the code is like 20 lines more, and race-free.
>   

OK, but if you allow the kernel to duplicate along different delivery
paths, usermode pretty much has to go to the effort of making sure
there's only one delivery path in order to keep track of how many
signals really appeared.

The only way to make duplication sane is to guarantee that if a signal
path *can* deliver a signal, it *will* deliver the signal, so that
usermode has some chance of correlating queued signals along each path.

But if you do that, then you end up with bad results.  If you have a
signal blocked, then it means you're obligated to keep the signal queued
forever in case the signal gets unblocked, even if usermode already got
it via a signalfd and has no intention of ever unblocking the signal. 
Similarly with a signalfd that never gets read.  And if you fill the
pending signal queue, do you start dropping signals?

> Since the siginfo needed to be delivered too, at that point doing it over 
> a read(2) would have messed up things [1], so I added a new syscall:
>
> int signalfd_dequeue(int fd, siginfo_t *info, long timeo);
>
> And the compat_ counter-part.
>
>
>
> [1] I thought about having a compat-free siginfo to be pulled from 
>     read(2), but that resulted to be messy, while we already have code to 
>     ship siginfos to userspace.
>   

Hm.  Yeah, that's tough.  If you have a 32-bit and 64-bit process
reading from the same signalfd source, would you expect them to return
the same format or different?


    J
