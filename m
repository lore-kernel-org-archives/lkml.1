Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYCYTEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYCYTEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYCYTEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:04:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbYCYTEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:04:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] AFS: prevent double cell registration
To: torvalds@osdl.org, akpm@linux-foundation.org, svens@stackframe.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 25 Mar 2008 19:03:44 +0000
Message-ID: <20080325190344.29835.86006.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080325190339.29835.44441.stgit@warthog.procyon.org.uk>
References: <20080325190339.29835.44441.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kafs doesn't check if the cell already exists - so if you do an
echo "add newcell.org 1.2.3.4" >/proc/fs/afs/cells it will try to
create this cell again. kobject will also complain about a double
registration. To prevent such problems, return -EEXIST in that case.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/cell.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 970d38f..788865d 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -127,14 +127,20 @@ struct afs_cell *afs_cell_create(const char *name, char *vllist)
 
 	_enter("%s,%s", name, vllist);
 
+	down_write(&afs_cells_sem);
+	read_lock(&afs_cells_lock);
+	list_for_each_entry(cell, &afs_cells, link) {
+		if (strcasecmp(cell->name, name) == 0)
+			goto duplicate_name;
+	}
+	read_unlock(&afs_cells_lock);
+
 	cell = afs_cell_alloc(name, vllist);
 	if (IS_ERR(cell)) {
 		_leave(" = %ld", PTR_ERR(cell));
 		return cell;
 	}
 
-	down_write(&afs_cells_sem);
-
 	/* add a proc directory for this cell */
 	ret = afs_proc_cell_setup(cell);
 	if (ret < 0)
@@ -167,6 +173,11 @@ error:
 	kfree(cell);
 	_leave(" = %d", ret);
 	return ERR_PTR(ret);
+
+duplicate_name:
+	read_unlock(&afs_cells_lock);
+	up_write(&afs_cells_sem);
+	return ERR_PTR(-EEXIST);
 }
 
 /*

