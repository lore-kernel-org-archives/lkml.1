Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbYFFVE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbYFFVE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYFFVEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:04:50 -0400
Received: from deep2.securesites.net ([198.65.247.173]:1177 "EHLO
	deep2.securesites.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbYFFVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:04:50 -0400
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 17:04:49 EDT
Date: Fri, 6 Jun 2008 14:40:06 -0600
From: Scott Wiersdorf <scott@bluehost.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, matt@bluehost.com
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
Message-ID: <20080606204005.GA4283@perlcode.org>
References: <20080605194334.GA56830@perlcode.org> <4848B305.9080305@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4848B305.9080305@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-Original-Status: RO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 09:16:13AM +0530, Balbir Singh wrote:
> >  #define PRINTF(fmt, arg...) {			\
> > @@ -80,6 +81,7 @@ static void usage(void)
> >  	fprintf(stderr, "  -l: listen forever\n");
> >  	fprintf(stderr, "  -v: debug on\n");
> >  	fprintf(stderr, "  -C: container path\n");
> > +	fprintf(stderr, "\nSend USR1 to reopen the logfile if -w is used.\n");
> 
> Please mention that old data will be lost and that SIGUSR1 will take affect
> after some data is received.

See below.

> Aren't we better of using the newer sigaction primitives? IIRC, signal can be
> racy. The man page states "Avoid its use"

I've rewritten this to use the new sigaction (bottom of this email). Thanks!

> > +int reopen_logfile(int fd, char *logfile)
> > +{
> > +	if (fd) {
> > +		PRINTF("USR1 received. Closing logfile.\n");
> > +		close(fd);
> > +	}
> > +	fd = open(logfile, O_WRONLY | O_CREAT | O_TRUNC,
> > +		  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
> 
> So sending USR1 causes data to be lost?

Yes, if you don't move the old file out of the way first. Sending a
USR1 can also be used to rotate the log:

  # ./getdelays -m0,1 -l -w logfile &
  (time passes)
  # mv logfile logfile.0
  # kill -USR1 <pid>

Or to truncate the log:

  # ./getdelays -m0,1 -l -w logfile &
  (time passes)
  # kill -USR1 <pid>

> > +						if (reopen_log) {
> > +							fd = reopen_logfile(fd, logfile);
> > +						}
> 
> This seems way of the 80 character space. You have braces that are not required.

Yeah, I'm all for saving one line ;-) (fixed in this new patch)


Signed-off-by: Scott Wiersdorf <scott@perlcode.org>

---
--- Documentation/accounting/getdelays.c	2008-05-15 09:00:12.000000000 -0600
+++ Documentation/accounting/getdelays.c	2008-06-06 14:34:37.000000000 -0600
@@ -50,6 +50,8 @@ int dbg;
 int print_delays;
 int print_io_accounting;
 int print_task_context_switch_counts;
+volatile sig_atomic_t reopen_log;
+struct sigaction sig_usr1;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -80,6 +82,8 @@ static void usage(void)
 	fprintf(stderr, "  -l: listen forever\n");
 	fprintf(stderr, "  -v: debug on\n");
 	fprintf(stderr, "  -C: container path\n");
+	fprintf(stderr, "\nSend USR1 to reopen and truncate the logfile (if \
+-w is used). New log is\ncreated after next netlink datum is received.\n");
 }
 
 /*
@@ -231,6 +235,30 @@ void print_ioacct(struct taskstats *t)
 		(unsigned long long)t->cancelled_write_bytes);
 }
 
+void catch_usr1(int sig)
+{
+	reopen_log = 1;
+	sigaction(SIGUSR1, &sig_usr1, NULL);
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
@@ -320,12 +348,11 @@ int main(int argc, char *argv[])
 	}
 
 	if (write_file) {
-		fd = open(logfile, O_WRONLY | O_CREAT | O_TRUNC,
-			  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
-		if (fd == -1) {
-			perror("Cannot open output file\n");
-			exit(1);
-		}
+		fd = reopen_logfile(fd, logfile);
+		sig_usr1.sa_handler = catch_usr1;
+		memset (&sig_usr1.sa_mask, 0x00, sizeof(sigset_t));
+		sig_usr1.sa_flags = SA_RESTART;
+		sigaction(SIGUSR1, &sig_usr1, NULL);
 	}
 
 	if ((nl_sd = create_nl_socket(NETLINK_GENERIC)) < 0)
@@ -444,6 +471,8 @@ int main(int argc, char *argv[])
 								err(1,"write error\n");
 							}
 						}
+						if (reopen_log)
+							fd = reopen_logfile(fd, logfile);
 						if (!loop)
 							goto done;
 						break;
