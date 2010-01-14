Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822Ab0ANOBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0ANOBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778Ab0ANOBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:01:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763Ab0ANOBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:01:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] NOMMU: Fix SYSV SHM for NOMMU
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: viro@ZenIV.linux.org.uk, vapier@gentoo.org, lethal@linux-sh.org,
       dhowells@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Jan 2010 13:58:30 +0000
Message-ID: <20100114135830.10482.54124.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c4caa778157dbbf04116f0ac2111e389b5cd7a29 broke SYSV SHM for NOMMU by
taking away the pointer to shm_get_unmapped_area() from shm_file_operations.

Put it back conditionally on CONFIG_MMU=n.

file->f_ops->get_unmapped_area() is used to find out the base address for a
mapping of a mappable chardev device or mappable memory-based file (such as a
ramfs file).  It needs to be called prior to file->f_ops->mmap() being called.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
---

 ipc/shm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/ipc/shm.c b/ipc/shm.c
index 92fe923..23256b8 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -298,6 +298,9 @@ static const struct file_operations shm_file_operations = {
 	.mmap		= shm_mmap,
 	.fsync		= shm_fsync,
 	.release	= shm_release,
+#ifndef CONFIG_MMU
+	.get_unmapped_area	= shm_get_unmapped_area,
+#endif
 };
 
 static const struct file_operations shm_file_operations_huge = {

