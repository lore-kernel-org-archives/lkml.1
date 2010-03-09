Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0CIQNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:13:08 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:60601 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab0CIQNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:13:07 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bernd Schmidt <bernds_cb1@t-online.de>
Subject: [PATCH] NOMMU: allow private mappings of read-only devices
Date: Tue,  9 Mar 2010 11:16:22 -0500
Message-Id: <1268151382-28469-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernds_cb1@t-online.de>

Slightly rearrange the logic that determines capabilities and vm_flags.
Disable BDI_CAP_MAP_DIRECT in all cases if the device can't support the
protections.  Allow private readonly mappings of readonly backing devices.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 mm/nommu.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 61a68d5..5767237 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -930,14 +930,6 @@ static int validate_mmap_request(struct file *file,
 			if (!(capabilities & BDI_CAP_MAP_DIRECT))
 				return -ENODEV;
 
-			if (((prot & PROT_READ)  && !(capabilities & BDI_CAP_READ_MAP))  ||
-			    ((prot & PROT_WRITE) && !(capabilities & BDI_CAP_WRITE_MAP)) ||
-			    ((prot & PROT_EXEC)  && !(capabilities & BDI_CAP_EXEC_MAP))
-			    ) {
-				printk("MAP_SHARED not completely supported on !MMU\n");
-				return -EINVAL;
-			}
-
 			/* we mustn't privatise shared mappings */
 			capabilities &= ~BDI_CAP_MAP_COPY;
 		}
@@ -953,6 +945,20 @@ static int validate_mmap_request(struct file *file,
 				capabilities &= ~BDI_CAP_MAP_DIRECT;
 		}
 
+		if (capabilities & BDI_CAP_MAP_DIRECT) {
+			if (((prot & PROT_READ)  && !(capabilities & BDI_CAP_READ_MAP))  ||
+			    ((prot & PROT_WRITE) && !(capabilities & BDI_CAP_WRITE_MAP)) ||
+			    ((prot & PROT_EXEC)  && !(capabilities & BDI_CAP_EXEC_MAP))
+			    ) {
+				capabilities &= ~BDI_CAP_MAP_DIRECT;
+				if (flags & MAP_SHARED) {
+					printk(KERN_WARNING
+					       "MAP_SHARED not completely supported on !MMU\n");
+					return -EINVAL;
+				}
+			}
+		}
+
 		/* handle executable mappings and implied executable
 		 * mappings */
 		if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
@@ -1008,22 +1014,20 @@ static unsigned long determine_vm_flags(struct file *file,
 	unsigned long vm_flags;
 
 	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
-	vm_flags |= VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 	/* vm_flags |= mm->def_flags; */
 
 	if (!(capabilities & BDI_CAP_MAP_DIRECT)) {
 		/* attempt to share read-only copies of mapped file chunks */
+		vm_flags |= VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 		if (file && !(prot & PROT_WRITE))
 			vm_flags |= VM_MAYSHARE;
-	}
-	else {
+	} else {
 		/* overlay a shareable mapping on the backing device or inode
 		 * if possible - used for chardevs, ramfs/tmpfs/shmfs and
 		 * romfs/cramfs */
+		vm_flags |= VM_MAYSHARE | (capabilities & BDI_CAP_VMFLAGS);
 		if (flags & MAP_SHARED)
-			vm_flags |= VM_MAYSHARE | VM_SHARED;
-		else if ((((vm_flags & capabilities) ^ vm_flags) & BDI_CAP_VMFLAGS) == 0)
-			vm_flags |= VM_MAYSHARE;
+			vm_flags |= VM_SHARED;
 	}
 
 	/* refuse to let anyone share private mappings with this process if
-- 
1.7.0.2

