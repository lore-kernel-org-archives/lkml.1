Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab0CAJil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:38:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41948 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab0CAJii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:38:38 -0500
Date: Mon, 1 Mar 2010 20:38:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100301203836.5148090b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/pci/pci-sysfs.c: In function 'pci_create_legacy_files':
drivers/pci/pci-sysfs.c:645: error: lvalue required as unary '&' operand
drivers/pci/pci-sysfs.c:658: error: lvalue required as unary '&' operand

Caused by commit 8e36e9ee3c5a9228b68717b35101c58fe9a001c5 ("sysfs: Use
sysfs_attr_init and sysfs_bin_attr_init on dynamic attributes")
interacting with commit 71f496c9ec9821d2e09b00298915b99b6cbc9d92 ("sysfs:
Use one lockdep class per sysfs attribute") both from the driver-core
tree.

I applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Mar 2010 19:41:15 +1100
Subject: [PATCH] sysfs: fix for thinko with sysfs_bin_attr_init()

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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
1.7.0

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
