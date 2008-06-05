Return-Path: <linux-kernel-owner+w=401wt.eu-S1762697AbYFEUEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762697AbYFEUEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYFEUEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:04:46 -0400
Received: from deep2.securesites.net ([198.65.247.173]:2483 "EHLO
	deep2.securesites.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYFEUEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:04:45 -0400
X-Greylist: delayed 2018 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 16:04:45 EDT
Date: Thu, 5 Jun 2008 13:30:50 -0600
From: Scott Wiersdorf <scott@perlcode.org>
To: Balbir Singh <balbir@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, matt@bluehost.com
Subject: [PATCH] getdelays.c
Message-ID: <20080605193050.GA3754@perlcode.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-Original-Status: RO
X-Original-Status: RO
X-Original-Status: RO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File: Documentation/accounting/getdelays.c

Linux version: 2.6.25-4

Description:

This patch adds a USR1 signal handler to getdelays.c, which causes
getdelays to close its logfile and reopen it (if '-w logfile' is
specified). This is useful in situations when getdelays is running for
a long time (i.e, the log file growing) and you need to rotate the
logs but don't want to lose any log data.


Sample usage:

1  # ./getdelays -m0,1,2,3 -l -w getdelays.log &
   (time passes)
2  # mv getdelays.log getdelays.log.1
3  # kill -USR1 <getdelays pid>

line 1: starts the program
line 2: renames the logfile. The log descriptor is still open and data
        being written to the log (assuming we didn't cross mountpoints)
line 3: getdelays closes the old descriptor and reopens getdelays.log


Note on 'volatile' usage:

I know this is generally frowned on, but I think it's needed here to
avoid the compiler optimizing away the variable (it will appear as if
it's never called, since it's value only changes in the signal
handler).


Patch:
<patch>
--- getdelays.c	2008-05-15 09:00:12.000000000 -0600
+++ getdelays.c	2008-06-05 02:23:57.000000000 -0600
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
</patch>

Scott
-- 
Scott Wiersdorf
<scott@perlcode.org>
