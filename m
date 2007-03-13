Return-Path: <linux-kernel-owner+w=401wt.eu-S933530AbXCMMw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbXCMMw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933526AbXCMMw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:52:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933530AbXCMMw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:52:56 -0400
Date: Tue, 13 Mar 2007 09:52:50 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove duplicated code for reading control registers
Message-ID: <20070313125250.GI10126@redhat.com>
References: <20070313123011.GG10126@redhat.com> <Pine.LNX.4.58.0703130532510.13997@shark.he.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0703130532510.13997@shark.he.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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

--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cleanup.patch"

---

 include/asm-x86_64/system.h   |    7 ++++++-
 include/asm-x86_64/tlbflush.h |   33 +++++----------------------------
 2 files changed, 11 insertions(+), 29 deletions(-)

2d19cf472903fa4c9e763301b7b1cc0fa53bd023
diff --git a/include/asm-x86_64/system.h b/include/asm-x86_64/system.h
index bd376bc..91b461d 100644
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
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
diff --git a/include/asm-x86_64/tlbflush.h b/include/asm-x86_64/tlbflush.h
index 983bd29..512401b 100644
--- a/include/asm-x86_64/tlbflush.h
+++ b/include/asm-x86_64/tlbflush.h
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
-- 
1.1.3


--hHWLQfXTYDoKhP50--
