Return-Path: <linux-kernel-owner+w=401wt.eu-S934625AbZJIXv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625AbZJIXv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934530AbZJIXv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:51:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934546AbZJIXv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:51:27 -0400
Date: Fri, 9 Oct 2009 16:50:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       h-shimamoto@ct.jp.nec.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: coalescing charge by percpu (Oct/9)
Message-Id: <20091009165002.629a91d2.akpm@linux-foundation.org>
In-Reply-To: <20091009170105.170e025f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091009165826.59c6f6e3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091009170105.170e025f.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 17:01:05 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +static void drain_all_stock_async(void)
> +{
> +	int cpu;
> +	/* This function is for scheduling "drain" in asynchronous way.
> +	 * The result of "drain" is not directly handled by callers. Then,
> +	 * if someone is calling drain, we don't have to call drain more.
> +	 * Anyway, work_pending() will catch if there is a race. We just do
> +	 * loose check here.
> +	 */
> +	if (atomic_read(&memcg_drain_count))
> +		return;
> +	/* Notify other cpus that system-wide "drain" is running */
> +	atomic_inc(&memcg_drain_count);
> +	get_online_cpus();
> +	for_each_online_cpu(cpu) {
> +		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
> +		if (work_pending(&stock->work))
> +			continue;
> +		INIT_WORK(&stock->work, drain_local_stock);
> +		schedule_work_on(cpu, &stock->work);
> +	}
> + 	put_online_cpus();
> +	atomic_dec(&memcg_drain_count);
> +	/* We don't wait for flush_work */
> +}

It's unusual to run INIT_WORK() each time we use a work_struct. 
Usually we will run INIT_WORK a single time, then just repeatedly use
that structure.  Because after the work has completed, it is still in a
ready-to-use state.

Running INIT_WORK() repeatedly against the same work_struct adds a risk
that we'll scribble on an in-use work_struct, which would make a big
mess.

