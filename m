Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbZFDSsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbZFDSsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZFDSsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:48:08 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35604 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZFDSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LkqsfvWUGcVSnWtRYEmct5roLh4vVRAa6zcE5pm/ske1ycmCDKp9iu8Z1HqNTlPqTG
         1cySf6eVqSomX6dio8Zl6GnQpNRxlij9Hm0pjtXPzdydvOfgv7SvC5qfFJcNSW0i7q3L
         a/G04262temw9ZUAcslS3u9JnpWPPK5WpIyw4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perfcounter: sleep before refresh using poll in perf top
Date: Thu,  4 Jun 2009 20:48:04 +0200
Message-Id: <1244141284-7507-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 Documentation/perf_counter/builtin-top.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 31c00ba..a31beb3 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
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
-- 
1.6.2.3

