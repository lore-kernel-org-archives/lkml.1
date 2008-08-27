Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYH0NtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYH0NtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYH0Nre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:47:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbYH0Nrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:47:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/59] CRED: Wrap task credential accesses in the USB driver
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org
Date: Wed, 27 Aug 2008 14:46:49 +0100
Message-ID: <20080827134649.19980.36926.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
---

 drivers/usb/core/devio.c |    8 ++++----
 drivers/usb/core/inode.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index c1018e7..c84dfdc 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -617,8 +617,8 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	init_waitqueue_head(&ps->wait);
 	ps->discsignr = 0;
 	ps->disc_pid = get_pid(task_pid(current));
-	ps->disc_uid = current->uid;
-	ps->disc_euid = current->euid;
+	ps->disc_uid = current_uid();
+	ps->disc_euid = current_euid();
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
 	security_task_getsecid(current, &ps->secid);
@@ -1172,8 +1172,8 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	as->signr = uurb->signr;
 	as->ifnum = ifnum;
 	as->pid = get_pid(task_pid(current));
-	as->uid = current->uid;
-	as->euid = current->euid;
+	as->uid = current_uid();
+	as->euid = current_euid();
 	security_task_getsecid(current, &as->secid);
 	if (!is_in) {
 		if (copy_from_user(as->urb->transfer_buffer, uurb->buffer,
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 736508e..c62e48b 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -277,8 +277,8 @@ static struct inode *usbfs_get_inode (struct super_block *sb, int mode, dev_t de
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {

