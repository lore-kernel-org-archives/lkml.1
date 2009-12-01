Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZLAOKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZLAOKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZLAOKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:10:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbZLAOKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:10:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org, akpm@linux-foundation.org
cc: dhowells@redhat.com, marc.c.dionne@gmail.com, kirill@bitel.ru,
       linux-kernel@vger.kernel.org, linux-cachefs@redhat.com
Subject: [PATCH] CacheFiles: Update IMA counters when using dentry_open
Date: Tue, 01 Dec 2009 14:09:24 +0000
Message-ID: <30322.1259676564@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Marc Dionne <marc.c.dionne@gmail.com>

When IMA is active, using dentry_open without updating the
IMA counters will result in free/open imbalance errors when
fput is eventually called.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/rdwr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 1d83325..a6c8c6f 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -11,6 +11,7 @@
 
 #include <linux/mount.h>
 #include <linux/file.h>
+#include <linux/ima.h>
 #include "internal.h"
 
 /*
@@ -922,6 +923,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 	} else {
+		ima_counts_get(file);
 		ret = -EIO;
 		if (file->f_op->write) {
 			pos = (loff_t) page->index << PAGE_SHIFT;
