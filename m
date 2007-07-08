Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbXGHQu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbXGHQu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 12:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXGHQuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 12:50:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbXGHQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 12:50:16 -0400
Date: Sun, 8 Jul 2007 09:49:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <p733azz16vh.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.0.999.0707080942170.31544@woody.linux-foundation.org>
References: <20070708043228.GB22397@wotan.suse.de>
 <p733azz16vh.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Jul 2007, Andi Kleen wrote:
>
> Nick Piggin <npiggin@suse.de> writes:
> 
> > I made some tests of the queued spinlock code using userspace test code on
> > 64-bit processors. I believe the xadd based code no longer has any theoretical
> > memory ordering problems.
> 
> Linus, the background of this is that on 8 socket Opteron systems
> the current spinlocks can become very unfair to the point of severe 
> starvation. These boxes are becomming more common.

Yeah, considering the numbers, I don't have any real objections here.

I would ask that the code be given to both Intel and AMD engineers to look 
over, just to verify that the lfence is sufficient (or whether it's even 
needed), but I think the use of "xaddw" to both increment _and_ load the 
old value for the non-contention case is an obviously good (and clever) 
way to handle that one, and even if we'd have to add something heavier 
than the lfence to the contended case, it looks fine to me.

So the only remaining issue is that unfairness is probably really good for 
some loads (not just for the spinlock itself - it will likely cause much 
better cache behaviour for stuff _inside_ the lock to stay on the same 
core), but I don't think we want to optimize for the contended case 
anyway, so that's more of a "it will be interesting to see" kind of 
comment.

In short: if we can have AMD/Intel engineers look this over for any subtle 
issues, and they are happy, then I'm happy. 

		Linus
