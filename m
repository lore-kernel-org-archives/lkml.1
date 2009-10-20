Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZJTRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZJTRzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZJTRzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:55:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZJTRzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:55:42 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf top: Fix symbol annotation
Date: Tue, 20 Oct 2009 15:54:55 -0200
Message-Id: <1256061295-19835-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use map->unmap_ip() here too to match section relative symbol
address to the absolute address needed to match objdump -dS addresses.

Reported-by: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index cc66286..fa20345 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -141,7 +141,8 @@ static void parse_source(struct sym_entry *syme)
 	sprintf(command,
 		"objdump --start-address=0x%016Lx "
 			 "--stop-address=0x%016Lx -dS %s",
-		sym->start, sym->end, path);
+		map->unmap_ip(map, sym->start),
+		map->unmap_ip(map, sym->end), path);
 
 	file = popen(command, "r");
 	if (!file)
@@ -173,11 +174,11 @@ static void parse_source(struct sym_entry *syme)
 
 		if (strlen(src->line)>8 && src->line[8] == ':') {
 			src->eip = strtoull(src->line, NULL, 16);
-			src->eip += map->start;
+			src->eip = map->unmap_ip(map, src->eip);
 		}
 		if (strlen(src->line)>8 && src->line[16] == ':') {
 			src->eip = strtoull(src->line, NULL, 16);
-			src->eip += map->start;
+			src->eip = map->unmap_ip(map, src->eip);
 		}
 	}
 	pclose(file);
-- 
1.5.5.1

