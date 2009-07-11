Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbZGKDZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbZGKDZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 23:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZGKDZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 23:25:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:11632 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZGKDZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 23:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E3cnw/uXPsb7ey8A0AkKN4sCWLY2nZUIuI53T6OfGN9bIAMpKuGXNc5C9ZH7cHmlxs
         Mg10BQxEDKmQ3fDp1XQGr+C5gjwNrAwP8RXnGMLR5n1hV8ij+sMWZucGWXVZOGyiPKWI
         OJnFDsyxn8N8ibLnSXqtqUliEWs7weCDm6Wbo=
MIME-Version: 1.0
In-Reply-To: <20090711004339.GA6125@nowhere>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <20090711004339.GA6125@nowhere>
Date: Sat, 11 Jul 2009 11:25:29 +0800
Message-ID: <d82e647a0907102025s655a82bg11af0eb901349c31@mail.gmail.com>
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
From: Ming Lei <tom.leiming@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/11 Frederic Weisbecker <fweisbec@gmail.com>:
> Hi,
>
> On Sun, Jun 28, 2009 at 11:04:35PM +0800, tom.leiming@gmail.com wrote:
>> Hi,Peter
>>
>> Currently lockdep uses recursion DFS(depth-first search) algorithm to
>> search target in checking lock circle(check_noncircular()),irq-safe
>> -> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
>> lock dependency. This patches replace the current DFS with BFS, based on
>> the following consideration:
>>
>>     1,no loss of efficiency, no matter DFS or BFS, the running time
>>     are O(V+E) (V is vertex count, and E is edge count of one
>>     graph);
>>
>>     2,BFS may be easily implemented by circular queue and consumes
>>     much less kernel stack space than DFS for DFS is implemented by
>>     recursion.
>
>
>
> Looks like a valuable argument. check_noncircular() can be called
> in very random places in the kernel where the stack may be
> already deep, and this recursive DFS doesn't help there.

Yes,  BFS uses the preallocated queue buffer as "stack" and removes
the recursive implementation of DFS, so does decrease kernel stack
consume
largely.

>From this point, BFS patch is valuable.

>
>
>
>>     3,The shortest path can be obtained by BFS if the target is
>>     found, but can't be got by DFS. By the shortest path, we can
>>     shorten the lock dependency chain and help to troubleshoot lock
>>     problem easier than before.
>
>
> But there I don't understand your argument.
> The shortest path finding doesn't seem to me a need.
> Example:
>
> Task 1 acquires: A B C
> And Later:
> Task 2 acquires: C B A
>
> DFS will probably report a circular lock dependency
> with A and C.
> BFS will probably report a circular lock dependency
> with B and C.
>
> Which one is the most important? Both dependencies must be fixed
> anyway. Once the developer will fix one of those, the remaining one
> will be reported and so on...
>
> Or am I missing something else?

Yes, you are right.  By BFS, we can always find the shortest circle, but we
find a random circle by DFS.   No one can say which circle is the most
important from the point of deadlock.

But it is easier to start troubleshooting from the shortest circle
than a random circle , then from the next shortest circle if other
circle still exists .

Right?

-- 
Lei Ming
