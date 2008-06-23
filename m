Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYFWAjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYFWAjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 20:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYFWAj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 20:39:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:27764 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYFWAjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 20:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=seE89xHz50vtts8A3ASUZ7GqCuid7ZRHEOp3uYLuJqq1q/lalqRLDkSe2yp8FVOUTY
         9gyst7EiL6SxCCo6inFW2+24zWvqkXrDhvIy7q5iLHlguNRqFtim0yNrjUWE/V/+Kwva
         yoGB0WhYJ1F3+32hBu50JXgbh7JTXwarERfZ8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: move reservetop and vmalloc parsing to pgtable_32.c
Date: Sun, 22 Jun 2008 17:40:10 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806220245.39289.yhlu.kernel@gmail.com> <200806220246.58958.yhlu.kernel@gmail.com>
In-Reply-To: <200806220246.58958.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806221740.10491.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also change reserve_top_address to __init attibute

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   33 ---------------------------------
 arch/x86/mm/pgtable_32.c   |   35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -185,39 +185,6 @@ static inline void copy_edd(void)
 }
 #endif
 
-/*
- * vmalloc=size forces the vmalloc area to be exactly 'size'
- * bytes. This can be used to increase (or decrease) the
- * vmalloc area - the default is 128m.
- */
-static int __init parse_vmalloc(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	__VMALLOC_RESERVE = memparse(arg, &arg);
-	return 0;
-}
-early_param("vmalloc", parse_vmalloc);
-
-/*
- * reservetop=size reserves a hole at the top of the kernel address space which
- * a hypervisor can load into later.  Needed for dynamically loaded hypervisors,
- * so relocating the fixmap can be done before paging initialization.
- */
-static int __init parse_reservetop(char *arg)
-{
-	unsigned long address;
-
-	if (!arg)
-		return -EINVAL;
-
-	address = memparse(arg, &arg);
-	reserve_top_address(address);
-	return 0;
-}
-early_param("reservetop", parse_reservetop);
-
 #ifdef CONFIG_BLK_DEV_INITRD
 
 static bool do_relocate_initrd = false;
Index: linux-2.6/arch/x86/mm/pgtable_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pgtable_32.c
+++ linux-2.6/arch/x86/mm/pgtable_32.c
@@ -152,7 +152,7 @@ EXPORT_SYMBOL(__FIXADDR_TOP);
  * Can be used to relocate the fixmap area and poke a hole in the top
  * of kernel address space to make room for a hypervisor.
  */
-void reserve_top_address(unsigned long reserve)
+void __init reserve_top_address(unsigned long reserve)
 {
 	BUG_ON(fixmaps_set > 0);
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
@@ -160,3 +160,36 @@ void reserve_top_address(unsigned long r
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
 	__VMALLOC_RESERVE += reserve;
 }
+
+/*
+ * vmalloc=size forces the vmalloc area to be exactly 'size'
+ * bytes. This can be used to increase (or decrease) the
+ * vmalloc area - the default is 128m.
+ */
+static int __init parse_vmalloc(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	__VMALLOC_RESERVE = memparse(arg, &arg);
+	return 0;
+}
+early_param("vmalloc", parse_vmalloc);
+
+/*
+ * reservetop=size reserves a hole at the top of the kernel address space which
+ * a hypervisor can load into later.  Needed for dynamically loaded hypervisors,
+ * so relocating the fixmap can be done before paging initialization.
+ */
+static int __init parse_reservetop(char *arg)
+{
+	unsigned long address;
+
+	if (!arg)
+		return -EINVAL;
+
+	address = memparse(arg, &arg);
+	reserve_top_address(address);
+	return 0;
+}
+early_param("reservetop", parse_reservetop);
