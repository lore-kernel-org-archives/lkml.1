Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZGWRdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZGWRdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZGWRdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:33:17 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:36193 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZGWRdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=MGFIuUSUD95ImeK3CHmp6dfFC2Qjvu5Z6MtHcIK1rjpbl2L2Q51sczK5Lr9CYSqRNQ
         UC1j/dr2jSR5sNAF7W2+BlzuZENrtBcITWYd74k+FoU064+78PtAkYNmpcU+dSdBpodc
         ew1BL8tXBDoM9lOEknTDu3ct9+pdbZTx2Ohw0=
MIME-Version: 1.0
Date: Thu, 23 Jul 2009 11:33:14 -0600
X-Google-Sender-Auth: 6427f4db6302fdea
Message-ID: <f158dc670907231033o32db6b07ib923c831461383b0@mail.gmail.com>
Subject: [PATCH] 9p: reset the stat buffer offset after each read
From: Latchesar Ionkov <lucho@ionkov.net>
To: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stat buffer offset variable (i) is set to zero at the beginning of
the v9fs_dir_readdir function. It should be reset to 0 each time data
is read from the file server.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 873cd31..9b0525f 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -74,7 +74,7 @@ static int v9fs_dir_readdir(struct file *filp, void
*dirent, filldir_t filldir)
 	struct p9_fid *fid;
 	int buflen;
 	char *statbuf;
-	int n, i = 0;
+	int n, i;

 	P9_DPRINTK(P9_DEBUG_VFS, "name %s\n", filp->f_path.dentry->d_name.name);
 	fid = filp->private_data;
@@ -90,6 +90,7 @@ static int v9fs_dir_readdir(struct file *filp, void
*dirent, filldir_t filldir)
 		if (err <= 0)
 			break;

+		i = 0;
 		n = err;
 		while (i < n) {
 			err = p9stat_read(statbuf + i, buflen-i, &st,
