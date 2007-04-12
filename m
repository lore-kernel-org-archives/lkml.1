Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXDLRAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXDLRAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030417AbXDLRAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:00:43 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:55511 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030405AbXDLRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:00:42 -0400
Message-Id: <20070412164620.588752236@szeredi.hu>
References: <20070412164541.580374744@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 12 Apr 2007 18:45:46 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 05/10] add "permit user mounts in new namespace" clone flag
Content-Disposition: inline; filename=mm-clone_allow_usermnt.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If CLONE_NEWNS and CLONE_NEWNS_USERMNT are given to clone(2) or
unshare(2), then allow user mounts within the new namespace.

This is not flexible enough, because user mounts can't be enabled for
the initial namespace.

The remaining clone bits also getting dangerously few...

Alternatives are:

  - prctl() flag
  - setting through the containers filesystem

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2007-04-12 13:46:19.000000000 +0200
+++ linux/fs/namespace.c	2007-04-12 13:54:36.000000000 +0200
@@ -1617,6 +1617,8 @@ struct mnt_namespace *copy_mnt_ns(int fl
 		return ns;
 
 	new_ns = dup_mnt_ns(ns, new_fs);
+	if (new_ns && (flags & CLONE_NEWNS_USERMNT))
+		new_ns->flags |= MNT_NS_PERMIT_USERMOUNTS;
 
 	put_mnt_ns(ns);
 	return new_ns;
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h	2007-04-12 13:26:48.000000000 +0200
+++ linux/include/linux/sched.h	2007-04-12 13:54:36.000000000 +0200
@@ -26,6 +26,7 @@
 #define CLONE_STOPPED		0x02000000	/* Start in stopped state */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
+#define CLONE_NEWNS_USERMNT	0x10000000	/* Allow user mounts in ns? */
 
 /*
  * Scheduling policies
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c	2007-04-11 18:27:46.000000000 +0200
+++ linux/kernel/fork.c	2007-04-12 13:59:10.000000000 +0200
@@ -1586,7 +1586,7 @@ asmlinkage long sys_unshare(unsigned lon
 	err = -EINVAL;
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
-				CLONE_NEWUTS|CLONE_NEWIPC))
+				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNS_USERMNT))
 		goto bad_unshare_out;
 
 	if ((err = unshare_thread(unshare_flags)))

--
