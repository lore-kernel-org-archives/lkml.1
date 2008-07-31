Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYGaI47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYGaI47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYGaI4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:56:51 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:40214 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751135AbYGaI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:56:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=NgUmSZeNchIH8cEs8Q/8/tkKggKMRFROwQZu7DB1ZyA+JlwXJWuVvR8i8062zBZVEBo3EmX3XA/XJ4xX3QrqsgMXJBpZCICo1wbyQpwgDnaXuIv8l0lMk22VZ37Je2XFH4IBt4fiU2S7KBAB5Z5rk/np714B5oot2/zDl8oytcc=  ;
X-YMail-OSG: 4oSPSP4VM1lorGW_dvXph.VE1JdLsajdPTMOz5MHO6jnMn_2TeBJnVCvDcMS.JGSDTefxpRWxbKVqiFWGURKUbfooz_oq6mXSvDRlGMWl_afzqfU_HgOR0y5R7hmUk7lBeQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Date: Thu, 31 Jul 2008 18:56:39 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@qumranet.com>,
       Adrian Bunk <bunk@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
References: <200807301438.55941.rusty@rustcorp.com.au> <200807311848.13142.nickpiggin@yahoo.com.au> <1217494343.11188.437.camel@pasglop>
In-Reply-To: <1217494343.11188.437.camel@pasglop>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_H5XkI000i8RFXLm"
Message-Id: <200807311856.39837.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_H5XkI000i8RFXLm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 31 July 2008 18:52, Benjamin Herrenschmidt wrote:
> On Thu, 2008-07-31 at 18:48 +1000, Nick Piggin wrote:
> > > If we do this then corresponding changes should be made to the powerpc
> > > patch upon which Ben presently sits.
> >
> > Powerpc will still use the CONFIG symbol for the moment because 32-bit
> > TLB flushing has not been verified to work, so we don't want to pull in
> > the 64-bit gup. There is some discussion going on, but they probably need
> > at least to implement pte_special, and then also do RCU freeing of page
> > tables.
>
> It's just a matter of building gup.c or not .. as long as it's
> in the makefile as obj-$(CONFIG_PPC64) (as I put it in the merged
> version of the patch), the weak symbol should work.

I see. Here we are, then.

--Boundary-00=_H5XkI000i8RFXLm
Content-Type: text/x-diff;
  charset="utf-8";
  name="out-of-line-gup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="out-of-line-gup.patch"

Out of line get_user_pages_fast fallback implementation, make it a weak
symbol, get rid of CONFIG_HAVE_GET_USER_PAGES_FAST.

Export the symbol to modules so lguest can use it.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-07-31 18:45:19.000000000 +1000
+++ linux-2.6/include/linux/mm.h	2008-07-31 18:53:43.000000000 +1000
@@ -834,7 +834,6 @@ extern int mprotect_fixup(struct vm_area
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
 
-#ifdef CONFIG_HAVE_GET_USER_PAGES_FAST
 /*
  * get_user_pages_fast provides equivalent functionality to get_user_pages,
  * operating on current and current->mm (force=0 and doesn't return any vmas).
@@ -848,25 +847,6 @@ extern int mprotect_fixup(struct vm_area
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 
-#else
-/*
- * Should probably be moved to asm-generic, and architectures can include it if
- * they don't implement their own get_user_pages_fast.
- */
-#define get_user_pages_fast(start, nr_pages, write, pages)	\
-({								\
-	struct mm_struct *mm = current->mm;			\
-	int ret;						\
-								\
-	down_read(&mm->mmap_sem);				\
-	ret = get_user_pages(current, mm, start, nr_pages,	\
-					write, 0, pages, NULL);	\
-	up_read(&mm->mmap_sem);					\
-								\
-	ret;							\
-})
-#endif
-
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-07-31 18:45:19.000000000 +1000
+++ linux-2.6/mm/memory.c	2008-07-31 18:53:43.000000000 +1000
@@ -1270,6 +1270,21 @@ int get_user_pages(struct task_struct *t
 }
 EXPORT_SYMBOL(get_user_pages);
 
+int __attribute__((weak)) get_user_pages_fast(unsigned long start,
+				int nr_pages, int write, struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(current, mm, start, nr_pages,
+					write, 0, pages, NULL);
+	up_read(&mm->mmap_sem);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(get_user_pages_fast);
+
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			spinlock_t **ptl)
 {
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2008-07-31 18:45:20.000000000 +1000
+++ linux-2.6/arch/x86/Kconfig	2008-07-31 18:53:43.000000000 +1000
@@ -22,7 +22,6 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_IOREMAP_PROT
-	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
Index: linux-2.6/arch/x86/mm/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/mm/Makefile	2008-07-31 18:45:20.000000000 +1000
+++ linux-2.6/arch/x86/mm/Makefile	2008-07-31 18:53:43.000000000 +1000
@@ -1,7 +1,6 @@
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o
+	    pat.o pgtable.o gup.o
 
-obj-$(CONFIG_HAVE_GET_USER_PAGES_FAST) += gup.o
 obj-$(CONFIG_X86_32)		+= pgtable_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig	2008-07-31 18:53:45.000000000 +1000
+++ linux-2.6/arch/powerpc/Kconfig	2008-07-31 18:53:51.000000000 +1000
@@ -42,9 +42,6 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
-config HAVE_GET_USER_PAGES_FAST
-	def_bool PPC64
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2008-07-31 18:55:16.000000000 +1000
+++ linux-2.6/mm/Kconfig	2008-07-31 18:55:20.000000000 +1000
@@ -77,9 +77,6 @@ config FLAT_NODE_MEM_MAP
 	def_bool y
 	depends on !SPARSEMEM
 
-config HAVE_GET_USER_PAGES_FAST
-	bool
-
 #
 # Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
 # to represent different areas of memory.  This variable allows

--Boundary-00=_H5XkI000i8RFXLm--
