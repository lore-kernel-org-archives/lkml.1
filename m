Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZGUFBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZGUFBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZGUFBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:01:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:58064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZGUFBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:01:12 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] taskstats-fork: Update the sample program getdelays.c to include fork notification
Date: Tue, 21 Jul 2009 10:31:56 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211031.56242.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the sample program, Documentation/accounting/getdelays.c to print a
message whenever a new task forks/clones in the cpumask specified. Change the
command-line option -m used to specify the cpumask to register to receive
taskstas on exit as -e and add an option -f for fork notification.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index aa73e72..fcbec43 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -69,12 +69,13 @@ struct msgtemplate {
 	char buf[MAX_MSG_SIZE];
 };
 
-char cpumask[100+6*MAX_CPUS];
+char fork_cpumask[100+6*MAX_CPUS];
+char exit_cpumask[100+6*MAX_CPUS];
 
 static void usage(void)
 {
 	fprintf(stderr, "getdelays [-dilv] [-w logfile] [-r bufsize] "
-			"[-m cpumask] [-t tgid] [-p pid]\n");
+			"[-e cpumask] [-f cpumask] [-t tgid] [-p pid]\n");
 	fprintf(stderr, "  -d: print delayacct stats\n");
 	fprintf(stderr, "  -i: print IO accounting (works only with -p)\n");
 	fprintf(stderr, "  -l: listen forever\n");
@@ -260,7 +261,8 @@ int main(int argc, char *argv[])
 	int fd = 0;
 	int count = 0;
 	int write_file = 0;
-	int maskset = 0;
+	int fork_maskset = 0;
+	int exit_maskset = 0;
 	char *logfile = NULL;
 	int loop = 0;
 	int containerset = 0;
@@ -270,7 +272,7 @@ int main(int argc, char *argv[])
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "qdiw:r:m:t:p:vlC:");
+		c = getopt(argc, argv, "qdiw:r:e:f:t:p:vlC:");
 		if (c < 0)
 			break;
 
@@ -302,10 +304,15 @@ int main(int argc, char *argv[])
 			if (rcvbufsz < 0)
 				err(1, "Invalid rcv buf size\n");
 			break;
-		case 'm':
-			strncpy(cpumask, optarg, sizeof(cpumask));
-			maskset = 1;
-			printf("cpumask %s maskset %d\n", cpumask, maskset);
+		case 'f':
+			strncpy(fork_cpumask, optarg, sizeof(fork_cpumask));
+			fork_maskset = 1;
+			printf("fork_cpumask %s maskset %d\n", fork_cpumask, fork_maskset);
+			break;
+		case 'e':
+			strncpy(exit_cpumask, optarg, sizeof(exit_cpumask));
+			exit_maskset = 1;
+			printf("exit_cpumask %s maskset %d\n", exit_cpumask, exit_maskset);
 			break;
 		case 't':
 			tid = atoi(optarg);
@@ -354,10 +361,21 @@ int main(int argc, char *argv[])
 	}
 	PRINTF("family id %d\n", id);
 
-	if (maskset) {
+	if (fork_maskset) {
+		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
+			      TASKSTATS_CMD_ATTR_REGISTER_FORK_CPUMASK,
+			      &fork_cpumask, strlen(fork_cpumask) + 1);
+		PRINTF("Sent register fork cpumask, retval %d\n", rc);
+		if (rc < 0) {
+			fprintf(stderr, "error sending register fork cpumask\n");
+			goto err;
+		}
+	}
+
+	if (exit_maskset) {
 		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
 			      TASKSTATS_CMD_ATTR_REGISTER_CPUMASK,
-			      &cpumask, strlen(cpumask) + 1);
+			      &exit_cpumask, strlen(exit_cpumask) + 1);
 		PRINTF("Sent register cpumask, retval %d\n", rc);
 		if (rc < 0) {
 			fprintf(stderr, "error sending register cpumask\n");
@@ -393,7 +411,7 @@ int main(int argc, char *argv[])
 			goto err;
 		}
 	}
-	if (!maskset && !tid && !containerset) {
+	if (!fork_maskset && !exit_maskset && !tid && !containerset) {
 		usage();
 		goto err;
 	}
@@ -429,6 +447,9 @@ int main(int argc, char *argv[])
 		while (len < rep_len) {
 			len += NLA_ALIGN(na->nla_len);
 			switch (na->nla_type) {
+			case TASKSTATS_TYPE_PID_TGID:
+				printf("New Task: \n");
+				/* Fall through */
 			case TASKSTATS_TYPE_AGGR_TGID:
 				/* Fall through */
 			case TASKSTATS_TYPE_AGGR_PID:
@@ -488,10 +509,18 @@ int main(int argc, char *argv[])
 		}
 	} while (loop);
 done:
-	if (maskset) {
+	if (fork_maskset) {
+		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
+			      TASKSTATS_CMD_ATTR_DEREGISTER_FORK_CPUMASK,
+			      &fork_cpumask, strlen(fork_cpumask) + 1);
+		printf("Sent deregister fork mask, retval %d\n", rc);
+		if (rc < 0)
+			err(rc, "error sending deregister fork cpumask\n");
+	}
+	if (exit_maskset) {
 		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
 			      TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK,
-			      &cpumask, strlen(cpumask) + 1);
+			      &exit_cpumask, strlen(exit_cpumask) + 1);
 		printf("Sent deregister mask, retval %d\n", rc);
 		if (rc < 0)
 			err(rc, "error sending deregister cpumask\n");

