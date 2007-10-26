Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbXJZXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbXJZXFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXJZXFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:05:22 -0400
Received: from 70-56-216-30.albq.qwest.net ([70.56.216.30]:43031 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156AbXJZXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:05:21 -0400
Date: Fri, 26 Oct 2007 17:05:19 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: use copy of the options value instead of original
Message-ID: <20071026230519.GA23570@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v9fs_parse_options function uses strsep which modifies the value of the
v9ses->options field. That modified value is later passed to the function
that creates the transport potentially making the transport creation
function to fail.

This patch creates a copy of v9ses->option field that v9fs_parse_options
function uses instead of the original value.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 0c0b7fa3d4e80ab3e4e69b8a55661f649d1b41ff
tree eeb4ac6ea85387c153e3f7f6cad370e1c5dc8534
parent c9927c2bf4f45bb85e8b502ab3fb79ad6483c244
author Latchesar Ionkov <lucho@ionkov.net> 1193438132 -0600
committer Latchesar Ionkov <lucho@ionkov.net> 1193438132 -0600

 fs/9p/v9fs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 756f7e9..fbb12da 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -82,7 +82,7 @@ static match_table_t tokens = {
 
 static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 {
-	char *options = v9ses->options;
+	char *options;
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option;
@@ -96,9 +96,10 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 	v9ses->cache = 0;
 	v9ses->trans = v9fs_default_trans();
 
-	if (!options)
+	if (!v9ses->options)
 		return;
 
+	options = kstrdup(v9ses->options, GFP_KERNEL);
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 		if (!*p)
@@ -169,6 +170,7 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 			continue;
 		}
 	}
+	kfree(options);
 }
 
 /**
