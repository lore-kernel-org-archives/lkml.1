Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894Ab0ASSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0ASSAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631Ab0ASSAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:00:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34318 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0ASSAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:00:40 -0500
Date: Tue, 19 Jan 2010 18:00:28 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Shailabh Nagar <nagar@watson.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] delay-accounting: Re-implement -c for getdelays.c to
	report  information on a target command
Message-ID: <20100119180027.GA5154@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Task delay-accounting was identified as one means of determining how long
a process spends in congestion_wait() without adding new statistics. For
example, if the workload should not be doing IO, delay-accounting could
reveal how long it was spending in unexpected IO or delays. Unfortunately,
on closer examination it was clear that getdelays does not act as documented.

Commit a3baf649 added Documentation/accounting/getdelays.c with a -c switch
that was documented to fork/exec a child and report statistics on it but for
reasons that are unclear to me, commit 9e06d3f9 deleted support for this
switch but did not update the documentation. It might be an oversight or
it might be because the control flow of the program meant that accounting
information would be printed once early in the lifetime of the program
making it of limited use.

This patch reimplements -c for getdelays.c to act as documented. Unlike the
original version, it waits until the command completes before printing any
information on it. An example of it being used looks like

$ ./getdelays -d -c find /home/mel -name mel
print delayacct stats ON
/home/mel
/home/mel/.notes-wine/drive_c/windows/profiles/mel
/home/mel/.wine/drive_c/windows/profiles/mel
/home/mel/git-configs/dot.kde/share/apps/konqueror/home/mel
PID	5923

CPU             count     real total  virtual total    delay total
                42779     5051232096     5164722692      564207988
IO              count    delay total
                41727    97804147758
SWAP            count    delay total
                    0              0
RECLAIM         count    delay total
                    0              0

It's not clear how or if this subsystem is being maintained. If the
authors agree on it but do not pick it up for merging, I'll go bug
Andrew with it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 Documentation/accounting/getdelays.c |   37 +++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 6e25c26..c6648bc 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -21,6 +21,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
+#include <sys/wait.h>
 #include <signal.h>
 
 #include <linux/genetlink.h>
@@ -266,11 +267,13 @@ int main(int argc, char *argv[])
 	int containerset = 0;
 	char containerpath[1024];
 	int cfd = 0;
+	int forking = 0;
+	sigset_t sigset;
 
 	struct msgtemplate msg;
 
-	while (1) {
-		c = getopt(argc, argv, "qdiw:r:m:t:p:vlC:");
+	while (!forking) {
+		c = getopt(argc, argv, "qdiw:r:m:t:p:vlC:c:");
 		if (c < 0)
 			break;
 
@@ -319,6 +322,27 @@ int main(int argc, char *argv[])
 				err(1, "Invalid pid\n");
 			cmd_type = TASKSTATS_CMD_ATTR_PID;
 			break;
+		case 'c':
+
+			/* Block SIGCHLD for sigwait() later */
+			if (sigemptyset(&sigset) == -1)
+				err(1, "Failed to empty sigset");
+			if (sigaddset(&sigset, SIGCHLD))
+				err(1, "Failed to set sigchld in sigset");
+			sigprocmask(SIG_BLOCK, &sigset, NULL);
+
+			/* fork/exec a child */
+			tid = fork();
+			if (tid < 0)
+				err(1, "Fork failed\n");
+			if (tid == 0)
+				if (execvp(argv[optind - 1], &argv[optind - 1]) < 0)
+					exit(-1);
+
+			/* Set the command type and avoid further processing */
+			cmd_type = TASKSTATS_CMD_ATTR_PID;
+			forking = 1;
+			break;
 		case 'v':
 			printf("debug on\n");
 			dbg = 1;
@@ -370,6 +394,15 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
+	/*
+	 * If we forked a child, wait for it to exit. Cannot use waitpid()
+	 * as all the delicious data would be reaped as part of the wait 
+	 */
+	if (tid && forking) {
+		int sig_received;
+		sigwait(&sigset, &sig_received);
+	}
+
 	if (tid) {
 		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
 			      cmd_type, &tid, sizeof(__u32));
