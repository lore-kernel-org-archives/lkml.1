Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZLHK63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZLHK63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZLHK62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:58:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZLHK61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:58:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
Date: Tue, 08 Dec 2009 10:57:53 +0000
Message-ID: <7253.1260269873@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> +			copy_to_user_page(vma, NULL, NULL,
> +					  (void *) addr, buf, len);
> ...
> +			copy_from_user_page(vma, NULL, NULL,
> +					    buf, (void *) addr, len);

I think this is not correct.  The third parameter in both cases (vaddr) is of
unsigned long type (so should be 0 not NULL), and should not be left zero in
any case.  I think it should be passed addr.  In fact, we should really pass
the second parameter too (page), though for now, I'm happy to leave that NULL.

See attached revision of the patch.

David
---
From: Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH] NOMMU: Use copy_*_user_page() in access_process_vm()

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
index af12270..953800f 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1896,9 +1896,11 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 
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
