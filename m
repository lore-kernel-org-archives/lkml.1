Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXJIGZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXJIGZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXJIGZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:25:25 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58551
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752301AbXJIGZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:25:24 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: akpm@linux-foundation.org
Subject: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
Date: Tue, 9 Oct 2007 01:25:18 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710090125.19089.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Prevent docproc from segfaulting when SRCTREE isn't set.

Signed-off-by: Rob Landley <rob@landley.net>
---

 scripts/basic/docproc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -r a26a53ed1101 scripts/basic/docproc.c
--- a/scripts/basic/docproc.c	Sun Oct 07 16:42:22 2007 -0700
+++ b/scripts/basic/docproc.c	Tue Oct 09 01:08:54 2007 -0500
@@ -64,12 +64,15 @@ FILELINE * entity_system;
 #define FUNCTION      "-function"
 #define NOFUNCTION    "-nofunction"
 
+char *srctree;
+
 void usage (void)
 {
 	fprintf(stderr, "Usage: docproc {doc|depend} file\n");
 	fprintf(stderr, "Input is read from file.tmpl. Output is sent to stdout\n");
 	fprintf(stderr, "doc: frontend when generating kernel documentation\n");
 	fprintf(stderr, "depend: generate list of files referenced within file\n");
+	fprintf(stderr, "Environment variable SRCTREE: absolute path to kernel source tree.\n");
 }
 
 /*
@@ -88,7 +91,7 @@ void exec_kernel_doc(char **svec)
 			exit(1);
 		case  0:
 			memset(real_filename, 0, sizeof(real_filename));
-			strncat(real_filename, getenv("SRCTREE"), PATH_MAX);
+			strncat(real_filename, srctree, PATH_MAX);
 			strncat(real_filename, KERNELDOCPATH KERNELDOC,
 					PATH_MAX - strlen(real_filename));
 			execvp(real_filename, svec);
@@ -168,7 +171,7 @@ void find_export_symbols(char * filename
 	if (filename_exist(filename) == NULL) {
 		char real_filename[PATH_MAX + 1];
 		memset(real_filename, 0, sizeof(real_filename));
-		strncat(real_filename, getenv("SRCTREE"), PATH_MAX);
+		strncat(real_filename, srctree, PATH_MAX);
 		strncat(real_filename, filename,
 				PATH_MAX - strlen(real_filename));
 		sym = add_new_file(filename);
@@ -335,6 +338,9 @@ int main(int argc, char *argv[])
 int main(int argc, char *argv[])
 {
 	FILE * infile;
+
+	srctree = getenv("SRCTREE");
+	if (!srctree) srctree = getcwd(NULL,0);
 	if (argc != 3) {
 		usage();
 		exit(1);

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
