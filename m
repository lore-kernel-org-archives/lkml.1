Return-Path: <linux-kernel-owner+w=401wt.eu-S935088AbZLKXiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935088AbZLKXiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934827AbZLKXgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:47 -0500
Received: from kroah.org ([198.145.64.141]:50447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933860AbZLKX3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:07 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/58] devpts_get_tty() should validate inode
Date: Fri, 11 Dec 2009 15:28:08 -0800
Message-Id: <1260574122-10676-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

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
Tested-by: Serge Hallyn <serue@us.ibm.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/devpts/inode.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index d5f8c96..8882ecc 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -517,11 +517,23 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 
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
-- 
1.6.5.5

