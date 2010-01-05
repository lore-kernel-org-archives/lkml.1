Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631Ab0AECRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0AECRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256Ab0AECPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:15:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43062 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab0AECPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:15:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
In-Reply-To: <20100105315.789846878@firstfloor.org>
To: linux-arch@vger.kernel.org, ebiederm@xmission.com,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/9] Add a kernel_address() that works for data too
Message-Id: <20100105021527.1AB19B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 03:15:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a variant of kernel_text_address() that includes kernel data.

Assumes kernel is _text ... _end - init section. True everywhere?

Cc: linux-arch@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kernel.h |    1 +
 kernel/extable.c       |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

Index: linux-2.6.33-rc2-ak/include/linux/kernel.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/kernel.h
+++ linux-2.6.33-rc2-ak/include/linux/kernel.h
@@ -205,6 +205,7 @@ extern unsigned long long memparse(const
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
+extern int kernel_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
 
 struct pid;
Index: linux-2.6.33-rc2-ak/kernel/extable.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/extable.c
+++ linux-2.6.33-rc2-ak/kernel/extable.c
@@ -72,6 +72,18 @@ int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
+static int core_kernel_address(unsigned long addr)
+{
+	if ((addr >= (unsigned long)_text &&
+	     addr <= (unsigned long)_end)) {
+		if (addr >= (unsigned long)__init_begin &&
+		    addr < (unsigned long)__init_end)
+			return system_state == SYSTEM_BOOTING;
+		return 1;
+	}
+	return 0;
+}
+
 int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
@@ -98,6 +110,12 @@ int kernel_text_address(unsigned long ad
 	return is_module_text_address(addr);
 }
 
+/* text or data in core kernel or module */
+int kernel_address(unsigned long addr)
+{
+	return core_kernel_address(addr) || is_module_address(addr);
+}
+
 /*
  * On some architectures (PPC64, IA64) function pointers
  * are actually only tokens to some data that then holds the
