Return-Path: <linux-kernel-owner+w=401wt.eu-S1163334AbXD1Ryi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163334AbXD1Ryi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163331AbXD1Rxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:38678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163324AbXD1RxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:53:00 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [33/35] x86_64: Remove duplicated code for reading control registers
Message-Id: <20070428175259.2E308151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Glauber de Oliveira Costa <gcosta@redhat.com>

On Tue, Mar 13, 2007 at 05:33:09AM -0700, Randy.Dunlap wrote:
> On Tue, 13 Mar 2007, Glauber de Oliveira Costa wrote:
> 
> > Tiny cleanup:
> >
> > In x86_64, the same functions for reading cr3 and writing cr{3,4} are
> > defined in tlbflush.h and system.h, whith just a name change.
> > The only difference is the clobbering of memory, which seems a safe, and
> > even needed change for the write_cr4. This patch removes the duplicate.
> > write_cr3() is moved to system.h for consistency.
> 
> missing patch.....
> 
thanks. Attached now

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"


Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-x86_64/system.h   |    7 ++++++-
 include/asm-x86_64/tlbflush.h |   33 +++++----------------------------
 2 files changed, 11 insertions(+), 29 deletions(-)

2d19cf472903fa4c9e763301b7b1cc0fa53bd023
Index: linux/include/asm-x86_64/system.h
===================================================================
--- linux.orig/include/asm-x86_64/system.h
+++ linux/include/asm-x86_64/system.h
@@ -89,6 +89,11 @@ static inline unsigned long read_cr3(voi
 	return cr3;
 } 
 
+static inline void write_cr3(unsigned long val)
+{
+	asm volatile("movq %0,%%cr3" :: "r" (val) : "memory");
+}
+
 static inline unsigned long read_cr4(void)
 { 
 	unsigned long cr4;
@@ -98,7 +103,7 @@ static inline unsigned long read_cr4(voi
 
 static inline void write_cr4(unsigned long val)
 { 
-	asm volatile("movq %0,%%cr4" :: "r" (val));
+	asm volatile("movq %0,%%cr4" :: "r" (val) : "memory");
 } 
 
 #define stts() write_cr0(8 | read_cr0())
Index: linux/include/asm-x86_64/tlbflush.h
===================================================================
--- linux.orig/include/asm-x86_64/tlbflush.h
+++ linux/include/asm-x86_64/tlbflush.h
@@ -3,41 +3,18 @@
 
 #include <linux/mm.h>
 #include <asm/processor.h>
-
-static inline unsigned long get_cr3(void)
-{
-	unsigned long cr3;
-	asm volatile("mov %%cr3,%0" : "=r" (cr3));
-	return cr3;
-}
-
-static inline void set_cr3(unsigned long cr3)
-{
-	asm volatile("mov %0,%%cr3" :: "r" (cr3) : "memory");
-}
+#include <asm/system.h>
 
 static inline void __flush_tlb(void)
 {
-	set_cr3(get_cr3());
-}
-
-static inline unsigned long get_cr4(void)
-{
-	unsigned long cr4;
-	asm volatile("mov %%cr4,%0" : "=r" (cr4));
-	return cr4;
-}
-
-static inline void set_cr4(unsigned long cr4)
-{
-	asm volatile("mov %0,%%cr4" :: "r" (cr4) : "memory");
+	write_cr3(read_cr3());
 }
 
 static inline void __flush_tlb_all(void)
 {
-	unsigned long cr4 = get_cr4();
-	set_cr4(cr4 & ~X86_CR4_PGE);	/* clear PGE */
-	set_cr4(cr4);			/* write old PGE again and flush TLBs */
+	unsigned long cr4 = read_cr4();
+	write_cr4(cr4 & ~X86_CR4_PGE);	/* clear PGE */
+	write_cr4(cr4);			/* write old PGE again and flush TLBs */
 }
 
 #define __flush_tlb_one(addr) \
