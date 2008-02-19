Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYBSWWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYBSWWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYBSWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:22:26 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:33914 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbYBSWW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:22:26 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Armbruster <armbru@redhat.com>, Jim Meyering <jim@meyering.net>
Subject: [PATCH] 9p: handle kstrdup and match_strdup failure
Date: Tue, 19 Feb 2008 23:13:35 +0100
Message-Id: <1203459219-14719-3-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.5.4.2.134.g82883
In-Reply-To: <1203459219-14719-2-git-send-email-jim@meyering.net>
References: <1203459219-14719-1-git-send-email-jim@meyering.net>
 <1203459219-14719-2-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* fs/9p/v9fs.c (v9fs_parse_options): Handle kstrdup and match_strdup failure.
Now that this function can fail, return an int, diagnose other option-parsing
failures, and adjust the sole caller:
(v9fs_session_init): Handle kstrdup failure.  Propagate any new
v9fs_parse_options failure "up".

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
FYI, my first crack at cleaning up v9fs_parse_options
removed the match_strdup call altogether, but was more
invasive in that it added a new function, match_strcmp and
made the existing match_number function public.
The patch below just handles the match_strdup failure.

 fs/9p/v9fs.c |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 9b0f022..8ca142c 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -74,16 +74,17 @@ static match_table_t tokens = {
  * @options: options string passed from mount
  * @v9ses: existing v9fs session information
  *
+ * Return 0 upon success, -ERRNO upon failure.
  */

-static void v9fs_parse_options(struct v9fs_session_info *v9ses)
+static int v9fs_parse_options(struct v9fs_session_info *v9ses)
 {
 	char *options;
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option = 0;
 	char *s, *e;
-	int ret;
+	int ret = 0;

 	/* setup defaults */
 	v9ses->afid = ~0;
@@ -91,19 +92,26 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 	v9ses->cache = 0;

 	if (!v9ses->options)
-		return;
+		return 0;

 	options = kstrdup(v9ses->options, GFP_KERNEL);
+	if (!options) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+			   "failed to allocate copy of option string\n");
+		return -ENOMEM;
+	}
+
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 		if (!*p)
 			continue;
 		token = match_token(p, tokens, args);
 		if (token < Opt_uname) {
-			ret = match_int(&args[0], &option);
-			if (ret < 0) {
+			int r = match_int(&args[0], &option);
+			if (r < 0) {
 				P9_DPRINTK(P9_DEBUG_ERROR,
 					"integer field, but no integer?\n");
+				ret = r;
 				continue;
 			}
 		}
@@ -139,6 +147,13 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)

 		case Opt_access:
 			s = match_strdup(&args[0]);
+			if (!s) {
+				P9_DPRINTK(P9_DEBUG_ERROR,
+					   "failed to allocate copy"
+					   " of option argument\n");
+				ret = -ENOMEM;
+				break;
+			}
 			v9ses->flags &= ~V9FS_ACCESS_MASK;
 			if (strcmp(s, "user") == 0)
 				v9ses->flags |= V9FS_ACCESS_USER;
@@ -158,6 +173,7 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 		}
 	}
 	kfree(options);
+	return ret;
 }

 /**
@@ -173,6 +189,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 {
 	int retval = -EINVAL;
 	struct p9_fid *fid;
+	int rc;

 	v9ses->uname = __getname();
 	if (!v9ses->uname)
@@ -191,7 +208,18 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	v9ses->dfltuid = V9FS_DEFUID;
 	v9ses->dfltgid = V9FS_DEFGID;
 	v9ses->options = kstrdup(data, GFP_KERNEL);
-	v9fs_parse_options(v9ses);
+	if (!v9ses->options) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+			   "failed to allocate copy of option string\n");
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	rc = v9fs_parse_options(v9ses);
+	if (rc < 0) {
+		retval = rc;
+		goto error;
+	}

 	v9ses->clnt = p9_client_create(dev_name, v9ses->options);

-- 
1.5.4.2.134.g82883

