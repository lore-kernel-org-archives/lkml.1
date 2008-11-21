Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYKURMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYKURMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYKURLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:11:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:36927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYKURLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:11:50 -0500
Message-ID: <4926EBD8.6070200@kernel.org>
Date: Sat, 22 Nov 2008 02:11:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: torvalds@linux-foundation.org, hch@infradead.org, mingo@elte.hu,
       rminnich@sandia.gov, ericvh@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] poll: allow f_op->poll to sleep, take #2
References: <491BA16C.30606@kernel.org> <alpine.LFD.2.00.0811151208430.3468@nehalem.linux-foundation.org> <49256CCE.9060107@kernel.org> <E1L3Z5h-0008J7-QN@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L3Z5h-0008J7-QN@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Nov 2008 17:11:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Thu, 20 Nov 2008, Tejun Heo wrote:
> 
> [snip]
> 
>> +int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
>> +			  ktime_t *expires, unsigned long slack)
> 
> The 'state' parameter is unused, and is always called with the
> TASK_INTERRUPTIBLE value.  Shouldn't it be removed?
> 
>> +{
>> +	int rc = -EINTR;
>> +
>> +	set_current_state(TASK_INTERRUPTIBLE);

Aieee... this should have been set_current_state(state).  We can also
remove @state but this being a schedule() function I think it's better
to pass @state explicitly.

>> +	if (!pwq->triggered)
>> +		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
>> +	__set_current_state(TASK_RUNNING);
>> +
>> +	/* clear triggered for the next iteration */
>> +	pwq->triggered = 0;
>> +
>> +	return rc;
>> +}
>> +
>> +EXPORT_SYMBOL(poll_schedule_timeout);
> 
> Checkpatch warning:
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #118: FILE: fs/select.c:216:
> +EXPORT_SYMBOL(poll_schedule_timeout);
> 
> [snip]
> 
>> Index: work/include/linux/poll.h
>> ===================================================================
>> --- work.orig/include/linux/poll.h
>> +++ work/include/linux/poll.h
>> @@ -57,6 +57,8 @@ struct poll_table_entry {
>>  struct poll_wqueues {
>>  	poll_table pt;
>>  	struct poll_table_page * table;
>> +	struct task_struct * polling_task;
>> +	int triggered;
> 
> Checkpatch error:
> 
> ERROR: "foo * bar" should be "foo *bar"
> #173: FILE: include/linux/poll.h:60:
> +       struct task_struct * polling_task;

For both, I was trying to stay consistent with the environment.  I
find mixed styles in close proximity much uglier than slightly
different but consistent style.  Eh... Is the consensus checkpatch or
die?

Thanks.

-- 
tejun
