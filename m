Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbYAXREP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbYAXREP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758354AbYAXQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291AbYAXQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:41 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfeld <pcaulfie@redhat.com>
Subject: [PATCH 19/19] dlm: Sanity check namelen before copying it
Date: Thu, 24 Jan 2008 10:50:42 -0600
Message-Id: <1201193442-8260-20-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfeld <pcaulfie@redhat.com>

The 32/64 compatibility code in the DLM does not check the validity of
the lock name length passed into it, so it can easily overwrite memory
if the value is rubbish (as early versions of libdlm can cause with
unlock calls, it doesn't zero the field).

This patch restricts the length of the name to the amount of data
actually passed into the call.

Signed-off-by: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index eb61648..1acb4c5 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -82,7 +82,8 @@ struct dlm_lock_result32 {
 };
 
 static void compat_input(struct dlm_write_request *kb,
-			 struct dlm_write_request32 *kb32)
+			 struct dlm_write_request32 *kb32,
+			 int max_namelen)
 {
 	kb->version[0] = kb32->version[0];
 	kb->version[1] = kb32->version[1];
@@ -112,7 +113,11 @@ static void compat_input(struct dlm_write_request *kb,
 		kb->i.lock.bastaddr = (void *)(long)kb32->i.lock.bastaddr;
 		kb->i.lock.lksb = (void *)(long)kb32->i.lock.lksb;
 		memcpy(kb->i.lock.lvb, kb32->i.lock.lvb, DLM_USER_LVB_LEN);
-		memcpy(kb->i.lock.name, kb32->i.lock.name, kb->i.lock.namelen);
+		if (kb->i.lock.namelen <= max_namelen)
+			memcpy(kb->i.lock.name, kb32->i.lock.name,
+			       kb->i.lock.namelen);
+		else
+			kb->i.lock.namelen = max_namelen;
 	}
 }
 
@@ -529,7 +534,8 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 
 		if (proc)
 			set_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags);
-		compat_input(kbuf, k32buf);
+		compat_input(kbuf, k32buf,
+			     count - sizeof(struct dlm_write_request32));
 		kfree(k32buf);
 	}
 #endif
-- 
1.5.3.3

