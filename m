Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZCAOLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZCAOLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZCAOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:11:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:1803 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZCAOLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=lFOvxYyKtLhz/gNQXeAHt6Ri9FXjsy54cTUZFWbjxTlSsM8GYaNtSoL4Ifiv+ibFWb
         dVgXjhSSxHaJVthRx521p4ScqKfyNfiarL9GE6bkQ2FiG0jOVIMNApbKVS/SC6ATe3IS
         CpcDuMoeapHGlDy4lx9YcfBhtcoeQw1UXvW3A=
Date: Sun, 1 Mar 2009 16:11:07 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] x86 mmiotrace: WARN_ONCE if dis/arming a page fails
Message-ID: <20090301161107.21d82c10@daedalus.pq.iki.fi>
In-Reply-To: <20090301160643.05a2219b@daedalus.pq.iki.fi>
References: <20090301160643.05a2219b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2f1f600e019955a0485452e4da676837bc8c91bd Mon Sep 17 00:00:00 2001
From: Stuart Bennett <stuart@freedesktop.org>
Date: Fri, 30 Jan 2009 17:38:59 +0000
Subject: [PATCH] x86 mmiotrace: WARN_ONCE if dis/arming a page fails

Print a full warning once, if arming or disarming a page fails.

Also, if initial arming fails, do not handle the page further. This
avoids the possibility of a page failing to arm and then later claiming
to have handled any fault on that page.

WARN_ONCE added by Pekka Paalanen.

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 93d8203..fb1f115 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -105,7 +105,7 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
-static void set_page_present(unsigned long addr, bool present,
+static int set_page_present(unsigned long addr, bool present,
 							unsigned int *pglevel)
 {
 	pteval_t pteval;
@@ -116,7 +116,7 @@ static void set_page_present(unsigned long addr, bool present,
 
 	if (!pte) {
 		pr_err("kmmio: no pte for page 0x%08lx\n", addr);
-		return;
+		return -1;
 	}
 
 	if (pglevel)
@@ -140,22 +140,27 @@ static void set_page_present(unsigned long addr, bool present,
 
 	default:
 		pr_err("kmmio: unexpected page level 0x%x.\n", level);
-		return;
+		return -1;
 	}
 
 	__flush_tlb_one(addr);
+
+	return 0;
 }
 
 /** Mark the given page as not present. Access to it will trigger a fault. */
-static void arm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
+static int arm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
 {
-	set_page_present(page & PAGE_MASK, false, pglevel);
+	int ret = set_page_present(page & PAGE_MASK, false, pglevel);
+	WARN_ONCE(ret < 0, KERN_ERR "kmmio arming 0x%08lx failed.\n", page);
+	return ret;
 }
 
 /** Mark the given page as present. */
 static void disarm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
 {
-	set_page_present(page & PAGE_MASK, true, pglevel);
+	int ret = set_page_present(page & PAGE_MASK, true, pglevel);
+	WARN_ONCE(ret < 0, KERN_ERR "kmmio disarming 0x%08lx failed.\n", page);
 }
 
 /*
@@ -326,9 +331,13 @@ static int add_kmmio_fault_page(unsigned long page)
 
 	f->count = 1;
 	f->page = page;
-	list_add_rcu(&f->list, kmmio_page_list(f->page));
 
-	arm_kmmio_fault_page(f->page, NULL);
+	if (arm_kmmio_fault_page(f->page, NULL)) {
+		kfree(f);
+		return -1;
+	}
+
+	list_add_rcu(&f->list, kmmio_page_list(f->page));
 
 	return 0;
 }
-- 
1.6.0.6

