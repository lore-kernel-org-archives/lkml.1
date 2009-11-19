Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZKSQ4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZKSQ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZKSQ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:56:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:33035 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZKSQ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:56:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf tools: Don't die() in mmap_dispatch_perf_file
Date: Thu, 19 Nov 2009 14:55:57 -0200
Message-Id: <1258649757-17554-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258649757-17554-2-git-send-email-acme@infradead.org>
References: <1258649757-17554-1-git-send-email-acme@infradead.org>
 <1258649757-17554-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Propagate the error, that, interestingly, are already handled by all
callers :-)

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/data_map.c |   80 ++++++++++++++++++++++++--------------------
 1 files changed, 44 insertions(+), 36 deletions(-)

diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index b8fc0fa..5543e7d 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -106,7 +106,7 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    int *cwdlen,
 			    char **cwd)
 {
-	int err, rc = EXIT_FAILURE;
+	int err;
 	struct perf_header *header;
 	unsigned long head, shift;
 	unsigned long offset = 0;
@@ -118,64 +118,69 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 	int input;
 	char *buf;
 
-	if (!curr_handler)
-		die("Forgot to register perf file handler");
+	if (curr_handler == NULL) {
+		pr_debug("Forgot to register perf file handler\n");
+		return -EINVAL;
+	}
 
 	page_size = getpagesize();
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
-		fprintf(stderr, " failed to open file: %s", input_name);
+		pr_err("Failed to open file: %s", input_name);
 		if (!strcmp(input_name, "perf.data"))
-			fprintf(stderr, "  (try 'perf record' first)");
-		fprintf(stderr, "\n");
-		exit(-1);
+			pr_err("  (try 'perf record' first)");
+		pr_err("\n");
+		return -errno;
 	}
 
-	err = fstat(input, &input_stat);
-	if (err < 0) {
-		perror("failed to stat file");
-		exit(-1);
+	if (fstat(input, &input_stat) < 0) {
+		pr_err("failed to stat file");
+		err = -errno;
+		goto out_close;
 	}
 
+	err = -EACCES;
 	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user or root\n",
+		pr_err("file: %s not owned by current user or root\n",
 			input_name);
-		exit(-1);
+		goto out_close;
 	}
 
-	if (!input_stat.st_size) {
-		fprintf(stderr, "zero-sized file, nothing to do!\n");
-		exit(0);
+	if (input_stat.st_size == 0) {
+		pr_info("zero-sized file, nothing to do!\n");
+		goto done;
 	}
 
+	err = -ENOMEM;
 	header = perf_header__new();
 	if (header == NULL)
-		return -ENOMEM;
+		goto out_close;
 
 	err = perf_header__read(header, input);
-	if (err < 0) {
-		perf_header__delete(header);
-		return err;
-	}
+	if (err < 0)
+		goto out_delete;
 	*pheader = header;
 	head = header->data_offset;
 
 	sample_type = perf_header__sample_type(header);
 
-	if (curr_handler->sample_type_check)
-		if (curr_handler->sample_type_check(sample_type) < 0)
-			exit(-1);
+	err = -EINVAL;
+	if (curr_handler->sample_type_check &&
+	    curr_handler->sample_type_check(sample_type) < 0)
+		goto out_delete;
 
+	err = -ENOMEM;
 	if (load_kernel(NULL) < 0) {
-		perror("failed to load kernel symbols");
-		return EXIT_FAILURE;
+		pr_err("failed to load kernel symbols\n");
+		goto out_delete;
 	}
 
 	if (!full_paths) {
 		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
-			perror("failed to get the current directory");
-			return EXIT_FAILURE;
+			pr_err("failed to get the current directory\n");
+			err = -errno;
+			goto out_delete;
 		}
 		*cwd = __cwd;
 		*cwdlen = strlen(*cwd);
@@ -189,11 +194,12 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 	head -= shift;
 
 remap:
-	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
-			   MAP_SHARED, input, offset);
+	buf = mmap(NULL, page_size * mmap_window, PROT_READ,
+		   MAP_SHARED, input, offset);
 	if (buf == MAP_FAILED) {
-		perror("failed to mmap file");
-		exit(-1);
+		pr_err("failed to mmap file\n");
+		err = -errno;
+		goto out_delete;
 	}
 
 more:
@@ -250,10 +256,12 @@ more:
 		goto more;
 
 done:
-	rc = EXIT_SUCCESS;
+	err = 0;
+out_close:
 	close(input);
 
-	return rc;
+	return err;
+out_delete:
+	perf_header__delete(header);
+	goto out_close;
 }
-
-
-- 
1.6.2.5

