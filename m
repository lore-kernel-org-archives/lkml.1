Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0CBX36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:58 -0500
Received: from kroah.org ([198.145.64.141]:38756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0CBX3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 62/62] sysfs: fix for thinko with sysfs_bin_attr_init()
Date: Tue,  2 Mar 2010 15:29:01 -0800
Message-Id: <1267572541-410-62-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/pci/pci-sysfs.c: In function 'pci_create_legacy_files':
drivers/pci/pci-sysfs.c:645: error: lvalue required as unary '&' operand
drivers/pci/pci-sysfs.c:658: error: lvalue required as unary '&' operand

Caused by commit "sysfs: Use sysfs_attr_init and sysfs_bin_attr_init on
dynamic attributes" interacting with commit "sysfs: Use one lockdep
class per sysfs attribute") both from the driver-core tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pci-sysfs.c |    4 ++--
 include/linux/sysfs.h   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9fa183c..de29645 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -642,7 +642,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 	if (!b->legacy_io)
 		goto kzalloc_err;
 
-	sysfs_bin_attr_init(&b->legacy_io);
+	sysfs_bin_attr_init(b->legacy_io);
 	b->legacy_io->attr.name = "legacy_io";
 	b->legacy_io->size = 0xffff;
 	b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
@@ -655,7 +655,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 		goto legacy_io_err;
 
 	/* Allocated above after the legacy_io struct */
-	sysfs_bin_attr_init(&b->legacy_mem);
+	sysfs_bin_attr_init(b->legacy_mem);
 	b->legacy_mem = b->legacy_io + 1;
 	b->legacy_mem->attr.name = "legacy_mem";
 	b->legacy_mem->size = 1024*1024;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index d77cde6..f0496b3 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -110,7 +110,7 @@ struct bin_attribute {
  *	enabled.  Lockdep gives a nice error when your attribute is
  *	added to sysfs if you don't have this.
  */
-#define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&bin_attr->attr)
+#define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&(bin_attr)->attr)
 
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
-- 
1.7.0.1

