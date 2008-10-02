Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYJBWew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYJBWew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYJBWem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:34:42 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:59906 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752788AbYJBWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:34:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=qwqW7CfFOu4DGDCplKidvO84A/Kksp1Xahj96ZjEaxb3Jw8Fy7KO0MiTsZbfB5vHrJiYmY0UQwJpWp2V/YK984p4kOQtE7LtoDEF7v3wcu2kT4kDqImewRF5ISR3Ve5e;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] check mapped ranges on sysfs resource files (for 2.6.27)
Date: Thu, 2 Oct 2008 15:34:37 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021534.38219.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending a patch rather than a pull request since it's just this.
Totally up to you (obviously) whether we stuff this into 2.6.27 or hold
off on it until 2.6.28.

It's fairly common for applications to map PCI resources through sysfs.
However, with the current implementation, it's possible for an application
to map far more than the range corresponding to the resourceN file it
opened.  This patch plugs that hole by checking the range at mmap time,
similar to what is done on platforms like sparc64 in their lower level
PCI remapping routines.

It was initially put together to help debug the e1000e NVRAM corruption
problem, since we initially thought an X driver might be walking past the
end of one of its mappings and clobbering the NVRAM.  It now looks like
that's not the case, but doing the check is still important for obvious
reasons.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>


diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c71858..4d1aa6e 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -16,6 +16,7 @@
 
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/stat.h>
 #include <linux/topology.h>
@@ -502,6 +503,8 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	struct resource *res = (struct resource *)attr->private;
 	enum pci_mmap_state mmap_type;
 	resource_size_t start, end;
+	unsigned long map_len = vma->vm_end - vma->vm_start;
+	unsigned long map_offset = vma->vm_pgoff << PAGE_SHIFT;
 	int i;
 
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
@@ -510,6 +513,17 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
+	/*
+	 * Make sure the range the user is trying to map falls within
+	 * the resource
+	 */
+	if (map_offset + map_len > pci_resource_len(pdev, i)) {
+		WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on BAR %d (size 0x%08lx)\n",
+		     current->comm, map_offset, map_offset + map_len, i,
+		     (unsigned long)pci_resource_len(pdev, i));
+		return -EINVAL;
+	}
+
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is
 	 * different from the resource itself, arch will do necessary fixup.
