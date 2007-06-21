Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbXFUVAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbXFUVAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbXFUVAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:00:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756011AbXFUVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:00:45 -0400
Date: Thu, 21 Jun 2007 13:58:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [patch] spinlock debug: make looping nicer
In-Reply-To: <20070621204234.GA1510@elte.hu>
Message-ID: <alpine.LFD.0.98.0706211352530.3593@woody.linux-foundation.org>
References: <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org>
 <20070621200941.GB22303@elte.hu> <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org>
 <20070621204234.GA1510@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ingo Molnar wrote:
> 
> btw., back then we also tried a spin_is_locked() based inner loop but it 
> didnt help the ->tree_lock lockups either. In any case i very much agree 
> that the 'nicer' looping should be added again - the patch below does 
> that. (build and boot tested)

Ok, I'm definitely not going to apply it right now, though.

> and the reason that this didnt help the ->tree_lock lockup is likely the 
> same why wait_task_inactive() broke _independently_ of the 'niceness' of 
> the spin-lock operation: there were too few instructions between 
> releasing the lock and re-acquiring it again can cause permanent 
> starvation of another CPU. No amount of logic on the spinning side can 
> overcome this, if acquire/release critical sections are following each 
> other too fast.

Exactly.

The only way to handle that case is to make sure that the person who 
*gets* the spinlock will slow down. The person who doesn't get it can't do 
anything at all about the fact that he's locked out.

A way to do that (as already mentioned) is to have a "this lock is 
contended" flag, and have the person who gets the lock do something about 
it (where the "something" might actually be as simple as saying "When I 
release a lock that somebody marked as having lots of contention, I will 
clear the contention flag, and then just delay myself").

Side note: that trivial approach only really helps for a *single* thread 
that gets it very much (like the example in wait_task_inactive). For true 
contention with multiple different CPU's that can *all* have the bad 
behaviour, you do actually need real queueing.

			Linus
