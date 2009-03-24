Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbZCXOT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbZCXOT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760815AbZCXOLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:11:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760847AbZCXOLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:11:46 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] dlm: fix length calculation in compat code
Date: Tue, 24 Mar 2009 09:07:52 -0500
Message-Id: <1237903672-18913-8-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using offsetof() to calculate name length does not work because
it does not produce consistent results with with structure packing.
This caused memcpy to corrupt memory by copying 4 extra bytes off
the end of the buffer on 64 bit kernels with 32 bit userspace
(the only case where this 32/64 compat code is used).

The fix is to calculate name length directly from the start instead
of trying to derive it later using count and offsetof.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 065149e..ebce994 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2006-2008 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2006-2009 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -84,7 +84,7 @@ struct dlm_lock_result32 {
 
 static void compat_input(struct dlm_write_request *kb,
 			 struct dlm_write_request32 *kb32,
-			 size_t count)
+			 int namelen)
 {
 	kb->version[0] = kb32->version[0];
 	kb->version[1] = kb32->version[1];
@@ -96,8 +96,7 @@ static void compat_input(struct dlm_write_request *kb,
 	    kb->cmd == DLM_USER_REMOVE_LOCKSPACE) {
 		kb->i.lspace.flags = kb32->i.lspace.flags;
 		kb->i.lspace.minor = kb32->i.lspace.minor;
-		memcpy(kb->i.lspace.name, kb32->i.lspace.name, count -
-			offsetof(struct dlm_write_request32, i.lspace.name));
+		memcpy(kb->i.lspace.name, kb32->i.lspace.name, namelen);
 	} else if (kb->cmd == DLM_USER_PURGE) {
 		kb->i.purge.nodeid = kb32->i.purge.nodeid;
 		kb->i.purge.pid = kb32->i.purge.pid;
@@ -115,8 +114,7 @@ static void compat_input(struct dlm_write_request *kb,
 		kb->i.lock.bastaddr = (void *)(long)kb32->i.lock.bastaddr;
 		kb->i.lock.lksb = (void *)(long)kb32->i.lock.lksb;
 		memcpy(kb->i.lock.lvb, kb32->i.lock.lvb, DLM_USER_LVB_LEN);
-		memcpy(kb->i.lock.name, kb32->i.lock.name, count -
-			offsetof(struct dlm_write_request32, i.lock.name));
+		memcpy(kb->i.lock.name, kb32->i.lock.name, namelen);
 	}
 }
 
@@ -539,9 +537,16 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 #ifdef CONFIG_COMPAT
 	if (!kbuf->is64bit) {
 		struct dlm_write_request32 *k32buf;
+		int namelen = 0;
+
+		if (count > sizeof(struct dlm_write_request32))
+			namelen = count - sizeof(struct dlm_write_request32);
+
 		k32buf = (struct dlm_write_request32 *)kbuf;
-		kbuf = kmalloc(count + 1 + (sizeof(struct dlm_write_request) -
-			       sizeof(struct dlm_write_request32)), GFP_KERNEL);
+
+		/* add 1 after namelen so that the name string is terminated */
+		kbuf = kzalloc(sizeof(struct dlm_write_request) + namelen + 1,
+			       GFP_KERNEL);
 		if (!kbuf) {
 			kfree(k32buf);
 			return -ENOMEM;
@@ -549,7 +554,8 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 
 		if (proc)
 			set_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags);
-		compat_input(kbuf, k32buf, count + 1);
+
+		compat_input(kbuf, k32buf, namelen);
 		kfree(k32buf);
 	}
 #endif
-- 
1.5.5.6

