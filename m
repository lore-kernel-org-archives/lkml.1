Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYAPAGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYAPAGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYAPAGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:06:12 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:38116 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYAPAGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:06:11 -0500
Date: Tue, 15 Jan 2008 16:05:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: bjorn.helgaas@hp.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH] ia64 aliasing-test: fix gcc warnings on non-ia64
Message-Id: <20080115160510.76d2bfbc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate all build warnings.  OK, these build warnings are from
a build on x86_64.  When I build on ia64, I don't see warnings.

Now builds cleanly on ia64 and x86_64.

Documentation/ia64/aliasing-test.c: In function 'map_mem':
Documentation/ia64/aliasing-test.c:39: warning: implicit declaration of function 'ioctl'
Documentation/ia64/aliasing-test.c: In function 'scan_rom':
Documentation/ia64/aliasing-test.c:183: warning: format '%ld' expects type 'long int', but argument 4 has type 'int'
Documentation/ia64/aliasing-test.c: At top level:
Documentation/ia64/aliasing-test.c:208: warning: function declaration isn't a prototype
Documentation/ia64/aliasing-test.c: In function 'main':
Documentation/ia64/aliasing-test.c:259: warning: control reaches end of non-void function
Documentation/ia64/aliasing-test.c: In function 'scan_rom':
Documentation/ia64/aliasing-test.c:152: warning: 'rc' may be used uninitialized in this function
Documentation/ia64/aliasing-test.c: In function 'scan_tree':
Documentation/ia64/aliasing-test.c:68: warning: 'rc' may be used uninitialized in this function

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/ia64/aliasing-test.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- linux-2.6.24-rc7.orig/Documentation/ia64/aliasing-test.c
+++ linux-2.6.24-rc7/Documentation/ia64/aliasing-test.c
@@ -16,6 +16,7 @@
 #include <fcntl.h>
 #include <fnmatch.h>
 #include <string.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <unistd.h>
@@ -65,7 +66,7 @@ int scan_tree(char *path, char *file, of
 {
 	struct dirent **namelist;
 	char *name, *path2;
-	int i, n, r, rc, result = 0;
+	int i, n, r, rc = 0, result = 0;
 	struct stat buf;
 
 	n = scandir(path, &namelist, 0, alphasort);
@@ -113,7 +114,7 @@ skip:
 		free(namelist[i]);
 	}
 	free(namelist);
-	return rc;
+	return result;
 }
 
 char buf[1024];
@@ -149,7 +150,7 @@ int scan_rom(char *path, char *file)
 {
 	struct dirent **namelist;
 	char *name, *path2;
-	int i, n, r, rc, result = 0;
+	int i, n, r, rc = 0, result = 0;
 	struct stat buf;
 
 	n = scandir(path, &namelist, 0, alphasort);
@@ -180,7 +181,7 @@ int scan_rom(char *path, char *file)
 			 * important thing is that no MCA happened.
 			 */
 			if (rc > 0)
-				fprintf(stderr, "PASS: %s read %ld bytes\n", path2, rc);
+				fprintf(stderr, "PASS: %s read %d bytes\n", path2, rc);
 			else {
 				fprintf(stderr, "PASS: %s not readable\n", path2);
 				return rc;
@@ -201,10 +202,10 @@ skip:
 		free(namelist[i]);
 	}
 	free(namelist);
-	return rc;
+	return result;
 }
 
-int main()
+int main(void)
 {
 	int rc;
 
@@ -256,4 +257,6 @@ int main()
 	scan_tree("/proc/bus/pci", "??.?", 0xA0000, 0x20000, 0);
 	scan_tree("/proc/bus/pci", "??.?", 0xC0000, 0x40000, 1);
 	scan_tree("/proc/bus/pci", "??.?", 0, 1024*1024, 0);
+
+	return rc;
 }
