Return-Path: <linux-kernel-owner+w=401wt.eu-S1751170AbZKYFzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbZKYFzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 00:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZKYFzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 00:55:03 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58580 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZKYFzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 00:55:02 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
Date: Wed, 25 Nov 2009 00:55:03 -0500
Message-Id: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

The mmu code uses the copy_*_user_page() variants in access_process_vm()
rather than copy_*_user() as the former includes an icache flush.  This is
important when doing things like setting software breakpoints with gdb.
So switch the nommu code over to do the same.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 mm/nommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 9876fa0..51ae9be 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1889,9 +1889,11 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 
 		/* only read or write mappings where it is permitted */
 		if (write && vma->vm_flags & VM_MAYWRITE)
-			len -= copy_to_user((void *) addr, buf, len);
+			copy_to_user_page(vma, NULL, NULL,
+					  (void *) addr, buf, len);
 		else if (!write && vma->vm_flags & VM_MAYREAD)
-			len -= copy_from_user(buf, (void *) addr, len);
+			copy_from_user_page(vma, NULL, NULL,
+					    buf, (void *) addr, len);
 		else
 			len = 0;
 	} else {
-- 
1.6.5.3

