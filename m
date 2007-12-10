Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbXLJCpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbXLJCpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXLJCm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:42:56 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49687 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXLJCms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:42:48 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 05/42] Unionfs: documentation for any known issues
Date: Sun,  9 Dec 2007 21:41:38 -0500
Message-Id: <11972545383139-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/issues.txt |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/unionfs/issues.txt

diff --git a/Documentation/filesystems/unionfs/issues.txt b/Documentation/filesystems/unionfs/issues.txt
new file mode 100644
index 0000000..9db1d70
--- /dev/null
+++ b/Documentation/filesystems/unionfs/issues.txt
@@ -0,0 +1,24 @@
+KNOWN Unionfs 2.1 ISSUES:
+=========================
+
+1. Unionfs should not use lookup_one_len() on the underlying f/s as it
+   confuses NFSv4.  Currently, unionfs_lookup() passes lookup intents to the
+   lower file-system, this eliminates part of the problem.  The remaining
+   calls to lookup_one_len may need to be changed to pass an intent.  We are
+   currently introducing VFS changes to fs/namei.c's do_path_lookup() to
+   allow proper file lookup and opening in stackable file systems.
+
+2. Lockdep (a debugging feature) isn't aware of stacking, and so it
+   incorrectly complains about locking problems.  The problem boils down to
+   this: Lockdep considers all objects of a certain type to be in the same
+   class, for example, all inodes.  Lockdep doesn't like to see a lock held
+   on two inodes within the same task, and warns that it could lead to a
+   deadlock.  However, stackable file systems do precisely that: they lock
+   an upper object, and then a lower object, in a strict order to avoid
+   locking problems; in addition, Unionfs, as a fan-out file system, may
+   have to lock several lower inodes.  We are currently looking into Lockdep
+   to see how to make it aware of stackable file systems.  In the meantime,
+   if you get any warnings from Lockdep, you can safely ignore them (or feel
+   free to report them to the Unionfs maintainers, just to be sure).
+
+For more information, see <http://unionfs.filesystems.org/>.
-- 
1.5.2.2

