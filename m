Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZKPScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZKPScZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZKPScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:32:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZKPScY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:32:24 -0500
Message-ID: <4B019A76.2080706@redhat.com>
Date: Mon, 16 Nov 2009 20:31:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 04/21] sched: implement scheduler notifiers
References: <1258391726-30264-1-git-send-email-tj@kernel.org> <1258391726-30264-5-git-send-email-tj@kernel.org>
In-Reply-To: <1258391726-30264-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2009 07:15 PM, Tejun Heo wrote:
> Implement scheduler notifiers.  This is superset of preempt notifiers
> which will be removed in favor of new notifiers.  Four notifications
> are defined - activated, deactivated, in and out.  In and out are
> identical to preempt notifiers.  Activated and deactivated are called
> when a task's readiness to run changes.  The first three are always
> called under rq lock.  Out may not be called under rq lock depending
> on architecture.
>
> The notifier block contains union of all four callbacks to avoid
> defining separate interface for each.
>    

> +
> +struct sched_notifier {
> +	struct hlist_node	link;
> +	union {
> +		void (*activated)(struct sched_notifier *n, bool wakeup);
> +		void (*deactivated)(struct sched_notifier *n, bool sleep);
> +		void (*in)(struct sched_notifier *n, struct task_struct *prev);
> +		void (*out)(struct sched_notifier *n, struct task_struct *next);
> +	};
> +};
> +
>
>   struct task_struct {
> @@ -1237,6 +1268,8 @@ struct task_struct {
>   	/* list of struct preempt_notifier: */
>   	struct hlist_head preempt_notifiers;
>   #endif
> +	/* sched notifiers */
> +	struct hlist_head notifiers[SCHED_NR_NOTIFIERS];
>
>    

Four hlist_heads (64 bytes) is pretty heavy for this.  I having all 
members present in sched_notifier (instead of a union) and calling a 
callback if it is not NULL.  This reduces the overhead to 16 bytes at 
the expense of an extra check for sched_notifier users.

Besides this, is there any difference to preempt_notifiers?  if not we 
can just add the new members and rename.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

