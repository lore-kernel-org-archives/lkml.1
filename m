Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYGaNNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYGaNNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYGaNM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:12:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYGaNM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:12:58 -0400
Message-ID: <4891B9E0.2090900@cn.fujitsu.com>
Date: Thu, 31 Jul 2008 21:10:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
References: <48912FDD.8060006@cn.fujitsu.com> <20080731072355.b582b2d6.pj@sgi.com>
In-Reply-To: <20080731072355.b582b2d6.pj@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cgroup_task_count() was called twice in every loop. IMO, it's not need.
task number maybe have been increased after kfree. But kfree is generally
quicker than kmalloc. So considering the increasing task number when kfree
is not so useful.

My patch has removed one cgroup_task_count() in every loop.

My patch has an additional line: fudge += fudge >> 3;
This line will reduce loop times remarkably when loop times is large.
(but also loop times is large just in theory)



Paul Jackson wrote:
> I agree that in theory, this kernel/cpuset.c update_tasks_nodemask()
> loop could loop forever, and that by forcing ntasks to keep increasing
> monotonically, this guarantees that it cannot loop forever.
> 
> I also agree that no known exploit of this exists, and doubt that
> any could be created.
> 
> I did find the added code logic to be a tad more difficult to read
> than I'd like.  How about the following patch, instead:
> 
> ---
>  kernel/cpuset.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- 2.6.25-mm1.orig/kernel/cpuset.c	2008-07-31 07:05:23.000000000 -0500
> +++ 2.6.25-mm1/kernel/cpuset.c	2008-07-31 07:13:48.000000000 -0500
> @@ -880,6 +880,7 @@ static int update_nodemask(struct cpuset
>  	struct task_struct *p;
>  	struct mm_struct **mmarray;
>  	int i, n, ntasks;
> +	int prev_ntasks = 0;
>  	int migrate;
>  	int fudge;
>  	int retval;
> @@ -939,7 +940,9 @@ static int update_nodemask(struct cpuset
>  	 */
>  	while (1) {
>  		ntasks = cgroup_task_count(cs->css.cgroup);  /* guess */
> +		ntasks = max(ntasks, prev_ntasks);	/* keep increasing */
>  		ntasks += fudge;
> +		prev_ntasks = ntasks;
>  		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
>  		if (!mmarray)
>  			goto done;
> 
> 


