Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZFXJU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZFXJU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZFXJUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:20:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61906 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbZFXJUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:20:44 -0400
Message-ID: <4A41EFE1.5050101@cn.fujitsu.com>
Date: Wed, 24 Jun 2009 17:20:33 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH] io-controller: Preempt a non-rt queue if a rt ioq is
 present in ancestor or sibling groups
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-21-git-send-email-vgoyal@redhat.com> <4A3F3648.7080007@cn.fujitsu.com> <20090622172123.GE15600@redhat.com> <4A4079B8.4020402@cn.fujitsu.com> <20090623140250.GA4262@redhat.com>
In-Reply-To: <20090623140250.GA4262@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Tue, Jun 23, 2009 at 02:44:08PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Mon, Jun 22, 2009 at 03:44:08PM +0800, Gui Jianfeng wrote:
>>>> Preempt the ongoing non-rt ioq if there are rt ioqs waiting for dispatching
>>>> in ancestor or sibling groups. It will give other group's rt ioq an chance 
>>>> to dispatch ASAP.
>>>>
>>> Hi Gui,
>>>
>>> Will new preempton logic of traversing up the hiearchy so that both new
>>> queue and old queue are at same level to take a preemption decision not
>>> take care of above scenario?
>> Hi Vivek,
>>
>> Would you explain a bit what do you mean about "both new queue and old queue 
>> are at same level to take a preemption decision". I don't understand it well.
>>
> 
> Consider following hierarchy.
> 
> 			root
> 			/ | 
> 		       A  1   
> 		       | 
> 		       2 
> In the above diagram, A is the group and "1" and "2" are two io queues 
> associated with tasks.
> 
> Now assume that queue "1" is being served and queue "2" gets backlogged.
> Should queue 2 preempt queue 1 now?
> 
> To take that decision, we need to do the comparision between type of
> entity of group A and queue 1 (That is at the same level or IOW, the
> entities in question have the same parent). If group A is of class RT and
> queue 1 is of type BE then queue 2 should preempt queue 1 otherwise not.
> 
> Hence in hierarchical setups to take a preemption decision, comparison
> should be done at same level.

  So what bfq_find_matching_entity has done is going to figure out the same
  level entities， in turn, taking the decision.

> 
>>> Please have a look at bfq_find_matching_entity().
>>>
>>> At the same time we probably don't want to preempt the non-rt queue
>>> with an RT queue in sibling group until and unless sibling group is an
>>> RT group.
>>>
>>> 		root
>>> 		/  \
>>> 	   BEgrpA  BEgrpB
>>> 	      |     |	
>>> 	  BEioq1   RTioq2
>>>
>>> Above we got two BE group A and B and assume ioq in group A is being
>>> served and then an RT request in group B comes. Because group B is an
>>> BE class group, we should not preempt the queue in group A.
>>   Yes, i also have this concern. So, it does not allow non-rt group preempts
>>   another group. I'll check whether there is a way to address this issue.
>>
> 
> So here also assume ioq1 is being served and ioq2 gets backlogged. To
> decide whether ioq2 should preempt ioq1 or not, one needs to go up the 
> hiearchy till two paths share the parent. That means one needs to go up
> at the BEgrpA and BEgrpB level where they have common parent "root". Now
> both the groups are of class BE hence ioq2 should not preempt ioq1.
> 
> Hope it helps.

  Thanks, it's very helpful.

  I have a thought now. Whether we can maintain a rt ioq list in efqd, and 
  elv_fq_select_ioq() travels this list to take preemtion decision for each
  available rt ioqs at the same level(by using bfq_find_matching_entity).
  I'd like to try it out.

> 
> Thanks
> Vivek
> 
> 
> 

-- 
Regards
Gui Jianfeng

