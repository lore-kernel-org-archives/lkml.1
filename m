Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZG1Lra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZG1Lra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZG1Lra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:47:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41200 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZG1Lr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:47:29 -0400
Message-ID: <4A6EE4A0.6080700@redhat.com>
Date: Tue, 28 Jul 2009 13:44:32 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, ryov@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com,
       agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 03/24] io-controller: bfq support of in-class preemption
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com> <1248467274-32073-4-git-send-email-vgoyal@redhat.com> <4A6DDBDE.8020608@redhat.com> <20090727224138.GA3702@redhat.com>
In-Reply-To: <20090727224138.GA3702@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi Jerome,
> 
> Thanks for testing it out. I could also reproduce the issue.
> 
> I had assumed that RT queue will always preempt non-RT queue and hence if
> there is an RT ioq/request pending, the sd->next_entity will point to
> itself and any queue which is preempting it has to be on same service
> tree.
> 
> But in your test case it looks like that RT async queue is pending and 
> there is some sync BE class IO going on. It looks like that CFQ allows
> sync queue preempting async queue irrespective of class, so in this case
> sync BE class reader will preempt async RT queue and that's where my
> assumption is broken and we see BUG_ON() hitting.
> 
> Can you please tryout following patch. It is a quick patch and requires
> more testing. It solves the crash but still does not solve the issue of
> sync queue always preempting async queues irrespective of class. In
> current scheduler we always schedule the RT queue first (whether it be
> sync or async). This problem requires little more thought.

I've tried it: I can't reproduce the issue anymore and I haven't seen any
other problem so far.
By the way, what is the expected result regarding fairness among different
groups when IO from different classes are run on each group? For instance,
if we have RT IO going on on one group, BE IO on an other and Idle IO on a
third group, what is the expected result: should the IO time been shared
fairly between the groups or should RT IO have priority? As it is now, the
time is shared fairly between BE and RT groups and the last group running
Idle IO hardly get any time.

Jerome

> 
> In this patch, we just check next entity on same class service tree and
> if one is present, stick new queue in front of it. We don't rely on
> sd->next_active, which could be pointing to a queue of different class
> in same group (scheduling_data).
>  
> ---
>  block/elevator-fq.c |   16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> Index: linux8/block/elevator-fq.c
> ===================================================================
> --- linux8.orig/block/elevator-fq.c	2009-07-27 18:13:34.000000000 -0400
> +++ linux8/block/elevator-fq.c	2009-07-27 18:18:49.000000000 -0400
> @@ -946,21 +946,15 @@ static void __bfq_activate_entity(struct
>  	if (add_front) {
>  		struct io_entity *next_entity;
>  
> -		/* Determine the entity which will be dispatched next */
> -		next_entity = sd->next_active;
> +		/*
> +		 * Determine the entity which will be dispatched next on
> +		 * same service tree.
> +		 */
> +		next_entity = __bfq_lookup_next_entity(st);
>  
>  		if (next_entity && next_entity != entity) {
> -			struct io_service_tree *new_st;
>  			u64 delta;
>  
> -			new_st = io_entity_service_tree(next_entity);
> -
> -			/*
> -			 * At this point, both entities should belong to
> -			 * same service tree as cross service tree preemption
> -			 * is automatically taken care by algorithm
> -			 */
> -			BUG_ON(new_st != st);
>  			entity->finish = next_entity->finish - 1;
>  			delta = bfq_delta(entity->budget, entity->weight);
>  			entity->start = entity->finish - delta;

