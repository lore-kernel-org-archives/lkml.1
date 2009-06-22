Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZFVMRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZFVMRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZFVMRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:17:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35208 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZFVMRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:17:44 -0400
Date: Mon, 22 Jun 2009 17:46:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH] cgroup: fix permanent wait in rmdir
Message-ID: <20090622121654.GA9561@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090622183707.dd9e665b.kamezawa.hiroyu@jp.fujitsu.com> <20090622105231.GA17242@elte.hu> <18e69edd004ec13730246bd40600448c.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <18e69edd004ec13730246bd40600448c.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-06-22 20:27:15]:

> Ingo Molnar wrote:
> >
> > FYI, there's a new cgroup related list corruption warning/crash that
> > i've seen a lot of times in latest -tip tests:
> >
> > [  478.555544] ------------[ cut here ]------------
> > [  478.556523] WARNING: at lib/list_debug.c:26 __list_add+0x70/0xa0()
> > [  478.556523] Hardware name:
> > [  478.556523] list_add corruption. next->prev should be prev
> > (ffff88003e640448), but was ffff88003fa1a6e8. (next=ffff88003fa1a8a0).
> > [  478.556523] Modules linked in:
> > [  478.556523] Pid: 470, comm: kswapd0 Not tainted 2.6.30-tip #10989
> > [  478.556523] Call Trace:
> > [  478.556523]  [<ffffffff81306150>] ? __list_add+0x70/0xa0
> > [  478.556523]  [<ffffffff810598dc>] warn_slowpath_common+0x8c/0xc0
> > [  478.556523]  [<ffffffff81059999>] warn_slowpath_fmt+0x69/0x70
> > [  478.556523]  [<ffffffff81086e3b>] ? __lock_acquired+0x18b/0x2b0
> > [  478.556523]  [<ffffffff811022f0>] ? page_check_address+0x110/0x1a0
> > [  478.556523]  [<ffffffff812ebcf2>] ? cpumask_any_but+0x42/0xb0
> > [  478.556523]  [<ffffffff8108c528>] ? __lock_release+0x38/0x90
> > [  478.556523]  [<ffffffff811024e1>] ? page_referenced_one+0x91/0x120
> > [  478.556523]  [<ffffffff81306150>] __list_add+0x70/0xa0
> > [  478.556523]  [<ffffffff8111dc63>] mem_cgroup_add_lru_list+0x63/0x70
> > [  478.556523]  [<ffffffff810eaee4>] move_active_pages_to_lru+0xf4/0x180
> > [  478.556523]  [<ffffffff810eb758>] ? shrink_active_list+0x1f8/0x2a0
> > [  478.556523]  [<ffffffff810eb758>] ? shrink_active_list+0x1f8/0x2a0
> > [  478.556523]  [<ffffffff810eb794>] shrink_active_list+0x234/0x2a0
> > [  478.556523]  [<ffffffff810ec3c3>] shrink_zone+0x173/0x1f0
> > [  478.556523]  [<ffffffff810ece0a>] balance_pgdat+0x4da/0x4e0
> > [  478.556523]  [<ffffffff810eb240>] ? isolate_pages_global+0x0/0x60
> > [  478.556523]  [<ffffffff810ed3b6>] kswapd+0x106/0x150
> > [  478.556523]  [<ffffffff810752f0>] ? autoremove_wake_function+0x0/0x40
> > [  478.556523]  [<ffffffff810ed2b0>] ? kswapd+0x0/0x150
> > [  478.556523]  [<ffffffff8107516e>] kthread+0x9e/0xb0
> > [  478.556523]  [<ffffffff8100d2ba>] child_rip+0xa/0x20
> > [  478.556523]  [<ffffffff8100cc40>] ? restore_args+0x0/0x30
> > [  478.556523]  [<ffffffff81075085>] ? kthreadd+0xb5/0x100
> > [  478.556523]  [<ffffffff810750d0>] ? kthread+0x0/0xb0
> > [  478.556523]  [<ffffffff8100d2b0>] ? child_rip+0x0/0x20
> > [  478.556523] ---[ end trace 9f3122957c34141e ]---
> > [  484.923530] ------------[ cut here ]------------
> > [  484.924525] WARNING: at lib/list_debug.c:26 __list_add+0x70/0xa0()
> > [  484.924525] Hardware name:
> > [  484.924525] list_add corruption. next->prev should be prev
> > (ffff88003e640448), but was ffff88003fa192e8. (next=ffff88003fa14d88).
> > [  484.941152] Modules linked in:
> > [  484.941152] Pid: 470, comm: kswapd0 Tainted: G        W  2.6.30-tip
> > #10989
> > [  484.941152] Call Trace:
> > [  484.941152]  [<ffffffff81306150>] ? __list_add+0x70/0xa0
> > [  484.941152]  [<ffffffff810598dc>] warn_slowpath_common+0x8c/0xc0
> > [  484.941152]  [<ffffffff81059999>] warn_slowpath_fmt+0x69/0x70
> > [  484.941152]  [<ffffffff81086e3b>] ? __lock_acquired+0x18b/0x2b0
> > [  484.941152]  [<ffffffff811022f0>] ? page_check_address+0x110/0x1a0
> > [  484.941152]  [<ffffffff812ebcf2>] ? cpumask_any_but+0x42/0xb0
> > [  484.941152]  [<ffffffff8108c528>] ? __lock_release+0x38/0x90
> > [  484.941152]  [<ffffffff811024e1>] ? page_referenced_one+0x91/0x120
> > [  484.941152]  [<ffffffff81306150>] __list_add+0x70/0xa0
> > [  484.941152]  [<ffffffff8111dc63>] mem_cgroup_add_lru_list+0x63/0x70
> > [  484.941152]  [<ffffffff810eaee4>] move_active_pages_to_lru+0xf4/0x180
> > [  484.941152]  [<ffffffff810eb758>] ? shrink_active_list+0x1f8/0x2a0
> > [  484.941152]  [<ffffffff810eb758>] ? shrink_active_list+0x1f8/0x2a0
> > [  484.941152]  [<ffffffff810eb794>] shrink_active_list+0x234/0x2a0
> > [  484.941152]  [<ffffffff810ec3c3>] shrink_zone+0x173/0x1f0
> > [  484.941152]  [<ffffffff810ece0a>] balance_pgdat+0x4da/0x4e0
> > [  484.941152]  [<ffffffff810eb240>] ? isolate_pages_global+0x0/0x60
> > [  484.941152]  [<ffffffff810ed3b6>] kswapd+0x106/0x150
> > [  484.941152]  [<ffffffff810752f0>] ? autoremove_wake_function+0x0/0x40
> > [  484.941152]  [<ffffffff810ed2b0>] ? kswapd+0x0/0x150
> > [  484.941152]  [<ffffffff8107516e>] kthread+0x9e/0xb0
> > [  484.941152]  [<ffffffff8100d2ba>] child_rip+0xa/0x20
> > [  484.941152]  [<ffffffff8100cc40>] ? restore_args+0x0/0x30
> > [  484.941152]  [<ffffffff81075085>] ? kthreadd+0xb5/0x100
> > [  484.941152]  [<ffffffff810750d0>] ? kthread+0x0/0xb0
> > [  484.941152]  [<ffffffff8100d2b0>] ? child_rip+0x0/0x20
> > [  484.941152] ---[ end trace 9f3122957c34141f ]---
> > [  485.365631] ------------[ cut here ]------------
> > [  485.368029] WARNING: at lib/list_debug.c:26 __list_add+0x70/0xa0()
> >
> > has this been reported before? Is there a fix for it i missed?
> >
> Hmm, looks new one.
> 
> Maybe related to my latest post which modifies __isolate_lru_page()
> memcg: fix lru rotation in isolate_pages
> 
> I'll dig tomorrow, sorry.
>

Hi, Ingo

Thanks for the bug report, looks new to me as well. Could you share
how you see this? Is it just regular use of a machine, some workload
running? Looks like it is happening in the reclaim path,
interesting...

-- 
	Balbir
