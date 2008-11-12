Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbYKLD3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbYKLD3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYKLD3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:29:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46114 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYKLD3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:29:13 -0500
Date: Wed, 12 Nov 2008 12:28:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: [RFC][PATCH 3/6] memcg: mem+swap controller kconfig
Message-Id: <20081112122833.a6edb391.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Config and control variable for mem+swap controller.

This patch adds CONFIG_CGROUP_MEM_RES_CTLR_SWAP
(memory resource controller swap extension.)

For accounting swap, it's obvious that we have to use additional memory
to remember "who uses swap". This adds more overhead.
So, it's better to offer "choice" to users. This patch adds 2 choices.

This patch adds 2 parameters to enable swap extension or not.
  - CONFIG
  - boot option

Changelog: v2 -> v3
 - adjusted to avoid HUNK.

Changelog: v1 -> v2
 - fixed typo.
 - make default value of "do_swap_account" to be 0 and turned on 1
   later if configured.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 Documentation/kernel-parameters.txt |    3 +++
 include/linux/memcontrol.h          |    3 +++
 init/Kconfig                        |   17 +++++++++++++++++
 mm/memcontrol.c                     |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)

Index: mmotm-2.6.28-Nov10/init/Kconfig
===================================================================
--- mmotm-2.6.28-Nov10.orig/init/Kconfig
+++ mmotm-2.6.28-Nov10/init/Kconfig
@@ -428,6 +428,23 @@ config CGROUP_MEM_RES_CTLR
 config MM_OWNER
 	bool
 
+config CGROUP_MEM_RES_CTLR_SWAP
+	bool "Memory Resource Controller Swap Extension(EXPERIMENTAL)"
+	depends on CGROUP_MEM_RES_CTLR && SWAP && EXPERIMENTAL
+	help
+	  Add swap management feature to memory resource controller. When you
+	  enable this, you can limit mem+swap usage per cgroup. In other words,
+	  when you disable this, memory resource controller has no cares to
+	  usage of swap...a process can exhaust all of the swap. This extension
+	  is useful when you want to avoid exhaustion swap but this itself
+	  adds more overheads and consumes memory for remembering information.
+	  Especially if you use 32bit system or small memory system, please
+	  be careful about enabling this. When memory resource controller
+	  is disabled by boot option, this will be automatically disabled and
+	  there will be no overhead from this. Even when you set this config=y,
+	  if boot option "noswapaccount" is set, swap will not be accounted.
+
+
 endmenu
 
 config SYSFS_DEPRECATED
Index: mmotm-2.6.28-Nov10/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Nov10.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Nov10/mm/memcontrol.c
@@ -42,6 +42,15 @@
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+/* Turned on only when memory cgroup is enabled && really_do_swap_account = 0 */
+int do_swap_account __read_mostly;
+static int really_do_swap_account __initdata = 1; /* for remember boot option*/
+#else
+#define do_swap_account		(0)
+#endif
+
+
 /*
  * Statistics for memory cgroup.
  */
@@ -1510,6 +1519,18 @@ static void mem_cgroup_free(struct mem_c
 }
 
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+static void __init enable_swap_cgroup(void)
+{
+	if (!mem_cgroup_subsys.disabled && really_do_swap_account)
+		do_swap_account = 1;
+}
+#else
+static void __init enable_swap_cgroup(void)
+{
+}
+#endif
+
 static struct cgroup_subsys_state *
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
@@ -1521,6 +1542,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		mem = &init_mem_cgroup;
 		/* do this in explicit way. */
 		mem->on_rmdir = 0;
+		enable_swap_cgroup();
 	} else {
 		mem = mem_cgroup_alloc();
 		if (!mem)
@@ -1607,3 +1629,13 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.attach = mem_cgroup_move_task,
 	.early_init = 0,
 };
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+
+static int __init disable_swap_account(char *s)
+{
+	really_do_swap_account = 0;
+	return 1;
+}
+__setup("noswapaccount", disable_swap_account);
+#endif
Index: mmotm-2.6.28-Nov10/Documentation/kernel-parameters.txt
===================================================================
--- mmotm-2.6.28-Nov10.orig/Documentation/kernel-parameters.txt
+++ mmotm-2.6.28-Nov10/Documentation/kernel-parameters.txt
@@ -1554,6 +1554,9 @@ and is between 256 and 4096 characters. 
 
 	nosoftlockup	[KNL] Disable the soft-lockup detector.
 
+	noswapaccount	[KNL] Disable accounting of swap in memory resource
+			controller. (See Documentation/controllers/memory.txt)
+
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
 	notsc		[BUGS=X86-32] Disable Time Stamp Counter
Index: mmotm-2.6.28-Nov10/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.28-Nov10.orig/include/linux/memcontrol.h
+++ mmotm-2.6.28-Nov10/include/linux/memcontrol.h
@@ -77,6 +77,9 @@ extern void mem_cgroup_record_reclaim_pr
 extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
 					int priority, enum lru_list lru);
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+extern int do_swap_account;
+#endif
 
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;

