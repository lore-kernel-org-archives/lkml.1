Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbYAQVnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbYAQVnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbYAQVla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:30 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44770 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbYAQVl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:28 -0500
Date: Thu, 17 Jan 2008 16:40:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Daniel Walker <dwalker@mvista.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/20] UML - LDT mutex conversion
Message-ID: <20080117214047.GA6772@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>

The ldt.semaphore conforms to the new struct mutex requirments,
so I converted it to use the new API and changed the name.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/sys-i386/ldt.c |   14 +++++++-------
 include/asm-um/ldt.h   |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6.22/arch/um/sys-i386/ldt.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/ldt.c	2008-01-17 13:44:46.000000000 -0500
+++ linux-2.6.22/arch/um/sys-i386/ldt.c	2008-01-17 13:45:32.000000000 -0500
@@ -147,7 +147,7 @@ static int read_ldt(void __user * ptr, u
 	if (ptrace_ldt)
 		return read_ldt_from_host(ptr, bytecount);
 
-	down(&ldt->semaphore);
+	mutex_lock(&ldt->lock);
 	if (ldt->entry_count <= LDT_DIRECT_ENTRIES) {
 		size = LDT_ENTRY_SIZE*LDT_DIRECT_ENTRIES;
 		if (size > bytecount)
@@ -171,7 +171,7 @@ static int read_ldt(void __user * ptr, u
 			ptr += size;
 		}
 	}
-	up(&ldt->semaphore);
+	mutex_unlock(&ldt->lock);
 
 	if (bytecount == 0 || err == -EFAULT)
 		goto out;
@@ -229,7 +229,7 @@ static int write_ldt(void __user * ptr, 
 	}
 
 	if (!ptrace_ldt)
-		down(&ldt->semaphore);
+		mutex_lock(&ldt->lock);
 
 	err = write_ldt_entry(mm_idp, func, &ldt_info, &addr, 1);
 	if (err)
@@ -289,7 +289,7 @@ static int write_ldt(void __user * ptr, 
 	err = 0;
 
 out_unlock:
-	up(&ldt->semaphore);
+	mutex_unlock(&ldt->lock);
 out:
 	return err;
 }
@@ -396,7 +396,7 @@ long init_new_ldt(struct mm_context *new
 
 
 	if (!ptrace_ldt)
-		init_MUTEX(&new_mm->ldt.semaphore);
+		mutex_init(&new_mm->ldt.lock);
 
 	if (!from_mm) {
 		memset(&desc, 0, sizeof(desc));
@@ -456,7 +456,7 @@ long init_new_ldt(struct mm_context *new
 		 * i.e., we have to use the stub for modify_ldt, which
 		 * can't handle the big read buffer of up to 64kB.
 		 */
-		down(&from_mm->ldt.semaphore);
+		mutex_lock(&from_mm->ldt.lock);
 		if (from_mm->ldt.entry_count <= LDT_DIRECT_ENTRIES)
 			memcpy(new_mm->ldt.u.entries, from_mm->ldt.u.entries,
 			       sizeof(new_mm->ldt.u.entries));
@@ -475,7 +475,7 @@ long init_new_ldt(struct mm_context *new
 			}
 		}
 		new_mm->ldt.entry_count = from_mm->ldt.entry_count;
-		up(&from_mm->ldt.semaphore);
+		mutex_unlock(&from_mm->ldt.lock);
 	}
 
     out:
Index: linux-2.6.22/include/asm-um/ldt.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/ldt.h	2007-11-14 10:33:41.000000000 -0500
+++ linux-2.6.22/include/asm-um/ldt.h	2008-01-17 13:45:32.000000000 -0500
@@ -8,7 +8,7 @@
 #ifndef __ASM_LDT_H
 #define __ASM_LDT_H
 
-#include "asm/semaphore.h"
+#include <linux/mutex.h>
 #include "asm/host_ldt.h"
 
 extern void ldt_host_info(void);
@@ -27,7 +27,7 @@ struct ldt_entry {
 
 typedef struct uml_ldt {
 	int entry_count;
-	struct semaphore semaphore;
+	struct mutex lock;
 	union {
 		struct ldt_entry * pages[LDT_PAGES_MAX];
 		struct ldt_entry entries[LDT_DIRECT_ENTRIES];
