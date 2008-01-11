Return-Path: <linux-kernel-owner+w=401wt.eu-S1759062AbYAKDcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062AbYAKDcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbYAKDcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:32:39 -0500
Received: from opcao.uece.br ([200.129.22.45]:51437 "EHLO opcao.uece.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190AbYAKDci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:32:38 -0500
Message-ID: <4786E1CE.4080404@uece.br>
Date: Fri, 11 Jan 2008 00:26:06 -0300
From: Sergio Luis <sergio@uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
CC: kernel-janitors@vger.kernel.org
Subject: [PATCH 1/1] PCI: change procfs interface to use unlocked_ioctl instead
 of ioctl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change drivers/pci/proc.c to use the unlocked_ioctl handler instead of
the ioctl one.

Signed-off-by: Sergio Luis <sergio@uece.br>

 proc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)


diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 716439e..8ac5880 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -12,6 +12,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/capability.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 #include "pci.h"
@@ -202,15 +203,17 @@ struct pci_filp_private {
     int write_combine;
 };
 
-static int proc_bus_pci_ioctl(struct inode *inode, struct file *file, 
unsigned int cmd, unsigned long arg)
+static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd, 
unsigned long arg)
 {
+    struct inode *inode = file->f_path.dentry->d_inode;
     const struct proc_dir_entry *dp = PDE(inode);
     struct pci_dev *dev = dp->data;
 #ifdef HAVE_PCI_MMAP
     struct pci_filp_private *fpriv = file->private_data;
 #endif /* HAVE_PCI_MMAP */
-    int ret = 0;
+    long ret = 0;
 
+    lock_kernel();
     switch (cmd) {
     case PCIIOC_CONTROLLER:
         ret = pci_domain_nr(dev->bus);
@@ -239,6 +242,7 @@ static int proc_bus_pci_ioctl(struct inode *inode, 
struct file *file, unsigned i
         break;
     };
 
+    unlock_kernel();
     return ret;
 }
 
@@ -291,7 +295,7 @@ static const struct file_operations 
proc_bus_pci_operations = {
     .llseek        = proc_bus_pci_lseek,
     .read        = proc_bus_pci_read,
     .write        = proc_bus_pci_write,
-    .ioctl        = proc_bus_pci_ioctl,
+    .unlocked_ioctl    = proc_bus_pci_ioctl,
 #ifdef HAVE_PCI_MMAP
     .open        = proc_bus_pci_open,
     .release    = proc_bus_pci_release,


