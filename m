Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbZJNJ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbZJNJ7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbZJNJ7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:59:14 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:20061 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327AbZJNJ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:59:12 -0400
From: Joel Becker <joel.becker@ORACLE.COM>
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, torvalds@linux-foundation.org
Subject: [PATCH 1/2] vfs: Add MAY_CREATE to the permission() flags.
Date: Wed, 14 Oct 2009 02:57:40 -0700
Message-Id: <1255514261-25823-2-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1255514261-25823-1-git-send-email-joel.becker@oracle.com>
References: <1255514261-25823-1-git-send-email-joel.becker@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AD5A09A.0146:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple rule of system calls is that you cannot return -ERESTARTSYS
after you've made non-idempotent changes.  ocfs2 has run into this with
open(O_CREAT|O_EXCL).  Once you've created the file, you can't restart
the open(), because O_CREAT|O_EXCL will trigger -EEXIST.

The problem is that ocfs2 is catching the signal ->permission(), called
by may_open().  This happens after ->create() has successfully created
the file.  ocfs2_permission() has to get a cluster lock, and this is
what can be interrupted by a signal.  Now, obviously we want to block
signals in the O_CREAT|O_EXCL case, but ocfs2_permission() has no way of
knowing it just got called from open_namei_create().

So we add the MAY_CREATE flag to permission().  open_namei_create() will
pass it to may_open(), and then ocfs2 can block signals in
ocfs2_permission() as appropriate.  The same is true of any other
filesystem that has to do work in may_open().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/namei.c         |    2 +-
 include/linux/fs.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d11f404..d54cb98 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1623,7 +1623,7 @@ out_unlock:
 	if (error)
 		return error;
 	/* Don't check for write permission, don't truncate */
-	return may_open(&nd->path, 0, flag & ~O_TRUNC);
+	return may_open(&nd->path, MAY_CREATE, flag & ~O_TRUNC);
 }
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..b1a454c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -53,6 +53,7 @@ struct inodes_stat_t {
 #define MAY_APPEND 8
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
+#define MAY_CREATE 64
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
1.6.3.3

