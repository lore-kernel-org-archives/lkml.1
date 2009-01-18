Return-Path: <linux-kernel-owner+w=401wt.eu-S1762366AbZARHhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762366AbZARHhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 02:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZARHhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 02:37:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55696 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbZARHhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:37:04 -0500
Date: Sun, 18 Jan 2009 08:34:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com, raven@themaw.net
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090118073441.GA699@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_options(&pgid) sets pgid = task_pgrp_nr() which uses the global
namespace. This is wrong, we use this pgid to find "struct pid" in the
current's namespace. Change parse_options() to use task_pgrp_vnr().

Also do s/task_pgrp_nr/task_pgrp_vnr/ in the debugging printks.
checkpatch.pl complains about "line over 80 characters", but it should
blame the cuurent code, not the patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/fs/autofs/inode.c~1_AUTOFS	2009-01-12 23:07:46.000000000 +0100
+++ CUR/fs/autofs/inode.c	2009-01-18 06:18:49.000000000 +0100
@@ -78,7 +78,7 @@ static int parse_options(char *options, 
 
 	*uid = current_uid();
 	*gid = current_gid();
-	*pgrp = task_pgrp_nr(current);
+	*pgrp = task_pgrp_vnr(current);
 
 	*minproto = *maxproto = AUTOFS_PROTO_VERSION;
 
--- CUR/fs/autofs/root.c~1_AUTOFS	2008-10-10 00:13:53.000000000 +0200
+++ CUR/fs/autofs/root.c	2009-01-18 06:15:42.000000000 +0100
@@ -215,7 +215,7 @@ static struct dentry *autofs_root_lookup
 	oz_mode = autofs_oz_mode(sbi);
 	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
 				"oz_mode = %d\n", task_pid_nr(current),
-				task_pgrp_nr(current), sbi->catatonic,
+				task_pgrp_vnr(current), sbi->catatonic,
 				oz_mode));
 
 	/*
@@ -550,7 +550,8 @@ static int autofs_root_ioctl(struct inod
 	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
 	void __user *argp = (void __user *)arg;
 
-	DPRINTK(("autofs_ioctl: cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",cmd,arg,sbi,task_pgrp_nr(current)));
+	DPRINTK(("autofs_ioctl: cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",
+		cmd, arg, sbi, task_pgrp_vnr(current)));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)

