Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbYEAPia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbYEAPia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbYEAPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:38:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:47889 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYEAPiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=ol2WogxyccQkt2GLKQ0XPYO8yBuovGZ2cO2Nkzc1yLvEPo5OhT8ywmwciw6yRNXluF+Va/q2Nype3nUkbWUEORoT0+40cJTNgTzq7oatP6kR137UndGrunxYIDnyHd5EvEXj53oUcWxB4Os+RXi2BF2xuSEHuBrOu+GiZYICNL0=
Date: Thu, 1 May 2008 18:38:12 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86 mmiotrace: page level is unsigned
Message-ID: <20080501183812.5cf6e8e7@daedalus.pq.iki.fi>
In-Reply-To: <20080429205214.GA22298@elte.hu>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
	<20080429234021.071f7948@daedalus.pq.iki.fi>
	<20080429234648.650227e9@daedalus.pq.iki.fi>
	<20080429205214.GA22298@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8261c3eeead01739d18875797816637621d17c2d Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Thu, 1 May 2008 16:15:11 +0300
Subject: [PATCH] x86 mmiotrace: page level is unsigned

Fixes some sparse warnings.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

There are three other sparse warnings, too, but two are false
positives and one is a code style issue. I do not know how to annotate
those away, or if it is even possible, so I will probably write a
proper question some time after the merge window closes about how to
deal with those.

 arch/x86/mm/kmmio.c    |   13 +++++++------
 arch/x86/mm/mmio-mod.c |    2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index c12be07..93d8203 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -105,11 +105,12 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
-static void set_page_present(unsigned long addr, bool present, int *pglevel)
+static void set_page_present(unsigned long addr, bool present,
+							unsigned int *pglevel)
 {
 	pteval_t pteval;
 	pmdval_t pmdval;
-	int level;
+	unsigned int level;
 	pmd_t *pmd;
 	pte_t *pte = lookup_address(addr, &level);
 
@@ -146,15 +147,15 @@ static void set_page_present(unsigned long addr, bool present, int *pglevel)
 }
 
 /** Mark the given page as not present. Access to it will trigger a fault. */
-static void arm_kmmio_fault_page(unsigned long page, int *page_level)
+static void arm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
 {
-	set_page_present(page & PAGE_MASK, false, page_level);
+	set_page_present(page & PAGE_MASK, false, pglevel);
 }
 
 /** Mark the given page as present. */
-static void disarm_kmmio_fault_page(unsigned long page, int *page_level)
+static void disarm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
 {
-	set_page_present(page & PAGE_MASK, true, page_level);
+	set_page_present(page & PAGE_MASK, true, pglevel);
 }
 
 /*
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index ed0e0e9..e7397e1 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -137,7 +137,7 @@ static ssize_t write_marker(struct file *file, const char __user *buffer,
 
 static void print_pte(unsigned long address)
 {
-	int level;
+	unsigned int level;
 	pte_t *pte = lookup_address(address, &level);
 
 	if (!pte) {
-- 
1.5.3.7

