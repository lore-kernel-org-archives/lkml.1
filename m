Return-Path: <linux-kernel-owner+w=401wt.eu-S1750845AbZFWEKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750845AbZFWEKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbZFWEJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:09:51 -0400
Received: from ms01.sssup.it ([193.205.80.99]:45329 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750706AbZFWEJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:09:50 -0400
Date: Tue, 23 Jun 2009 06:10:52 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in elevaotor layer
Message-ID: <20090623041052.GS28770@gandalf.sssup.it>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-3-git-send-email-vgoyal@redhat.com> <20090622084612.GD3728@balbir.in.ibm.com> <20090622124313.GF28770@gandalf.sssup.it> <20090623024337.GC3620@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623024337.GC3620@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Mon, Jun 22, 2009 10:43:37PM -0400
>
> On Mon, Jun 22, 2009 at 02:43:13PM +0200, Fabio Checconi wrote:
> 
...
> > > Please help me understand this, we sort the tree by finish time, but
> > > search by vtime, start_time. The worst case could easily be O(N),
> > > right?
> > > 
> > 
> > no, (again, the full answer is in the paper); the nice property of
> > min_start is that it partitions the tree in two regions, one with
> > eligible entities and one without any of them.  once we know that
> > there is one eligible entity (checking the min_start at the root)
> > we can find the node i with min(F_i) subject to S_i < V walking down
> > a single path from the root to the leftmost eligible entity.  (we
> > need to go to the right only if the subtree on the left contains 
> > no eligible entities at all.)  since the RB tree is balanced this
> > can be done in O(log N).
> > 
> 
> Hi Fabio,
> 
> When I go thorough the paper you mentioned above, they seem to have
> sorted the tree based on eligible time (looks like equivalent of start
> time) and then keep track of minimum deadline on each node (equivalnet of
> finish time).
> 
> We seem to be doing reverse in BFQ where we sort tree on finish time
> and keep track of minimum start time on each node. Is there any specific
> reason behind that?
> 

Well... no specific reasons...  I think that our implementation is easier
to understand than the one of the paper, because it actually uses finish
times as the ordering key, and min_start to quickly locate eligible
subtrees, following the definition of the algorithm.

Moreover, if you look at the get_req() code in the paper, it needs a
couple of loops to get to the result, while with our implementation
we save the second loop.

Our version is still correct, because it always moves to the left
(towards smaller finish times), except when moving to the left would
mean entering a non feasible subtree, in which case it moves to the
right.

Unfortunately I'm not aware of any paper describing a version of the
algorithm more similar to the one we've implemented.  Sorry for not
having mentioned that difference in the comments nor anywhere else,
it has been a long long time since I read the paper, and I must have
forgotten about that.
