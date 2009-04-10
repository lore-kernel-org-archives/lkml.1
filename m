Return-Path: <linux-kernel-owner+w=401wt.eu-S936448AbZDJCjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936448AbZDJCjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934858AbZDJCgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:36:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46185 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934657AbZDJCgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fgB/m16LmhUDZOIKQb2PSLS2UJyDQ1E2WUgNGND3ZpwzZ4W+pp6S2qcrNa0Na+u7Q2
         Ri7LSI84BELm2FDmm/k3Io5S1uIidDhhKFd+/QaC/wMxHh8n3/mtJUZ9izl0vt+n/dZX
         jJNR02i2DR7qz05ndXtWev0SDncIWYe8zCk4s=
Date: Fri, 10 Apr 2009 06:36:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/30] cr: i386 LDT support
Message-ID: <20090410023625.GN27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXME: LDT actual restoration

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/cr/cr-x86_32.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/kernel/cr/cr-x86_32.c
+++ b/kernel/cr/cr-x86_32.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 2000-2009 Parallels Holdings, Ltd. */
 #include <linux/sched.h>
 #include <asm/i387.h>
+#include <asm/ldt.h>
 
 #include <linux/cr.h>
 #include "cr.h"
@@ -226,21 +227,25 @@ int cr_arch_restore_task_struct(struct task_struct *tsk, struct cr_image_task_st
 
 int cr_arch_check_mm_struct(struct mm_struct *mm)
 {
-	mutex_lock(&mm->context.lock);
-	if (mm->context.ldt || mm->context.size != 0) {
-		mutex_unlock(&mm->context.lock);
-		WARN_ON(1);
-		return -EINVAL;
-	}
 	return 0;
 }
 
 unsigned int cr_arch_len_mm_struct(struct mm_struct *mm)
 {
-	return 0;
+	unsigned int len;
+
+	mutex_lock(&mm->context.lock);
+	len = mm->context.size * LDT_ENTRY_SIZE;
+	mutex_unlock(&mm->context.lock);
+	return len;
 }
 
 int cr_arch_dump_mm_struct(struct cr_context *ctx, struct mm_struct *mm)
 {
-	return 0;
+	int rv;
+
+	mutex_lock(&mm->context.lock);
+	rv = cr_write(ctx, mm->context.ldt, mm->context.size * LDT_ENTRY_SIZE);
+	mutex_unlock(&mm->context.lock);
+	return rv;
 }
