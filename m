Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYDFESg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYDFESg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 00:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYDFES0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 00:18:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:46737 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYDFES0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 00:18:26 -0400
X-IronPort-AV: E=Sophos;i="4.25,610,1199682000"; 
   d="scan'208";a="51426518"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: PATCH [1/1]: Don't return symbol lables in init sections after they have been freed
Date: Sun, 6 Apr 2008 00:14:41 -0400
User-Agent: KMail/1.9.5
Cc: "LKML" <linux-kernel@vger.kernel.org>
References: <200803041847.15884.rgetz@blackfin.uclinux.org> <200804021801.25937.rgetz@blackfin.uclinux.org> <200804040941.42275.rusty@rustcorp.com.au>
In-Reply-To: <200804040941.42275.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804060014.41440.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Apr 2008 04:14:29.0680 (UTC) FILETIME=[B58F0300:01C8979C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 3 Apr 2008 19:41, Rusty Russell pondered:
> On Thursday 03 April 2008 08:01:25 Robin Getz wrote:
> > On Tue 4 Mar 2008 20:43, Rusty Russell pondered:
> > >     As to the actual patch, your kallsyms.c patch matches
> > > a2da4052f1df6bc77749f84496fe731ab8b458f7's change to extable.c: please
> > > resubmit with just that one.  For bonus points, look at combining the
> > > extable and kallsyms logic so we don't diverge in future...
> >
> > OK since this took so long, I went for bonus points...
> 
> Looks good.  I don't have extratext in my kernel tho 
> (v2.6.25-rc8-139-ge315c12).  Otherwise I'd suspect it should be consistently 
> used between extable and kallsyms.

update patch - refactored a bit more - all address checking is removed from
kallsyms, and moved to extable - if this looks ok - I will send it properly...


Index: linux-2.6.x/kernel/kallsyms.c
===================================================================
--- linux-2.6.x/kernel/kallsyms.c	(revision 4546)
+++ linux-2.6.x/kernel/kallsyms.c	(working copy)
@@ -45,38 +45,20 @@
 
 extern const unsigned long kallsyms_markers[] __attribute__((weak));
 
-static inline int is_kernel_inittext(unsigned long addr)
+static int is_ksym_addr(unsigned long addr)
 {
-	if (addr >= (unsigned long)_sinittext
-	    && addr <= (unsigned long)_einittext)
-		return 1;
-	return 0;
-}
+	if (all_var) {
+		if (core_kernel_anywhere(addr))
+			return 1;
 
-static inline int is_kernel_text(unsigned long addr)
-{
-	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
-		return 1;
-	return in_gate_area_no_task(addr);
-}
+		return in_gate_area_no_task(addr);
+	}
 
-static inline int is_kernel(unsigned long addr)
-{
-	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_end)
+	if (core_kernel_text(addr))
 		return 1;
+
 	return in_gate_area_no_task(addr);
-}
 
-static int is_ksym_addr(unsigned long addr)
-{
-	if (all_var)
-		return is_kernel(addr);
-
-	return is_kernel_text(addr) || is_kernel_inittext(addr);
 }
 
 /* expand a compressed symbol data into the resulting uncompressed string,
@@ -206,7 +188,7 @@
 
 	/* if we found no next symbol, we use the end of the section */
 	if (!symbol_end) {
-		if (is_kernel_inittext(addr))
+		if (core_kernel_inittext(addr))
 			symbol_end = (unsigned long)_einittext;
 		else if (all_var)
 			symbol_end = (unsigned long)_end;
Index: linux-2.6.x/kernel/extable.c
===================================================================
--- linux-2.6.x/kernel/extable.c	(revision 4541)
+++ linux-2.6.x/kernel/extable.c	(working copy)
@@ -40,18 +40,43 @@
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
+#ifdef CONFIG_KALLSYMS_ALL
+int core_kernel_anywhere(unsigned long addr)
+{
+	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_end)
+		return 1;
+	return 0;
+}
+#endif
+
+int __core_kernel_text(unsigned long addr)
+{
 	if (addr >= (unsigned long)_stext &&
 	    addr <= (unsigned long)_etext)
 		return 1;
 
-	if (addr >= (unsigned long)_sinittext &&
-	    addr <= (unsigned long)_einittext)
- 		return 1;

 	return 0;
 }
 
+int core_kernel_text(unsigned long addr)
+{
+	return __core_kernel_text(addr) || core_kernel_inittext(addr);
+}
+
 int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
@@ -65,3 +90,4 @@
 		return 1;
 	return module_text_address(addr) != NULL;
 }
+
Index: linux-2.6.x/include/linux/kernel.h
===================================================================
--- linux-2.6.x/include/linux/kernel.h	(revision 4541)
+++ linux-2.6.x/include/linux/kernel.h	(working copy)
@@ -167,6 +167,8 @@
 extern unsigned long long memparse(char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
+extern int core_kernel_inittext(unsigned long addr);
+extern int core_kernel_anywhere(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 struct pid;
