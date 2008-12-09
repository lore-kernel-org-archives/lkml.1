Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYLIO3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYLIO3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYLIOU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:20:28 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:44735 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbYLIOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:20:22 -0500
Date: Tue, 9 Dec 2008 08:19:31 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Brice Goglin <Brice.Goglin@inria.fr>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] No get_user/put_user while holding mmap_sem in
 do_pages_stat?
In-Reply-To: <493BDBE6.9040600@inria.fr>
Message-ID: <Pine.LNX.4.64.0812090811450.13181@quilx.com>
References: <493B3179.7030204@inria.fr> <20081206185050.544f67fc.akpm@linux-foundation.org>
 <493BDBE6.9040600@inria.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess the simplest solution would be to move the taking of mmap_sem into
the loop. Mean taking mmap_sem for every page that we determine the status of.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c	2008-12-09 08:07:08.796603952 -0600
+++ linux-2.6/mm/migrate.c	2008-12-09 08:08:36.400116263 -0600
@@ -994,8 +994,6 @@
 	unsigned long i;
 	int err;

-	down_read(&mm->mmap_sem);
-
 	for (i = 0; i < nr_pages; i++) {
 		const void __user *p;
 		unsigned long addr;
@@ -1007,12 +1005,17 @@
 			goto out;
 		addr = (unsigned long) p;

+		down_read(&mm->mmap_sem);
+
 		vma = find_vma(mm, addr);
-		if (!vma)
+		if (!vma) {
+			up_read(&mm->mmap_sem);
 			goto set_status;
-
+		}
 		page = follow_page(vma, addr, 0);

+		up_read(&mm->mmap_sem);
+
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto set_status;
@@ -1029,7 +1032,6 @@
 	err = 0;

 out:
-	up_read(&mm->mmap_sem);
 	return err;
 }

