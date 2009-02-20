Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZBTWkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZBTWkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZBTWkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:40:10 -0500
Received: from main.gmane.org ([80.91.229.2]:51055 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbZBTWkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:40:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dheeraj Reddy <dheerajr@gmail.com>
Subject: Incorrect #ifdef in arch/x86/mm/pat.c 
Date: Fri, 20 Feb 2009 22:39:13 +0000 (UTC)
Message-ID: <loom.20090220T223617-127@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 134.134.139.72 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/1.0.154.48 Safari/525.19)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,
    The checks for reading /dev/kmem and /dev/mem in arch/x86/mm/pat.c seems to 
be incorrect when CONFIG_STRICT_DEVMEM is set.
Following patch corrects it.
The check should always return 1 when CONFIG_STRICT_DEVMEM is not defined, 
similar to what is in drivers/char/mem.c

truly
dheeraj

[dreddy-desktop:~/Ksources/git.linux-2.6]$ git diff
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index aebbf67..2aff276 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -503,12 +503,6 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned 
l
 }

 #ifdef CONFIG_STRICT_DEVMEM
-/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/
-static inline int range_is_allowed(unsigned long pfn, unsigned long size)
-{
-       return 1;
-}
-#else
 /* This check is needed to avoid cache aliasing when PAT is enabled */
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
@@ -531,6 +525,12 @@ static inline int range_is_allowed(unsigned long pfn, 
unsig
        }
        return 1;
 }
+#else
+/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+{
+       return 1;
+}
 #endif /* CONFIG_STRICT_DEVMEM */

 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,



