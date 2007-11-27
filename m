Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbXK0NGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbXK0NGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbXK0NGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:06:09 -0500
Received: from paragon.brong.net ([74.52.187.94]:33538 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbXK0NGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:06:05 -0500
Date: Wed, 28 Nov 2007 00:06:01 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Kujau <lists@nerdbynature.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rob Mueller <robm@fastmail.fm>
Subject: [PATCH] mm/page-writeback - highmem_is_dirtyable option (replaces
	dirty_highmem patch)
Message-ID: <20071127130601.GA20685@brong.net>
References: <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org> <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org> <20071122034204.GA14079@brong.net> <20071126205428.c264ccff.akpm@linux-foundation.org> <1196141064.31920.1223402735@webmail.messagingengine.com> <20071126215315.3422eaa2.akpm@linux-foundation.org> <20071127121028.GA19148@brong.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127121028.GA19148@brong.net>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 11:10:28PM +1100, Bron Gondwana wrote:
> On Mon, Nov 26, 2007 at 09:53:15PM -0800, Andrew Morton wrote:
> > umm, really you want
> > /proc/sys/vm/dont-account-highmem-in-dirty-memory-calculations, only
> > shorter.
> > 
> > Do you agree?
> 
> I still read dirty_highmem as:
> 
> /proc/sys/vm/do-account-highmem-in-dirty-memory-calculations
> 
> ... so we're still talking one negative apart!
> 
> > It would be simpler to have
> > /proc/sys/vm/do-account-highmem-in-dirty-memory-calculations,
> > defaulting to "true" - this has no negations.
> 
> No, that's not true.  The whole point is that between 2.6.16 and
> 2.6.20 the kernel behaviour changed.  It currently doesn't count
> highmem in dirty memory calculations, which is why the memory pressure
> appears to be so great when actually there's still 4Gb of unused
> memory in the box.
> 
> > OK, I give up.  Please see if you can think of something less confusing
> > which involves no negations?
> 
> I think this might be slightly clearer:
> 
> /proc/sys/vm/highmem_is_dirtyable - defaults to false
> 
> [ ... ]
> 
> Would you like me to re-submit the patch based on this?  I'm
> certainly not happy with dirty_highmem as it is now in mm
> because it looks backwards and unclear to me.

Well, it was quick enough to just do - here's the patch.  I've
also updated the documentation a bit to clarify the intention and
the reasons why you might want to use it (based in part on the 
comments to the original change that made highmem uncountable for
dirtyness purposes)

Tested and applied against 2.6.23.9 (our build script makes Debian
packages from a clean unpack of kernel major plus patch minor plus
svn checkout of out quilt series and apply regardless, so it was
just as easy to bump the version number while I was at it).

Builds, boots, passes a quick run of the test program I used last
time around.

Bron.

Add vm.highmem_is_dirtyable toggle

A 32 bit machine with HIGHMEM64 enabled running DCC has an MMAPed file
of approximately 2Gb size which contains a hash format that is written
randomly by the dbclean process.  On 2.6.16 this process took a few
minutes.  With lowmem only accounting of dirty ratios, this takes about
12 hours of 100% disk IO, all random writes.

This patch includes some code cleanup from Linus and a toggle in
/proc/sys/vm/highmem_is_dirtyable which can be set to 1 to add the 
highmem back to the total available memory count.

Signed-off-by: Bron Gondwana <brong@fastmail.fm>
Index: linux-2.6.23.8-reiserfix-fai-vmdirty/mm/page-writeback.c
===================================================================
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/mm/page-writeback.c	2007-11-21 21:58:20.000000000 -0500
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/mm/page-writeback.c	2007-11-27 07:27:51.000000000 -0500
@@ -70,6 +70,12 @@
 int dirty_background_ratio = 5;
 
 /*
+ * free highmem will not be subtracted from the total free memory
+ * for calculating free ratios if vm_highmem_is_dirtyable is true
+ */
+int vm_highmem_is_dirtyable;
+
+/*
  * The generator of dirty data starts writeback at this percentage
  */
 int vm_dirty_ratio = 10;
@@ -153,7 +159,10 @@
 	x = global_page_state(NR_FREE_PAGES)
 		+ global_page_state(NR_INACTIVE)
 		+ global_page_state(NR_ACTIVE);
-	x -= highmem_dirtyable_memory(x);
+
+	if (!vm_highmem_is_dirtyable)
+		x -= highmem_dirtyable_memory(x);
+
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
@@ -163,20 +172,12 @@
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
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/include/linux/writeback.h	2007-10-09 16:31:38.000000000 -0400
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/include/linux/writeback.h	2007-11-27 07:22:17.000000000 -0500
@@ -95,6 +95,7 @@
 extern int vm_dirty_ratio;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
+extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;
 
Index: linux-2.6.23.8-reiserfix-fai-vmdirty/kernel/sysctl.c
===================================================================
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/kernel/sysctl.c	2007-10-09 16:31:38.000000000 -0400
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/kernel/sysctl.c	2007-11-27 07:26:43.000000000 -0500
@@ -776,6 +776,7 @@
 /* Constants for minimum and maximum testing in vm_table.
    We use these as one-element integer vectors. */
 static int zero;
+static int one = 1;
 static int two = 2;
 static int one_hundred = 100;
 
@@ -1066,6 +1067,19 @@
 		.extra1		= &zero,
 	},
 #endif
+#ifdef CONFIG_HIGHMEM
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "highmem_is_dirtyable",
+		.data		= &vm_highmem_is_dirtyable,
+		.maxlen		= sizeof(vm_highmem_is_dirtyable),
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
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/Documentation/filesystems/proc.txt	2007-10-09 16:31:38.000000000 -0400
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/Documentation/filesystems/proc.txt	2007-11-27 07:21:22.000000000 -0500
@@ -1253,6 +1253,21 @@
 Data which has been dirty in-memory for longer than this interval will be
 written out next time a pdflush daemon wakes up.
 
+highmem_is_dirtyable
+--------------------
+
+Only present if CONFIG_HIGHMEM is set.
+
+This defaults to 0 (false), meaning that the ratios set above are calculated
+as a percentage of lowmem only.  This protects against excessive scanning
+in page reclaim, swapping and general VM distress.
+
+Setting this to 1 can be useful on 32 bit machines where you want to make
+random changes within an MMAPed file that is larger than your available
+lowmem without causing large quantities of random IO.  Is is safe if the
+behavior of all programs running on the machine is known and memory will
+not be otherwise stressed.
+
 legacy_va_layout
 ----------------
 
Index: linux-2.6.23.8-reiserfix-fai-vmdirty/Documentation/sysctl/vm.txt
===================================================================
--- linux-2.6.23.8-reiserfix-fai-vmdirty.orig/Documentation/sysctl/vm.txt	2007-10-09 16:31:38.000000000 -0400
+++ linux-2.6.23.8-reiserfix-fai-vmdirty/Documentation/sysctl/vm.txt	2007-11-27 07:13:30.000000000 -0500
@@ -22,6 +22,7 @@
 - dirty_background_ratio
 - dirty_expire_centisecs
 - dirty_writeback_centisecs
+- highmem_is_dirtyable   (only if CONFIG_HIGHMEM set)
 - max_map_count
 - min_free_kbytes
 - laptop_mode
@@ -36,10 +37,10 @@
 
 ==============================================================
 
-dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
-dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
-block_dump, swap_token_timeout, drop-caches,
-hugepages_treat_as_movable:
+dirty_ratio, dirty_background_ratio, dirty_expire_centisecs, 
+dirty_writeback_centisecs, highmem_is_dirtyable,
+vfs_cache_pressure, laptop_mode, block_dump, swap_token_timeout,
+drop-caches, hugepages_treat_as_movable:
 
 See Documentation/filesystems/proc.txt
 
