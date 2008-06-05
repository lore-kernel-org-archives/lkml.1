Return-Path: <linux-kernel-owner+w=401wt.eu-S1763169AbYFEUI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763169AbYFEUI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYFEUIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:08:20 -0400
Received: from c-67-164-200-215.hsd1.ut.comcast.net ([67.164.200.215]:2583
	"EHLO home.perlcode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYFEUIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:08:19 -0400
X-Greylist: delayed 1443 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 16:08:18 EDT
Date: Thu, 5 Jun 2008 13:43:35 -0600
From: Scott Wiersdorf <scott@perlcode.org>
To: Balbir Singh <balbir@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, matt@bluehost.com
Subject: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
Message-ID: <20080605194334.GA56830@perlcode.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a USR1 signal handler to getdelays.c, which causes getdelays
to close its logfile and reopen it (if '-w logfile' is
specified). This is useful in situations when getdelays is running for
a long time (i.e, the log file growing) and you need to rotate the
logs but don't want to lose any log data.

Signed-off-by: Scott Wiersdorf <scott@perlcode.org>
---
--- Documentation/accounting/getdelays.c	2008-05-15 09:00:12.000000000 -0600
+++ Documentation/accounting/getdelays.c	2008-06-05 02:23:57.000000000 -0600
@@ -50,6 +50,7 @@ int dbg;
 int print_delays;
 int print_io_accounting;
 int print_task_context_switch_counts;
+volatile sig_atomic_t reopen_log = 0;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -80,6 +81,7 @@ static void usage(void)
 	fprintf(stderr, "  -l: listen forever\n");
 	fprintf(stderr, "  -v: debug on\n");
 	fprintf(stderr, "  -C: container path\n");
+	fprintf(stderr, "\nSend USR1 to reopen the logfile if -w is used.\n");
 }
 
 /*
@@ -231,6 +233,30 @@ void print_ioacct(struct taskstats *t)
 		(unsigned long long)t->cancelled_write_bytes);
 }
 
+void catch_usr1(int sig)
+{
+	reopen_log = 1;
+	signal(sig, catch_usr1);
+}
+
+int reopen_logfile(int fd, char *logfile)
+{
+	if (fd) {
+		PRINTF("USR1 received. Closing logfile.\n");
+		close(fd);
+	}
+	fd = open(logfile, O_WRONLY | O_CREAT | O_TRUNC,
+		  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+	if (fd == -1) {
+		perror("Cannot open output file\n");
+		exit(1);
+	}
+
+	reopen_log = 0;
+
+	return fd;
+}
+
 int main(int argc, char *argv[])
 {
 	int c, rc, rep_len, aggr_len, len2, cmd_type;
@@ -320,12 +346,8 @@ int main(int argc, char *argv[])
 	}
 
 	if (write_file) {
-		fd = open(logfile, O_WRONLY | O_CREAT | O_TRUNC,
-			  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
-		if (fd == -1) {
-			perror("Cannot open output file\n");
-			exit(1);
-		}
+		fd = reopen_logfile(fd, logfile);
+		signal(SIGUSR1, catch_usr1); /* only set when write_file is set */
 	}
 
 	if ((nl_sd = create_nl_socket(NETLINK_GENERIC)) < 0)
@@ -444,6 +466,9 @@ int main(int argc, char *argv[])
 								err(1,"write error\n");
 							}
 						}
+						if (reopen_log) {
+							fd = reopen_logfile(fd, logfile);
+						}
 						if (!loop)
 							goto done;
 						break;

