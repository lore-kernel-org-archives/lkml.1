Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZEZN7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZEZN7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZEZN7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:59:35 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:61080 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZEZN7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:59:35 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC] kernel/lockdep: use BFS(breadth-first search) algorithm
 to search target
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090526215442.2dbd888b@linux-lm>
References: <20090526215442.2dbd888b@linux-lm>
Content-Type: text/plain
Date: Tue, 26 May 2009 15:59:34 +0200
Message-Id: <1243346374.23657.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 21:54 +0800, Ming Lei wrote:
> Hi,All
> 
> Currently lockdep uses recursion DFS(depth-first search) algorithm to
> search target in checking lock circle(check_noncircular()),irq-safe
> -> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
> lock dependency. I plan to replace the current DFS with BFS, based on
> the following consideration:
> 
> 	1,no loss of efficiency, no matter DFS or BFS, the running time
> 	are O(V+E) (V is vertex count, and E is edge count of one
> 	graph);
> 
> 	2,BFS may be easily implemented by circular queue and consumes
> 	much less kernel stack space than DFS for DFS is implemented by
> 	recursion, we know kernel stack is very limited, eg. 4KB.
> 
> 	3, The shortest path can be obtained by BFS if the target is
> 	found, but can't be got by DFS. By the shortest path, we can
> 	shorten the lock dependency chain and help to troubleshoot lock
> 	problem easier than before.
> 
> Any suggestions, objections or viewpoint?

Ah, replace the full cycle detection might be worth it, esp with that
pre-allocated stack you used. Its all serialized on the graph lock
anyway.

I'm not sure about 3, though, since we search on adding a each new
dependency we'll only ever have a choice between cycles when one new
dependency generates two cycles at the same time. Something I think is
rare.

But yes, it wuold be nice to get rid of the current recursive algorithm
there.

