Return-Path: <linux-kernel-owner+w=401wt.eu-S2992571AbXCGU4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992571AbXCGU4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992572AbXCGU4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:56:12 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42740 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992571AbXCGU4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:56:10 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 12:56:07 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <45EF20F7.1050307@goop.org>
Message-ID: <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
 <20070307233833.f1482f86.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
 <45EF20F7.1050307@goop.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Jeremy Fitzhardinge wrote:

> Davide Libenzi wrote:
> > On Wed, 7 Mar 2007, Linus Torvalds wrote:
> >
> >   
> >> On Wed, 7 Mar 2007, Stephen Rothwell wrote:
> >>     
> >>> You probably need the queue anyway because the real time signals are
> >>> supposed to queue.
> >>>       
> >> Davide - the *real* problem is (I think) that you try to allow signals to 
> >> be returned *both* by signalfd() and as a real signal.
> >>
> >> That's wrong, wrong, wrong.
> >>
> >> My original patch used "dequeue_signal()" to dequeue signals. Trust me, I 
> >> did that for a reason. Your re-design to think that you can get the signal 
> >> without using the real signal dequeueing is simply broken.
> >>     
> >
> > I think having the ability to have both can be usefull, so the idea of 
> > having multiple listeners fd (that both would not work with the single 
> > queue since they'd racing over dequeue_signal).
> >   
> 
> Do you have a specific use-case in mind?  Because I don't think this is
> very useful at all; in fact it may be the opposite of useful.
> 
> Generally signals are "owned" by one particular piece of code, and if
> you want to distribute the event further then you do that in the app, as
> you have to do with a normal signal handler.  This code is the fd-based
> analog of sigtimedwait, and so it should behave basically the same way. 
> If multiple threads call sigtimedwait on the same signal set, then one
> and only one will receive each signal.  This is good, because it means
> you can have a thread pool processing signals (and other events) knowing
> that there won't be duplicate processing.
> 
> I haven't looked at your code in detail, but it isn't clear from your
> description whether you can have multiple signalfds for different
> (distinct) sets of signals.  That would be useful as a first level of
> demultiplexing between multiple user-mode signal consumers.  If you
> allow that, you need to decide whether a read/poll on a signalfd blocks
> until the head queued signal is part of the signal set, or if any queued
> signal is in the set.

If you think a signal as a generic event source, than you see how more 
instances can attach to it and receive them.
You can have multiple signalfd with whatever sigmasks, even intersecting. 
You can pass the fd around, w/out the fear that a standard signal delivery 
would race with you on dequeue_signal (making you block after you got a 
POLLIN). You can have both standard and file based devliery, or you can 
not. Up to you. If you don't want to, you block them, otherwise you 
don't. It's flexible, and the code is like 20 lines more, and race-free.
Since the siginfo needed to be delivered too, at that point doing it over 
a read(2) would have messed up things [1], so I added a new syscall:

int signalfd_dequeue(int fd, siginfo_t *info, long timeo);

And the compat_ counter-part.



[1] I thought about having a compat-free siginfo to be pulled from 
    read(2), but that resulted to be messy, while we already have code to 
    ship siginfos to userspace.


- Davide


