Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbZCYAoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbZCYAoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbZCYAa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:26 -0400
Received: from kroah.org ([198.145.64.141]:54157 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756743AbZCYAaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>, Alex Williamson <alex.williamson@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/61] sysfs: sysfs_add_one WARNs with full path to duplicate filename
Date: Tue, 24 Mar 2009 17:26:45 -0700
Message-Id: <1237940825-22904-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

sysfs: sysfs_add_one WARNs with full path to duplicate filename

As a debugging aid, it can be useful to know the full path to a
duplicate file being created in sysfs.

We now will display warnings such as:

	sysfs: cannot create duplicate filename '/foo'

when attempting to create multiple files named 'foo' in the sysfs
root, or:

	sysfs: cannot create duplicate filename '/bus/pci/slots/5/foo'

when attempting to create multiple files named 'foo' under a
given directory in sysfs.

The path displayed is always a relative path to sysfs_root. The
leading '/' in the path name refers to the sysfs_root mount
point, and should not be confused with the "real" '/'.

Thanks to Alex Williamson for essentially writing sysfs_pathname.

Cc: Alex Williamson <alex.williamson@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 82d3b79..f13d852 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -434,6 +434,26 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 }
 
 /**
+ *	sysfs_pathname - return full path to sysfs dirent
+ *	@sd: sysfs_dirent whose path we want
+ *	@path: caller allocated buffer
+ *
+ *	Gives the name "/" to the sysfs_root entry; any path returned
+ *	is relative to wherever sysfs is mounted.
+ *
+ *	XXX: does no error checking on @path size
+ */
+static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
+{
+	if (sd->s_parent) {
+		sysfs_pathname(sd->s_parent, path);
+		strcat(path, "/");
+	}
+	strcat(path, sd->s_name);
+	return path;
+}
+
+/**
  *	sysfs_add_one - add sysfs_dirent to parent
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be added
@@ -458,8 +478,16 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	int ret;
 
 	ret = __sysfs_add_one(acxt, sd);
-	WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
-		       "can not be created\n", sd->s_name);
+	if (ret == -EEXIST) {
+		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
+		WARN(1, KERN_WARNING
+		     "sysfs: cannot create duplicate filename '%s'\n",
+		     (path == NULL) ? sd->s_name :
+		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
+		            sd->s_name));
+		kfree(path);
+	}
+
 	return ret;
 }
 
-- 
1.6.2

