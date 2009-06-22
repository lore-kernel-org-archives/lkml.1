Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZFVPBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZFVPBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZFVPBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:01:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:49130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZFVPBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:01:12 -0400
Date: Mon, 22 Jun 2009 15:00:39 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf report: Output more symbol related debug data
Message-ID: <tip-d13c8eeb02770648dbd9097eb0ebeff70b2939be@git.kernel.org>
Git-Commit-ID: d13c8eeb02770648dbd9097eb0ebeff70b2939be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 22 Jun 2009 15:00:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d13c8eeb02770648dbd9097eb0ebeff70b2939be
Gitweb:     http://git.kernel.org/tip/d13c8eeb02770648dbd9097eb0ebeff70b2939be
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 22 Jun 2009 16:52:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 22 Jun 2009 16:59:32 +0200

perf report: Output more symbol related debug data

Print more symbol relocation related info under -vv.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    3 ++-
 tools/perf/util/symbol.c    |    4 ++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5eb5566..ae8fe37 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -814,7 +814,6 @@ resolve_symbol(struct thread *thread, struct map **mapp,
 			*mapp = map;
 got_map:
 		ip = map->map_ip(map, ip);
-		*ipp  = ip;
 
 		dso = map->dso;
 	} else {
@@ -828,6 +827,8 @@ got_map:
 		dso = kernel_dso;
 	}
 	dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+	dprintf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
+	*ipp  = ip;
 
 	if (dsop)
 		*dsop = dso;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 01b62fa..9c659ef 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -535,6 +535,10 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		gelf_getshdr(sec, &shdr);
 		obj_start = sym.st_value;
 
+		if (verbose >= 2)
+			printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
+				(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
+
 		sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 
 		f = symbol__new(sym.st_value, sym.st_size,
