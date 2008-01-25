Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbYAYHYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbYAYHYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbYAYHPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:55 -0500
Received: from ns1.suse.de ([195.135.220.2]:52569 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758656AbYAYHPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Denis Cheng <crquan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 031/196] sysfs: create optimal relative symlink targets
Date: Thu, 24 Jan 2008 23:09:29 -0800
Message-Id: <1201245134-4876-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Instead of walking from the source down to the root of sysfs, and back
to the target, we stop at the first directory the source and the target
share.

This link:
  /devices/pci0000:00/0000:00:1d.7/usb1/1-0:1.0/ep_81

pointed to:
  ../../../../../devices/pci0000:00/0000:00:1d.0/usb2/2-0:1.0/usb_endpoint/usbdev2.1_ep81

now it just points to:
  usb_endpoint/usbdev1.1_ep81

Thanks to Denis Cheng for bringing this up, and sending the initial patch.

CC: Denis Cheng <crquan@gmail.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c |   88 +++++++++++++++++++++++++---------------------------
 1 files changed, 42 insertions(+), 46 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 3eac20c..5f66c44 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -19,39 +19,6 @@
 
 #include "sysfs.h"
 
-static int object_depth(struct sysfs_dirent *sd)
-{
-	int depth = 0;
-
-	for (; sd->s_parent; sd = sd->s_parent)
-		depth++;
-
-	return depth;
-}
-
-static int object_path_length(struct sysfs_dirent * sd)
-{
-	int length = 1;
-
-	for (; sd->s_parent; sd = sd->s_parent)
-		length += strlen(sd->s_name) + 1;
-
-	return length;
-}
-
-static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
-{
-	--length;
-	for (; sd->s_parent; sd = sd->s_parent) {
-		int cur = strlen(sd->s_name);
-
-		/* back up enough to print this bus id with '/' */
-		length -= cur;
-		strncpy(buffer + length, sd->s_name, cur);
-		*(buffer + --length) = '/';
-	}
-}
-
 /**
  *	sysfs_create_link - create symlink between two objects.
  *	@kobj:	object whose directory we're creating the link in.
@@ -112,7 +79,6 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	return error;
 }
 
-
 /**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
@@ -124,24 +90,54 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 	sysfs_hash_and_remove(kobj->sd, name);
 }
 
-static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
-				 struct sysfs_dirent * target_sd, char *path)
+static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
+				 struct sysfs_dirent *target_sd, char *path)
 {
-	char * s;
-	int depth, size;
+	struct sysfs_dirent *base, *sd;
+	char *s = path;
+	int len = 0;
+
+	/* go up to the root, stop at the base */
+	base = parent_sd;
+	while (base->s_parent) {
+		sd = target_sd->s_parent;
+		while (sd->s_parent && base != sd)
+			sd = sd->s_parent;
+
+		if (base == sd)
+			break;
+
+		strcpy(s, "../");
+		s += 3;
+		base = base->s_parent;
+	}
+
+	/* determine end of target string for reverse fillup */
+	sd = target_sd;
+	while (sd->s_parent && sd != base) {
+		len += strlen(sd->s_name) + 1;
+		sd = sd->s_parent;
+	}
 
-	depth = object_depth(parent_sd);
-	size = object_path_length(target_sd) + depth * 3 - 1;
-	if (size > PATH_MAX)
+	/* check limits */
+	if (len < 2)
+		return -EINVAL;
+	len--;
+	if ((s - path) + len > PATH_MAX)
 		return -ENAMETOOLONG;
 
-	pr_debug("%s: depth = %d, size = %d\n", __FUNCTION__, depth, size);
+	/* reverse fillup of target string from target to base */
+	sd = target_sd;
+	while (sd->s_parent && sd != base) {
+		int slen = strlen(sd->s_name);
 
-	for (s = path; depth--; s += 3)
-		strcpy(s,"../");
+		len -= slen;
+		strncpy(s + len, sd->s_name, slen);
+		if (len)
+			s[--len] = '/';
 
-	fill_object_path(target_sd, path, size);
-	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
+		sd = sd->s_parent;
+	}
 
 	return 0;
 }
-- 
1.5.3.8

