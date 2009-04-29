Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbZD2LGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbZD2LGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbZD2LFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:05:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:49841 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbZD2LFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:05:31 -0400
Date: Wed, 29 Apr 2009 11:04:50 GMT
From: tip-bot for Stuart Bennett <stuart@freedesktop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, pq@iki.fi, stuart@freedesktop.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, pq@iki.fi, stuart@freedesktop.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240946271-7083-4-git-send-email-stuart@freedesktop.org>
References: <1240946271-7083-4-git-send-email-stuart@freedesktop.org>
Subject: [tip:tracing/core] tracing: x86, mmiotrace: refactor clearing/restore of page presence
Message-ID: <tip-46e91d00b1165b14b484aa33800e1bba0794ae1a@git.kernel.org>
Git-Commit-ID: 46e91d00b1165b14b484aa33800e1bba0794ae1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 11:04:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46e91d00b1165b14b484aa33800e1bba0794ae1a
Gitweb:     http://git.kernel.org/tip/46e91d00b1165b14b484aa33800e1bba0794ae1a
Author:     Stuart Bennett <stuart@freedesktop.org>
AuthorDate: Tue, 28 Apr 2009 20:17:50 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 11:33:33 +0200

tracing: x86, mmiotrace: refactor clearing/restore of page presence

* change function names to clear_* from set_*: in reality we only clear
  and restore page presence, and never unconditionally set present.
  Using clear_*({true, false}, ...) is therefore more honest than
  set_*({false, true}, ...)

* upgrade presence storage to pteval_t: doing user-space tracing will
  require saving and manipulation of the _PAGE_PROTNONE bit, in addition
  to the existing _PAGE_PRESENT changes, and having multiple bools stored
  and passed around does not seem optimal

[ Impact: refactor, clean up mmiotrace code ]

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Acked-by: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1240946271-7083-4-git-send-email-stuart@freedesktop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/kmmio.c |   43 ++++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 869181a..a769d1a 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -32,7 +32,7 @@ struct kmmio_fault_page {
 	struct list_head list;
 	struct kmmio_fault_page *release_next;
 	unsigned long page; /* location of the fault page */
-	bool old_presence; /* page presence prior to arming */
+	pteval_t old_presence; /* page presence prior to arming */
 	bool armed;
 
 	/*
@@ -108,49 +108,51 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
-static void set_pmd_presence(pmd_t *pmd, bool present, bool *old)
+static void clear_pmd_presence(pmd_t *pmd, bool clear, pmdval_t *old)
 {
 	pmdval_t v = pmd_val(*pmd);
-	*old = !!(v & _PAGE_PRESENT);
-	v &= ~_PAGE_PRESENT;
-	if (present)
-		v |= _PAGE_PRESENT;
+	if (clear) {
+		*old = v & _PAGE_PRESENT;
+		v &= ~_PAGE_PRESENT;
+	} else	/* presume this has been called with clear==true previously */
+		v |= *old;
 	set_pmd(pmd, __pmd(v));
 }
 
-static void set_pte_presence(pte_t *pte, bool present, bool *old)
+static void clear_pte_presence(pte_t *pte, bool clear, pteval_t *old)
 {
 	pteval_t v = pte_val(*pte);
-	*old = !!(v & _PAGE_PRESENT);
-	v &= ~_PAGE_PRESENT;
-	if (present)
-		v |= _PAGE_PRESENT;
+	if (clear) {
+		*old = v & _PAGE_PRESENT;
+		v &= ~_PAGE_PRESENT;
+	} else	/* presume this has been called with clear==true previously */
+		v |= *old;
 	set_pte_atomic(pte, __pte(v));
 }
 
-static int set_page_presence(unsigned long addr, bool present, bool *old)
+static int clear_page_presence(struct kmmio_fault_page *f, bool clear)
 {
 	unsigned int level;
-	pte_t *pte = lookup_address(addr, &level);
+	pte_t *pte = lookup_address(f->page, &level);
 
 	if (!pte) {
-		pr_err("kmmio: no pte for page 0x%08lx\n", addr);
+		pr_err("kmmio: no pte for page 0x%08lx\n", f->page);
 		return -1;
 	}
 
 	switch (level) {
 	case PG_LEVEL_2M:
-		set_pmd_presence((pmd_t *)pte, present, old);
+		clear_pmd_presence((pmd_t *)pte, clear, &f->old_presence);
 		break;
 	case PG_LEVEL_4K:
-		set_pte_presence(pte, present, old);
+		clear_pte_presence(pte, clear, &f->old_presence);
 		break;
 	default:
 		pr_err("kmmio: unexpected page level 0x%x.\n", level);
 		return -1;
 	}
 
-	__flush_tlb_one(addr);
+	__flush_tlb_one(f->page);
 	return 0;
 }
 
@@ -171,9 +173,9 @@ static int arm_kmmio_fault_page(struct kmmio_fault_page *f)
 	WARN_ONCE(f->armed, KERN_ERR "kmmio page already armed.\n");
 	if (f->armed) {
 		pr_warning("kmmio double-arm: page 0x%08lx, ref %d, old %d\n",
-					f->page, f->count, f->old_presence);
+					f->page, f->count, !!f->old_presence);
 	}
-	ret = set_page_presence(f->page, false, &f->old_presence);
+	ret = clear_page_presence(f, true);
 	WARN_ONCE(ret < 0, KERN_ERR "kmmio arming 0x%08lx failed.\n", f->page);
 	f->armed = true;
 	return ret;
@@ -182,8 +184,7 @@ static int arm_kmmio_fault_page(struct kmmio_fault_page *f)
 /** Restore the given page to saved presence state. */
 static void disarm_kmmio_fault_page(struct kmmio_fault_page *f)
 {
-	bool tmp;
-	int ret = set_page_presence(f->page, f->old_presence, &tmp);
+	int ret = clear_page_presence(f, false);
 	WARN_ONCE(ret < 0,
 			KERN_ERR "kmmio disarming 0x%08lx failed.\n", f->page);
 	f->armed = false;
