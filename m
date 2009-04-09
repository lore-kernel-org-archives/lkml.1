Return-Path: <linux-kernel-owner+w=401wt.eu-S935055AbZDIPlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055AbZDIPlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZDIPlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:41:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbZDIPlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:41:17 -0400
Date: Thu, 9 Apr 2009 08:35:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
In-Reply-To: <87tz4x97uq.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.0904090831000.4583@localhost.localdomain>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <87tz4x97uq.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Andi Kleen wrote:
>
> You have to be very careful with this. Mutexes can be slower than
> spinlocks (and the new BKL is a spinlock) in some situations, they
> typically schedule much more etc., which can be costly.

Actually, with the new adaptive spinning, that basically shouldn't be true 
any more. Or rather, you should need some really bad/unlucky situation for 
it to scheduler more than necessary, and if the locker _acts_ like a 
spinlock (ie it doesn't block while holding the lock), performance should 
approach a spinlock.

That said, there are definitely reasons why a mutex can be slower than the 
BKL, and the whole "BKL gets implicitly dropped at sleep time" is very 
high on that list of reasons. The sleeping patterns can be _very_ 
different with a mutex than with a BKL.

> Better would be to use spinlocks if possible. I guess you just would
> need to find all sleep points and wrap them with lock dropping?

I do agree that a filesystem should try to avoid sleeping locks if at all 
possible, especially on the paths that the VM uses for writeback. But on 
the other hand, I think the issue with reiserfs is just the bad latencies 
that the BKL can cause, and then it doesn't matter.

			Linus
