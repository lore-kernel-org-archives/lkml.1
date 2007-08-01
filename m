Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbXHAV5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbXHAV5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXHAV5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:57:40 -0400
Received: from stephens.ittc.ku.edu ([129.237.125.220]:58271 "EHLO
	stephens.ittc.ku.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbXHAV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:57:39 -0400
Date: Wed, 1 Aug 2007 16:57:28 -0500
From: nwatkins@ittc.ku.edu
To: mathieu.desnoyers@polymtl.ca
Cc: nwatkins@ittc.ku.edu, linux-kernel@vger.kernel.org
Subject: [patch 1/1] Adds flavor field to __mark_marker
Message-ID: <20070801215728.GB10470@ittc.ku.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="marker-add-site-defined-flavor.diff"
User-Agent: quilt/0.46-1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (stephens.ittc.ku.edu [129.237.125.220]); Wed, 01 Aug 2007 16:57:29 -0500 (CDT)
X-VirusScan: Clean
X-MailScanner-From: nwatkins@ittc.ku.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch demonstrates an extension field to the
low-level marker functionality, and updates macros to accept
this additional data.


Index: linux-2.6.22-rc6-mm1/include/linux/marker.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/marker.h	2007-08-01 15:39:36.000000000 -0500
+++ linux-2.6.22-rc6-mm1/include/linux/marker.h	2007-08-01 15:39:37.000000000 -0500
@@ -31,10 +31,14 @@
 	const char *args;	/* List of arguments litteraly transformed
 				 * into a string: "arg1, arg2, arg3".
 				 */
+	const int flavor;	/* site-defined marker flavor  */
 	immediate_char_t state;	/* Immediate value state. */
 	marker_probe_func *call;/* Probe handler function pointer */
 	void *pdata;		/* Private probe data */
-} __attribute__((aligned(8)));
+} __attribute__((aligned(32)));
+
+/* Default marker flavor */
+#define MARKER_DEFAULT 0
 
 #ifdef CONFIG_MARKERS
 
@@ -46,7 +50,7 @@
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define __trace_mark(generic, name, format, args...)			\
+#define ___trace_mark(generic, flavor, name, format, args...)		\
 	do {								\
 		static const char __mstrtab_name_##name[]		\
 		__attribute__((section("__markers_strings")))		\
@@ -60,7 +64,7 @@
 		static struct __mark_marker __mark_##name		\
 		__attribute__((section("__markers"))) =			\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
-		__mstrtab_args_##name, { 0 },				\
+		__mstrtab_args_##name, flavor, { 0 },			\
 		__mark_empty_function, NULL };				\
 		asm volatile ( "" : : "i" (&__mark_##name));		\
 		__mark_check_format(format, ## args);			\
@@ -81,6 +85,9 @@
 		}							\
 	} while (0)
 
+#define __trace_mark(generic, name, format, args...) \
+		___trace_mark(generic, MARKER_DEFAULT, name, format, ## args)
+
 extern void module_marker_update(struct module *mod);
 #else /* !CONFIG_MARKERS */
 #define __trace_mark(generic, name, format, args...) \
Index: linux-2.6.22-rc6-mm1/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/asm-generic/vmlinux.lds.h	2007-08-01 15:39:36.000000000 -0500
+++ linux-2.6.22-rc6-mm1/include/asm-generic/vmlinux.lds.h	2007-08-01 15:40:06.000000000 -0500
@@ -13,7 +13,7 @@
 #define DATA_DATA							\
 	*(.data)							\
 	*(.data.init.refok)						\
-	. = ALIGN(8);							\
+	. = ALIGN(32);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
 	VMLINUX_SYMBOL(__stop___markers) = .;

-- 
