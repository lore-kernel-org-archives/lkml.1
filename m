Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZFWHbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZFWHbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZFWHbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:31:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45163 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZFWHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:31:30 -0400
Date: Tue, 23 Jun 2009 16:29:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] fix bad page removal from LRU (Was Re:
 [RFC][PATCH] cgroup: fix permanent wait in rmdir
Message-Id: <20090623162951.b4057104.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090623162759.94ba43d0.nishimura@mxp.nes.nec.co.jp>
References: <20090622183707.dd9e665b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090622105231.GA17242@elte.hu>
	<20090623085755.9cf75da2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090623162759.94ba43d0.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 16:27:59 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Tue, 23 Jun 2009 08:57:55 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 22 Jun 2009 12:52:31 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > FYI, there's a new cgroup related list corruption warning/crash that 
> > > i've seen a lot of times in latest -tip tests:
> > > 
> > > [  478.555544] ------------[ cut here ]------------
> > > [  478.556523] WARNING: at lib/list_debug.c:26 __list_add+0x70/0xa0()
> > > [  478.556523] Hardware name:         
> > > [  478.556523] list_add corruption. next->prev should be prev (ffff88003e640448), but was ffff88003fa1a6e8. (next=ffff88003fa1a8a0).
> > > [  478.556523] Modules linked in:
> > > [  478.556523] Pid: 470, comm: kswapd0 Not tainted 2.6.30-tip #10989
> > > [  478.556523] Call Trace:
> > > [  478.556523]  [<ffffffff81306150>] ? __list_add+0x70/0xa0
> > > [  478.556523]  [<ffffffff810598dc>] warn_slowpath_common+0x8c/0xc0
> > > [  478.556523]  [<ffffffff81059999>] warn_slowpath_fmt+0x69/0x70
> > > [  478.556523]  [<ffffffff81086e3b>] ? __lock_acquired+0x18b/0x2b0
> > > [  478.556523]  [<ffffffff811022f0>] ? page_check_address+0x110/0x1a0
> > > [  478.556523]  [<ffffffff812ebcf2>] ? cpumask_any_but+0x42/0xb0
> > > [  478.556523]  [<ffffffff8108c528>] ? __lock_release+0x38/0x90
> > > [  478.556523]  [<ffffffff811024e1>] ? page_referenced_one+0x91/0x120
> > > [  478.556523]  [<ffffffff81306150>] __list_add+0x70/0xa0
> > > [  478.556523]  [<ffffffff8111dc63>] mem_cgroup_add_lru_list+0x63/0x70
> > > [  478.556523]  [<ffffffff810eaee4>] move_active_pages_to_lru+0xf4/0x180
> > > [  478.556523]  [<ffffffff810eb758>] ? shrink_active_list+0x1f8/0x2a0
> > > [  478.556523]  [<ffffffff810eb758>] ? shrink_active_list+0x1f8/0x2a0
> > > [  478.556523]  [<ffffffff810eb794>] shrink_active_list+0x234/0x2a0
> > > [  478.556523]  [<ffffffff810ec3c3>] shrink_zone+0x173/0x1f0
> > > [  478.556523]  [<ffffffff810ece0a>] balance_pgdat+0x4da/0x4e0
> > > [  478.556523]  [<ffffffff810eb240>] ? isolate_pages_global+0x0/0x60
> > > [  478.556523]  [<ffffffff810ed3b6>] kswapd+0x106/0x150
> > > [  478.556523]  [<ffffffff810752f0>] ? autoremove_wake_function+0x0/0x40
> > > [  478.556523]  [<ffffffff810ed2b0>] ? kswapd+0x0/0x150
> > > [  478.556523]  [<ffffffff8107516e>] kthread+0x9e/0xb0
> > > [  478.556523]  [<ffffffff8100d2ba>] child_rip+0xa/0x20
> > > [  478.556523]  [<ffffffff8100cc40>] ? restore_args+0x0/0x30
> > > [  478.556523]  [<ffffffff81075085>] ? kthreadd+0xb5/0x100
> > > [  478.556523]  [<ffffffff810750d0>] ? kthread+0x0/0xb0
> > > [  478.556523]  [<ffffffff8100d2b0>] ? child_rip+0x0/0x20
> > > [  478.556523] ---[ end trace 9f3122957c34141e ]---
> > > [  484.923530] ------------[ cut here ]------------
> > > [  484.924525] WARNING: at lib/list_debug.c:26 __list_add+0x70/0xa0()
> > > [  484.924525] Hardware name:         
> > > [  484.924525] list_add corruption. next->prev should be prev (ffff88003e640448), but was ffff88003fa192e8. (next=ffff88003fa14d88).
> > > [  484.941152] Modules linked in:
> > > [  484.941152] Pid: 470, comm: kswapd0 Tainted: G        W  2.6.30-tip #10989
> > > [  484.941152] Call Trace:
> > > [  484.941152]  [<ffffffff81306150>] ? __list_add+0x70/0xa0
> > > [  484.941152]  [<ffffffff810598dc>] warn_slowpath_common+0x8c/0xc0
> > > [  484.941152]  [<ffffffff81059999>] warn_slowpath_fmt+0x69/0x70
> > > [  484.941152]  [<ffffffff81086e3b>] ? __lock_acquired+0x18b/0x2b0
> > > [  484.941152]  [<ffffffff811022f0>] ? page_check_address+0x110/0x1a0
> > > [  484.941152]  [<ffffffff812ebcf2>] ? cpumask_any_but+0x42/0xb0
> > > [  484.941152]  [<ffffffff8108c528>] ? __lock_release+0x38/0x90
> > > [  484.941152]  [<ffffffff811024e1>] ? page_referenced_one+0x91/0x120
> > > [  484.941152]  [<ffffffff81306150>] __list_add+0x70/0xa0
> > > [  484.941152]  [<ffffffff8111dc63>] mem_cgroup_add_lru_list+0x63/0x70
> > > [  484.941152]  [<ffffffff810eaee4>] move_active_pages_to_lru+0xf4/0x180
> > > [  484.941152]  [<ffffffff810eb758>] ? shrink_active_list+0x1f8/0x2a0
> > > [  484.941152]  [<ffffffff810eb758>] ? shrink_active_list+0x1f8/0x2a0
> > > [  484.941152]  [<ffffffff810eb794>] shrink_active_list+0x234/0x2a0
> > > [  484.941152]  [<ffffffff810ec3c3>] shrink_zone+0x173/0x1f0
> > > [  484.941152]  [<ffffffff810ece0a>] balance_pgdat+0x4da/0x4e0
> > > [  484.941152]  [<ffffffff810eb240>] ? isolate_pages_global+0x0/0x60
> > > [  484.941152]  [<ffffffff810ed3b6>] kswapd+0x106/0x150
> > > [  484.941152]  [<ffffffff810752f0>] ? autoremove_wake_function+0x0/0x40
> > > [  484.941152]  [<ffffffff810ed2b0>] ? kswapd+0x0/0x150
> > > [  484.941152]  [<ffffffff8107516e>] kthread+0x9e/0xb0
> > > [  484.941152]  [<ffffffff8100d2ba>] child_rip+0xa/0x20
> > > [  484.941152]  [<ffffffff8100cc40>] ? restore_args+0x0/0x30
> > > [  484.941152]  [<ffffffff81075085>] ? kthreadd+0xb5/0x100
> > > [  484.941152]  [<ffffffff810750d0>] ? kthread+0x0/0xb0
> > > [  484.941152]  [<ffffffff8100d2b0>] ? child_rip+0x0/0x20
> > > [  484.941152] ---[ end trace 9f3122957c34141f ]---
> > > [  485.365631] ------------[ cut here ]------------
> > > [  485.368029] WARNING: at lib/list_debug.c:26 __list_add+0x70/0xa0()
> > > 
> > > has this been reported before? Is there a fix for it i missed?
> > > 
> > 
> > I think this is a fix for the problem. Sorry for regression.
> > fix for "memcg: fix lru rotation in isolate_pages" patch in 2.6.30-git18.
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > A page isolated is "cursor_page" not "page".
> > This causes list corruption finally.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I reproduced this bug and have confirmed that this patch fixes it.
> 
> 	Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
Thank you!!

-Kame

