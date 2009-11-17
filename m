Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZKQQ1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZKQQ1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZKQQ1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:27:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:32845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbZKQQ1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:27:01 -0500
Message-ID: <4B02CE81.5010303@kernel.org>
Date: Wed, 18 Nov 2009 01:25:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 19/21] workqueue: introduce worker
References: <20091117115137.GL4379@hawkmoon.kerlabs.com>
In-Reply-To: <20091117115137.GL4379@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/17/2009 08:51 PM, Louis Rilling wrote:
>>> +static struct worker *create_worker(struct cpu_workqueue_struct *cwq, bool bind)
>>> +{
>>> +	int id = -1;
>>> +	struct worker *worker = NULL;
>>> +
>>> +	spin_lock(&workqueue_lock);
>>> +	while (ida_get_new(&per_cpu(worker_ida, cwq->cpu), &id)) {
>>> +		spin_unlock_irq(&workqueue_lock);
>>> +		if (!ida_pre_get(&per_cpu(worker_ida, cwq->cpu), GFP_KERNEL))
>>> +			goto fail;
>>> +		spin_lock(&workqueue_lock);
>>> +	}
>>> +	spin_unlock_irq(&workqueue_lock);
>>> +
>>> +	worker = alloc_worker();
>>> +	if (!worker)
>>> +		goto fail;
>>> +
>>> +	worker->cwq = cwq;
>>> +	worker->id = id;
>>> +
>>> +	worker->task = kthread_create(worker_thread, worker, "kworker/%u:%d",
>>> +				      cwq->cpu, id);
>>> +	if (IS_ERR(worker->task))
>>> +		goto fail;
>>> +
>>> +	if (bind)
>>> +		kthread_bind(worker->task, cwq->cpu);
>>> +
>>> +	return worker;
>>> +fail:
>>> +	if (id >= 0) {
>>> +		spin_lock(&workqueue_lock);
>>> +		ida_remove(&per_cpu(worker_ida, cwq->cpu), id);
>>> +		spin_unlock_irq(&workqueue_lock);
>>> +	}
>>> +	kfree(worker);
>>> +	return NULL;
>>> +}
>>
>> AFAIU create_worker() should call spin_lock_irq() instead of spin_lock().
> 
> spin_unlock() instead of spin_unlock_irq() looks better in fact ;).

Oooh... right, thanks for spotting that.  I'll fix it up.

-- 
tejun
