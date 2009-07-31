Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZGaKzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZGaKzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZGaKzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:55:46 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:33139 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZGaKzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:55:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Cc: bugzilla.kernel.org@falkensweb.com
Subject: [PATCH] cifs: reinstate original behavior when uid=/gid= options are specified
Date: Fri, 31 Jul 2009 06:55:42 -0400
Message-Id: <1249037742-7862-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the regression reported here:

http://bugzilla.kernel.org/show_bug.cgi?id=13861

commit 4ae1507f6d266d0cc3dd36e474d83aad70fec9e4 changed the default
behavior when the uid= or gid= option was specified for a mount. The
existing behavior was to always clobber the ownership information
provided by the server when these options were specified. The above
commit changed this behavior so that these options simply provided
defaults when the server did not provide this information.

This patch reverts this change so that the default behavior is restored.
It also adds "noforceuid" and "noforcegid" options to make it so that
ownership information from the server is preserved, even when the mount
has uid= or gid= options specified.

It also adds a couple of printk notices that pop up when forceuid or
forcegid options are specified without a uid= or gid= option.

Reported-by: Tom Chiverton <bugzilla.kernel.org@falkensweb.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |   42 ++++++++++++++++++++++++++++++------------
 1 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f248688..1f3345d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -803,6 +803,10 @@ cifs_parse_mount_options(char *options, const char *devname,
 	char *data;
 	unsigned int  temp_len, i, j;
 	char separator[2];
+	short int override_uid = -1;
+	short int override_gid = -1;
+	bool uid_specified = false;
+	bool gid_specified = false;
 
 	separator[0] = ',';
 	separator[1] = 0;
@@ -1093,18 +1097,20 @@ cifs_parse_mount_options(char *options, const char *devname,
 						    "too long.\n");
 				return 1;
 			}
-		} else if (strnicmp(data, "uid", 3) == 0) {
-			if (value && *value)
-				vol->linux_uid =
-					simple_strtoul(value, &value, 0);
-		} else if (strnicmp(data, "forceuid", 8) == 0) {
-				vol->override_uid = 1;
-		} else if (strnicmp(data, "gid", 3) == 0) {
-			if (value && *value)
-				vol->linux_gid =
-					simple_strtoul(value, &value, 0);
-		} else if (strnicmp(data, "forcegid", 8) == 0) {
-				vol->override_gid = 1;
+		} else if (!strnicmp(data, "uid", 3) && value && *value) {
+			vol->linux_uid = simple_strtoul(value, &value, 0);
+			uid_specified = true;
+		} else if (!strnicmp(data, "forceuid", 8)) {
+			override_uid = 1;
+		} else if (!strnicmp(data, "noforceuid", 10)) {
+			override_uid = 0;
+		} else if (!strnicmp(data, "gid", 3) && value && *value) {
+			vol->linux_gid = simple_strtoul(value, &value, 0);
+			gid_specified = true;
+		} else if (!strnicmp(data, "forcegid", 8)) {
+			override_gid = 1;
+		} else if (!strnicmp(data, "noforcegid", 10)) {
+			override_gid = 0;
 		} else if (strnicmp(data, "file_mode", 4) == 0) {
 			if (value && *value) {
 				vol->file_mode =
@@ -1355,6 +1361,18 @@ cifs_parse_mount_options(char *options, const char *devname,
 	if (vol->UNCip == NULL)
 		vol->UNCip = &vol->UNC[2];
 
+	if (uid_specified)
+		vol->override_uid = override_uid;
+	else if (override_uid == 1)
+		printk(KERN_NOTICE "CIFS: ignoring forceuid mount option "
+				   "specified with no uid= option.\n");
+
+	if (gid_specified)
+		vol->override_gid = override_gid;
+	else if (override_gid == 1)
+		printk(KERN_NOTICE "CIFS: ignoring forcegid mount option "
+				   "specified with no gid= option.\n");
+
 	return 0;
 }
 
-- 
1.6.0.6

