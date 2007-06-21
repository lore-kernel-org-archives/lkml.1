Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXFUSrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXFUSrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXFUSrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:47:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbXFUSrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:47:16 -0400
Date: Thu, 21 Jun 2007 11:44:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
Message-ID: <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Eric Dumazet wrote:
> 
> This reminds me Nick's proposal of 'queued spinlocks' 3 months ago
> 
> Maybe this should be re-considered ? (unlock is still a non atomic op, 
> so we dont pay the serializing cost twice)

No. The point is simple:

	IF YOU NEED THIS, YOU ARE DOING SOMETHING WRONG!

I don't understand why this is even controversial. Especially since we 
have a patch for the problem that proves my point: the _proper_ way to fix 
things is to just not do the bad thing, instead of trying to allow the bad 
behaviour and try to handle it.

Things like queued spinlocks just make excuses for bad code. 

We don't do nesting locking either, for exactly the same reason. Are 
nesting locks "easier"? Absolutely. They are also almost always a sign of 
a *bug*. So making spinlocks and/or mutexes nest by default is just a way 
to encourage bad programming!

> extract : 
> 
> Implement queued spinlocks for i386. This shouldn't increase the size of
> the spinlock structure, while still able to handle 2^16 CPUs.

Umm. i386 spinlocks could and should be *one*byte*.

In fact, I don't even know why they are wasting four bytes right now: the 
fact that somebody made them an "int" just wastes memory. All the actual 
code uses "decb", so it's not even a question of safety. I wonder why we 
have that 32-bit thing and the ugly casts.

Ingo, any memory of that?

(And no, on 32-bit x86, we don't allow more than 128 CPU's. I don't think 
such an insane machine has ever existed).

		Linus
