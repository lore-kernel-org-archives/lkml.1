Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbZFEXs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbZFEXs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbZFEXl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36415 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZFEXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:11 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 20/39] kbuild: allow docproc invocation from external
Date: Sat,  6 Jun 2009 01:42:38 +0200
Message-Id: <1244245377-17441-20-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

- getcwd returns path without a slash at the end, add the slash
- add KBUILD_SRC env support, so that we can specify path for
  kernel (to know where scripts/kernel-doc resides) and SRCTREE
  (for searching files referenced in .tmpl) separately

[v2]
- use KBUILD_SRC instead of a newly introduced environment variable

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/basic/docproc.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
index 35bdc68..4c9523e 100644
--- a/scripts/basic/docproc.c
+++ b/scripts/basic/docproc.c
@@ -69,7 +69,7 @@ FILELINE * docsection;
 #define NOFUNCTION    "-nofunction"
 #define NODOCSECTIONS "-no-doc-sections"
 
-char *srctree;
+static char *srctree, *kernsrctree;
 
 void usage (void)
 {
@@ -77,7 +77,8 @@ void usage (void)
 	fprintf(stderr, "Input is read from file.tmpl. Output is sent to stdout\n");
 	fprintf(stderr, "doc: frontend when generating kernel documentation\n");
 	fprintf(stderr, "depend: generate list of files referenced within file\n");
-	fprintf(stderr, "Environment variable SRCTREE: absolute path to kernel source tree.\n");
+	fprintf(stderr, "Environment variable SRCTREE: absolute path to sources.\n");
+	fprintf(stderr, "                     KBUILD_SRC: absolute path to kernel source tree.\n");
 }
 
 /*
@@ -96,8 +97,8 @@ void exec_kernel_doc(char **svec)
 			exit(1);
 		case  0:
 			memset(real_filename, 0, sizeof(real_filename));
-			strncat(real_filename, srctree, PATH_MAX);
-			strncat(real_filename, KERNELDOCPATH KERNELDOC,
+			strncat(real_filename, kernsrctree, PATH_MAX);
+			strncat(real_filename, "/" KERNELDOCPATH KERNELDOC,
 					PATH_MAX - strlen(real_filename));
 			execvp(real_filename, svec);
 			fprintf(stderr, "exec ");
@@ -178,6 +179,7 @@ void find_export_symbols(char * filename)
 		char real_filename[PATH_MAX + 1];
 		memset(real_filename, 0, sizeof(real_filename));
 		strncat(real_filename, srctree, PATH_MAX);
+		strncat(real_filename, "/", PATH_MAX - strlen(real_filename));
 		strncat(real_filename, filename,
 				PATH_MAX - strlen(real_filename));
 		sym = add_new_file(filename);
@@ -382,6 +384,9 @@ int main(int argc, char *argv[])
 	srctree = getenv("SRCTREE");
 	if (!srctree)
 		srctree = getcwd(NULL, 0);
+	kernsrctree = getenv("KBUILD_SRC");
+	if (!kernsrctree)
+		kernsrctree = srctree;
 	if (argc != 3) {
 		usage();
 		exit(1);
-- 
1.6.3.rc3.40.g75b44

