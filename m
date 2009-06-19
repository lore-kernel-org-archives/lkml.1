Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZFSAhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZFSAhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZFSAhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:37:03 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:36270 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZFSAhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:37:01 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] rmap: fixup page_referenced() for nommu systems
Date: Thu, 18 Jun 2009 20:36:53 -0400
Message-Id: <1245371813-30954-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the recent changes that went into mm/vmscan.c to overhaul stuff, we
ended up with these warnings on no-mmu systems:
mm/vmscan.c: In function ‘shrink_page_list’:
mm/vmscan.c:580: warning: unused variable ‘vm_flags’
mm/vmscan.c: In function ‘shrink_active_list’:
mm/vmscan.c:1294: warning: ‘vm_flags’ may be used uninitialized in this function
mm/vmscan.c:1242: note: ‘vm_flags’ was declared here

This is because the no-mmu function defines page_referenced() to work on
the first argument only (the page).  It does not clear the vm_flags given
to it because for no-mmu systems, they never actually get utilized.  Since
that is no longer strictly true, we need to set vm_flags to 0 like everyone
else so gcc can do proper dead code elimination without annoying us with
unused warnings.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/rmap.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 216d024..bf116d0 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -118,7 +118,14 @@ int try_to_munlock(struct page *);
 #define anon_vma_prepare(vma)	(0)
 #define anon_vma_link(vma)	do {} while (0)
 
-#define page_referenced(page, locked, cnt, flags) TestClearPageReferenced(page)
+static inline int page_referenced(struct page *page, int is_locked,
+				  struct mem_cgroup *cnt,
+				  unsigned long *vm_flags)
+{
+	*vm_flags = 0;
+	return TestClearPageReferenced(page);
+}
+
 #define try_to_unmap(page, refs) SWAP_FAIL
 
 static inline int page_mkclean(struct page *page)
-- 
1.6.3.1

