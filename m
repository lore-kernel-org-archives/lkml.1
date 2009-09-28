Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZI1LWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZI1LWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 07:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZI1LWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 07:22:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34540 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZI1LWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 07:22:38 -0400
Message-ID: <a15a1673b361dc2f5c9b1fb670e5c23e.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <661de9470909280232q67dd451fkcf063aec671d3ea2@mail.gmail.com>
References: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org>
    <20090928154213.8e873dec.kamezawa.hiroyu@jp.fujitsu.com>
    <20090928180649.b6b7eea9.kamezawa.hiroyu@jp.fujitsu.com>
    <661de9470909280232q67dd451fkcf063aec671d3ea2@mail.gmail.com>
Date: Mon, 28 Sep 2009 20:22:39 +0900 (JST)
Subject: Re: [BUGFIX][PATCH][rc1] memcg: fix refcnt goes to minus
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>> __mem_cgroup_largest_soft_limit_node() returns a mem_cgroup_per_zone
>> "mz"
>> with incremnted mz->mem->css's refcnt.
>> Then, the caller of this function has to call css_put(mz->mem->css).
>>
>> But, mz can be !NULL even if "not found" i.e. without css_get().
>> By this, css->refcnt will go down to minus.
>>
>> This may cause various things...one of results will be
>> initite-loop in css_tryget() &#160;as this.
>>
>> INFO: RCU detected CPU 0 stall (t=10000 jiffies)
>> sending NMI to all CPUs:
>> NMI backtrace for cpu 0
>> CPU 0:
>> <snip>
>>
>> &#160;<<EOE>> &#160;<IRQ> &#160;[<ffffffff810884bd>]
trace_hardirqs_off+0xd/0x10
>> &#160;[<ffffffff8102a940>] flat_send_IPI_mask+0x90/0xb0
>> &#160;[<ffffffff8102a9c9>] flat_send_IPI_all+0x69/0x70
>> &#160;[<ffffffff81027372>] arch_trigger_all_cpu_backtrace+0x62/0xa0
>> &#160;[<ffffffff810bff8e>] __rcu_pending+0x7e/0x370
>> &#160;[<ffffffff810c02c7>] rcu_check_callbacks+0x47/0x130
>> &#160;[<ffffffff81063a26>] update_process_times+0x46/0x70
>> &#160;[<ffffffff81085930>] tick_sched_timer+0x60/0x160
>> &#160;[<ffffffff810858d0>] ? tick_sched_timer+0x0/0x160
>> &#160;[<ffffffff8107a03a>] __run_hrtimer+0xba/0x150
>> &#160;[<ffffffff8107a325>] hrtimer_interrupt+0xd5/0x1b0
>> &#160;[<ffffffff81426dfe>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>> &#160;[<ffffffff8142cacd>] smp_apic_timer_interrupt+0x6d/0x9b
>> &#160;[<ffffffff8100cb33>] apic_timer_interrupt+0x13/0x20
>> &#160;<EOI> &#160;[<ffffffff811317b6>] ? mem_cgroup_walk_tree+0x156/0x180
>> &#160;[<ffffffff811316d3>] ? mem_cgroup_walk_tree+0x73/0x180
>> &#160;[<ffffffff81131692>] ? mem_cgroup_walk_tree+0x32/0x180
>> &#160;[<ffffffff81131a00>] ? mem_cgroup_get_local_stat+0x0/0x110
>> &#160;[<ffffffff81131d5b>] ? mem_control_stat_show+0x14b/0x330
>> &#160;[<ffffffff810a57fd>] ? cgroup_seqfile_show+0x3d/0x60
>>
>> Above shows CPU0 caught in css_tryget()'s inifinite loop because
>> of bad refcnt.
>>
>> This is a fix to set mz=NULL at the top of retry path.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> ---
>> &#160;mm/memcontrol.c | &#160; &#160;3 ++-
>> &#160;1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6.32-rc1/mm/memcontrol.c
>> ===================================================================
>> --- linux-2.6.32-rc1.orig/mm/memcontrol.c
>> +++ linux-2.6.32-rc1/mm/memcontrol.c
>> @@ -447,9 +447,10 @@ static struct mem_cgroup_per_zone *
>> &#160;__mem_cgroup_largest_soft_limit_node(struct
mem_cgroup_tree_per_zone *mctz)
>> &#160;{
>> &#160; &#160; &#160; &#160;struct rb_node *rightmost = NULL;
>> - &#160; &#160; &#160; struct mem_cgroup_per_zone *mz = NULL;
>> + &#160; &#160; &#160; struct mem_cgroup_per_zone *mz;
>>
>> &#160;retry:
>> + &#160; &#160; &#160; mz = NULL;
>> &#160; &#160; &#160; &#160;rightmost = rb_last(&mctz->rb_root);
>> &#160; &#160; &#160; &#160;if (!rightmost)
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;goto done;
&#160; &#160; &#160; &#160; &#160; &#160; &#160;/* Nothing to reclaim
from */
>>
>
> Good catch! So we fail at css_tryget() once, but mz is valid, we
> return a non NULL mz and we do a css_put() causing ref count to go
> bad.
yes.
> The next iteration that uses this mz will hang?
Maybe no. next css_tryget() hangs if css->refcnt is 0.

> I've not been
> able to hit, may be I should test in a really small cgroup under
> stress.
>
Maybe my small patch (not posted yet) affected and I couldn't reproduce it.
But the bug itself should be fixed.
(So, I want to add a sanity check to css_put()).

Thanks,
-Kame


> Balbir Singh.
>


