Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZI1Jcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZI1Jcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 05:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZI1Jcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 05:32:50 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:35057 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZI1Jct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 05:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WAb9WQ3MN8DSZPDIU/f0M82uVyiY1rorfiVOzWnopqRfF0rss69gpooNmBfy+IVwR7
         z3Y/SUycfjLfLhiJ9Gpb8/b6u9Lc6NgRB4BxyeZUQEzz6GZ/vo94nIXa3Ftoxb+Qa+b+
         ccmMR1H1GGgW2A0wkB+q7mxQuXt1cUpFNNj+A=
MIME-Version: 1.0
In-Reply-To: <20090928180649.b6b7eea9.kamezawa.hiroyu@jp.fujitsu.com>
References: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org>
	 <20090928154213.8e873dec.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090928180649.b6b7eea9.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 15:02:51 +0530
X-Google-Sender-Auth: 767d3d7fe3b57342
Message-ID: <661de9470909280232q67dd451fkcf063aec671d3ea2@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH][rc1] memcg: fix refcnt goes to minus
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> __mem_cgroup_largest_soft_limit_node() returns a mem_cgroup_per_zone "mz"
> with incremnted mz->mem->css's refcnt.
> Then, the caller of this function has to call css_put(mz->mem->css).
>
> But, mz can be !NULL even if "not found" i.e. without css_get().
> By this, css->refcnt will go down to minus.
>
> This may cause various things...one of results will be
> initite-loop in css_tryget()  as this.
>
> INFO: RCU detected CPU 0 stall (t=10000 jiffies)
> sending NMI to all CPUs:
> NMI backtrace for cpu 0
> CPU 0:
> <snip>
>
>  <<EOE>>  <IRQ>  [<ffffffff810884bd>] trace_hardirqs_off+0xd/0x10
>  [<ffffffff8102a940>] flat_send_IPI_mask+0x90/0xb0
>  [<ffffffff8102a9c9>] flat_send_IPI_all+0x69/0x70
>  [<ffffffff81027372>] arch_trigger_all_cpu_backtrace+0x62/0xa0
>  [<ffffffff810bff8e>] __rcu_pending+0x7e/0x370
>  [<ffffffff810c02c7>] rcu_check_callbacks+0x47/0x130
>  [<ffffffff81063a26>] update_process_times+0x46/0x70
>  [<ffffffff81085930>] tick_sched_timer+0x60/0x160
>  [<ffffffff810858d0>] ? tick_sched_timer+0x0/0x160
>  [<ffffffff8107a03a>] __run_hrtimer+0xba/0x150
>  [<ffffffff8107a325>] hrtimer_interrupt+0xd5/0x1b0
>  [<ffffffff81426dfe>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff8142cacd>] smp_apic_timer_interrupt+0x6d/0x9b
>  [<ffffffff8100cb33>] apic_timer_interrupt+0x13/0x20
>  <EOI>  [<ffffffff811317b6>] ? mem_cgroup_walk_tree+0x156/0x180
>  [<ffffffff811316d3>] ? mem_cgroup_walk_tree+0x73/0x180
>  [<ffffffff81131692>] ? mem_cgroup_walk_tree+0x32/0x180
>  [<ffffffff81131a00>] ? mem_cgroup_get_local_stat+0x0/0x110
>  [<ffffffff81131d5b>] ? mem_control_stat_show+0x14b/0x330
>  [<ffffffff810a57fd>] ? cgroup_seqfile_show+0x3d/0x60
>
> Above shows CPU0 caught in css_tryget()'s inifinite loop because
> of bad refcnt.
>
> This is a fix to set mz=NULL at the top of retry path.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> ---
>  mm/memcontrol.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.32-rc1/mm/memcontrol.c
> ===================================================================
> --- linux-2.6.32-rc1.orig/mm/memcontrol.c
> +++ linux-2.6.32-rc1/mm/memcontrol.c
> @@ -447,9 +447,10 @@ static struct mem_cgroup_per_zone *
>  __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>  {
>        struct rb_node *rightmost = NULL;
> -       struct mem_cgroup_per_zone *mz = NULL;
> +       struct mem_cgroup_per_zone *mz;
>
>  retry:
> +       mz = NULL;
>        rightmost = rb_last(&mctz->rb_root);
>        if (!rightmost)
>                goto done;              /* Nothing to reclaim from */
>

Good catch! So we fail at css_tryget() once, but mz is valid, we
return a non NULL mz and we do a css_put() causing ref count to go
bad. The next iteration that uses this mz will hang? I've not been
able to hit, may be I should test in a really small cgroup under
stress.

Balbir Singh.
