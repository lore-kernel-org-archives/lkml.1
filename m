Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbYDAVKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbYDAVKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbYDAVIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:08:01 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45619 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761494AbYDAVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:58 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 10/14] Unionfs: document reasons for opaque directories
Date: Tue,  1 Apr 2008 17:06:52 -0400
Message-Id: <12070840213666-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/concepts.txt |   36 ++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/unionfs/concepts.txt b/Documentation/filesystems/unionfs/concepts.txt
index 0bc1a19..b853788 100644
--- a/Documentation/filesystems/unionfs/concepts.txt
+++ b/Documentation/filesystems/unionfs/concepts.txt
@@ -52,6 +52,42 @@ Later, when Unionfs traverses branches (due to lookup or readdir), it
 eliminate 'foo' from the namespace (as well as the whiteout itself.)
 
 
+Opaque Directories:
+===================
+
+Assume we have a unionfs mount comprising of two branches.  Branch 0 is
+empty; branch 1 has the directory /a and file /a/f.  Let's say we mount a
+union of branch 0 as read-write and branch 1 as read-only.  Now, let's say
+we try to perform the following operation in the union:
+
+	rm -fr a
+
+Because branch 1 is not writable, we cannot physically remove the file /a/f
+or the directory /a.  So instead, we will create a whiteout in branch 0
+named /.wh.a, masking out the name "a" from branch 1.  Next, let's say we
+try to create a directory named "a" as follows:
+
+	mkdir a
+
+Because we have a whiteout for "a" already, Unionfs behaves as if "a"
+doesn't exist, and thus will delete the whiteout and replace it with an
+actual directory named "a".
+
+The problem now is that if you try to "ls" in the union, Unionfs will
+perform is normal directory name unification, for *all* directories named
+"a" in all branches.  This will cause the file /a/f from branch 1 to
+re-appear in the union's namespace, which violates Unix semantics.
+
+To avoid this problem, we have a different form of whiteouts for
+directories, called "opaque directories" (same as BSD Union Mount does).
+Whenever we replace a whiteout with a directory, that directory is marked as
+opaque.  In Unionfs 2.x, it means that we create a file named
+/a/.wh.__dir_opaque in branch 0, after having created directory /a there.
+When unionfs notices that a directory is opaque, it stops all namespace
+operations (including merging readdir contents) at that opaque directory.
+This prevents re-exposing names from masked out directories.
+
+
 Duplicate Elimination:
 ======================
 
-- 
1.5.2.2

