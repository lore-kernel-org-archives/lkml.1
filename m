Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZAEOI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZAEOI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZAEOIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:08:48 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:46890 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbZAEOIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:08:47 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 1/1] scripts: allow docproc invocation from external
Date: Mon,  5 Jan 2009 15:08:30 +0100
Message-Id: <1231164510-14355-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- getcwd returns path without slash at the end, add the slash
- add KERNSRCTREE env, so that we can specify path for kernel
  (for knowing where to find scripts/kernel-doc) and SRCTREE
  (for searching files referenced in .tmpl) separately

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/basic/docproc.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
index 35bdc68..c716ae8 100644
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
+	fprintf(stderr, "                     KERNSRCTREE: absolute path to kernel source tree.\n");
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
+	kernsrctree = getenv("KERNSRCTREE");
+	if (!kernsrctree)
+		kernsrctree = srctree;
 	if (argc != 3) {
 		usage();
 		exit(1);
-- 
1.6.0.6

