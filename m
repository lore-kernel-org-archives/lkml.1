Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbZE0Kes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbZE0Kes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 06:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZE0Kej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 06:34:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:45265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZE0Kei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 06:34:38 -0400
Date: Wed, 27 May 2009 10:33:36 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Fix the profiling of existing pid or whole box
Message-ID: <tip-ef65b2a0b3a2f82850144df6e6a7796f6d66da6b@git.kernel.org>
Git-Commit-ID: ef65b2a0b3a2f82850144df6e6a7796f6d66da6b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 10:33:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef65b2a0b3a2f82850144df6e6a7796f6d66da6b
Gitweb:     http://git.kernel.org/tip/ef65b2a0b3a2f82850144df6e6a7796f6d66da6b
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 27 May 2009 10:10:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 12:31:03 +0200

perf record: Fix the profiling of existing pid or whole box

Perf record bails if no command argument is provided, so you can't use
naked -a or -p to profile a running task or the whole box.

Allow foreground profiling of an existing pid or the entire system.

[ Impact: fix command option handling bug ]

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 431077a..4a06866 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -354,7 +354,7 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
-	if (target_pid == -1) {
+	if (target_pid == -1 && argc) {
 		pid = fork();
 		if (pid < 0)
 			perror("failed to fork");
@@ -430,7 +430,7 @@ int cmd_record(int argc, const char **argv, const char *prefix)
 	create_events_help(events_help_msg);
 
 	argc = parse_options(argc, argv, options, record_usage, 0);
-	if (!argc)
+	if (!argc && target_pid == -1 && !system_wide)
 		usage_with_options(record_usage, options);
 
 	if (!nr_counters) {
