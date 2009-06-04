Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZFDTzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZFDTzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZFDTze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:55:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:47256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZFDTzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:55:33 -0400
Date: Thu, 4 Jun 2009 19:54:45 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1244141284-7507-1-git-send-email-fweisbec@gmail.com>
References: <1244141284-7507-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf_counter: Sleep before refresh using poll in perf top
Message-ID: <tip-0f5486b5c71a831a713ce356d8d06822e3c7c379@git.kernel.org>
Git-Commit-ID: 0f5486b5c71a831a713ce356d8d06822e3c7c379
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 19:54:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f5486b5c71a831a713ce356d8d06822e3c7c379
Gitweb:     http://git.kernel.org/tip/0f5486b5c71a831a713ce356d8d06822e3c7c379
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 4 Jun 2009 20:48:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 21:44:53 +0200

perf_counter: Sleep before refresh using poll in perf top

perf top is refreshed every delay_secs the thread runs in such
loop:

while (sleep(delay_secs)) {
	print_sym_table();
}

At the end of print_sym_table(), poll is used without sleep delay
to check if we have something from stdin.

It means that this check is done only every delay_secs, which can
be higher that 2 secs if the user defined a custom refresh rate.

We can drop sleep() here and directly use poll to wait between
refresh periods, so that the reaction after the user stops perf top
after typing "Enter" is immediate and doesn't suffer from the
delay_secs latency.

Nb: poll doesn't add any overhead that can parasite perf top measures
since it sleeps the entire timeout here.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1244141284-7507-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 31c00ba..28cbde4 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -204,7 +204,7 @@ static void print_sym_table(void)
 			list_remove_active_sym(syme);
 	}
 
-	write(1, CONSOLE_CLEAR, strlen(CONSOLE_CLEAR));
+	puts(CONSOLE_CLEAR);
 
 	printf(
 "------------------------------------------------------------------------------\n");
@@ -278,23 +278,21 @@ static void print_sym_table(void)
 		color_fprintf(stdout, color, "%4.1f%%", pcnt);
 		printf(" - %016llx : %s\n", sym->start, sym->name);
 	}
-
-	{
-		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
-
-		if (poll(&stdin_poll, 1, 0) == 1) {
-			printf("key pressed - exiting.\n");
-			exit(0);
-		}
-	}
 }
 
 static void *display_thread(void *arg)
 {
+	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
+	int delay_msecs = delay_secs * 1000;
+
 	printf("PerfTop refresh period: %d seconds\n", delay_secs);
 
-	while (!sleep(delay_secs))
+	do {
 		print_sym_table();
+	} while (!poll(&stdin_poll, 1, delay_msecs) == 1);
+
+	printf("key pressed - exiting.\n");
+	exit(0);
 
 	return NULL;
 }
