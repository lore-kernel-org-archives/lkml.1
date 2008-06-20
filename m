Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYFTP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYFTP5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbYFTP40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:56:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:56874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845AbYFTP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:56:24 -0400
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 1/3] Introduce /proc/firmware_mem
Date: Fri, 20 Jun 2008 17:56:58 +0200
Message-Id: <1213977420-1555-2-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213977420-1555-1-git-send-email-bwalle@suse.de>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/iomem contains mostly the view of the system about the memory resources.
However, when using kexec, it's necessary to get also the firmware view, i.e.
the original memory map the kernel got passed before applying command line
options like exactmap or mem=<value>. kexec needs both views:

 a) When another kernel is booted, then the firmware view is needed. If you
    boot your original kernel with mem=3G, then you don't necessarily expect
    thew kexec'd kernel also to have a limited amount of memory.

 b) When the ELF core headers for kernel dumps are generated, kexec needs the
    kernel view about memory resources because it doesn't make sense to dump
    memory that never has been used.

The patch only creates the interface and the resource tree. It has to be filled
by architecture code.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 include/linux/ioport.h |    1 +
 kernel/resource.c      |   39 +++++++++++++++++++++++++++++++--------
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index c6801bf..4af561a 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -100,6 +100,7 @@ struct resource_list {
 /* PC/ISA/whatever - the normal PC address spaces: IO and memory */
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
+extern struct resource firmware_mem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
diff --git a/kernel/resource.c b/kernel/resource.c
index 74af2d7..dee58a7 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -36,6 +36,15 @@ struct resource iomem_resource = {
 };
 EXPORT_SYMBOL(iomem_resource);
 
+struct resource firmware_mem_resource = {
+	.name	= "Firmware memory map",
+	.start	= 0,
+	.end	= -1,
+	.flags	= IORESOURCE_MEM,
+};
+EXPORT_SYMBOL(firmware_mem_resource);
+
+
 static DEFINE_RWLOCK(resource_lock);
 
 #ifdef CONFIG_PROC_FS
@@ -95,24 +104,30 @@ static const struct seq_operations resource_op = {
 	.show	= r_show,
 };
 
-static int ioports_open(struct inode *inode, struct file *file)
+static int resource_open(struct inode *inode, struct file *file,
+	                 struct resource *resource)
 {
 	int res = seq_open(file, &resource_op);
 	if (!res) {
 		struct seq_file *m = file->private_data;
-		m->private = &ioport_resource;
+		m->private = resource;
 	}
 	return res;
 }
 
+static int ioports_open(struct inode *inode, struct file *file)
+{
+	return resource_open(inode, file, &ioport_resource);
+}
+
 static int iomem_open(struct inode *inode, struct file *file)
 {
-	int res = seq_open(file, &resource_op);
-	if (!res) {
-		struct seq_file *m = file->private_data;
-		m->private = &iomem_resource;
-	}
-	return res;
+	return resource_open(inode, file, &iomem_resource);
+}
+
+static int firmware_mem_open(struct inode *inode, struct file *file)
+{
+	return resource_open(inode, file, &firmware_mem_resource);
 }
 
 static const struct file_operations proc_ioports_operations = {
@@ -129,10 +144,18 @@ static const struct file_operations proc_iomem_operations = {
 	.release	= seq_release,
 };
 
+static const struct file_operations proc_firmware_mem_operations = {
+	.open		= firmware_mem_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init ioresources_init(void)
 {
 	proc_create("ioports", 0, NULL, &proc_ioports_operations);
 	proc_create("iomem", 0, NULL, &proc_iomem_operations);
+	proc_create("firmware_mem", 0, NULL, &proc_firmware_mem_operations);
 	return 0;
 }
 __initcall(ioresources_init);
-- 
1.5.4.5

