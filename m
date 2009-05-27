Return-Path: <linux-kernel-owner+w=401wt.eu-S932505AbZE0SV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbZE0SV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbZE0SVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:21:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:52031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbZE0SVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:21:35 -0400
Message-Id: <20090527182100.740018486@chello.nl>
References: <20090527182021.231666503@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 20:20:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 2/7] perf_counter: tools: report: add vmlinux support
Content-Disposition: inline; filename=perf_counter-tools-report-sort.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to use vmlinux instead of kallsyms.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/builtin-report.c |   37 +++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

Index: linux-2.6/Documentation/perf_counter/builtin-report.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-report.c
+++ linux-2.6/Documentation/perf_counter/builtin-report.c
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
 

-- 

