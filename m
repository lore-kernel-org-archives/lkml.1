Return-Path: <linux-kernel-owner+w=401wt.eu-S1422977AbXCGRvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422977AbXCGRvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422948AbXCGRvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:51:01 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42656 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422968AbXCGRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:50:11 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 09:50:10 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
 <20070307233833.f1482f86.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Linus Torvalds wrote:

> On Wed, 7 Mar 2007, Stephen Rothwell wrote:
> > 
> > You probably need the queue anyway because the real time signals are
> > supposed to queue.
> 
> Davide - the *real* problem is (I think) that you try to allow signals to 
> be returned *both* by signalfd() and as a real signal.
> 
> That's wrong, wrong, wrong.
> 
> My original patch used "dequeue_signal()" to dequeue signals. Trust me, I 
> did that for a reason. Your re-design to think that you can get the signal 
> without using the real signal dequeueing is simply broken.

I think having the ability to have both can be usefull, so the idea of 
having multiple listeners fd (that both would not work with the single 
queue since they'd racing over dequeue_signal).
The two place where I plugges signalfd_notify() has the siginfo already 
compiled, so I just need to:

1) Pass the siginfo pointer to signalfd_notify too

2) Switch from having a bitmap, to a struct list_head queue

3) Dequeue and return the signal and siginfo inside a compat-free 
   structure

The #2 makes code even easier actually. The poll would just do a 
list_empty(), and dequeueing is just get-head and list_del().



- Davide


