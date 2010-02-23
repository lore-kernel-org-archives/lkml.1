Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0BWOFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:05:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:16254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0BWOFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:05:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,526,1262592000"; 
   d="scan'208";a="775153268"
Date: Tue, 23 Feb 2010 22:04:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Chris Frost <frost@cs.ucla.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lwoodman@redhat.com" <lwoodman@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Tom Zanussi <tzanussi@gmail.com>, "riel@redhat.com" <riel@redhat.com>,
       Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Subject: Re: [RFC PATCH -tip 0/2 v3] pagecache tracepoints proposal
Message-ID: <20100223140435.GA31131@localhost>
References: <4B6B7FBF.9090005@bx.jp.nec.com> <20100205072858.GC9320@elte.hu> <20100208155450.GA17055@localhost> <20100218143429.ddea9bb2.kamezawa.hiroyu@jp.fujitsu.com> <20100218095850.GR5612@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218095850.GR5612@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 05:58:50PM +0800, Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-02-18 14:34:29]:
> > Can we dump page's cgroup ? If so, I'm happy.
> > Maybe
> > ==
> >   struct page_cgroup *pc = lookup_page_cgroup(page);
> >   struct mem_cgroup *mem = pc->mem_cgroup;
> >   shodt mem_cgroup_id = mem->css.css_id;
> > 
> >   And statistics can be counted per css_id.
> >
> 
> Good idea, all of this needs to happen with a check to see if memcg is
> enabled/disabled at boot as well. pc can be NULL if
> CONFIG_CGROUP_MEM_RES_CTLR is not enabled.

Not sure if this is the one in your mind, but I defined a function in
memcontrol.c for the trace code. Compile tested.

It'll be used like this:

        TP_fast_assign(
                        __entry->memcg          = page_memcg_id(page);
                      )

        TP_printk("index=%lu len=%lu flags=%lx count=%u mapcount=%u memcg=%d",

Thanks,
Fengguang

---
memcg: introduce page_memcg_id()

This will be used to dump the memcg id associated with a pagecache page.

CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   16 ++++++++++++++++
 2 files changed, 22 insertions(+)

--- linux-mm.orig/include/linux/memcontrol.h	2010-02-23 21:49:39.000000000 +0800
+++ linux-mm/include/linux/memcontrol.h	2010-02-23 21:50:14.000000000 +0800
@@ -69,6 +69,7 @@ extern void mem_cgroup_out_of_memory(str
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
+extern unsigned short page_memcg_id(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
 static inline
@@ -142,6 +143,11 @@ static inline int mem_cgroup_try_charge_
 	return 0;
 }
 
+static inline unsigned short page_memcg_id(struct page *page)
+{
+	return 0;
+}
+
 static inline void mem_cgroup_commit_charge_swapin(struct page *page,
 					  struct mem_cgroup *ptr)
 {
--- linux-mm.orig/mm/memcontrol.c	2010-02-23 21:48:23.000000000 +0800
+++ linux-mm/mm/memcontrol.c	2010-02-23 21:49:33.000000000 +0800
@@ -324,6 +324,22 @@ static struct mem_cgroup *try_get_mem_cg
 	return mem;
 }
 
+unsigned short page_memcg_id(struct page *page)
+{
+	struct mem_cgroup *mem;
+	struct cgroup_subsys_state *css;
+	unsigned short id = 0;
+
+	mem = try_get_mem_cgroup_from_page(page);
+	if (mem) {
+		css = mem_cgroup_css(mem);
+		id = css_id(css);
+		css_put(css);
+	}
+
+	return id;
+}
+
 /*
  * Call callback function against all cgroup under hierarchy tree.
  */
