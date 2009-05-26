Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZEZOhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZEZOhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZEZOgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:36:52 -0400
Received: from mail-pz0-f109.google.com ([209.85.222.109]:42655 "EHLO
	mail-pz0-f109.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZEZOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=vmT9Wgl4t6oRzoJFhpmPwhrUYfA1w92fiNBd41v55SlN0ODyyZDvqyPfCEjGfmsA/a
         53n4UZ88Vnghv0eyZkHe8CB3pI5aOnn3mMyy7CeRFK3Ks+AXQx5AGDj7ih9svc7eeUcO
         /ObRRLJsnaa0PqnXy0NYtTpXc5ZxP9nK4uBRs=
Date: Tue, 26 May 2009 22:36:39 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] kernel/lockdep: use BFS(breadth-first search) algorithm
 to search target
Message-ID: <20090526223639.39567126@linux-lm>
In-Reply-To: <1243346374.23657.9.camel@twins>
References: <20090526215442.2dbd888b@linux-lm>
	<1243346374.23657.9.camel@twins>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 15:59:34 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-05-26 at 21:54 +0800, Ming Lei wrote:
> > Hi,All
> > 
> > Currently lockdep uses recursion DFS(depth-first search) algorithm
> > to search target in checking lock
> > circle(check_noncircular()),irq-safe ->
> > irq-unsafe(check_irq_usage()) and irq inversion when adding a new
> > lock dependency. I plan to replace the current DFS with BFS, based
> > on the following consideration:
> > 
> > 	1,no loss of efficiency, no matter DFS or BFS, the running
> > time are O(V+E) (V is vertex count, and E is edge count of one
> > 	graph);
> > 
> > 	2,BFS may be easily implemented by circular queue and
> > consumes much less kernel stack space than DFS for DFS is
> > implemented by recursion, we know kernel stack is very limited, eg.
> > 4KB.
> > 
> > 	3, The shortest path can be obtained by BFS if the target is
> > 	found, but can't be got by DFS. By the shortest path, we can
> > 	shorten the lock dependency chain and help to troubleshoot
> > lock problem easier than before.
> > 
> > Any suggestions, objections or viewpoint?
> 
> Ah, replace the full cycle detection might be worth it, esp with that
> pre-allocated stack you used. Its all serialized on the graph lock
> anyway.
> 
> I'm not sure about 3, though, since we search on adding a each new
> dependency we'll only ever have a choice between cycles when one new
> dependency generates two cycles at the same time. Something I think is
> rare.

IMHO, maybe it is not much, but is not rare, for example, the prev node
is in a graph(GA) and the next node is in another graph(GB). If GA and
GB is not connected, the edge of prev to next can't generate a cycle.
If GA and GB is connected, it is possible to generate one or multiple
cycles,which depends on the connect degree between GA and GB.

BTW: BFS in the previous patch finds a shorter path in the
thread:

	http://marc.info/?l=linux-kernel&m=124211522525625&w=2



> 
> But yes, it wuold be nice to get rid of  current recursive
> algorithm there.
> 

OK, I'll start to do it.

Thanks.
-- 
Lei Ming
