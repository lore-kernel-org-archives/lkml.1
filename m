Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbZE0Twp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbZE0Twp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932695AbZE0TwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:52:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:51411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbZE0TwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:52:22 -0400
Date: Wed, 27 May 2009 19:51:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090527182100.740018486@chello.nl>
References: <20090527182100.740018486@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: tools: report: Add vmlinux support
Message-ID: <tip-450aaa2b2a1b006870ba68251fbb40b2387caade@git.kernel.org>
Git-Commit-ID: 450aaa2b2a1b006870ba68251fbb40b2387caade
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 19:51:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  450aaa2b2a1b006870ba68251fbb40b2387caade
Gitweb:     http://git.kernel.org/tip/450aaa2b2a1b006870ba68251fbb40b2387caade
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 May 2009 20:20:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 21:44:12 +0200

perf_counter: tools: report: Add vmlinux support

Allow to use vmlinux instead of kallsyms.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090527182100.740018486@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   37 ++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index a9ff49a..3e87cbd 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -19,6 +19,7 @@
 #define SHOW_HV		4
 
 static char		const *input_name = "perf.data";
+static char		*vmlinux = NULL;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
@@ -532,6 +533,39 @@ out_delete_dso:
 	return -1;
 }
 
+static int load_kernel(void)
+{
+	int fd, nr;
+
+	if (!vmlinux)
+		goto kallsyms;
+
+	fd = open(vmlinux, O_RDONLY);
+	if (fd < 0)
+		goto kallsyms;
+
+	kernel_dso = dso__new("[kernel]");
+	if (!kernel_dso)
+		goto fail_open;
+
+	nr = dso__load_sym(kernel_dso, fd, vmlinux);
+
+	if (nr <= 0)
+		goto fail_load;
+
+	dsos__add(kernel_dso);
+	close(fd);
+
+	return 0;
+
+fail_load:
+	dso__delete(kernel_dso);
+fail_open:
+	close(fd);
+kallsyms:
+	return load_kallsyms();
+}
+
 struct map {
 	struct list_head node;
 	uint64_t	 start;
@@ -850,7 +884,7 @@ static int __cmd_report(void)
 		exit(0);
 	}
 
-	if (load_kallsyms() < 0) {
+	if (load_kernel() < 0) {
 		perror("failed to open kallsyms");
 		return EXIT_FAILURE;
 	}
@@ -1039,6 +1073,7 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
+	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
 	OPT_END()
 };
 
