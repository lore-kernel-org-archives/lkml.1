Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0BDCHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:07:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:58276 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab0BDCHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:07:32 -0500
Message-ID: <4B6A2D29.3010804@kernel.org>
Date: Thu, 04 Feb 2010 11:12:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
       rusty@rustcorp.com.au, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] core: workqueue: BUG_ON on workqueue recursion
References: <20100203122755.0fd4fb7e@marrow.netinsight.se> <20100203194350.GA13824@redhat.com>
In-Reply-To: <20100203194350.GA13824@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 02:06:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/04/2010 04:43 AM, Oleg Nesterov wrote:
> On 02/03, Simon Kagstrom wrote:
>>
>> When the workqueue is flushed from workqueue context (recursively), the
>> system enters a strange state where things at random (dependent on the
>> global workqueue) start misbehaving. For example, for us the console and
>> logins locks up while the web server continues running.
>>
>> Since the system becomes unstable, change this to a BUG_ON instead.
> 
> I agree with this patch. We are going to deadlock anyway, if the
> condition is true the caller is cwq->current_work, this means
> flush_cpu_workqueue() will insert the barrier and hang.
> 
> However,
> 
>> @@ -482,7 +482,7 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
>>  	int active = 0;
>>  	struct wq_barrier barr;
>>
>> -	WARN_ON(cwq->thread == current);
>> +	BUG_ON(cwq->thread == current);
> 
> Another option is change the code to do
> 
> 	if (WARN_ON(cwq->thread == current))
> 		return;
> 
> This gives the kernel chance to survive after the warning.
> 
> What do you think?

Yeah, I like this one better too.  Even solely for debugging,
WARN_ON() is better as often users don't have reliable ways to gather
kernel log after a BUG_ON().

Thanks.

-- 
tejun
