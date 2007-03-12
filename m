Return-Path: <linux-kernel-owner+w=401wt.eu-S1030567AbXCLQRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030567AbXCLQRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030572AbXCLQRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:17:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59216 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030567AbXCLQRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:17:43 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix deadlock in audit_log_task_context()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HQnDS-0008Ks-CN@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 12 Mar 2007 16:17:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


GFP_KERNEL allocations in non-blocking context; fixed by killing
an idiotic use of security_getprocattr().

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/auditsc.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3599558..628c7ac 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -739,28 +739,26 @@ static inline void audit_free_context(struct audit_context *context)
 void audit_log_task_context(struct audit_buffer *ab)
 {
 	char *ctx = NULL;
-	ssize_t len = 0;
+	unsigned len;
+	int error;
+	u32 sid;
+
+	selinux_get_task_sid(current, &sid);
+	if (!sid)
+		return;
 
-	len = security_getprocattr(current, "current", NULL, 0);
-	if (len < 0) {
-		if (len != -EINVAL)
+	error = selinux_sid_to_string(sid, &ctx, &len);
+	if (error) {
+		if (error != -EINVAL)
 			goto error_path;
 		return;
 	}
 
-	ctx = kmalloc(len, GFP_KERNEL);
-	if (!ctx)
-		goto error_path;
-
-	len = security_getprocattr(current, "current", ctx, len);
-	if (len < 0 )
-		goto error_path;
-
 	audit_log_format(ab, " subj=%s", ctx);
+	kfree(ctx);
 	return;
 
 error_path:
-	kfree(ctx);
 	audit_panic("error in audit_log_task_context");
 	return;
 }
-- 
1.5.0-rc2.GIT

