Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbYEVVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbYEVVP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYEVVPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:15:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50020 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbYEVVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:15:45 -0400
Subject: RE: fair group scheduler not so fair?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com, mingo@elte.hu, pj@sgi.com
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB54194850357ED61@fmsmsx411.amr.corp.intel.com>
References: <4834B75A.40900@nortel.com> <1211439417.29104.7.camel@twins>
	 <4835D14B.20904@nortel.com>
	 <1211486868.6463.134.camel@lappy.programming.kicks-ass.net>
	 <5FD5754DDBA0B1499B5A0B4BB54194850357ED61@fmsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 23:13:39 +0200
Message-Id: <1211490819.6463.172.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 13:18 -0700, Li, Tong N wrote:
> Peter,
> 
> I didn't look at your patches, but I thought you were flattening group
> weights down to task-level so that the scheduler only looks at per-task
> weights. That'd make group fairness as good as task fairness gets. Is
> this still the case?

We still have hierarchical runqueues - getting rid of that is another
tree I'm working on, it has an EEVDF based rq scheduler.

For load balancing purposes we are indeed projecting everything to a
flat level.

A rather quick description of what we do:


We'll have:

  task-weight     - the weight for a task
  group-weight    - the weight for a group (same units as for tasks)
  group-shares    - the weight for a group on a particular cpu
  runqueue-weight - the sum of weights

we compute group-shares as:

  s_(i,g) = W_g * rw_(i,g) / \Sum_j rw_(j,g)
  
s_(i,g)  := group g's shares for cpu i
W_g      := group g's weight
rw_(i,g) := group g's runqueue weight for cpu i

(all for a given group)

We compute these shares while walking the task group tree bottom up,
since the shares for a child's group will affect the runqueue weight for
its parent.

We then select the busiest runqueue from the available set solely based
on top level runqueue weight (since that accurately reflects all the
child group weights after updating the shares).

We compute an imbalance between this rq and the busiest rq in top
weight.

Then, for this busiest cpu we compute the hierarchical load for each
group:

 h_load_(i,g) = rw_(i,0) \Prod_{l=1} s_(i,l)/rw_(i,{l-1})

Where l iterates over the tree levels (not the cpus).

h_load represents the full weight of the group as seen from the top
level. This is used to convert the weight of each moved task to top
weight, and we'll keep on moving tasks until the imbalance is satisfied.


Given the following:

      root
     / | \
   _A_ 1  2
  /| |\
 3 4 5 B
      / \
     6   7

     CPU0            CPU1
     root            root
     /  \            /  \
    A    1          A    2
   / \             / \
  4   B           3   5
     / \
    6   7


Numerical examples given the above scenario, assuming every body's
weight is 1024:

 s_(0,A) = s_(1,A) = 512
 s_(0,B) = 1024, s_(1,B) = 0

 rw_(0,A) = rw(1,A) = 2048
 rw_(0,B) = 2048, rw_(1,B) = 0

 h_load_(0,A) = h_load_(1,A) = 512
 h_load_(0,B) = 256, h_load(1,B) = 0




