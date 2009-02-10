Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbZBJNEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbZBJNEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbZBJNEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:04:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:58826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbZBJNEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:04:34 -0500
Subject: Re: cgroup, RT reservation per core(s)?
From: Peter Zijlstra <peterz@infradead.org>
To: Rolando Martins <rolando.martins@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Feb 2009 14:06:17 +0100
Message-Id: <1234271177.23438.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 20:04 +0000, Rolando Martins wrote:

> I should have elaborated this more:
> 
>                      root
>                   ----|----
>                   |          |
> (0.5 mem) 0         1 (100% rt, 0.5 mem)
>                          ---------
>                          |    |    |
>                          2   3   4  (33% rt for each group, 33% mem
> per group(0.165))
> Rol


Right, i think this can be done.

You would indeed need cpusets and sched-cgroups.

Split the machine in 2 using cpusets.

   ___R___
  /       \
 A         B

Where R is the root cpuset, and A and B are the siblings.
Assign A one half the cpus, and B the other half.
Disable load-balancing on R.

Then using sched cgroups create the hierarchy

  ____1____
 /    |    \
2     3     4

Where 1 can be the root group if you like.

Assign 1 a utilization limit of 100%, and 2,3 and 4 a utilization limit
of 33% each.

Then place the tasks that get 100% cputime on your 2 cpus in cpuset A
and sched group 1.

Place your other tasks in B,{2-4} respectively.

The reason this works is that bandwidth distribution is sched domain
wide, and by disabling load-balancing on R, you split the schedule
domain.

I've never actually tried anything like this, let me know if it
works ;-)
