Return-Path: <linux-kernel-owner+w=401wt.eu-S1761151AbXLNGz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151AbXLNGz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXLNGzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:55:52 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:39879 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLNGzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:55:51 -0500
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: [RFC] [patch 1/2] add non_init_kernel_text_address
Date: Fri, 14 Dec 2007 12:25:30 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: rusty@rustcorp.com.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141225.30099.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since __init functions are discarded and its memory freed once
initialization completes, It would be better if we enable kprobes 
to refuse probing __init functions. The attached patchset will do 
that.

This patch creates non_init_kernel_text_address() to identify
non_init text area.

Iam open to suggestions for a better functionname. 

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com> 
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>


---
 include/linux/kernel.h |    2 ++
 kernel/extable.c       |   16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc5-mm1/include/linux/kernel.h
===================================================================
--- linux-2.6.24-rc5-mm1.orig/include/linux/kernel.h
+++ linux-2.6.24-rc5-mm1/include/linux/kernel.h
@@ -169,6 +169,8 @@ extern unsigned long long memparse(char 
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
+extern int non_init_kernel_text_address(unsigned long addr);
+extern int non_init_core_kernel_text(unsigned long addr);
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
Index: linux-2.6.24-rc5-mm1/kernel/extable.c
===================================================================
--- linux-2.6.24-rc5-mm1.orig/kernel/extable.c
+++ linux-2.6.24-rc5-mm1/kernel/extable.c
@@ -40,11 +40,18 @@ const struct exception_table_entry *sear
 	return e;
 }
 
-int core_kernel_text(unsigned long addr)
+int non_init_core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
 	    addr <= (unsigned long)_etext)
 		return 1;
+	return 0;
+}
+
+int core_kernel_text(unsigned long addr)
+{
+	if (non_init_core_kernel_text(addr))
+		return 1;
 
 	if (addr >= (unsigned long)_sinittext &&
 	    addr <= (unsigned long)_einittext)
@@ -65,3 +72,10 @@ int kernel_text_address(unsigned long ad
 		return 1;
 	return module_text_address(addr) != NULL;
 }
+
+int non_init_kernel_text_address(unsigned long addr)
+{
+	if (non_init_core_kernel_text(addr))
+		return 1;
+	return module_text_address(addr) != NULL;
+}
