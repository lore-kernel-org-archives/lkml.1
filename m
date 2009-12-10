Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbZLJN65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbZLJN65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbZLJN6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:58:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbZLJN6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:58:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/7] NOMMU: Use copy_*_user_page() in access_process_vm()
To: vapier.adi@gmail.com, lethal@linux-sh.org, jie.zhang@analog.com,
       stefani@seibold.net, gerg@snapgear.com
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Dec 2009 13:58:21 +0000
Message-ID: <20091210135821.6325.90645.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk>
References: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

The MMU code uses the copy_*_user_page() variants in access_process_vm()
rather than copy_*_user() as the former includes an icache flush.  This is
important when doing things like setting software breakpoints with gdb.
So switch the NOMMU code over to do the same.

This patch makes the reasonable assumption that copy_from_user_page() won't
fail - which is probably fine, as we've checked the VMA from which we're
copying is usable, and the copy is not allowed to cross VMAs.  The one case
where it might go wrong is if the VMA is a device rather than RAM, and that
device returns an error which - in which case rubbish will be returned rather
than EIO.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index bffbdfc..a8c2392 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1897,9 +1897,11 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 
 		/* only read or write mappings where it is permitted */
 		if (write && vma->vm_flags & VM_MAYWRITE)
-			len -= copy_to_user((void *) addr, buf, len);
+			copy_to_user_page(vma, NULL, addr,
+					 (void *) addr, buf, len);
 		else if (!write && vma->vm_flags & VM_MAYREAD)
-			len -= copy_from_user(buf, (void *) addr, len);
+			copy_from_user_page(vma, NULL, addr,
+					    buf, (void *) addr, len);
 		else
 			len = 0;
 	} else {

