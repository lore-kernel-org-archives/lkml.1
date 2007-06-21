Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbXFUPwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbXFUPwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXFUPwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:52:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbXFUPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:52:38 -0400
Date: Thu, 21 Jun 2007 08:50:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070621073031.GA683@elte.hu>
Message-ID: <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ingo Molnar wrote:
> 
> what worries me a bit though is that my patch that made spinlocks 
> equally agressive to that loop didnt solve the hangs!

Your parch kept doing "spin_trylock()", didn't it?

That's a read-modify-write thing, and keeps bouncing the cacheline back 
and forth, and together with the fact that even *after* you get the 
spinlock the "wait_for_inactive()" would actually end up looping back, 
releasing it, and re-getting it.

So the problem was that "wait_for_inactive()" kept the lock (because it 
actually *got* it), and looped over getting it, and because it was an 
exclusive cacheline ownership, that implies that somebody else is not 
getting it, and is kept from ever getting it.

So trying to use "trylock" doesn't help. It still has all the same bad 
sides - it still gets the lock (getting the lock wasn't the problem: 
_holding_ the lock was the problem), and it still kept the cache line for 
the lock on one core.

The only way to avoid lock contention is to avoid any exclusive use at 
all.

			Linus
