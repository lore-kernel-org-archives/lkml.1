Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbXJXWQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbXJXWQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXJXWOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:14:04 -0400
Received: from xenotime.net ([66.160.160.81]:59150 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755766AbXJXWOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:14:01 -0400
Date: Wed, 24 Oct 2007 15:08:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Johannes Berg <johannes@sipsolutions.net>,
       sam@ravnborg.org
Subject: [PATCH 6/6] kernel-doc: new P directive for DOC: sections
Message-ID: <11932637283771@xenotime.net>
In-Reply-To: <11932637282902@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

The !P directive includes the contents of a DOC: section
given by title, e.g.
!Pfilename Title of the section

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 scripts/basic/docproc.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- linux-2.6.23-git19.orig/scripts/basic/docproc.c
+++ linux-2.6.23-git19/scripts/basic/docproc.c
@@ -30,6 +30,7 @@
  *		!Ifilename
  *		!Dfilename
  *		!Ffilename
+ *		!Pfilename
  *
  */
 
@@ -57,6 +58,7 @@ FILEONLY *symbolsonly;
 typedef void FILELINE(char * file, char * line);
 FILELINE * singlefunctions;
 FILELINE * entity_system;
+FILELINE * docsection;
 
 #define MAXLINESZ     2048
 #define MAXFILES      250
@@ -289,12 +291,36 @@ void singfunc(char * filename, char * li
 }
 
 /*
+ * Insert specific documentation section from a file.
+ * Call kernel-doc with the following parameters:
+ * kernel-doc -docbook -function "doc section" filename
+ */
+void docsect(char *filename, char *line)
+{
+	char *vec[6]; /* kerneldoc -docbook -function "section" file NULL */
+	char *s;
+
+	for (s = line; *s; s++)
+		if (*s == '\n')
+			*s = '\0';
+
+	vec[0] = KERNELDOC;
+	vec[1] = DOCBOOK;
+	vec[2] = FUNCTION;
+	vec[3] = line;
+	vec[4] = filename;
+	vec[5] = NULL;
+	exec_kernel_doc(vec);
+}
+
+/*
  * Parse file, calling action specific functions for:
  * 1) Lines containing !E
  * 2) Lines containing !I
  * 3) Lines containing !D
  * 4) Lines containing !F
- * 5) Default lines - lines not matching the above
+ * 5) Lines containing !P
+ * 6) Default lines - lines not matching the above
  */
 void parse_file(FILE *infile)
 {
@@ -328,6 +354,15 @@ void parse_file(FILE *infile)
 						s++;
 					singlefunctions(line +2, s);
 					break;
+				case 'P':
+					/* filename */
+					while (*s && !isspace(*s)) s++;
+					*s++ = '\0';
+					/* DOC: section name */
+					while (isspace(*s))
+						s++;
+					docsection(line +2, s);
+					break;
 				default:
 					defaultline(line);
 			}
@@ -374,6 +409,7 @@ int main(int argc, char *argv[])
 		externalfunctions = find_export_symbols;
 		symbolsonly       = find_export_symbols;
 		singlefunctions   = noaction2;
+		docsection        = noaction2;
 		parse_file(infile);
 
 		/* Rewind to start from beginning of file again */
@@ -383,6 +419,7 @@ int main(int argc, char *argv[])
 		externalfunctions = extfunc;
 		symbolsonly       = printline;
 		singlefunctions   = singfunc;
+		docsection        = docsect;
 
 		parse_file(infile);
 	}
@@ -396,6 +433,7 @@ int main(int argc, char *argv[])
 		externalfunctions = adddep;
 		symbolsonly       = adddep;
 		singlefunctions   = adddep2;
+		docsection        = adddep2;
 		parse_file(infile);
 		printf("\n");
 	}


-- 

