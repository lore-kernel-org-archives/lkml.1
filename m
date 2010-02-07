Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0BGNqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 08:46:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:55018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0BGNqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 08:46:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf top: Use address pattern in lookup_sym_source
Date: Sun,  7 Feb 2010 11:46:16 -0200
Message-Id: <1265550376-12665-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1265550376-12665-1-git-send-email-acme@infradead.org>
References: <1265550376-12665-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Because we may have aliases, like __GI___strcoll_l in
/lib64/libc-2.10.2.so that appears in objdump as:

$ objdump --start-address=0x0000003715a86420 \
           --stop-address=0x0000003715a872dc -dS /lib64/libc-2.10.2.so

0000003715a86420 <__strcoll_l>:
  3715a86420:	55                   	push   %rbp
  3715a86421:	48 89 e5             	mov    %rsp,%rbp
  3715a86424:	41 57                	push   %r15
[root@doppio linux-2.6-tip]#

So look for the address exactly at the start of the line instead so that
annotation can work for in these cases.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index befa57e..c72ab50 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -202,10 +202,9 @@ static void parse_source(struct sym_entry *syme)
 	len = sym->end - sym->start;
 
 	sprintf(command,
-		"objdump --start-address=0x%016Lx "
-			 "--stop-address=0x%016Lx -dS %s",
-		map__rip_2objdump(map, sym->start),
-		map__rip_2objdump(map, sym->end), path);
+		"objdump --start-address=%#0*Lx --stop-address=%#0*Lx -dS %s",
+		BITS_PER_LONG / 4, map__rip_2objdump(map, sym->start),
+		BITS_PER_LONG / 4, map__rip_2objdump(map, sym->end), path);
 
 	file = popen(command, "r");
 	if (!file)
@@ -292,13 +291,15 @@ static void lookup_sym_source(struct sym_entry *syme)
 {
 	struct symbol *symbol = sym_entry__symbol(syme);
 	struct source_line *line;
-	char pattern[PATH_MAX];
+	const size_t pattern_len = BITS_PER_LONG / 4 + 2;
+	char pattern[pattern_len + 1];
 
-	sprintf(pattern, "<%s>:", symbol->name);
+	sprintf(pattern, "%0*Lx <", BITS_PER_LONG / 4,
+		map__rip_2objdump(syme->map, symbol->start));
 
 	pthread_mutex_lock(&syme->src->lock);
 	for (line = syme->src->lines; line; line = line->next) {
-		if (strstr(line->line, pattern)) {
+		if (memcmp(line->line, pattern, pattern_len) == 0) {
 			syme->src->source = line;
 			break;
 		}
-- 
1.6.2.5

