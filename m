Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbZGKVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbZGKVJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZGKVJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 17:09:11 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:60853 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZGKVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 17:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BRa88EGJcSlQ5bkbau0ogF06m/fzAqJdZNpcTDT2rWgqM4qktuUGVZ/ZVQpUDmT0Bf
         UNqFMAV/S0niTCW1d3SKMG5ExuIALIsfN3HTSgZcZ9M4QN693rdLx1ocmpxsDk1q3AYe
         T7QKtf2KjE5DrE8diiQeO7cgBYXQhScT6bllc=
Date: Sat, 11 Jul 2009 23:09:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
Message-ID: <20090711210902.GB6641@nowhere>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com> <20090711004339.GA6125@nowhere> <d82e647a0907102025s655a82bg11af0eb901349c31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d82e647a0907102025s655a82bg11af0eb901349c31@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 11:25:29AM +0800, Ming Lei wrote:
> 2009/7/11 Frederic Weisbecker <fweisbec@gmail.com>:
> > Hi,
> >
> > On Sun, Jun 28, 2009 at 11:04:35PM +0800, tom.leiming@gmail.com wrote:
> >> Hi,Peter
> >>
> >> Currently lockdep uses recursion DFS(depth-first search) algorithm to
> >> search target in checking lock circle(check_noncircular()),irq-safe
> >> -> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
> >> lock dependency. This patches replace the current DFS with BFS, based on
> >> the following consideration:
> >>
> >>     1,no loss of efficiency, no matter DFS or BFS, the running time
> >>     are O(V+E) (V is vertex count, and E is edge count of one
> >>     graph);
> >>
> >>     2,BFS may be easily implemented by circular queue and consumes
> >>     much less kernel stack space than DFS for DFS is implemented by
> >>     recursion.
> >
> >
> >
> > Looks like a valuable argument. check_noncircular() can be called
> > in very random places in the kernel where the stack may be
> > already deep, and this recursive DFS doesn't help there.
> 
> Yes,  BFS uses the preallocated queue buffer as "stack" and removes
> the recursive implementation of DFS, so does decrease kernel stack
> consume
> largely.
> 
> From this point, BFS patch is valuable.


Right!

 
> >
> >
> >
> >>     3,The shortest path can be obtained by BFS if the target is
> >>     found, but can't be got by DFS. By the shortest path, we can
> >>     shorten the lock dependency chain and help to troubleshoot lock
> >>     problem easier than before.
> >
> >
> > But there I don't understand your argument.
> > The shortest path finding doesn't seem to me a need.
> > Example:
> >
> > Task 1 acquires: A B C
> > And Later:
> > Task 2 acquires: C B A
> >
> > DFS will probably report a circular lock dependency
> > with A and C.
> > BFS will probably report a circular lock dependency
> > with B and C.
> >
> > Which one is the most important? Both dependencies must be fixed
> > anyway. Once the developer will fix one of those, the remaining one
> > will be reported and so on...
> >
> > Or am I missing something else?
> 
> Yes, you are right.  By BFS, we can always find the shortest circle, but we
> find a random circle by DFS.   No one can say which circle is the most
> important from the point of deadlock.
> 
> But it is easier to start troubleshooting from the shortest circle
> than a random circle , then from the next shortest circle if other
> circle still exists .
> 
> Right?


I don't have a strong opinion on this. I just don't think the shortest path is
the most important if there are many many paths.
Whatever AB-BA is encountered, all of them must be fixed.
What might give a degree of importance for such bad circle is the window
in which it triggers.

