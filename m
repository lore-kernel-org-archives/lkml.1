Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZDVTW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZDVTW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZDVTWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:22:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:32893 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbZDVTWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:22:17 -0400
Date: Wed, 22 Apr 2009 21:22:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090422192216.GE4593@kernel.dk>
References: <49EE42CC.7070002@opengridcomputing.com> <20090422131703.GO4593@kernel.dk> <49EF2882.1020306@opengridcomputing.com> <49EF293F.4030504@opengridcomputing.com> <49EF2C32.4030409@opengridcomputing.com> <20090422163032.GV4593@kernel.dk> <20090422163705.GW4593@kernel.dk> <49EF5F31.30408@opengridcomputing.com> <20090422183406.GA4593@kernel.dk> <49EF6929.9020600@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF6929.9020600@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Steve Wise wrote:
>
>> Odd... Can you try this variant?
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 7e13f04..3a97c18 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -154,6 +154,7 @@ struct cfq_queue {
>>  	unsigned long rb_key;
>>  	/* prio tree member */
>>  	struct rb_node p_node;
>> +	struct rb_root *p_root;
>>  	/* sorted list of pending requests */
>>  	struct rb_root sort_list;
>>  	/* if fifo isn't expired, next request to serve */
>> @@ -594,22 +595,25 @@ cfq_prio_tree_lookup(struct cfq_data *cfqd, int ioprio, sector_t sector,
>>   static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue 
>> *cfqq)
>>  {
>> -	struct rb_root *root = &cfqd->prio_trees[cfqq->ioprio];
>> +	struct rb_root *root = &cfqd->prio_trees[cfqq->org_ioprio];
>>  	struct rb_node **p, *parent;
>>  	struct cfq_queue *__cfqq;
>>  -	if (!RB_EMPTY_NODE(&cfqq->p_node))
>> -		rb_erase_init(&cfqq->p_node, root);
>> +	if (cfqq->p_root) {
>> +		rb_erase_init(&cfqq->p_node, cfqq->p_root);
>> +		cfqq->p_root = NULL;
>> +	}
>>   	if (cfq_class_idle(cfqq))
>>  		return;
>>  	if (!cfqq->next_rq)
>>  		return;
>>  -	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->ioprio, 
>> cfqq->next_rq->sector,
>> -					 &parent, &p);
>> +	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->org_ioprio,
>> +					cfqq->next_rq->sector, &parent, &p);
>>  	BUG_ON(__cfqq);
>>  +	cfqq->p_root = root;
>>  	rb_link_node(&cfqq->p_node, parent, p);
>>  	rb_insert_color(&cfqq->p_node, root);
>>  }
>> @@ -656,8 +660,10 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>   	if (!RB_EMPTY_NODE(&cfqq->rb_node))
>>  		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
>> -	if (!RB_EMPTY_NODE(&cfqq->p_node))
>> -		rb_erase_init(&cfqq->p_node, &cfqd->prio_trees[cfqq->ioprio]);
>> +	if (cfqq->p_root) {
>> +		rb_erase_init(&cfqq->p_node, cfqq->p_root);
>> +		cfqq->p_root = NULL;
>> +	}
>>   	BUG_ON(!cfqd->busy_queues);
>>  	cfqd->busy_queues--;
>> @@ -976,7 +982,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>>  	 * First, if we find a request starting at the end of the last
>>  	 * request, choose it.
>>  	 */
>> -	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->ioprio,
>> +	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->org_ioprio,
>>  				      sector, &parent, NULL);
>>  	if (__cfqq)
>>  		return __cfqq;
>>
>>   
>
> Still crashes with this variant:

OK, so please try and revert a36e71f996e25d6213f57951f7ae1874086ec57e
and see if that works?

Or, better yet, please try and revert
55a63998b8967615a15e2211ba0ff3a84a565824 first. If that doesn't work,
try the above revert.

-- 
Jens Axboe

