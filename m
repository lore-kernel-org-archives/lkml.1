Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZLXJ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZLXJ3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 04:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZLXJ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 04:29:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34849 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZLXJ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 04:29:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] futex: Fix ZERO_PAGE cause infinite loop
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20091224182630.3DCB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 24 Dec 2009 18:29:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch need both futex and zero-page developer's ack.
==========================================================

commit a13ea5b7 (mm: reinstate ZERO_PAGE) made the unfortunate regression.
following test program never finish and waste 100% cpu time.

At the making commit 38d47c1b7 (rely on get_user_pages() for shared
futexes). There isn't zero page in linux kernel. then, futex developers
thought gup retry is safe. but we reinstated zero page later...

This patch fixes it.

futex-zero.c
---------------------------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <syscall.h>
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <linux/futex.h>
 #include <pthread.h>

int main(int argc, char **argv)
{
        long page_size;
        int ret;
        void *buf;

        page_size = sysconf(_SC_PAGESIZE);

        buf = mmap(NULL, page_size, PROT_READ|PROT_WRITE,
			MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
        if (buf == (void *)-1) {
                perror("mmap error.\n");
                exit(1);
        }

        fprintf(stderr, "futex wait\n");
        ret = syscall( SYS_futex, buf, FUTEX_WAIT, 1, NULL, NULL, NULL);
        if (ret != 0 && errno != EWOULDBLOCK) {
                perror("futex error.\n");
                exit(1);
        }
        fprintf(stderr, "futex_wait: ret = %d, errno = %d\n", ret, errno);

        return 0;
}
---------------------------------------------------------------------

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mm.h |   16 ++++++++++++++++
 kernel/futex.c     |    3 +++
 mm/memory.c        |   14 --------------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2265f28..dd755ea 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -751,6 +751,22 @@ struct zap_details {
 	unsigned long truncate_count;		/* Compare vm_truncate_count */
 };
 
+#ifndef is_zero_pfn
+extern unsigned long zero_pfn;
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	return pfn == zero_pfn;
+}
+#endif
+
+#ifndef my_zero_pfn
+extern unsigned long zero_pfn;
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	return zero_pfn;
+}
+#endif
+
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		pte_t pte);
 
diff --git a/kernel/futex.c b/kernel/futex.c
index 8e3c3ff..79b89cc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -254,6 +254,8 @@ again:
 
 	page = compound_head(page);
 	lock_page(page);
+	if (is_zero_pfn(page_to_pfn(page)))
+		goto anon_key;
 	if (!page->mapping) {
 		unlock_page(page);
 		put_page(page);
@@ -268,6 +270,7 @@ again:
 	 * the object not the particular process.
 	 */
 	if (PageAnon(page)) {
+ anon_key:
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
diff --git a/mm/memory.c b/mm/memory.c
index 09e4b1b..3743fb5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -457,20 +457,6 @@ static inline int is_cow_mapping(unsigned int flags)
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
-#ifndef is_zero_pfn
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	return pfn == zero_pfn;
-}
-#endif
-
-#ifndef my_zero_pfn
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	return zero_pfn;
-}
-#endif
-
 /*
  * vm_normal_page -- This function gets the "struct page" associated with a pte.
  *
-- 
1.6.5.2



