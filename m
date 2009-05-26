Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZEZO0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZEZO0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZEZO0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:26:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:52962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZEZO0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:26:15 -0400
Date: Tue, 26 May 2009 14:24:43 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Fix kernel symbol resolution
Message-ID: <tip-59d81029b6804c3d5895d07cad77d7dfddc6b5b2@git.kernel.org>
Git-Commit-ID: 59d81029b6804c3d5895d07cad77d7dfddc6b5b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 14:24:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59d81029b6804c3d5895d07cad77d7dfddc6b5b2
Gitweb:     http://git.kernel.org/tip/59d81029b6804c3d5895d07cad77d7dfddc6b5b2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 26 May 2009 11:14:27 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 16:19:05 +0200

perf report: Fix kernel symbol resolution

kallsyms have just the symbol start, so we need to read two lines
to get the len.

[ Impact: fix incorrect kernel symbol display in perf report ]

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   30 ++++++++++++++++++++------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 697f960..b19b893 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -360,9 +360,17 @@ static int load_kallsyms(void)
 	char *line = NULL;
 	size_t n;
 
+	if (getline(&line, &n, file) < 0 || !line)
+		goto out_delete_dso;
+
+	unsigned long long previous_start;
+	char c, previous_symbf[4096];
+	if (sscanf(line, "%llx %c %s", &previous_start, &c, previous_symbf) != 3)
+		goto out_delete_line;
+
 	while (!feof(file)) {
 		unsigned long long start;
-		char c, symbf[4096];
+		char symbf[4096];
 
 		if (getline(&line, &n, file) < 0)
 			break;
@@ -371,12 +379,18 @@ static int load_kallsyms(void)
 			goto out_delete_dso;
 
 		if (sscanf(line, "%llx %c %s", &start, &c, symbf) == 3) {
-			struct symbol *sym = symbol__new(start, 0x1000000, symbf);
+			if (start > previous_start) {
+				struct symbol *sym = symbol__new(previous_start,
+								 start - previous_start,
+								 previous_symbf);
 
-			if (sym == NULL)
-				goto out_delete_dso;
+				if (sym == NULL)
+					goto out_delete_dso;
 
-			dso__insert_symbol(kernel_dso, sym);
+				dso__insert_symbol(kernel_dso, sym);
+				previous_start = start;
+				strcpy(previous_symbf, symbf);
+			}
 		}
 	}
 
@@ -385,6 +399,8 @@ static int load_kallsyms(void)
 	fclose(file);
 	return 0;
 
+out_delete_line:
+	free(line);
 out_delete_dso:
 	dso__delete(kernel_dso);
 	return -1;
