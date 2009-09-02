Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbZIBNBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbZIBNBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZIBNBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:01:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZIBNBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:01:24 -0400
Date: Wed, 2 Sep 2009 13:00:52 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Work around strict aliasing related warnings
Message-ID: <tip-65014ab36196f6d86edc9ee23759d6930b9d89a8@git.kernel.org>
Git-Commit-ID: 65014ab36196f6d86edc9ee23759d6930b9d89a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 13:00:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65014ab36196f6d86edc9ee23759d6930b9d89a8
Gitweb:     http://git.kernel.org/tip/65014ab36196f6d86edc9ee23759d6930b9d89a8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 2 Sep 2009 14:55:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Sep 2009 14:56:33 +0200

perf tools: Work around strict aliasing related warnings

Older versions of GCC are rather stupid about strict aliasing:

  util/trace-event-parse.c: In function 'parse_cmdlines':
  util/trace-event-parse.c:93: warning: dereferencing type-punned pointer will break strict-aliasing rules
  util/trace-event-parse.c: In function 'parse_proc_kallsyms':
  util/trace-event-parse.c:155: warning: dereferencing type-punned pointer will break strict-aliasing rules
  util/trace-event-parse.c:157: warning: dereferencing type-punned pointer will break strict-aliasing rules
  util/trace-event-parse.c:158: warning: dereferencing type-punned pointer will break strict-aliasing rules
  util/trace-event-parse.c: In function 'parse_ftrace_printk':
  util/trace-event-parse.c:294: warning: dereferencing type-punned pointer will break strict-aliasing rules
  util/trace-event-parse.c:295: warning: dereferencing type-punned pointer will break strict-aliasing rules
  make: *** [util/trace-event-parse.o] Error 1

Make it clear to GCC that we intend with those pointers, by passing
them through via an explicit (void *) cast.

We might want to add -fno-strict-aliasing as well, like the kernel
itself does.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/trace-event-info.c  |    2 +-
 tools/perf/util/trace-event-parse.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 8161527..6c9302a 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -188,7 +188,7 @@ int bigendian(void)
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
 	unsigned int *ptr;
 
-	ptr = (unsigned int *)str;
+	ptr = (unsigned int *)(void *)str;
 	return *ptr == 0x01020304;
 }
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 665dac2..37b10c2 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -90,7 +90,7 @@ void parse_cmdlines(char *file, int size __unused)
 	while (line) {
 		item = malloc_or_die(sizeof(*item));
 		sscanf(line, "%d %as", &item->pid,
-		       (float *)&item->comm); /* workaround gcc warning */
+		       (float *)(void *)&item->comm); /* workaround gcc warning */
 		item->next = list;
 		list = item;
 		line = strtok_r(NULL, "\n", &next);
@@ -152,10 +152,10 @@ void parse_proc_kallsyms(char *file, unsigned int size __unused)
 		item = malloc_or_die(sizeof(*item));
 		item->mod = NULL;
 		ret = sscanf(line, "%as %c %as\t[%as",
-			     (float *)&addr_str, /* workaround gcc warning */
+			     (float *)(void *)&addr_str, /* workaround gcc warning */
 			     &ch,
-			     (float *)&item->func,
-			     (float *)&item->mod);
+			     (float *)(void *)&item->func,
+			     (float *)(void *)&item->mod);
 		item->addr = strtoull(addr_str, NULL, 16);
 		free(addr_str);
 
@@ -291,8 +291,8 @@ void parse_ftrace_printk(char *file, unsigned int size __unused)
 	while (line) {
 		item = malloc_or_die(sizeof(*item));
 		ret = sscanf(line, "%as : %as",
-			     (float *)&addr_str, /* workaround gcc warning */
-			     (float *)&item->printk);
+			     (float *)(void *)&addr_str, /* workaround gcc warning */
+			     (float *)(void *)&item->printk);
 		item->addr = strtoull(addr_str, NULL, 16);
 		free(addr_str);
 
