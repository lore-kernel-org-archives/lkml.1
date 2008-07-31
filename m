Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYGaILZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYGaILZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYGaILK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:11:10 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:29323 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750972AbYGaILG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:11:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=ZFKifK70Hof/MQOuQe2xsjCztr4CzEXUDsMCuOtWqo/nLBw6avo3jfDZFP63udhN5ARUnT0BMKNkyn/TMDmapZsglV9f5P1Wpu4O2vwP/u0faf+VMshVmCrc1myCFrizjXfMLPA6mRILSKZkW1USBKdi2WDi58BOMuhsbqRFC38=  ;
X-YMail-OSG: D3l3Rk8VM1kOxCv3Pf52WbKcCaBE27uR3XUbsyvJ2zr3NMqdsqw7H6TQGKTGsVD_rKcKW9LqRIYMwhRuKA2uSJo0_7_efLbOl266d5UItZdyqfGMyrV7Ss3x57HdzDwBb9A-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Date: Thu, 31 Jul 2008 18:10:57 +1000
User-Agent: KMail/1.9.5
Cc: Avi Kivity <avi@qumranet.com>, Adrian Bunk <bunk@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org
References: <200807301438.55941.rusty@rustcorp.com.au> <48915F2F.4020407@qumranet.com> <20080731000257.59830c25.akpm@linux-foundation.org>
In-Reply-To: <20080731000257.59830c25.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ROXkI7Pb5eS/mq/"
Message-Id: <200807311810.57821.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ROXkI7Pb5eS/mq/
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 31 July 2008 17:02, Andrew Morton wrote:
> On Thu, 31 Jul 2008 09:43:59 +0300 Avi Kivity <avi@qumranet.com> wrote:

> > Surprised.  Why not an out-of-line function?  Would eliminate the
> > present discussion as well.
>
> Excellent question!

Like this?

--Boundary-00=_ROXkI7Pb5eS/mq/
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="out-of-line-gup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="out-of-line-gup.patch"

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-07-31 17:59:04.000000000 +1000
+++ linux-2.6/include/linux/mm.h	2008-07-31 18:01:51.000000000 +1000
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
--- linux-2.6.orig/mm/memory.c	2008-07-31 17:59:26.000000000 +1000
+++ linux-2.6/mm/memory.c	2008-07-31 18:01:25.000000000 +1000
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
--- linux-2.6.orig/arch/x86/Kconfig	2008-07-31 18:08:35.000000000 +1000
+++ linux-2.6/arch/x86/Kconfig	2008-07-31 18:08:53.000000000 +1000
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
--- linux-2.6.orig/arch/x86/mm/Makefile	2008-07-31 18:08:58.000000000 +1000
+++ linux-2.6/arch/x86/mm/Makefile	2008-07-31 18:09:07.000000000 +1000
@@ -1,7 +1,6 @@
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o
+	    pat.o pgtable.o gup.o
 
-obj-$(CONFIG_HAVE_GET_USER_PAGES_FAST) += gup.o
 obj-$(CONFIG_X86_32)		+= pgtable_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o

--Boundary-00=_ROXkI7Pb5eS/mq/--
