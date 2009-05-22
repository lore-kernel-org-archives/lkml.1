Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZEVFBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZEVFBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZEVE4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:56:20 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45240 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbZEVE4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NRMbz7UYJ3TRMgUyIfS22QWWXfRJgC7Ea5bYjZfsibyPUwKLdcDzqSvHURX8LeLhc9
         RMrG6YyAQ+ksC4TKo79KyAmFd0QvhdfH8kNbkgPT/RwUmLMlEoHgrFJFSU5gznD3cP3x
         Hl5fxI7YLOvsfz7hcVxjaJetpt+JsrlsTfijI=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 24/38] C/R: x86_64 debug registers
Date: Fri, 22 May 2009 08:55:18 +0400
Message-Id: <1242968132-1044-24-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/kstate-image.h  |    7 +++++++
 kernel/kstate/kstate-x86_64.c |   26 ++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/linux/kstate-image.h b/include/linux/kstate-image.h
index d697d97..7c54711 100644
--- a/include/linux/kstate-image.h
+++ b/include/linux/kstate-image.h
@@ -143,6 +143,13 @@ struct kstate_image_task_struct_x86_64 {
 	__u16		gsindex;
 	__u16		ss;
 
+	__u64		dr0;
+	__u64		dr1;
+	__u64		dr2;
+	__u64		dr3;
+	__u64		dr6;
+	__u64		dr7;
+
 	__u64		tls_array[3];
 } __packed;
 
diff --git a/kernel/kstate/kstate-x86_64.c b/kernel/kstate/kstate-x86_64.c
index 0d85704..83ed1b5 100644
--- a/kernel/kstate/kstate-x86_64.c
+++ b/kernel/kstate/kstate-x86_64.c
@@ -109,6 +109,10 @@ static int check_image_task_struct_x86_64(struct kstate_image_task_struct *tsk_i
 	if (rv < 0)
 		return rv;
 
+	rv = ptrace_check_debugreg(0, i->dr0, i->dr1, i->dr2, i->dr3, i->dr6, i->dr7);
+	if (rv < 0)
+		return rv;
+
 	if (i->tls_array[0]) {
 		rv = check_tls((struct desc_struct *)&i->tls_array[0]);
 		if (rv < 0)
@@ -150,10 +154,6 @@ int kstate_arch_check_task_struct(struct task_struct *tsk)
 		return -EINVAL;
 	}
 #endif
-	if (test_tsk_thread_flag(tsk, TIF_DEBUG)) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
 	if (tsk->thread.xstate) {
 		WARN_ON(1);
 		return -EINVAL;
@@ -250,6 +250,13 @@ static int dump_task_struct_x86_64(struct kstate_context *ctx, struct task_struc
 	i->gsindex = encode_segment(tsk->thread.gsindex);
 	i->ss = encode_segment(regs->ss);
 
+	i->dr0 = tsk->thread.debugreg0;
+	i->dr1 = tsk->thread.debugreg1;
+	i->dr2 = tsk->thread.debugreg2;
+	i->dr3 = tsk->thread.debugreg3;
+	i->dr6 = tsk->thread.debugreg6;
+	i->dr7 = tsk->thread.debugreg7;
+
 	BUILD_BUG_ON(sizeof(tsk->thread.tls_array[0]) != 8);
 	BUILD_BUG_ON(sizeof(tsk->thread.tls_array) != 3 * 8);
 	memcpy(i->tls_array, tsk->thread.tls_array, sizeof(i->tls_array));
@@ -299,6 +306,17 @@ static int restore_task_struct_x86_64(struct task_struct *tsk, struct kstate_ima
 	tsk->thread.gsindex = decode_segment(i->gsindex);
 	regs->ss = decode_segment(i->ss);
 
+	tsk->thread.debugreg0 = i->dr0;
+	tsk->thread.debugreg1 = i->dr1;
+	tsk->thread.debugreg2 = i->dr2;
+	tsk->thread.debugreg3 = i->dr3;
+	tsk->thread.debugreg6 = i->dr6;
+	tsk->thread.debugreg7 = i->dr7;
+	if (i->dr7)
+		set_tsk_thread_flag(tsk, TIF_DEBUG);
+	else
+		clear_tsk_thread_flag(tsk, TIF_DEBUG);
+
 	memcpy(tsk->thread.tls_array, i->tls_array, sizeof(i->tls_array));
 
 	set_tsk_thread_flag(tsk, TIF_FORK);
-- 
1.5.6.5

