Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbZKIHoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbZKIHoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZKIHoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:44:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbZKIHox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:44:53 -0500
Message-ID: <4AF7C793.5040706@cn.fujitsu.com>
Date: Mon, 09 Nov 2009 15:41:07 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 15/20] blkio: Take care of preemptions across groups
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-16-git-send-email-vgoyal@redhat.com> <4AF3D68E.3050203@cn.fujitsu.com> <20091106221019.GA2969@redhat.com>
In-Reply-To: <20091106221019.GA2969@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Nov 06, 2009 at 03:55:58PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> o Additional preemption checks for groups where we travel up the hierarchy
>>>   and see if one queue should preempt other or not.
>>>
>>> o Also prevents preemption across groups in some cases to provide isolation
>>>   between groups.
>>>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>> ---
>>>  block/cfq-iosched.c |   33 +++++++++++++++++++++++++++++++++
>>>  1 files changed, 33 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>>> index 87b1799..98dbead 100644
>>> --- a/block/cfq-iosched.c
>>> +++ b/block/cfq-iosched.c
>>> @@ -2636,6 +2636,36 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>>  	}
>>>  }
>>>  
>>> +static bool cfq_should_preempt_group(struct cfq_data *cfqd,
>>> +		struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
>>> +{
>>> +	struct cfq_entity *cfqe = &cfqq->entity;
>>> +	struct cfq_entity *new_cfqe = &new_cfqq->entity;
>>> +
>>> +	if (cfqq_to_cfqg(cfqq) != &cfqd->root_group)
>>> +		cfqe = parent_entity(&cfqq->entity);
>>> +
>>> +	if (cfqq_to_cfqg(new_cfqq) != &cfqd->root_group)
>>> +		new_cfqe = parent_entity(&new_cfqq->entity);
>>> +
>>> +	/*
>>> +	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
>>> +	 */
>>> +
>>> +	if (new_cfqe->ioprio_class == IOPRIO_CLASS_RT
>>> +	    && cfqe->ioprio_class != IOPRIO_CLASS_RT)
>>> +		return true;
>>> +	/*
>>> +	 * Allow an BE request to pre-empt an ongoing IDLE clas timeslice.
>>> +	 */
>>> +
>>> +	if (new_cfqe->ioprio_class == IOPRIO_CLASS_BE
>>> +	    && cfqe->ioprio_class == IOPRIO_CLASS_IDLE)
>>> +		return true;
>>> +
>>> +	return false;
>>> +}
>>> +
>>>  /*
>>>   * Check if new_cfqq should preempt the currently active queue. Return 0 for
>>>   * no or if we aren't sure, a 1 will cause a preempt.
>>> @@ -2666,6 +2696,9 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>>>  	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
>>>  		return true;
>>>  
>>> +	if (cfqq_to_cfqg(new_cfqq) != cfqq_to_cfqg(cfqq))
>>> +		return cfq_should_preempt_group(cfqd, cfqq, new_cfqq);
>>> +
>> Vivek, why not put cfq_should_preempt_group() at the beginning of cfq_should_preempt()
>> to prevent preemption across groups?
> 
> Hi Gui,
> 
> Currently the checks before the group check were not hurting much, that's
> why.
> 
> The only contentious check will be if a sync IO in one group should
> preempt the async IO in other group or not.

  In my opinion, sync IO should not preempt async one in other group from the fairness point
  of view.

Thanks
Gui


