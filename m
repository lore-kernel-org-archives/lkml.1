Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbZKWKaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbZKWKaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbZKWKae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:30:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbZKWKad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:30:33 -0500
Date: Mon, 23 Nov 2009 11:28:07 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH tip/sched/core] introduce task_times() to replace
	task_[us]time() pair
Message-ID: <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com>
References: <4B061E9A.8040100@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B061E9A.8040100@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 01:44:10PM +0900, Hidetoshi Seto wrote:
> Function task_[us]times() are called consecutively in almost all
> cases.  However task_stime() is implemented to call task_utime()
> from its inside, so such paired calls run task_utime() twice.
> 
> It means we do heavy divisions (div_u64 + do_div) twice to get
> stime and utime which can be obtained at same time by one set
> of divisions.
> 
> This patch introduces task_times(*tsk, *utime, *stime) to get
> stime and utime at once, in better, optimized way.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

[snip]

> @@ -5155,6 +5155,14 @@ cputime_t task_stime(struct task_struct *p)
>  {
>  	return p->stime;
>  }
> +
> +void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
> +{
> +	if (ut)
> +		*ut = task_utime(p);
> +	if (st)
> +		*st = task_stime(p);
> +}
>  #else

I think task_{u,s}time are not needed anymore. Can we just fully get
rid of them and only use task_times() ?

>  #ifndef nsecs_to_cputime
> @@ -5162,41 +5170,48 @@ cputime_t task_stime(struct task_struct *p)
>  	msecs_to_cputime(div_u64((__nsecs), NSEC_PER_MSEC))
>  #endif

Could we furhter optimize this? Perhaps we can use below code
(taken from timespec_to_jiffies()):

	cputime = (nsec * NSEC_CONVERSION) >>
                 (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;


Stanislaw
