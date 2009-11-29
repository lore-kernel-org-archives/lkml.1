Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZK2PNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZK2PNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZK2PNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:13:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZK2PNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:13:09 -0500
Message-ID: <4B128F65.40804@redhat.com>
Date: Sun, 29 Nov 2009 17:12:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: Optimize branch hint in context_switch()
References: <4B1262AC.8000903@klingt.org>
In-Reply-To: <4B1262AC.8000903@klingt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2009 02:01 PM, Tim Blechmann wrote:
> Branch hint profiling on my nehalem machine showed 88%
> incorrect branch hints:
>
> 42017484 326957902  88 context_switch                 sched.c              3043
> 42038493 326953687  88 context_switch                 sched.c              3050
>
> @@ -3040,14 +3040,14 @@ context_switch(struct rq *rq, struct task_struct *prev,
>   	 */
>   	arch_start_context_switch(prev);
>
> -	if (likely(!mm)) {
> +	if (unlikely(!mm)) {
>   		next->active_mm = oldmm;
>   		atomic_inc(&oldmm->mm_count);
>   		enter_lazy_tlb(oldmm, next);
>   	} else
>   		switch_mm(oldmm, mm, next);
>
> -	if (likely(!prev->mm)) {
> +	if (unlikely(!prev->mm)) {
>   		prev->active_mm = NULL;
>   		rq->prev_mm = oldmm;
>   	}
>    

I don't think either the original or the patch is correct.  Whether or 
not a task has an mm is entirely workload dependent, we shouldn't be 
giving hints here.

-- 
error compiling committee.c: too many arguments to function

