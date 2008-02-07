Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYBGGUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYBGGUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYBGGSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 13/16] dlm: dlm/user.c input validation fixes
Date: Thu,  7 Feb 2008 00:09:16 -0600
Message-Id: <1202364559-9201-14-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

a) in device_write(): add sentinel NUL byte, making sure that lspace.name will
be NUL-terminated
b) in compat_input() be keep it simple about the amounts of data we are copying.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 7cbc682..c306045 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -82,7 +82,7 @@ struct dlm_lock_result32 {
 
 static void compat_input(struct dlm_write_request *kb,
 			 struct dlm_write_request32 *kb32,
-			 int max_namelen)
+			 size_t count)
 {
 	kb->version[0] = kb32->version[0];
 	kb->version[1] = kb32->version[1];
@@ -94,7 +94,8 @@ static void compat_input(struct dlm_write_request *kb,
 	    kb->cmd == DLM_USER_REMOVE_LOCKSPACE) {
 		kb->i.lspace.flags = kb32->i.lspace.flags;
 		kb->i.lspace.minor = kb32->i.lspace.minor;
-		strcpy(kb->i.lspace.name, kb32->i.lspace.name);
+		memcpy(kb->i.lspace.name, kb32->i.lspace.name, count -
+			offsetof(struct dlm_write_request32, i.lspace.name));
 	} else if (kb->cmd == DLM_USER_PURGE) {
 		kb->i.purge.nodeid = kb32->i.purge.nodeid;
 		kb->i.purge.pid = kb32->i.purge.pid;
@@ -112,11 +113,8 @@ static void compat_input(struct dlm_write_request *kb,
 		kb->i.lock.bastaddr = (void *)(long)kb32->i.lock.bastaddr;
 		kb->i.lock.lksb = (void *)(long)kb32->i.lock.lksb;
 		memcpy(kb->i.lock.lvb, kb32->i.lock.lvb, DLM_USER_LVB_LEN);
-		if (kb->i.lock.namelen <= max_namelen)
-			memcpy(kb->i.lock.name, kb32->i.lock.name,
-			       kb->i.lock.namelen);
-		else
-			kb->i.lock.namelen = max_namelen;
+		memcpy(kb->i.lock.name, kb32->i.lock.name, count -
+			offsetof(struct dlm_write_request32, i.lock.name));
 	}
 }
 
@@ -508,7 +506,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 #endif
 		return -EINVAL;
 
-	kbuf = kmalloc(count, GFP_KERNEL);
+	kbuf = kzalloc(count + 1, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
 
@@ -526,15 +524,14 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 	if (!kbuf->is64bit) {
 		struct dlm_write_request32 *k32buf;
 		k32buf = (struct dlm_write_request32 *)kbuf;
-		kbuf = kmalloc(count + (sizeof(struct dlm_write_request) -
+		kbuf = kmalloc(count + 1 + (sizeof(struct dlm_write_request) -
 			       sizeof(struct dlm_write_request32)), GFP_KERNEL);
 		if (!kbuf)
 			return -ENOMEM;
 
 		if (proc)
 			set_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags);
-		compat_input(kbuf, k32buf,
-			     count - sizeof(struct dlm_write_request32));
+		compat_input(kbuf, k32buf, count + 1);
 		kfree(k32buf);
 	}
 #endif
-- 
1.5.3.3

