Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbXA2Trw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbXA2Trw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXA2Trw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:47:52 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:43377 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbXA2Trv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:47:51 -0500
To: torvalds@osdl.org
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fuse: fix bug in control filesystem mount
Message-Id: <E1HBcTU-0002JB-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 29 Jan 2007 20:47:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please apply before 2.6.20.  Thanks.


The BUG in fuse_ctl_add_dentry() could be triggered if the control
filesystem was unmounted and mounted again while one or more fuse
filesystems were present.

The fix is to reset the dentry counter in fuse_ctl_kill_sb().

Bug reported by Florent Mertens.

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>

---
Index: linux/fs/fuse/control.c
===================================================================
--- linux.orig/fs/fuse/control.c	2007-01-29 20:40:50.000000000 +0100
+++ linux/fs/fuse/control.c	2007-01-29 20:40:52.000000000 +0100
@@ -193,8 +193,12 @@ static int fuse_ctl_get_sb(struct file_s
 
 static void fuse_ctl_kill_sb(struct super_block *sb)
 {
+	struct fuse_conn *fc;
+
 	mutex_lock(&fuse_mutex);
 	fuse_control_sb = NULL;
+	list_for_each_entry(fc, &fuse_conn_list, entry)
+		fc->ctl_ndents = 0;
 	mutex_unlock(&fuse_mutex);
 
 	kill_litter_super(sb);
