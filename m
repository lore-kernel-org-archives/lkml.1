Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZEIJjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZEIJjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZEIJiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:38:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZEIJix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:38:53 -0400
Subject: Re: [PATCH v3] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu
 cputime count
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20090509182541.8D0F.A69D9226@jp.fujitsu.com>
References: <20090507185831.9D24.A69D9226@jp.fujitsu.com>
	 <20090507105007.GA28398@elte.hu>
	 <20090509182541.8D0F.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Sat, 09 May 2009 11:38:45 +0200
Message-Id: <1241861925.6316.112.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-09 at 18:26 +0900, KOSAKI Motohiro wrote:
> 
> Index: b/kernel/sched.c
> ===================================================================
> --- a/kernel/sched.c    2009-05-09 16:48:08.000000000 +0900
> +++ b/kernel/sched.c    2009-05-09 18:16:00.000000000 +0900
> @@ -824,8 +824,12 @@ static struct file_operations sched_feat
>         .release        = single_release,
>  };
>  
> +static __read_mostly s32 cpuacct_batch;
> +
>  static __init int sched_init_debug(void)
>  {
> +       cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> +
>         debugfs_create_file("sched_features", 0644, NULL, NULL,
>                         &sched_feat_fops);

I'm pretty user you can select cpu accounting without SCHED_DEBUG...

> @@ -10457,7 +10461,8 @@ static void cpuacct_update_stats(struct 
>         ca = task_ca(tsk);
>  
>         do {
> -               percpu_counter_add(&ca->cpustat[idx], val);
> +               __percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
> +
>                 ca = ca->parent;
>         } while (ca);
>         rcu_read_unlock();
> 

