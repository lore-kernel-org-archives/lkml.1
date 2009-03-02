Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZCBFeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZCBFeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 00:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZCBFeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 00:34:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60572 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZCBFeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 00:34:11 -0500
Date: Mon, 2 Mar 2009 14:32:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Memory controller soft limit patches (v3)
Message-Id: <20090302143250.f47758f9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090302044043.GC11421@balbir.in.ibm.com>
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
	<20090302092404.1439d2a6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302044043.GC11421@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 10:10:43 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 09:24:04]:
> 
> > On Sun, 01 Mar 2009 11:59:59 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > 
> > > From: Balbir Singh <balbir@linux.vnet.ibm.com>

> > 
> > At first, it's said "When cgroup people adds something, the kernel gets slow".
> > This is my start point of reviewing. Below is comments to this version of patch.
> > 
> >  1. I think it's bad to add more hooks to res_counter. It's enough slow to give up
> >     adding more fancy things..
> 
> res_counters was desgined to be extensible, why is adding anything to
> it going to make it slow, unless we turn on soft_limits?
> 
You inserted new "if" logic in the core loop.
(What I want to say here is not that this is definitely bad but that "isn't there
 any alternatives which is less overhead.)


> > 
> >  2. please avoid to add hooks to hot-path. In your patch, especially a hook to
> >     mem_cgroup_uncharge_common() is annoying me.
> 
> If soft limits are not enabled, the function does a small check and
> leaves. 
> 
&soft_fail_res is passed always even if memory.soft_limit==ULONG_MAX
res_counter_soft_limit_excess() adds one more function call and spinlock, and irq-off.

> > 
> >  3. please avoid to use global spinlock more. 
> >     no lock is best. mutex is better, maybe.
> > 
> 
> No lock to update a tree which is update concurrently?
> 
Using tree/sort itself is nonsense, I believe.


> >  4. RB-tree seems broken. Following is example. (please note you do all ops
> >     in lazy manner (once in HZ/4.)
> > 
> >    i). while running, the tree is constructed as following
> > 
> >              R           R=exceed=300M
> >             / \ 
> >            A   B      A=exceed=200M  B=exceed=400M
> >    ii) A process B exits, but and usage goes down.
> 
> That is why we have the hook in uncharge. Even if we update and the
> usage goes down, the tree is ordered by usage_in_excess which is
> updated only when the tree is updated. So what you show below does not
> occur. I think I should document the design better.
> 

time_check==true. So, update-tree at uncharge() only happens once in HZ/4
==
@@ -1422,6 +1520,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
+	mem_cgroup_check_and_update_tree(mem, true);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		css_put(&mem->css);
==
Then, not-sorted RB-tree can be there.

BTW,
   time_after(jiffies, 0)
is buggy (see definition). If you want make this true always,
   time_after(jiffies, jiffies +1)

Thanks,
-Kame



