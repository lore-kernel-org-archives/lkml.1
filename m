Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYC1Omi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYC1Omi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYC1Ofq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:35:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbYC1Oeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:34:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/45] AFS: prevent double cell registration [ver #35]
To: torvalds@osdl.org, akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       chuck.lever@oracle.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 28 Mar 2008 14:32:29 +0000
Message-ID: <20080328143229.3483.92808.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
References: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

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

