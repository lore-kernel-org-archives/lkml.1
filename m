Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbXKBI1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbXKBI1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 04:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXKBI1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 04:27:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33986 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXKBI1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 04:27:32 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 02 Nov 2007 13:56:58 +0530
Message-Id: <20071102082658.24616.78116.sendpatchset@balbir-laptop>
Subject: [PATCH] make getdelays cgroupstats aware
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This patch was dropped from the -mm tree and not merged back. Updated with
the name change of containerstats to cgroupstats

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/accounting/getdelays.c |   43 ++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff -puN Documentation/accounting/getdelays.c~csstats Documentation/accounting/getdelays.c
--- linux-2.6-latest/Documentation/accounting/getdelays.c~csstats	2007-11-02 13:17:52.000000000 +0530
+++ linux-2.6-latest-balbir/Documentation/accounting/getdelays.c	2007-11-02 13:21:31.000000000 +0530
@@ -25,6 +25,7 @@
 
 #include <linux/genetlink.h>
 #include <linux/taskstats.h>
+#include <linux/cgroupstats.h>
 
 /*
  * Generic macros for dealing with netlink sockets. Might be duplicated
@@ -78,6 +79,7 @@ static void usage(void)
 	fprintf(stderr, "  -i: print IO accounting (works only with -p)\n");
 	fprintf(stderr, "  -l: listen forever\n");
 	fprintf(stderr, "  -v: debug on\n");
+	fprintf(stderr, "  -C: container path\n");
 }
 
 /*
@@ -212,6 +214,14 @@ void task_context_switch_counts(struct t
 	       t->nvcsw, t->nivcsw);
 }
 
+void print_cgroupstats(struct cgroupstats *c)
+{
+	printf("sleeping %llu, blocked %llu, running %llu, stopped %llu, "
+		"uninterruptible %llu\n", c->nr_sleeping, c->nr_io_wait,
+		c->nr_running, c->nr_stopped, c->nr_uninterruptible);
+}
+
+
 void print_ioacct(struct taskstats *t)
 {
 	printf("%s: read=%llu, write=%llu, cancelled_write=%llu\n",
@@ -239,11 +249,14 @@ int main(int argc, char *argv[])
 	int maskset = 0;
 	char *logfile = NULL;
 	int loop = 0;
+	int containerset = 0;
+	char containerpath[1024];
+	int cfd = 0;
 
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "qdiw:r:m:t:p:vl");
+		c = getopt(argc, argv, "qdiw:r:m:t:p:vlC:");
 		if (c < 0)
 			break;
 
@@ -260,6 +273,10 @@ int main(int argc, char *argv[])
 			printf("printing task/process context switch rates\n");
 			print_task_context_switch_counts = 1;
 			break;
+		case 'C':
+			containerset = 1;
+			strncpy(containerpath, optarg, strlen(optarg) + 1);
+			break;
 		case 'w':
 			logfile = strdup(optarg);
 			printf("write to file %s\n", logfile);
@@ -334,6 +351,11 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (tid && containerset) {
+		fprintf(stderr, "Select either -t or -C, not both\n");
+		goto err;
+	}
+
 	if (tid) {
 		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
 			      cmd_type, &tid, sizeof(__u32));
@@ -344,6 +366,20 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (containerset) {
+		cfd = open(containerpath, O_RDONLY);
+		if (cfd < 0) {
+			perror("error opening container file");
+			goto err;
+		}
+		rc = send_cmd(nl_sd, id, mypid, CGROUPSTATS_CMD_GET,
+			      CGROUPSTATS_CMD_ATTR_FD, &cfd, sizeof(__u32));
+		if (rc < 0) {
+			perror("error sending cgroupstats command");
+			goto err;
+		}
+	}
+
 	do {
 		int i;
 
@@ -422,6 +458,9 @@ int main(int argc, char *argv[])
 				}
 				break;
 
+			case CGROUPSTATS_TYPE_CGROUP_STATS:
+				print_cgroupstats(NLA_DATA(na));
+				break;
 			default:
 				fprintf(stderr, "Unknown nla_type %d\n",
 					na->nla_type);
@@ -443,5 +482,7 @@ err:
 	close(nl_sd);
 	if (fd)
 		close(fd);
+	if (cfd)
+		close(cfd);
 	return 0;
 }
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
