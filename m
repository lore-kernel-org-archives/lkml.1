Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYFZBHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYFZBHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbYFZBBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:55 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:20470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090AbYFZBBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=x+I5CyJ2R5L5Ibjjl9SZxHukwGPP00iB2TDLgHLNrAdBYLrsfWTWF7LVROc1YZWXAr
         nchJADUP2ksMaw0GuSLBZtMc5/RJhgKwCK+sffSYJLu+y4koekTKyoi6RbN6PKbiUwJw
         bKZNGAPWcU0iL7orbHpY4YXjud1BquelIXBsg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 13/16] x86: move parse elfvorehdr back to setup.c
Date: Wed, 25 Jun 2008 17:58:55 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251758.55757.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c        |   16 ++++++++++++++++
 arch/x86/kernel/setup_percpu.c |   16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -487,6 +487,22 @@ void __init reserve_standard_io_resource
 
 }
 
+#ifdef CONFIG_PROC_VMCORE
+/* elfcorehdr= specifies the location of elf core header
+ * stored by the crashed kernel. This option will be passed
+ * by kexec loader to the capture kernel.
+ */
+static int __init setup_elfcorehdr(char *arg)
+{
+	char *end;
+	if (!arg)
+		return -EINVAL;
+	elfcorehdr_addr = memparse(arg, &end);
+	return end > arg ? 0 : -EINVAL;
+}
+early_param("elfcorehdr", setup_elfcorehdr);
+#endif
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -387,19 +387,3 @@ EXPORT_SYMBOL(node_to_cpumask);
 
 #endif /* X86_64_NUMA */
 
-
-#ifdef CONFIG_PROC_VMCORE
-/* elfcorehdr= specifies the location of elf core header
- * stored by the crashed kernel. This option will be passed
- * by kexec loader to the capture kernel.
- */
-static int __init setup_elfcorehdr(char *arg)
-{
-	char *end;
-	if (!arg)
-		return -EINVAL;
-	elfcorehdr_addr = memparse(arg, &end);
-	return end > arg ? 0 : -EINVAL;
-}
-early_param("elfcorehdr", setup_elfcorehdr);
-#endif
