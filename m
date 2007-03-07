Return-Path: <linux-kernel-owner+w=401wt.eu-S2992470AbXCGWKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992470AbXCGWKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992652AbXCGWKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:10:06 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:48936 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992635AbXCGWKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:10:04 -0500
Subject: [PATCH] remove_arg_zero() rewrite
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr =?ISO-8859-1?Q?Tesa=5F=5F=EDk?= <ptesarik@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070221154159.d316d526.akpm@linux-foundation.org>
References: <1171978145.22720.21.camel@golias.tesarici.cz>
	 <20070221154159.d316d526.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 23:09:57 +0100
Message-Id: <1173305397.4868.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 15:41 -0800, Andrew Morton wrote:

> I mean.... what the hell?
> 
> As you appear to have managed to work out what the sorry thing is trying to
> do, would you have time to simply rip it out and completely rewrite it,
> including a nice comment telling the world what this function's function is?
> 
> Because what we have there is beyond repairing.

Something like so?
Boots uml seemingly without errors.

---
Rewrite remove_arg_zero() to be more parseable by untwisted minds.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/exec.c |   40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2007-03-07 21:54:17.000000000 +0100
+++ linux-2.6/fs/exec.c	2007-03-07 23:08:27.000000000 +0100
@@ -987,28 +987,34 @@ void compute_creds(struct linux_binprm *
 
 EXPORT_SYMBOL(compute_creds);
 
+/*
+ * Arguments are '\0' separated strings found at the location bprm->p
+ * points to; chop off the first by relocating brpm->p to right after
+ * the first '\0' encountered.
+ */
 void remove_arg_zero(struct linux_binprm *bprm)
 {
-	if (bprm->argc) {
-		unsigned long offset;
-		char * kaddr;
-		struct page *page;
+	unsigned long offset;
+	char *kaddr;
+	struct page *page;
 
-		offset = bprm->p % PAGE_SIZE;
-		goto inside;
+	if (!bprm->argc)
+		return;
+
+	do {
+		offset = bprm->p & ~PAGE_MASK;
+		page = bprm->page[bprm->p >> PAGE_SHIFT];
+		kaddr = kmap_atomic(page, KM_USER0);
+
+		for (; offset < PAGE_SIZE && kaddr[offset];
+				offset++, bprm->p++)
+			;
 
-		while (bprm->p++, *(kaddr+offset++)) {
-			if (offset != PAGE_SIZE)
-				continue;
-			offset = 0;
-			kunmap_atomic(kaddr, KM_USER0);
-inside:
-			page = bprm->page[bprm->p/PAGE_SIZE];
-			kaddr = kmap_atomic(page, KM_USER0);
-		}
 		kunmap_atomic(kaddr, KM_USER0);
-		bprm->argc--;
-	}
+	} while (offset == PAGE_SIZE);
+
+	bprm->p++;
+	bprm->argc--;
 }
 
 EXPORT_SYMBOL(remove_arg_zero);


