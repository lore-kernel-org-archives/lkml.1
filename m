Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbYDBWB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbYDBWB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbYDBWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:01:18 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:2855 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbYDBWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:01:17 -0400
X-IronPort-AV: E=Sophos;i="4.25,595,1199682000"; 
   d="scan'208";a="65639863"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: PATCH [1/1]: Don't return symbol lables in init sections after they have been freed
Date: Wed, 2 Apr 2008 18:01:25 -0400
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200803041847.15884.rgetz@blackfin.uclinux.org> <200803051243.26732.rusty@rustcorp.com.au>
In-Reply-To: <200803051243.26732.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021801.25937.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 02 Apr 2008 22:01:15.0955 (UTC) FILETIME=[129E8030:01C8950D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 4 Mar 2008 20:43, Rusty Russell pondered:
>     As to the actual patch, your kallsyms.c patch matches 
> a2da4052f1df6bc77749f84496fe731ab8b458f7's change to extable.c: please 
> resubmit with just that one.  For bonus points, look at combining the extable 
> and kallsyms logic so we don't diverge in future...

OK since this took so long, I went for bonus points...

The only think I wasn't sure about - is since it now does things in extable.c,
it removes the static inline functions from kallsyms.c - which could cause a
potential slowdown...

I'm sure this will not apply to the mm tree, (it was based on 2.6.24.3), but
should provide some idea for feedback.

Index: linux-2.6.x/kernel/extable.c
===================================================================
--- linux-2.6.x/kernel/extable.c	(revision 4461)
+++ linux-2.6.x/kernel/extable.c	(working copy)
@@ -40,17 +40,40 @@
 	return e;
 }
 
-int core_kernel_text(unsigned long addr)
+int core_kernel_inittext(unsigned long addr)
 {
+	if (addr >= (unsigned long)_sinittext &&
+	    addr <= (unsigned long)_einittext)
+		return 1;
+	return 0;
+}
+
+int core_kernel_extratext(unsigned long addr)
+{
+	if (addr >= (unsigned long)_sextratext &&
+	    addr <= (unsigned long)_eextratext)
+		return 1;
+	return 0;
+}
+
+int __core_kernel_text(unsigned long addr)
+{
 	if (addr >= (unsigned long)_stext &&
 	    addr <= (unsigned long)_etext)
 		return 1;
 
-	if (addr >= (unsigned long)_sinittext &&
-	    addr <= (unsigned long)_einittext)
 		return 1;
 	return 0;
+
 }
+int core_kernel_text(unsigned long addr)
+{
+	return __core_kernel_text(addr) || core_kernel_inittext(addr);
+}
 
 int __kernel_text_address(unsigned long addr)
 {
@@ -65,3 +88,4 @@
 		return 1;
 	return module_text_address(addr) != NULL;
 }
+
Index: linux-2.6.x/kernel/kallsyms.c
===================================================================
--- linux-2.6.x/kernel/kallsyms.c	(revision 4461)
+++ linux-2.6.x/kernel/kallsyms.c	(working copy)
@@ -45,47 +45,24 @@
 
 extern const unsigned long kallsyms_markers[] __attribute__((weak));
 
-static inline int is_kernel_inittext(unsigned long addr)
-{
-	if (addr >= (unsigned long)_sinittext
-	    && addr <= (unsigned long)_einittext)
-		return 1;
-	return 0;
-}
-
-static inline int is_kernel_extratext(unsigned long addr)
-{
-	if (addr >= (unsigned long)_sextratext
-	    && addr <= (unsigned long)_eextratext)
-		return 1;
-	return 0;
-}
-
 static inline int is_kernel_text(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
+	if (core_kernel_text(addr))
 		return 1;
-	return in_gate_area_no_task(addr);
-}
 
-static inline int is_kernel(unsigned long addr)
-{
-	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_end)
-		return 1;
 	return in_gate_area_no_task(addr);
 }
 
 static int is_ksym_addr(unsigned long addr)
 {
-	if (all_var)
-		return is_kernel(addr);
+	if (all_var) {
+		if (addr >= (unsigned long)_stext && addr <= (unsigned long)_end)
+			return 1;
+		else
+			return in_gate_area_no_task(addr);
+	}
 
-	return is_kernel_text(addr) || is_kernel_inittext(addr) ||
-		is_kernel_extratext(addr);
+	return is_kernel_text(addr) || core_kernel_extratext(addr);
 }
 
 /* expand a compressed symbol data into the resulting uncompressed string,
@@ -215,7 +192,7 @@
 
 	/* if we found no next symbol, we use the end of the section */
 	if (!symbol_end) {
-		if (is_kernel_inittext(addr))
+		if (core_kernel_inittext(addr))
 			symbol_end = (unsigned long)_einittext;
 		else if (all_var)
 			symbol_end = (unsigned long)_end;
Index: linux-2.6.x/include/linux/kernel.h
===================================================================
--- linux-2.6.x/include/linux/kernel.h	(revision 4461)
+++ linux-2.6.x/include/linux/kernel.h	(working copy)
@@ -167,6 +167,8 @@
 extern unsigned long long memparse(char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
+extern int core_kernel_extratext(unsigned long addr);
+extern int core_kernel_inittext(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 struct pid;

