Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbXLSJiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbXLSJiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXLSJin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:38:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59460 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752500AbXLSJil (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:38:41 -0500
Date: Wed, 19 Dec 2007 20:38:34 +1100
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch, rfc] mm.h, security.h, key.h and preventing namespace poisoning
Message-ID: <20071219093834.GW4396912@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I just updated a git tree and started getting errors on a
"copy_keys" macro warning.

The code I've been working on uses a ->copy_keys() method for
copying the keys in a btree block from one place to another. I've
been working on this code for a while
(http://oss.sgi.com/archives/xfs/2007-11/msg00046.html) and keep the
tree I'm working in reletively up to date (lags linus by a couple of
weeks at most). The update I did this afternoon gave a conflict
warning with the macro in include/linux/key.h.

Given that I'm not directly including key.h anywhere in the XFS
code, I'm getting the namespace polluted indirectly from some other
include that is necessary.

As it turns out, this commit from 13 days ago:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7cd94146cd504016315608e297219f9fb7b1413b

included security.h in mm.h and that is how I'm seeing the namespace
poisoning coming from key.h when !CONFIG_KEY.

Including security.h in mm.h means much wider includes for pretty
much the entire kernel, and it opens up namespace issues like this
that never previously existed.

The patch below (only tested for !CONFIG_KEYS && !CONFIG_SECURITY)
moves security.h into the mmap.c and nommu.c files that need it so
it doesn't end up with kernel wide scope.

Comments?

---
 include/linux/mm.h       |   16 ----------------
 include/linux/security.h |   26 +++++++++++++++++++++++++-
 mm/mmap.c                |    1 +
 mm/nommu.c               |    1 +
 4 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1b7b95c..520238c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -12,7 +12,6 @@
 #include <linux/prio_tree.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
-#include <linux/security.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -514,21 +513,6 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 }
 
 /*
- * If a hint addr is less than mmap_min_addr change hint to be as
- * low as possible but still greater than mmap_min_addr
- */
-static inline unsigned long round_hint_to_min(unsigned long hint)
-{
-#ifdef CONFIG_SECURITY
-	hint &= PAGE_MASK;
-	if (((void *)hint != NULL) &&
-	    (hint < mmap_min_addr))
-		return PAGE_ALIGN(mmap_min_addr);
-#endif
-	return hint;
-}
-
-/*
  * Some inline functions in vmstat.h depend on page_zone()
  */
 #include <linux/vmstat.h>
diff --git a/include/linux/security.h b/include/linux/security.h
index ac05083..e9ba391 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2568,6 +2568,19 @@ void security_key_free(struct key *key);
 int security_key_permission(key_ref_t key_ref,
 			    struct task_struct *context, key_perm_t perm);
 
+/*
+ * If a hint addr is less than mmap_min_addr change hint to be as
+ * low as possible but still greater than mmap_min_addr
+ */
+static inline unsigned long round_hint_to_min(unsigned long hint)
+{
+	hint &= PAGE_MASK;
+	if (((void *)hint != NULL) &&
+	    (hint < mmap_min_addr))
+		return PAGE_ALIGN(mmap_min_addr);
+	return hint;
+}
+
 #else
 
 static inline int security_key_alloc(struct key *key,
@@ -2588,7 +2601,18 @@ static inline int security_key_permission(key_ref_t key_ref,
 	return 0;
 }
 
-#endif
+static inline unsigned long round_hint_to_min(unsigned long hint)
+{
+	return hint;
+}
+
+#endif /* CONFIG_SECURITY */
+
+#else /* !CONFIG_KEYS */
+static inline unsigned long round_hint_to_min(unsigned long hint)
+{
+	return hint;
+}
 #endif /* CONFIG_KEYS */
 
 #endif /* ! __LINUX_SECURITY_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index 15678aa..0d666de 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -26,6 +26,7 @@
 #include <linux/mount.h>
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
+#include <linux/security.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff --git a/mm/nommu.c b/mm/nommu.c
index b989cb9..99702d1 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -28,6 +28,7 @@
 #include <linux/personality.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/security.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
