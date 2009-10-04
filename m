Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZJDMxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZJDMxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZJDMxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:53:31 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60092 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZJDMxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:53:31 -0400
Message-Id: <20091004125327.997524942@I-love.SAKURA.ne.jp>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sun, 04 Oct 2009 21:49:49 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #16 03/25] LSM: Pass original mount flags to security_sb_mount().
Content-Disposition: inline; filename=lsm-pass-original-mount-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows LSM modules to determine based on original mount flags
passed to mount(). A LSM module can get masked mount flags (if needed) by

	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
		   MS_STRICTATIME);

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/namespace.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- security-testing-2.6.orig/fs/namespace.c
+++ security-testing-2.6/fs/namespace.c
@@ -1921,6 +1921,16 @@ long do_mount(char *dev_name, char *dir_
 	if (data_page)
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
+	/* ... and get the mountpoint */
+	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
+	if (retval)
+		return retval;
+
+	retval = security_sb_mount(dev_name, &path,
+				   type_page, flags, data_page);
+	if (retval)
+		goto dput_out;
+
 	/* Default to relatime unless overriden */
 	if (!(flags & MS_NOATIME))
 		mnt_flags |= MNT_RELATIME;
@@ -1945,16 +1955,6 @@ long do_mount(char *dev_name, char *dir_
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
 		   MS_STRICTATIME);
 
-	/* ... and get the mountpoint */
-	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
-	if (retval)
-		return retval;
-
-	retval = security_sb_mount(dev_name, &path,
-				   type_page, flags, data_page);
-	if (retval)
-		goto dput_out;
-
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);

-- 
