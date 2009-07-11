Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbZGKAny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbZGKAny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 20:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbZGKAnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 20:43:46 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:47296 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZGKAnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 20:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bWhLBCiBZL+Hc8eFMhzK2YbdYZ+iGuf8R8swvf1RevPE167tSmGzdj/SjNjRtoqBGw
         tv5AuyFY9gKEMwxsE9lEyT29hdwNEc7e5Pg9832DNzKvnlx26f9Wyg6iNGbq6Rcg8lUG
         RDQ8HptZU6y64qyaO5q0CBgGekEcVxAcgwhso=
Date: Sat, 11 Jul 2009 02:43:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: tom.leiming@gmail.com
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
Message-ID: <20090711004339.GA6125@nowhere>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 28, 2009 at 11:04:35PM +0800, tom.leiming@gmail.com wrote:
> Hi,Peter
> 
> Currently lockdep uses recursion DFS(depth-first search) algorithm to
> search target in checking lock circle(check_noncircular()),irq-safe
> -> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
> lock dependency. This patches replace the current DFS with BFS, based on
> the following consideration:
> 
>     1,no loss of efficiency, no matter DFS or BFS, the running time
>     are O(V+E) (V is vertex count, and E is edge count of one
>     graph);
> 
>     2,BFS may be easily implemented by circular queue and consumes
>     much less kernel stack space than DFS for DFS is implemented by
>     recursion.



Looks like a valuable argument. check_noncircular() can be called
in very random places in the kernel where the stack may be
already deep, and this recursive DFS doesn't help there.



>     3,The shortest path can be obtained by BFS if the target is
>     found, but can't be got by DFS. By the shortest path, we can
>     shorten the lock dependency chain and help to troubleshoot lock
>     problem easier than before.


But there I don't understand your argument.
The shortest path finding doesn't seem to me a need.
Example:

Task 1 acquires: A B C
And Later:
Task 2 acquires: C B A

DFS will probably report a circular lock dependency
with A and C.
BFS will probably report a circular lock dependency
with B and C.

Which one is the most important? Both dependencies must be fixed
anyway. Once the developer will fix one of those, the remaining one
will be reported and so on...

Or am I missing something else?

