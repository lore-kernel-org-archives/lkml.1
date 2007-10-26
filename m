Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbXJZTmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbXJZTmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXJZTms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:42:48 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:6462 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXJZTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:42:47 -0400
X-IronPort-AV: i="4.21,335,1188792000"; 
   d="scan'208"; a="42521135:sNHT33134948"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [patch] remove support for un-needed _extratext section
Date: Fri, 26 Oct 2007 15:43:56 -0400
User-Agent: KMail/1.9.5
Cc: "Jon Loeliger" <jdl@freescale.com>,
       "David Woodhouse" <dwmw2@infradead.org>, paulus@samba.org,
       linux-kernel@vger.kernel.org
References: <200710240836.13412.rgetz@blackfin.uclinux.org> <1193409099.16168.31.camel@shinybook.infradead.org> <4721FC6B.8010006@freescale.com>
In-Reply-To: <4721FC6B.8010006@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261543.57111.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 26 Oct 2007 19:42:45.0342 (UTC) FILETIME=[616D57E0:01C81808]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

when passing a zero address to kallsyms_lookup(), the kernel thought it was a
valid kernel address, even if it is not. This is because is_ksym_addr() called 
is_kernel_extratext() and checked against labels that don't exist on many 
archs (which default as zero). Since PPC was the only kernel which defines 
_extra_text, (in 2005), and no longer needs it, this patch removes _extra_text
support.

 arch/ppc/kernel/vmlinux.lds.S  |    5 -----
 include/asm-generic/sections.h |    2 --
 kernel/kallsyms.c              |   11 +----------
 scripts/kallsyms.c             |   12 +++---------
 4 files changed, 4 insertions(+), 26 deletions(-)

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
cc: David Woodhouse <dwmw2@infradead.org>
cc: Jon Loeliger <jdl@freescale.com>
cc: Paul Mackerras <paulus@samba.org>

----

For some history (provided by Jon):
 http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019734.html
 http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019736.html
 http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019751.html

Index: kernel/kallsyms.c
===================================================================
--- kernel/kallsyms.c	(revision 3780)
+++ kernel/kallsyms.c	(working copy)
@@ -48,14 +48,6 @@
 	return 0;
 }
 
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
 	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
@@ -79,8 +71,7 @@
 	if (all_var)
 		return is_kernel(addr);
 
-	return is_kernel_text(addr) || is_kernel_inittext(addr) ||
-		is_kernel_extratext(addr);
+	return is_kernel_text(addr) || is_kernel_inittext(addr);
 }
 
 /* expand a compressed symbol data into the resulting uncompressed string,
Index: include/asm-generic/sections.h
===================================================================
--- include/asm-generic/sections.h	(revision 3780)
+++ include/asm-generic/sections.h	(working copy)
@@ -8,8 +8,6 @@
 extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
-extern char _sextratext[] __attribute__((weak));
-extern char _eextratext[] __attribute__((weak));
 extern char _end[];
 extern char __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
Index: scripts/kallsyms.c
===================================================================
--- scripts/kallsyms.c	(revision 3780)
+++ scripts/kallsyms.c	(working copy)
@@ -45,7 +45,7 @@
 
 static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
-static unsigned long long _text, _stext, _etext, _sinittext, _einittext, _sextratext, _eextratext;
+static unsigned long long _text, _stext, _etext, _sinittext, _einittext;
 static unsigned long long _stext_l1, _etext_l1;
 static int all_symbols = 0;
 static char symbol_prefix_char = '\0';
@@ -104,10 +104,6 @@
 		_sinittext = s->addr;
 	else if (strcmp(sym, "_einittext") == 0)
 		_einittext = s->addr;
-	else if (strcmp(sym, "_sextratext") == 0)
-		_sextratext = s->addr;
-	else if (strcmp(sym, "_eextratext") == 0)
-		_eextratext = s->addr;
 	else if (strcmp(sym, "_stext_l1" ) == 0)
 		_stext_l1 = s->addr;
 	else if (strcmp(sym, "_etext_l1" ) == 0)
@@ -175,18 +171,16 @@
 	if (!all_symbols) {
 		if ((s->addr < _stext || s->addr > _etext)
 		    && (s->addr < _sinittext || s->addr > _einittext)
-		    && (s->addr < _sextratext || s->addr > _eextratext)
 		    && (s->addr < _stext_l1 || s->addr > _etext_l1))
 			return 0;
 		/* Corner case.  Discard any symbols with the same value as
-		 * _etext _einittext or _eextratext; they can move between pass
+		 * _etext; they can move between pass
 		 * 1 and 2 when the kallsyms data are added.  If these symbols
 		 * move then they may get dropped in pass 2, which breaks the
 		 * kallsyms rules.
 		 */
 		if ((s->addr == _etext && strcmp((char*)s->sym + offset, "_etext")) ||
-		    (s->addr == _einittext && strcmp((char*)s->sym + offset, "_einittext")) ||
-		    (s->addr == _eextratext && strcmp((char*)s->sym + offset, "_eextratext")))
+		    (s->addr == _einittext && strcmp((char*)s->sym + offset, "_einittext")))
 			return 0;
 	}
 
Index: arch/ppc/kernel/vmlinux.lds.S
===================================================================
--- arch/ppc/kernel/vmlinux.lds.S	(revision 3780)
+++ arch/ppc/kernel/vmlinux.lds.S	(working copy)
@@ -144,11 +144,6 @@
 
   . = ALIGN(4096);
   __init_end = .;
-
-  . = ALIGN(4096);
-  _sextratext = .;
-  _eextratext = .;
-
   __bss_start = .;
   .bss       :
   {
