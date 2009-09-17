Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZIQVvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZIQVvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZIQVvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:51:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZIQVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:51:02 -0400
Date: Thu, 17 Sep 2009 14:50:39 -0700
Message-Id: <200909172150.n8HLodmX024622@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronuix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Michal Hocko <mhocko@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Additional x86 fixes
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Thu, 17 Sep 2009 14:50:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit de55a8958f6e3ef5ce5f0971b80bd44bfcac7cf1:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

H. Peter Anvin (1):
      Merge branch 'x86/pat' into x86/urgent

Michal Hocko (1):
      x86: Increase MIN_GAP to include randomized stack

Suresh Siddha (1):
      x86, pat: don't use rb-tree based lookup in reserve_memtype()

Sorry for the merge, but the PAT fix could not be based on the other
patch without a rebase.

	-hpa


commit 80938332d8cf652f6b16e0788cf0ca136befe0b5
Author: Michal Hocko <mhocko@suse.cz>
Date:   Tue Sep 8 11:01:55 2009 +0200

    x86: Increase MIN_GAP to include randomized stack
    
    Currently we are not including randomized stack size when calculating
    mmap_base address in arch_pick_mmap_layout for topdown case. This might
    cause that mmap_base starts in the stack reserved area because stack is
    randomized by 1GB for 64b (8MB for 32b) and the minimum gap is 128MB.
    
    If the stack really grows down to mmap_base then we can get silent mmap
    region overwrite by the stack values.
    
    Let's include maximum stack randomization size into MIN_GAP which is
    used as the low bound for the gap in mmap.
    
    Signed-off-by: Michal Hocko <mhocko@suse.cz>
    LKML-Reference: <1252400515-6866-1-git-send-email-mhocko@suse.cz>
    Acked-by: Jiri Kosina <jkosina@suse.cz>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Cc: Stable Team <stable@kernel.org>

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 83c1bc8..456a304 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -299,6 +299,8 @@ do {									\
 
 #ifdef CONFIG_X86_32
 
+#define STACK_RND_MASK (0x7ff)
+
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
 
 #define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 1658296..c8191de 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -29,13 +29,26 @@
 #include <linux/random.h>
 #include <linux/limits.h>
 #include <linux/sched.h>
+#include <asm/elf.h>
+
+static unsigned int stack_maxrandom_size(void)
+{
+	unsigned int max = 0;
+	if ((current->flags & PF_RANDOMIZE) &&
+		!(current->personality & ADDR_NO_RANDOMIZE)) {
+		max = ((-1U) & STACK_RND_MASK) << PAGE_SHIFT;
+	}
+
+	return max;
+}
+
 
 /*
  * Top of mmap area (just below the process stack).
  *
- * Leave an at least ~128 MB hole.
+ * Leave an at least ~128 MB hole with possible stack randomization.
  */
-#define MIN_GAP (128*1024*1024)
+#define MIN_GAP (128*1024*1024UL + stack_maxrandom_size())
 #define MAX_GAP (TASK_SIZE/6*5)
 
 /*
commit dcb73bf402e0d5b28ce925dbbe4dab3b00b21eee
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Wed Sep 16 14:28:03 2009 -0700

    x86, pat: don't use rb-tree based lookup in reserve_memtype()
    
    Recent enhancement of rb-tree based lookup exposed a  bug with the lookup
    mechanism in the reserve_memtype() which ensures that there are no conflicting
    memtype requests for the memory range.
    
    memtype_rb_search() returns an entry which has a start address <= new start
    address. And from here we traverse the linear linked list to check if there
    any conflicts with the existing mappings. As the rbtree is based on the
    start address of the memory range, it is quite possible that we have several
    overlapped mappings whose start address is much less than new requested start
    but the end is >= new requested end. This results in conflicting memtype
    mappings.
    
    Same bug exists with the old code which uses cached_entry from where
    we traverse the linear linked list. But the new rb-tree code exposes this
    bug fairly easily.
    
    For now, don't use the memtype_rb_search() and always start the search from
    the head of linear linked list in reserve_memtype(). Linear linked list
    for most of the systems grow's to few 10's of entries(as we track memory type
    of RAM pages using struct page). So we should be ok for now.
    
    We still retain the rbtree and use it to speed up free_memtype() which
    doesn't have the same bug(as we know what exactly we are searching for
    in free_memtype).
    
    Also use list_for_each_entry_from() in free_memtype() so that we start
    the search from rb-tree lookup result.
    
    Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    LKML-Reference: <1253136483.4119.12.camel@sbs-t61.sc.intel.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index d2a72ab..9b647f6 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -424,17 +424,9 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	spin_lock(&memtype_lock);
 
-	entry = memtype_rb_search(&memtype_rbroot, new->start);
-	if (likely(entry != NULL)) {
-		/* To work correctly with list_for_each_entry_continue */
-		entry = list_entry(entry->nd.prev, struct memtype, nd);
-	} else {
-		entry = list_entry(&memtype_list, struct memtype, nd);
-	}
-
 	/* Search for existing mapping that overlaps the current range */
 	where = NULL;
-	list_for_each_entry_continue(entry, &memtype_list, nd) {
+	list_for_each_entry(entry, &memtype_list, nd) {
 		if (end <= entry->start) {
 			where = entry->nd.prev;
 			break;
@@ -532,7 +524,7 @@ int free_memtype(u64 start, u64 end)
 	 * in sorted start address
 	 */
 	saved_entry = entry;
-	list_for_each_entry(entry, &memtype_list, nd) {
+	list_for_each_entry_from(entry, &memtype_list, nd) {
 		if (entry->start == start && entry->end == end) {
 			rb_erase(&entry->rb, &memtype_rbroot);
 			list_del(&entry->nd);
