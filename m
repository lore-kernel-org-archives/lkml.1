Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYIHIVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYIHIVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 04:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYIHIVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 04:21:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49355 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYIHIVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 04:21:17 -0400
Message-ID: <48C4E012.4060400@cn.fujitsu.com>
Date: Mon, 08 Sep 2008 16:19:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: Re: [PATCH] cgroup(fix critical bug): new handling for tasks
 file
References: <48B360CE.2010501@cn.fujitsu.com>	 <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>	 <48B39319.7070403@cn.fujitsu.com>	 <6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>	 <48B4D81D.2040200@cn.fujitsu.com> <6599ad830808270536i353e1807kaac4e9fb74301bb0@mail.gmail.com> <48B69582.4000208@cn.fujitsu.com> <48C0C4F7.2080702@google.com>
In-Reply-To: <48C0C4F7.2080702@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's great, Thanks!

	Lai Jiangshan.


Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Paul Menage wrote:

> - allocate an array of single pages rather than a single kmalloc() region

I will send a patch for it in few days.

> +
> +static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
>  {
> -	int cnt = 0;
> -	int i;
> +	/*
> +	 * Initially we receive a position value that corresponds to
> +	 * one more than the last pid shown (or 0 on the first call or
> +	 * after a seek to the start). Use a binary-search to find the
> +	 * next pid to display, if any
> +	 */
> +	struct cgroup *cgrp = s->private;
> +	int index = 0, pid = *pos;
> +	int *iter;

use pid_t instead of int (include other functions)

> +
> +	down_read(&cgrp->pids_mutex);
> +	if (pid) {
> +		int end = cgrp->pids_length;
> +		int i;

int i; unused.

> +		while (index < end) {
> +			int mid = (index + end) / 2;
> +			if (cgrp->tasks_pids[mid] == pid) {
> +				index = mid;
> +				break;
> +			} else if (cgrp->tasks_pids[mid] <= pid)

(cgrp->tasks_pids[mid] <= pid) ===> (cgrp->tasks_pids[mid] < pid)

> +				index = mid + 1;
> +			else
> +				end = mid;
> +		}
> +	}

