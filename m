Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYIYQ6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYIYQ6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYIYQ5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:57:54 -0400
Received: from mail.collax.com ([82.194.105.242]:35593 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYIYQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:57:53 -0400
X-Greylist: delayed 1815 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2008 12:57:52 EDT
Message-ID: <48DBBBF1.3050407@collax.com>
Date: Thu, 25 Sep 2008 18:27:29 +0200
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: SMACK startproc patch
Content-Type: multipart/mixed;
 boundary="------------020508070507090209000006"
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 25092008 #1124361, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020508070507090209000006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry if i pollute the wrong list with my stuff. But SMACK does not seem 
to have it's own list and now lives in the kernel. Though this is 
userspace related...

The smack howto mentions a not yet implemented smack option for 
start-stop-daemon.
We mainly use startproc. So i made a patch which adds this functionality 
to startproc.

It adds the option [-S LABEL] to startproc, which brings the called 
process up with /proc/self/attr/current = LABEL.
I figured setting the security context should happen after things like 
pidfiles where written. But this is certainly up for discussion.

This patch applies to killproc version 2.08.

Please enjoy and comment.

Regards
  Tilman Baumann

-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942

--------------020508070507090209000006
Content-Type: text/x-patch;
 name="killproc-smack.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="killproc-smack.diff"

diff -Nur killproc-2.08.orig/startproc.c killproc-2.08/startproc.c
--- killproc-2.08.orig/startproc.c	2005-05-25 15:40:58.000000000 +0200
+++ killproc-2.08/startproc.c	2008-09-15 19:49:21.000000000 +0200
@@ -17,6 +17,7 @@
  * 1998/05/06 Werner Fink: rework, added "-p" for pid files
  * 1999/08/05 Werner Fink: added "-t" for time to sleep, reenable "-e"
  * 2000/11/10 Werner Fink: LSB specs, logging
+ * 2008/09/15 Tilman Baumann <tilman.baumann@collax.com>: Smack labels
  */
 
 #include "libinit.h"
@@ -26,12 +27,12 @@
 #include <grp.h>
 
 #define USAGE		"Usage:\n"\
-			"\t%s [-f] [+/-<prio>] [-s] [-u uid] [-g gid] [-v] [-l log_file|-q] /full/path/to/program\n"
+			"\t%s [-f] [+/-<prio>] [-s] [-u uid] [-g gid] [-v] [-l log_file|-q] [-S smacklabel] /full/path/to/program\n"
 #define USAGE_SD	"Usage:\n"\
 			"\t%s [-f] [-n +/-<prio>] /full/path/to/program\n"
 
 static int do_fork(const char *name, char *argv[], const char* log_file,
-		   const int nicelvl, const int env, const char* root, unsigned short flags);
+		   const int nicelvl, const int env, const char* root, unsigned short flags, const char *smack);
 
 static int quiet = 1, supprmsg = 0, sess = 0, seconds = 0, force = 0, dialog = 0;
 static struct passwd *user = NULL;
@@ -54,6 +55,7 @@
     char *fullname = NULL, *basename = NULL;
     char *log_file = NULL, *pid_file = NULL, *ignore_file = NULL;
     char *root = NULL;
+    char *smack = NULL;
     int nicelvl = 0, env = 0;
     unsigned short flags = (DAEMON|PIDOF);
 
@@ -81,7 +83,7 @@
     }
 
     opterr = 0;
-    while ((c = getopt(argc, argv, "+c:edp:l:hqvsu:g:t:n:fLi:")) != -1) { /* `+' is POSIX correct */
+    while ((c = getopt(argc, argv, "+c:edp:l:hqvsu:S:g:t:n:fLi:")) != -1) { /* `+' is POSIX correct */
 	switch (c) {
 	    case 'v':
 		quiet = 0;
@@ -211,6 +213,12 @@
 	    case 'h':
 		error(0, (strcmp("startproc", we_are) ? USAGE_SD : USAGE), we_are);
 		break;
+            case 'S':
+		if (optarg && optarg[0] != '/' && optarg[0] != '-') {
+                    smack = optarg;
+		} else
+                    error(LSB_WRGSYN,"Option -S requires a smack label string\n");
+		break;
 	    default:
 		break;
 	}
@@ -310,7 +318,7 @@
 	exit(LSB_OK);		/* Accordingly to LSB we have succeed. */
 
 force:
-    (void)do_fork(fullname, argv, log_file, nicelvl, env, root, flags);
+    (void)do_fork(fullname, argv, log_file, nicelvl, env, root, flags, smack);
 
     /* Do we have started it? */
 
@@ -340,7 +348,7 @@
 
 /* The core function */
 static int do_fork(const char *inname, char *argv[], const char* log_file,
-		   const int nicelvl, const int env, const char* root, unsigned short flags)
+		   const int nicelvl, const int env, const char* root, unsigned short flags, const char *smack)
 {
     extern char * we_are;
     int tty = 255;
@@ -474,6 +482,16 @@
 		    close(devnull);
 	    }
 	}
+	if (smack) {
+	    FILE *smack_current;
+	    if ((smack_current = fopen("/proc/self/attr/current", "w")) == 0 ) {
+	        error(LSB_PROOF," can not set smack label (missing capability?). %s\n", strerror(errno));
+	    } else {
+	        fprintf(smack_current, "%s", smack);
+		fclose(smack_current);
+	    }
+	    
+	}
 	fflush(stdout);
 	fflush(stderr);		/* flush stdout and especially stderr */
 	closelog();

--------------020508070507090209000006--
