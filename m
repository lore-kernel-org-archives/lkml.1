Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZJXBJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZJXBJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZJXBEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:51678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbZJXBEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:32 -0400
Date: Sat, 24 Oct 2009 01:03:49 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256061295-19835-1-git-send-email-acme@redhat.com>
References: <1256061295-19835-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf top: Fix symbol annotation
Message-ID: <tip-c88e4bf60de6253a048cf4e6b3b0715e543e0460@git.kernel.org>
Git-Commit-ID: c88e4bf60de6253a048cf4e6b3b0715e543e0460
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c88e4bf60de6253a048cf4e6b3b0715e543e0460
Gitweb:     http://git.kernel.org/tip/c88e4bf60de6253a048cf4e6b3b0715e543e0460
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 20 Oct 2009 15:54:55 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Oct 2009 21:12:59 +0200

perf top: Fix symbol annotation

We need to use map->unmap_ip() here too to match section
relative symbol address to the absolute address needed to match
objdump -dS addresses.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1256061295-19835-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
