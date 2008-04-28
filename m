Return-Path: <linux-kernel-owner+w=401wt.eu-S936336AbYD1TQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936336AbYD1TQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933866AbYD1TP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:15:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:64961 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933720AbYD1TP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=tlG0ONmWYYHuCPVikQxVMZGUdy4gJBkDTvccIkQPBmNAYzYo9uzbqh9dh+6ndaLUy/V2/A4yg8qnuihuYusCJGLinMzZecq8xolFZxbwvoAb4t+0zDYO1dYYDm7QvxxWxezf2tcYpsna+4MBjUA1Td4dUUZN9j/osszK2u4uer0=
Date: Mon, 28 Apr 2008 23:15:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Markus Metzger <markus.t.metzger@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: DS cleanup - dont treat 0 as NULL
Message-ID: <20080428191504.GA6842@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Actually I wonder why in original code Atom processors was
_that_ aligned? Was it made with a special purpose? yes,
it's a mobile platform, but can't see any reason for such
alignment.

 arch/x86/kernel/ds.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 5b32b6d..24a323c 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -238,12 +238,12 @@ static inline struct ds_context *ds_alloc_context(struct task_struct *task)
 		context = kzalloc(sizeof(*context), GFP_KERNEL);
 
 		if (!context)
-			return 0;
+			return NULL;
 
 		context->ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
 		if (!context->ds) {
 			kfree(context);
-			return 0;
+			return NULL;
 		}
 
 		*p_context = context;
@@ -279,7 +279,7 @@ static inline void ds_put_context(struct ds_context *context)
 	if (--context->count)
 		goto out;
 
-	*(context->this) = 0;
+	*(context->this) = NULL;
 
 	if (context->task)
 		clear_tsk_thread_flag(context->task, TIF_DS_AREA_MSR);
@@ -341,16 +341,16 @@ static inline void *ds_allocate_buffer(size_t size, unsigned int *pages)
 	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
 	vm   = current->mm->total_vm  + pgsz;
 	if (rlim < vm)
-		return 0;
+		return NULL;
 
 	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
 	vm   = current->mm->locked_vm  + pgsz;
 	if (rlim < vm)
-		return 0;
+		return NULL;
 
 	buffer = kzalloc(size, GFP_KERNEL);
 	if (!buffer)
-		return 0;
+		return NULL;
 
 	current->mm->total_vm  += pgsz;
 	current->mm->locked_vm += pgsz;
@@ -395,7 +395,7 @@ static int ds_request(struct task_struct *task, void *base, size_t size,
 	if (context->owner[qual] == current)
 		goto out_unlock;
 	error = -EPERM;
-	if (context->owner[qual] != 0)
+	if (context->owner[qual] != NULL)
 		goto out_unlock;
 	context->owner[qual] = current;
 
@@ -445,7 +445,7 @@ static int ds_request(struct task_struct *task, void *base, size_t size,
 	return error;
 
  out_release:
-	context->owner[qual] = 0;
+	context->owner[qual] = NULL;
 	ds_put_context(context);
 	return error;
 
@@ -825,7 +825,7 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 			ds_configure(&ds_cfg_var);
 			break;
 		case 0xF: /* Core2 */
-        case 0x1C: /* Atom */
+		case 0x1C: /* Atom */
 			ds_configure(&ds_cfg_64);
 			break;
 		default:

