Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZKRCfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZKRCfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 21:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZKRCfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 21:35:23 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47352 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZKRCfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 21:35:22 -0500
Date: Tue, 17 Nov 2009 18:35:43 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, root@localdomain.pl,
       sukadev@linux.vnet.ibm.com,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] devpts_get_tty() should validate inode
Message-ID: <20091118023541.GA14430@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


devpts_get_tty() assumes that the inode passed in is associated with a valid
pty.  But if the only reference to the pty is via a bind-mount, the inode
passed to devpts_get_tty() while valid, would refer to a pty that no longer
exists.

With a lot of debug effort, Grzegorz Nosek developed a small program (see
below) to reproduce a crash on recent kernels. This crash is a regression
introduced by the commit:

	commit 527b3e4773628b30d03323a2cb5fb0d84441990f
	Author: Sukadev Bhattiprolu <sukadev@us.ibm.com>
	Date:   Mon Oct 13 10:43:08 2008 +0100

To fix, ensure that the dentry associated with the inode has not yet been
deleted/unhashed by devpts_pty_kill().

See also:
https://lists.linux-foundation.org/pipermail/containers/2009-July/019273.html 

tty-bug.c:

#define _GNU_SOURCE
#include <fcntl.h>
#include <sched.h>
#include <stdlib.h>
#include <sys/mount.h>
#include <sys/signal.h>
#include <unistd.h>
#include <stdio.h>

#include <linux/fs.h>

void dummy(int sig)
{
}

static int child(void *unused)
{
	int fd;

	signal(SIGINT, dummy); signal(SIGHUP, dummy);
	pause(); /* cheesy synchronisation to wait for /dev/pts/0 to appear */

	mount("/dev/pts/0", "/dev/console", NULL, MS_BIND, NULL);
	sleep(2);

	fd = open("/dev/console", O_RDWR);
	dup(0); dup(0);
	write(1, "Hello world!\n", sizeof("Hello world!\n")-1);
	return 0;
}

int main(void)
{
	pid_t pid;
	char *stack;

	stack = malloc(16384);
	pid = clone(child, stack+16384, CLONE_NEWNS|SIGCHLD, NULL);

	open("/dev/ptmx", O_RDWR|O_NOCTTY|O_NONBLOCK);

	unlockpt(fd); grantpt(fd);

	sleep(2);
	kill(pid, SIGHUP);
	sleep(1);
	return 0; /* exit before child opens /dev/console */
}

Reported-by: Grzegorz Nosek <root@localdomain.pl>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Index: linux-2.6/fs/devpts/inode.c
===================================================================
--- linux-2.6.orig/fs/devpts/inode.c	2009-10-20 21:11:03.000000000 -0700
+++ linux-2.6/fs/devpts/inode.c	2009-11-17 16:07:16.000000000 -0800
@@ -517,11 +517,23 @@
 
 struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number)
 {
+	struct dentry *dentry;
+	struct tty_struct *tty;
+
 	BUG_ON(pts_inode->i_rdev == MKDEV(TTYAUX_MAJOR, PTMX_MINOR));
 
+	/* Ensure dentry has not been deleted by devpts_pty_kill() */
+	dentry = d_find_alias(pts_inode);
+	if (!dentry)
+		return NULL;
+
+	tty = NULL;
 	if (pts_inode->i_sb->s_magic == DEVPTS_SUPER_MAGIC)
-		return (struct tty_struct *)pts_inode->i_private;
-	return NULL;
+		tty = (struct tty_struct *)pts_inode->i_private;
+
+	dput(dentry);
+
+	return tty;
 }
 
 void devpts_pty_kill(struct tty_struct *tty)
