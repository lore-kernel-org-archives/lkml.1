Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYKXU4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYKXU4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYKXUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:53:38 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36285 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYKXUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:53:34 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>, kbuild <linux-kbuild@vger.kernel.org>
Cc: "Sally, Gene" <Gene.Sally@timesys.com>, gene.sally@timesys.com,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 7/8] kbuild: gen_init_cpio expands shell variables in file names
Date: Mon, 24 Nov 2008 21:54:54 +0100
Message-Id: <1227560095-32597-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.GIT
In-Reply-To: <20081124205150.GA32497@uranus.ravnborg.org>
References: <20081124205150.GA32497@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sally, Gene <Gene.Sally@timesys.com>

Modify gen_init_cpio so that lines that specify files can contain
what looks like a shell variable that's expanded during processing.

For example:

   file /sbin/kinit ${RFS_BASE}/usr/src/klibc/kinit/kinit 0755 0 0

given RFS_BASE is "/some/directory" in the environment

would be expanded to

   file /sbin/kinit /some/directory/usr/src/klibc/kinit/kinit 0755 0 0

If several environment variables appear in a line, they are all expanded
with processing happening from left to right.
Undefined variables expand to a null string.
Syntax errors stop processing, letting the existing error handling
show the user offending line.

This patch helps embedded folks who frequently create several
RFS directories and then switch between them as they're tuning
an initramfs.

Signed-off-by: gene.sally@timesys.com
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 usr/gen_init_cpio.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 7abc07f..f1d3fe3 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -370,6 +370,30 @@ error:
 	return rc;
 }
 
+static char *cpio_replace_env(char *new_location)
+{
+       char expanded[PATH_MAX + 1];
+       char env_var[PATH_MAX + 1];
+       char *start;
+       char *end;
+
+       for (start = NULL; (start = strstr(new_location, "${")); ) {
+               end = strchr(start, '}');
+               if (start < end) {
+                       *env_var = *expanded = '\0';
+                       strncat(env_var, start + 2, end - start - 2);
+                       strncat(expanded, new_location, start - new_location);
+                       strncat(expanded, getenv(env_var), PATH_MAX);
+                       strncat(expanded, end + 1, PATH_MAX);
+                       strncpy(new_location, expanded, PATH_MAX);
+               } else
+                       break;
+       }
+
+       return new_location;
+}
+
+
 static int cpio_mkfile_line(const char *line)
 {
 	char name[PATH_MAX + 1];
@@ -415,7 +439,8 @@ static int cpio_mkfile_line(const char *line)
 	} else {
 		dname = name;
 	}
-	rc = cpio_mkfile(dname, location, mode, uid, gid, nlinks);
+	rc = cpio_mkfile(dname, cpio_replace_env(location),
+	                 mode, uid, gid, nlinks);
  fail:
 	if (dname_len) free(dname);
 	return rc;
@@ -439,6 +464,7 @@ void usage(const char *prog)
 		"\n"
 		"<name>       name of the file/dir/nod/etc in the archive\n"
 		"<location>   location of the file in the current filesystem\n"
+		"             expands shell variables quoted with ${}\n"
 		"<target>     link target\n"
 		"<mode>       mode/permissions of the file\n"
 		"<uid>        user id (0=root)\n"
-- 
1.5.6.GIT

