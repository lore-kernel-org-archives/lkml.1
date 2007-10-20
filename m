Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbXJUByV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbXJUByV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXJUBwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:52:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56842 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXJUBw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:52:27 -0400
Date: Sun, 21 Oct 2007 01:52:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/4] MultiAdmin 1.0.7
In-Reply-To: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710210152210.1997@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 2/4] Use of capable_light()

capable() now behaves like (capable_light() && is_superadm). Since some
operations are allowed by subadmins too, it suffices to use
capable_light().


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, May 01 2006
Modified July 11 2006

---
 arch/alpha/kernel/pci-noop.c |    2 +-
 drivers/char/lp.c            |    2 +-
 drivers/firmware/efivars.c   |    2 +-
 drivers/pci/pci-sysfs.c      |    2 +-
 drivers/pci/proc.c           |    2 +-
 drivers/pci/syscall.c        |    2 +-
 fs/quota.c                   |    8 ++++----
 ipc/msg.c                    |    2 +-
 ipc/sem.c                    |    2 +-
 ipc/shm.c                    |    4 ++--
 10 files changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6.23.1/arch/alpha/kernel/pci-noop.c
===================================================================
--- linux-2.6.23.1.orig/arch/alpha/kernel/pci-noop.c
+++ linux-2.6.23.1/arch/alpha/kernel/pci-noop.c
@@ -89,7 +89,7 @@ asmlinkage long
 sys_pciconfig_read(unsigned long bus, unsigned long dfn,
 		   unsigned long off, unsigned long len, void *buf)
 {
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_light(CAP_SYS_ADMIN))
 		return -EPERM;
 	else
 		return -ENODEV;
Index: linux-2.6.23.1/drivers/char/lp.c
===================================================================
--- linux-2.6.23.1.orig/drivers/char/lp.c
+++ linux-2.6.23.1/drivers/char/lp.c
@@ -627,7 +627,7 @@ static int lp_ioctl(struct inode *inode,
 			if (copy_to_user(argp, &LP_STAT(minor),
 					sizeof(struct lp_stats)))
 				return -EFAULT;
-			if (capable(CAP_SYS_ADMIN))
+			if (capable_light(CAP_SYS_ADMIN))
 				memset(&LP_STAT(minor), 0,
 						sizeof(struct lp_stats));
 			break;
Index: linux-2.6.23.1/drivers/firmware/efivars.c
===================================================================
--- linux-2.6.23.1.orig/drivers/firmware/efivars.c
+++ linux-2.6.23.1/drivers/firmware/efivars.c
@@ -351,7 +351,7 @@ static ssize_t efivar_attr_show(struct k
 	struct efivar_attribute *efivar_attr = to_efivar_attr(attr);
 	ssize_t ret = -EIO;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_light(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	if (efivar_attr->show) {
Index: linux-2.6.23.1/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.23.1.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6.23.1/drivers/pci/pci-sysfs.c
@@ -222,7 +222,7 @@ pci_read_config(struct kobject *kobj, st
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (capable(CAP_SYS_ADMIN)) {
+	if (capable_light(CAP_SYS_ADMIN)) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
Index: linux-2.6.23.1/drivers/pci/proc.c
===================================================================
--- linux-2.6.23.1.orig/drivers/pci/proc.c
+++ linux-2.6.23.1/drivers/pci/proc.c
@@ -59,7 +59,7 @@ proc_bus_pci_read(struct file *file, cha
 	 * undefined locations (think of Intel PIIX4 as a typical example).
 	 */
 
-	if (capable(CAP_SYS_ADMIN))
+	if (capable_light(CAP_SYS_ADMIN))
 		size = dev->cfg_size;
 	else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 		size = 128;
Index: linux-2.6.23.1/drivers/pci/syscall.c
===================================================================
--- linux-2.6.23.1.orig/drivers/pci/syscall.c
+++ linux-2.6.23.1/drivers/pci/syscall.c
@@ -26,7 +26,7 @@ sys_pciconfig_read(unsigned long bus, un
 	long err;
 	long cfg_ret;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_light(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	err = -ENODEV;
Index: linux-2.6.23.1/fs/quota.c
===================================================================
--- linux-2.6.23.1.orig/fs/quota.c
+++ linux-2.6.23.1/fs/quota.c
@@ -82,11 +82,11 @@ static int generic_quotactl_valid(struct
 	if (cmd == Q_GETQUOTA) {
 		if (((type == USRQUOTA && current->euid != id) ||
 		     (type == GRPQUOTA && !in_egroup_p(id))) &&
-		    !capable(CAP_SYS_ADMIN))
+		    !capable_light(CAP_SYS_ADMIN))
 			return -EPERM;
 	}
 	else if (cmd != Q_GETFMT && cmd != Q_SYNC && cmd != Q_GETINFO)
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable_light(CAP_SYS_ADMIN))
 			return -EPERM;
 
 	return 0;
@@ -133,10 +133,10 @@ static int xqm_quotactl_valid(struct sup
 	if (cmd == Q_XGETQUOTA) {
 		if (((type == XQM_USRQUOTA && current->euid != id) ||
 		     (type == XQM_GRPQUOTA && !in_egroup_p(id))) &&
-		     !capable(CAP_SYS_ADMIN))
+		     !capable_light(CAP_SYS_ADMIN))
 			return -EPERM;
 	} else if (cmd != Q_XGETQSTAT && cmd != Q_XQUOTASYNC) {
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable_light(CAP_SYS_ADMIN))
 			return -EPERM;
 	}
 
Index: linux-2.6.23.1/ipc/msg.c
===================================================================
--- linux-2.6.23.1.orig/ipc/msg.c
+++ linux-2.6.23.1/ipc/msg.c
@@ -518,7 +518,7 @@ asmlinkage long sys_msgctl(int msqid, in
 
 	err = -EPERM;
 	if (current->euid != ipcp->cuid &&
-	    current->euid != ipcp->uid && !capable(CAP_SYS_ADMIN))
+	    current->euid != ipcp->uid && !capable_light(CAP_SYS_ADMIN))
 		/* We _could_ check for CAP_CHOWN above, but we don't */
 		goto out_unlock_up;
 
Index: linux-2.6.23.1/ipc/sem.c
===================================================================
--- linux-2.6.23.1.orig/ipc/sem.c
+++ linux-2.6.23.1/ipc/sem.c
@@ -883,7 +883,7 @@ static int semctl_down(struct ipc_namesp
 			goto out_unlock;
 	}
 	if (current->euid != ipcp->cuid && 
-	    current->euid != ipcp->uid && !capable(CAP_SYS_ADMIN)) {
+	    current->euid != ipcp->uid && !capable_light(CAP_SYS_ADMIN)) {
 	    	err=-EPERM;
 		goto out_unlock;
 	}
Index: linux-2.6.23.1/ipc/shm.c
===================================================================
--- linux-2.6.23.1.orig/ipc/shm.c
+++ linux-2.6.23.1/ipc/shm.c
@@ -756,7 +756,7 @@ asmlinkage long sys_shmctl (int shmid, i
 
 		if (current->euid != shp->shm_perm.uid &&
 		    current->euid != shp->shm_perm.cuid && 
-		    !capable(CAP_SYS_ADMIN)) {
+		    !capable_light(CAP_SYS_ADMIN)) {
 			err=-EPERM;
 			goto out_unlock_up;
 		}
@@ -793,7 +793,7 @@ asmlinkage long sys_shmctl (int shmid, i
 		err=-EPERM;
 		if (current->euid != shp->shm_perm.uid &&
 		    current->euid != shp->shm_perm.cuid && 
-		    !capable(CAP_SYS_ADMIN)) {
+		    !capable_light(CAP_SYS_ADMIN)) {
 			goto out_unlock_up;
 		}
 
