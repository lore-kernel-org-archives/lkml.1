Return-Path: <linux-kernel-owner+w=401wt.eu-S1423387AbXEAK1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423387AbXEAK1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161680AbXEAK1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:27:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161707AbXEAK13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:27:29 -0400
Subject: [GFS2] use lib/parser for parsing mount options [30/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jwhiter@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:22:55 +0100
Message-Id: <1178014975.5462.190.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 476c006be009d4121e401a9e9f49a3362a7a272f Mon Sep 17 00:00:00 2001
From: Josef Bacik <jwhiter@redhat.com>
Date: Mon, 23 Apr 2007 11:55:39 -0400
Subject: [PATCH] [GFS2] use lib/parser for parsing mount options

This patch converts the mount option parsing to use the kernels lib/parser stuff
like all of the other filesystems.  I tested this and it works well.  Thank you,

Signed-off-by: Josef Bacik <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index 32caecd..4864659 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -13,6 +13,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
+#include <linux/parser.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -20,6 +21,52 @@
 #include "sys.h"
 #include "util.h"
 
+enum {
+	Opt_lockproto,
+	Opt_locktable,
+	Opt_hostdata,
+	Opt_spectator,
+	Opt_ignore_local_fs,
+	Opt_localflocks,
+	Opt_localcaching,
+	Opt_debug,
+	Opt_nodebug,
+	Opt_upgrade,
+	Opt_num_glockd,
+	Opt_acl,
+	Opt_noacl,
+	Opt_quota_off,
+	Opt_quota_account,
+	Opt_quota_on,
+	Opt_suiddir,
+	Opt_nosuiddir,
+	Opt_data_writeback,
+	Opt_data_ordered,
+};
+
+static match_table_t tokens = {
+	{Opt_lockproto, "lockproto=%s"},
+	{Opt_locktable, "locktable=%s"},
+	{Opt_hostdata, "hostdata=%s"},
+	{Opt_spectator, "spectator"},
+	{Opt_ignore_local_fs, "ignore_local_fs"},
+	{Opt_localflocks, "localflocks"},
+	{Opt_localcaching, "localcaching"},
+	{Opt_debug, "debug"},
+	{Opt_nodebug, "nodebug"},
+	{Opt_upgrade, "upgrade"},
+	{Opt_num_glockd, "num_glockd=%d"},
+	{Opt_acl, "acl"},
+	{Opt_noacl, "noacl"},
+	{Opt_quota_off, "quota=off"},
+	{Opt_quota_account, "quota=account"},
+	{Opt_quota_on, "quota=on"},
+	{Opt_suiddir, "suiddir"},
+	{Opt_nosuiddir, "nosuiddir"},
+	{Opt_data_writeback, "data=writeback"},
+	{Opt_data_ordered, "data=ordered"}
+};
+
 /**
  * gfs2_mount_args - Parse mount options
  * @sdp:
@@ -54,146 +101,150 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 	   process them */
 
 	for (options = data; (o = strsep(&options, ",")); ) {
+		int token, option;
+		substring_t tmp[MAX_OPT_ARGS];
+
 		if (!*o)
 			continue;
 
-		v = strchr(o, '=');
-		if (v)
-			*v++ = 0;
+		token = match_token(o, tokens, tmp);
+		switch (token) {
+		case Opt_lockproto:
+			v = match_strdup(&tmp[0]);
+			if (!v) {
+				fs_info(sdp, "no memory for lockproto\n");
+				error = -ENOMEM;
+				goto out_error;
+			}
 
-		if (!strcmp(o, "lockproto")) {
-			if (!v)
-				goto need_value;
-			if (remount && strcmp(v, args->ar_lockproto))
+			if (remount && strcmp(v, args->ar_lockproto)) {
+				kfree(v);
 				goto cant_remount;
+			}
+			
 			strncpy(args->ar_lockproto, v, GFS2_LOCKNAME_LEN);
 			args->ar_lockproto[GFS2_LOCKNAME_LEN - 1] = 0;
-		}
+			kfree(v);
+			break;
+		case Opt_locktable:
+			v = match_strdup(&tmp[0]);
+			if (!v) {
+				fs_info(sdp, "no memory for locktable\n");
+				error = -ENOMEM;
+				goto out_error;
+			}
 
-		else if (!strcmp(o, "locktable")) {
-			if (!v)
-				goto need_value;
-			if (remount && strcmp(v, args->ar_locktable))
+			if (remount && strcmp(v, args->ar_locktable)) {
+				kfree(v);
 				goto cant_remount;
+			}
+
 			strncpy(args->ar_locktable, v, GFS2_LOCKNAME_LEN);
-			args->ar_locktable[GFS2_LOCKNAME_LEN - 1] = 0;
-		}
+			args->ar_locktable[GFS2_LOCKNAME_LEN - 1]  = 0;
+			kfree(v);
+			break;
+		case Opt_hostdata:
+			v = match_strdup(&tmp[0]);
+			if (!v) {
+				fs_info(sdp, "no memory for hostdata\n");
+				error = -ENOMEM;
+				goto out_error;
+			}
 
-		else if (!strcmp(o, "hostdata")) {
-			if (!v)
-				goto need_value;
-			if (remount && strcmp(v, args->ar_hostdata))
+			if (remount && strcmp(v, args->ar_hostdata)) {
+				kfree(v);
 				goto cant_remount;
+			}
+
 			strncpy(args->ar_hostdata, v, GFS2_LOCKNAME_LEN);
 			args->ar_hostdata[GFS2_LOCKNAME_LEN - 1] = 0;
-		}
-
-		else if (!strcmp(o, "spectator")) {
+			kfree(v);
+			break;
+		case Opt_spectator:
 			if (remount && !args->ar_spectator)
 				goto cant_remount;
 			args->ar_spectator = 1;
 			sdp->sd_vfs->s_flags |= MS_RDONLY;
-		}
-
-		else if (!strcmp(o, "ignore_local_fs")) {
+			break;
+		case Opt_ignore_local_fs:
 			if (remount && !args->ar_ignore_local_fs)
 				goto cant_remount;
 			args->ar_ignore_local_fs = 1;
-		}
-
-		else if (!strcmp(o, "localflocks")) {
+			break;
+		case Opt_localflocks:
 			if (remount && !args->ar_localflocks)
 				goto cant_remount;
 			args->ar_localflocks = 1;
-		}
-
-		else if (!strcmp(o, "localcaching")) {
+			break;
+		case Opt_localcaching:
 			if (remount && !args->ar_localcaching)
 				goto cant_remount;
 			args->ar_localcaching = 1;
-		}
-
-		else if (!strcmp(o, "debug"))
+			break;
+		case Opt_debug:
 			args->ar_debug = 1;
-
-		else if (!strcmp(o, "nodebug"))
+			break;
+		case Opt_nodebug:
 			args->ar_debug = 0;
-
-		else if (!strcmp(o, "upgrade")) {
+			break;
+		case Opt_upgrade:
 			if (remount && !args->ar_upgrade)
 				goto cant_remount;
 			args->ar_upgrade = 1;
-		}
+			break;
+		case Opt_num_glockd:
+			if ((error = match_int(&tmp[0], &option))) {
+				fs_info(sdp, "problem getting num_glockd\n");
+				goto out_error;
+			}
 
-		else if (!strcmp(o, "num_glockd")) {
-			unsigned int x;
-			if (!v)
-				goto need_value;
-			sscanf(v, "%u", &x);
-			if (remount && x != args->ar_num_glockd)
+			if (remount && option != args->ar_num_glockd)
 				goto cant_remount;
-			if (!x || x > GFS2_GLOCKD_MAX) {
+			if (!option || option > GFS2_GLOCKD_MAX) {
 				fs_info(sdp, "0 < num_glockd <= %u  (not %u)\n",
-				        GFS2_GLOCKD_MAX, x);
+				        GFS2_GLOCKD_MAX, option);
 				error = -EINVAL;
-				break;
+				goto out_error;
 			}
-			args->ar_num_glockd = x;
-		}
-
-		else if (!strcmp(o, "acl")) {
+			args->ar_num_glockd = option;
+			break;
+		case Opt_acl:
 			args->ar_posix_acl = 1;
 			sdp->sd_vfs->s_flags |= MS_POSIXACL;
-		}
-
-		else if (!strcmp(o, "noacl")) {
+			break;
+		case Opt_noacl:
 			args->ar_posix_acl = 0;
 			sdp->sd_vfs->s_flags &= ~MS_POSIXACL;
-		}
-
-		else if (!strcmp(o, "quota")) {
-			if (!v)
-				goto need_value;
-			if (!strcmp(v, "off"))
-				args->ar_quota = GFS2_QUOTA_OFF;
-			else if (!strcmp(v, "account"))
-				args->ar_quota = GFS2_QUOTA_ACCOUNT;
-			else if (!strcmp(v, "on"))
-				args->ar_quota = GFS2_QUOTA_ON;
-			else {
-				fs_info(sdp, "invalid value for quota\n");
-				error = -EINVAL;
-				break;
-			}
-		}
-
-		else if (!strcmp(o, "suiddir"))
+			break;
+		case Opt_quota_off:
+			args->ar_quota = GFS2_QUOTA_OFF;
+			break;
+		case Opt_quota_account:
+			args->ar_quota = GFS2_QUOTA_ACCOUNT;
+			break;
+		case Opt_quota_on:
+			args->ar_quota = GFS2_QUOTA_ON;
+			break;
+		case Opt_suiddir:
 			args->ar_suiddir = 1;
-
-		else if (!strcmp(o, "nosuiddir"))
+			break;
+		case Opt_nosuiddir:
 			args->ar_suiddir = 0;
-
-		else if (!strcmp(o, "data")) {
-			if (!v)
-				goto need_value;
-			if (!strcmp(v, "writeback"))
-				args->ar_data = GFS2_DATA_WRITEBACK;
-			else if (!strcmp(v, "ordered"))
-				args->ar_data = GFS2_DATA_ORDERED;
-			else {
-				fs_info(sdp, "invalid value for data\n");
-				error = -EINVAL;
-				break;
-			}
-		}
-
-		else {
+			break;
+		case Opt_data_writeback:
+			args->ar_data = GFS2_DATA_WRITEBACK;
+			break;
+		case Opt_data_ordered:
+			args->ar_data = GFS2_DATA_ORDERED;
+			break;
+		default:
 			fs_info(sdp, "unknown option: %s\n", o);
 			error = -EINVAL;
-			break;
+			goto out_error;
 		}
 	}
 
+out_error:
 	if (error)
 		fs_info(sdp, "invalid mount option(s)\n");
 
@@ -202,10 +253,6 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 
 	return error;
 
-need_value:
-	fs_info(sdp, "need value for option %s\n", o);
-	return -EINVAL;
-
 cant_remount:
 	fs_info(sdp, "can't remount with option %s\n", o);
 	return -EINVAL;
-- 
1.5.1.2



