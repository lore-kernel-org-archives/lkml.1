Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZGMWaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZGMWaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZGMWaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:30:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbZGMWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:30:20 -0400
Date: Mon, 13 Jul 2009 15:29:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       linux-mm@kvack.org, fengguang.wu@intel.com, cl@linux-foundation.org,
       riel@redhat.com
Subject: Re: [PATCH 3/4][resend]  Show kernel stack usage in /proc/meminfo
 and OOM log output
Message-Id: <20090713152952.9b1f6388.akpm@linux-foundation.org>
In-Reply-To: <20090713150114.6260.A69D9226@jp.fujitsu.com>
References: <20090713144924.6257.A69D9226@jp.fujitsu.com>
	<20090713150114.6260.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 15:02:25 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> ChangeLog
>   Since v1
>    - Rewrote the descriptin (Thanks Christoph!)
> 
> =====================
> Subject: [PATCH] Show kernel stack usage in /proc/meminfo and OOM log output
> 
> The amount of memory allocated to kernel stacks can become significant and
> cause OOM conditions. However, we do not display the amount of memory
> consumed by stacks.
> 
> Add code to display the amount of memory used for stacks in /proc/meminfo.
> 
> ...
>  
> +static void account_kernel_stack(struct thread_info *ti, int account)
> +{
> +	struct zone *zone = page_zone(virt_to_page(ti));
> +
> +	mod_zone_page_state(zone, NR_KERNEL_STACK, account);
> +}
> +
>  void free_task(struct task_struct *tsk)
>  {
>  	prop_local_destroy_single(&tsk->dirties);
> +	account_kernel_stack(tsk->stack, -1);

But surely there are other less expensive ways of calculating this. 
The number we want is small-known-constant * number-of-tasks.

number-of-tasks probably isn't tracked, but can be calculated along the
lines of nr_running(), nr_uninterruptible() and nr_iowait().

number-of-tasks is also equal to number-of-task_structs and
number-of_thread_infos which can be obtained from slab (if the arch
implemented these via slab - uglier).


