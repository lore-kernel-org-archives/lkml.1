Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZA0Ws0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZA0Ws0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZA0WsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:48:16 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:4426 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZA0WsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:48:15 -0500
Message-ID: <497F8F2D.600@cybernetics.com>
Date: Tue, 27 Jan 2009 17:48:13 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <olsajiri@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] make shm_get_stat() more robust
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shm_get_stat() assumes idr_find(&shm_ids(ns).ipcs_idr) returns
"struct shmid_kernel *"; all other callers assume that it returns
"struct kern_ipc_perm *".  This works because "struct kern_ipc_perm"
is currently the first member of "struct shmid_kernel", but it would
be better to use container_of() to prevent future breakage.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.29-rc2-git3/ipc/shm.c.orig	2009-01-27 16:23:10.000000000 -0500
+++ linux-2.6.29-rc2-git3/ipc/shm.c	2009-01-27 16:24:19.000000000 -0500
@@ -551,12 +551,14 @@ static void shm_get_stat(struct ipc_name
 	in_use = shm_ids(ns).in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
+		struct kern_ipc_perm *ipc;
 		struct shmid_kernel *shp;
 		struct inode *inode;
 
-		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
-		if (shp == NULL)
+		ipc = idr_find(&shm_ids(ns).ipcs_idr, next_id);
+		if (ipc == NULL)
 			continue;
+		shp = container_of(ipc, struct shmid_kernel, shm_perm);
 
 		inode = shp->shm_file->f_path.dentry->d_inode;
 



