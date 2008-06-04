Return-Path: <linux-kernel-owner+w=401wt.eu-S1761234AbYFDMOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234AbYFDMOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbYFDMK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:42730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443AbYFDMKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:subject
         :content-disposition;
        b=i1ux+7tFTYL+FSCQHeEUMuv4p9eJHpnUUio+/RamN8u+sI3W8XjPTiTzNn8n3NSKVd
         KajDzv6jKhdMk4RmrJjBhIDcHHtyoWIVbcbjqrpItrawBgmIX6hfJ7HUSDpnSC1tdTIZ
         w4YQmnWrVCPrru03oAgfXXmqCvXmRm9ZD6fE0=
Message-Id: <20080604115803.227318404@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:45 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch -v3 12/22] introduce memory_read_from_buffer
Content-Disposition: inline; filename=memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces memory_read_from_buffer.

The only difference between memory_read_from_buffer and simple_read_from_buffer
is which address space the function copies to.

simple_read_from_buffer copies to user space memory.
memory_read_from_buffer copies to normal memory.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 fs/libfs.c         |   18 ++++++++++++++++++
 include/linux/fs.h |    5 ++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

Index: 2.6-git/fs/libfs.c
===================================================================
--- 2.6-git.orig/fs/libfs.c
+++ 2.6-git/fs/libfs.c
@@ -528,6 +528,23 @@ ssize_t simple_read_from_buffer(void __u
 	return count;
 }
 
+ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+				const void *from, size_t available)
+{
+	loff_t pos = *ppos;
+
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= available)
+		return 0;
+	if (count > available - pos)
+		count = available - pos;
+	memcpy(to, from + pos, count);
+	*ppos = pos + count;
+
+	return count;
+}
+
 /*
  * Transaction based IO.
  * The file expects a single write which triggers the transaction, and then
@@ -800,6 +817,7 @@ EXPORT_SYMBOL(simple_statfs);
 EXPORT_SYMBOL(simple_sync_file);
 EXPORT_SYMBOL(simple_unlink);
 EXPORT_SYMBOL(simple_read_from_buffer);
+EXPORT_SYMBOL(memory_read_from_buffer);
 EXPORT_SYMBOL(simple_transaction_get);
 EXPORT_SYMBOL(simple_transaction_read);
 EXPORT_SYMBOL(simple_transaction_release);
Index: 2.6-git/include/linux/fs.h
===================================================================
--- 2.6-git.orig/include/linux/fs.h
+++ 2.6-git/include/linux/fs.h
@@ -2000,7 +2000,10 @@ extern int simple_fill_super(struct supe
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 
-extern ssize_t simple_read_from_buffer(void __user *, size_t, loff_t *, const void *, size_t);
+extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
+			loff_t *ppos, const void *from, size_t available);
+extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+			const void *from, size_t available);
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,

-- 
