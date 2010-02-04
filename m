Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab0BDJz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:55:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:52243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab0BDJz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:55:56 -0500
Date: Thu, 4 Feb 2010 09:54:20 GMT
From: tip-bot for Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, kirr@landau.phys.spbu.ru, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1265223128-11786-8-git-send-email-acme@infradead.org>
References: <1265223128-11786-8-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix it for non-prelinked *.so
Message-ID: <tip-7a2b6209863626cf8362e5ff4653491558f91e67@git.kernel.org>
Git-Commit-ID: 7a2b6209863626cf8362e5ff4653491558f91e67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:54:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a2b6209863626cf8362e5ff4653491558f91e67
Gitweb:     http://git.kernel.org/tip/7a2b6209863626cf8362e5ff4653491558f91e67
Author:     Kirill Smelkov <kirr@landau.phys.spbu.ru>
AuthorDate: Wed, 3 Feb 2010 16:52:07 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:33:27 +0100

perf annotate: Fix it for non-prelinked *.so

The problem was we were incorrectly calculating objdump
addresses for sym->start and sym->end, look:

For simple ET_DYN type DSO (*.so) with one function, objdump -dS
output is something like this:

    000004ac <my_strlen>:
    int my_strlen(const char *s)
     4ac:   55                      push   %ebp
     4ad:   89 e5                   mov    %esp,%ebp
     4af:   83 ec 10                sub    $0x10,%esp
    {

i.e. we have relative-to-dso-mapping IPs (=RIP) there.

For ET_EXEC type and probably for prelinked libs as well (sorry
can't test - I don't use prelink) objdump outputs absolute IPs,
e.g.

    08048604 <zz_strlen>:
    extern "C"
    int zz_strlen(const char *s)
     8048604:       55                      push   %ebp
     8048605:       89 e5                   mov    %esp,%ebp
     8048607:       83 ec 10                sub    $0x10,%esp
    {

So, if sym->start is always relative to dso mapping(*), we'll
have to unmap it for ET_EXEC like cases, and leave as is for
ET_DYN cases.

(*) and it is - we've explicitely made it relative. Look for
    adjust_symbols handling in dso__load_sym()

Previously we were always unmapping sym->start and for ET_DYN
dsos resulting addresses were wrong, and so objdump output was
empty.

The end result was that perf annotate output for symbols from
non-prelinked *.so had always 0.00% percents only, which is
wrong.

To fix it, let's introduce a helper for converting rip to
objdump address, and also let's document what map_ip() and
unmap_ip() do -- I had to study sources for several hours to
understand it.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1265223128-11786-8-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |    5 +++--
 tools/perf/util/map.c         |   12 ++++++++++++
 tools/perf/util/map.h         |    9 +++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4fc3899..28ea4e0 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -189,7 +189,7 @@ static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 			line_ip = -1;
 	}
 
-	start = he->map->unmap_ip(he->map, sym->start);
+	start = map__rip_2objdump(he->map, sym->start);
 
 	if (line_ip != -1) {
 		const char *path = NULL;
@@ -397,7 +397,8 @@ static void annotate_sym(struct hist_entry *he)
 		       dso, dso->long_name, sym, sym->name);
 
 	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s",
-		map->unmap_ip(map, sym->start), map->unmap_ip(map, sym->end),
+		map__rip_2objdump(map, sym->start),
+		map__rip_2objdump(map, sym->end),
 		filename, filename);
 
 	if (verbose >= 3)
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index f6626cc..af5805f 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -210,3 +210,15 @@ size_t map__fprintf(struct map *self, FILE *fp)
 	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
 		       self->start, self->end, self->pgoff, self->dso->name);
 }
+
+/*
+ * objdump wants/reports absolute IPs for ET_EXEC, and RIPs for ET_DYN.
+ * map->dso->adjust_symbols==1 for ET_EXEC-like cases.
+ */
+u64 map__rip_2objdump(struct map *map, u64 rip)
+{
+	u64 addr = map->dso->adjust_symbols ?
+			map->unmap_ip(map, rip) :	/* RIP -> IP */
+			rip;
+	return addr;
+}
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index de04839..9cee9c7 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -26,8 +26,12 @@ struct map {
 	u64			end;
 	enum map_type		type;
 	u64			pgoff;
+
+	/* ip -> dso rip */
 	u64			(*map_ip)(struct map *, u64);
+	/* dso rip -> ip */
 	u64			(*unmap_ip)(struct map *, u64);
+
 	struct dso		*dso;
 };
 
@@ -56,6 +60,11 @@ static inline u64 identity__map_ip(struct map *map __used, u64 ip)
 	return ip;
 }
 
+
+/* rip -> addr suitable for passing to `objdump --start-address=` */
+u64 map__rip_2objdump(struct map *map, u64 rip);
+
+
 struct symbol;
 struct mmap_event;
 
