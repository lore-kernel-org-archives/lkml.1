Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650Ab0AEUd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0AEUd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374Ab0AEUdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:33:55 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:48120 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0AEUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:33:54 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] check for NULL pointer dereference in btrfs_set_acl
Date: Tue, 5 Jan 2010 21:33:47 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc2-00302-gc5974b8-dirty; KDE/4.3.85; x86_64; ; )
MIME-Version: 1.0
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001052133.48355.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for for NULL pointer in btrfs_set_acl and omit calling 
posix_acl_equiv_mode in this case to avoid NULL pointer dereference there. 

Signed-off-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2e9e699..3a3a96d 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -111,13 +111,15 @@ static int btrfs_set_acl(struct btrfs_trans_handle 
*trans,

        switch (type) {
        case ACL_TYPE_ACCESS:
-               mode = inode->i_mode;
-               ret = posix_acl_equiv_mode(acl, &mode);
-               if (ret < 0)
-                       return ret;
-               ret = 0;
-               inode->i_mode = mode;
                name = POSIX_ACL_XATTR_ACCESS;
+               if (acl) {
+                       mode = inode->i_mode;
+                       ret = posix_acl_equiv_mode(acl, &mode);
+                       if (ret < 0)
+                               return ret;
+                       ret = 0;
+                       inode->i_mode = mode;
+               }
                break;
        case ACL_TYPE_DEFAULT:
                if (!S_ISDIR(inode->i_mode))
