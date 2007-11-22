Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXKVDmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXKVDmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 22:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbXKVDmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 22:42:10 -0500
Received: from paragon.brong.net ([74.52.187.94]:35077 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbXKVDmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 22:42:08 -0500
Date: Thu, 22 Nov 2007 14:42:04 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Bron Gondwana <brong@fastmail.fm>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: [PATCH 1/1] mm: add dirty_highmem option
Message-ID: <20071122034204.GA14079@brong.net>
References: <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org> <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org> <20071115115049.GA8297@brong.net> <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org> <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:14:32PM -0800, Linus Torvalds wrote:
> Examples of non-broken solutions:
>  (a) always use lowmem sizes (what we do now)
>  (b) always use total mem sizes (sane but potentially dangerous: but the 
>      VM pressure should work! It has serious bounce-buffer issues, though, 
>      which is why I think it's crazy even if it's otherwise consistent)
> 
> Btw, I actually suspect that while (a) is what we do now, for the specific 
> case that Bron has, we could have a /proc/sys/vm option to just enable 
> (b). So we don't have to have just one consistent model, we can allow odd 
> users (and Bron sounds like one - sorry Bron ;) to just force other, odd, 
> but consistent models.

A 32 bit machine with HIGHMEM64 enabled running DCC has an MMAPed file
of approximately 2Gb size which contains a hash format that is written
"randomly" by the dbclean process.  On 2.6.16 this process took a few
minutes.  With lowmem only accounting of dirty ratios, this takes about
12 hours of 100% disk IO, all random writes.

This patch includes some code cleanup from Linus and a toggle in
/proc/sys/vm/dirty_highmem which can be set to 1 to add the highmem
back to the total available memory count.

Signed-off-by: Bron Gondwana <brong@fastmail.fm>

Index: linux-2.6.23.8-reiserfix-fai-vmdirty/mm/page-writeback.c
===================================================================
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/mm/page-writeback.c	2007-11-22 01:48:20.000000000 +0000
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/mm/page-writeback.c	2007-11-22 02:42:04.000000000 +0000
@@ -70,6 +70,12 @@ static inline long sync_writeback_pages(
 int dirty_background_ratio = 5;
 
 /*
+ * free highmem will not be subtracted from the total free memory
+ * for calculating free ratios if vm_dirty_highmem is true
+ */
+int vm_dirty_highmem;
+
+/*
  * The generator of dirty data starts writeback at this percentage
  */
 int vm_dirty_ratio = 10;
@@ -153,7 +159,8 @@ static unsigned long determine_dirtyable
 	x = global_page_state(NR_FREE_PAGES)
 		+ global_page_state(NR_INACTIVE)
 		+ global_page_state(NR_ACTIVE);
-	x -= highmem_dirtyable_memory(x);
+	if (!vm_dirty_highmem)
+		x -= highmem_dirtyable_memory(x);
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
@@ -163,20 +170,12 @@ get_dirty_limits(long *pbackground, long
 {
 	int background_ratio;		/* Percentages */
 	int dirty_ratio;
-	int unmapped_ratio;
 	long background;
 	long dirty;
 	unsigned long available_memory = determine_dirtyable_memory();
 	struct task_struct *tsk;
 
-	unmapped_ratio = 100 - ((global_page_state(NR_FILE_MAPPED) +
-				global_page_state(NR_ANON_PAGES)) * 100) /
-					available_memory;
-
 	dirty_ratio = vm_dirty_ratio;
-	if (dirty_ratio > unmapped_ratio / 2)
-		dirty_ratio = unmapped_ratio / 2;
-
 	if (dirty_ratio < 5)
 		dirty_ratio = 5;
 
Index: linux-2.6.23.8-reiserfix-fai-vmdirty/include/linux/writeback.h
===================================================================
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/include/linux/writeback.h	2007-10-09 20:31:38.000000000 +0000
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/include/linux/writeback.h	2007-11-22 01:48:21.000000000 +0000
@@ -92,6 +92,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
+extern int vm_dirty_highmem;
 extern int vm_dirty_ratio;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
Index: linux-2.6.23.8-reiserfix-fai-vmdirty/kernel/sysctl.c
===================================================================
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/kernel/sysctl.c	2007-10-09 20:31:38.000000000 +0000
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/kernel/sysctl.c	2007-11-22 01:48:21.000000000 +0000
@@ -776,6 +776,7 @@ static ctl_table kern_table[] = {
 /* Constants for minimum and maximum testing in vm_table.
    We use these as one-element integer vectors. */
 static int zero;
+static int one = 1;
 static int two = 2;
 static int one_hundred = 100;
 
@@ -1066,6 +1067,19 @@ static ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 #endif
+#ifdef CONFIG_HIGHMEM
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "dirty_highmem",
+		.data		= &vm_dirty_highmem,
+		.maxlen		= sizeof(vm_dirty_highmem),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
Index: linux-2.6.23.8-reiserfix-fai-vmdirty/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/Documentation/filesystems/proc.txt	2007-11-22 02:32:36.000000000 +0000
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/Documentation/filesystems/proc.txt	2007-11-22 02:39:11.000000000 +0000
@@ -1229,6 +1229,18 @@ dirty_background_ratio
 Contains, as a percentage of total system memory, the number of pages at which
 the pdflush background writeback daemon will start writing out dirty data.
 
+dirty_highmem
+-------------
+
+Contains, as a boolean, a switch to allow highmem to be counted as
+part of the "available" memory against which the dirty ratios will be
+applied.
+
+Setting this to 1 can be useful on 32 bit machines where you want to make
+random changes within an MMAPed file that is larger than your available
+lowmem, however it is potentially dangerous and has serious bounce-buffer
+issues.
+
 dirty_ratio
 -----------------
 
Index: linux-2.6.23.8-reiserfix-fai-vmdirty/Documentation/sysctl/vm.txt
===================================================================
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/Documentation/sysctl/vm.txt	2007-11-22 02:31:32.000000000 +0000
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/Documentation/sysctl/vm.txt	2007-11-22 02:32:31.000000000 +0000
@@ -18,6 +18,7 @@ files can be found in mm/swap.c.
 Currently, these files are in /proc/sys/vm:
 - overcommit_memory
 - page-cluster
+- dirty_highmem
 - dirty_ratio
 - dirty_background_ratio
 - dirty_expire_centisecs
@@ -36,10 +37,10 @@ Currently, these files are in /proc/sys/
 
 ==============================================================
 
-dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
-dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
-block_dump, swap_token_timeout, drop-caches,
-hugepages_treat_as_movable:
+dirty_highmem, dirty_ratio, dirty_background_ratio, 
+dirty_expire_centisecs, dirty_writeback_centisecs, 
+vfs_cache_pressure, laptop_mode, block_dump, 
+swap_token_timeout, drop-caches, hugepages_treat_as_movable:
 
 See Documentation/filesystems/proc.txt
 
