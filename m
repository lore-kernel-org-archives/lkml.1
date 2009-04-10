Return-Path: <linux-kernel-owner+w=401wt.eu-S937475AbZDJClR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937475AbZDJClR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935499AbZDJChV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:37:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:52299 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935491AbZDJChS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tgDmb7J2l1Q1RPgbWuDoll8pw5A0uLHCrTHnqiUPy6guziCc3GV2hpnbOInaDW6nJi
         /pBIAN4qoZrYRLQHJ1axjSQWqh5zDps822doJvl3/f1Ob41IPLSboUblZKV0cXTk+YRW
         laVWXI9hXbASR56JSze8+Ezrmf2WBq/sr+2w0=
Date: Fri, 10 Apr 2009 06:37:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/30] cr: x86_64 LDT support
Message-ID: <20090410023721.GQ27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXME: actual LDT restore

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/cr/cr-x86_64.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/kernel/cr/cr-x86_64.c
+++ b/kernel/cr/cr-x86_64.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 2000-2009 Parallels Holdings, Ltd. */
 #include <linux/sched.h>
 #include <asm/i387.h>
+#include <asm/ldt.h>
 
 #include <linux/cr.h>
 #include "cr.h"
@@ -400,22 +401,25 @@ int cr_arch_restore_task_struct(struct task_struct *tsk, struct cr_image_task_st
 
 int cr_arch_check_mm_struct(struct mm_struct *mm)
 {
-	mutex_lock(&mm->context.lock);
-	if (mm->context.ldt || mm->context.size != 0) {
-		mutex_unlock(&mm->context.lock);
-		WARN_ON(1);
-		return -EINVAL;
-	}
-	mutex_unlock(&mm->context.lock);
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
