Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504Ab0AHMud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0AHMud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459Ab0AHMtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:49:51 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:37366 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0AHMtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:49:47 -0500
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 4/6] perf annotate: fix it for non-prelinked *.so
Date: Fri,  8 Jan 2010 15:23:07 +0300
Message-Id: <17ba5387f6273bff22b44d869f94c7c58e9118fb.1262952612.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.6.6.79.gd514e.dirty
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem was we were incorrectly calculating objdump addresses for
sym->start and sym->end, look:

For simple ET_DYN type DSO (*.so) with one function, objdump -dS output
is something like this:

    000004ac <my_strlen>:
    int my_strlen(const char *s)
     4ac:   55                      push   %ebp
     4ad:   89 e5                   mov    %esp,%ebp
     4af:   83 ec 10                sub    $0x10,%esp
    {

i.e. we have relative-to-dso-mapping IPs (=RIP) there.

For ET_EXEC type and probably for prelinked libs as well (sorry can't
test - I don't use prelink) objdump outputs absolute IPs, e.g.

    08048604 <zz_strlen>:
    extern "C"
    int zz_strlen(const char *s)
     8048604:       55                      push   %ebp
     8048605:       89 e5                   mov    %esp,%ebp
     8048607:       83 ec 10                sub    $0x10,%esp
    {

So, if sym->start is always relative to dso mapping(*), we'll have to
unmap it for ET_EXEC like cases, and leave as is for ET_DYN cases.

(*) and it is - we've explicitely made it relative. Look for
    adjust_symbols handling in dso__load_sym()

Previously we were always unmapping sym->start and for ET_DYN dsos
resulting addresses were wrong, and so objdump output was empty.

The end result was that perf annotate output for symbols from
non-prelinked *.so had always 0.00% percents only, which is wrong.

----

To fix it, let's introduce a helper for converting rip to objdump
address, and also let's document what map_ip() and unmap_ip() do -- I
had to study sources for several hours to understand it.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/util/map.c         |   14 ++++++++++++++
 tools/perf/util/map.h         |    9 +++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 117bbae..117301a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -195,7 +195,7 @@ static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 			line_ip = -1;
 	}
 
-	start = he->map->unmap_ip(he->map, sym->start);
+	start = map__rip_2objdump(he->map, sym->start);
 
 	if (line_ip != -1) {
 		const char *path = NULL;
@@ -405,7 +405,7 @@ static void annotate_sym(struct hist_entry *he)
 		       dso, dso->long_name, sym, sym->name);
 
 	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s",
-		map->unmap_ip(map, sym->start), map->unmap_ip(map, sym->end),
+		map__rip_2objdump(map, sym->start), map__rip_2objdump(map, sym->end),
 		filename, filename);
 
 	if (verbose >= 3)
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index c4d55a0..d6da969 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -201,3 +201,17 @@ size_t map__fprintf(struct map *self, FILE *fp)
 	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
 		       self->start, self->end, self->pgoff, self->dso->name);
 }
+
+
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
index 72f0b6a..39fa478 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -24,8 +24,12 @@ struct map {
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
 
@@ -44,6 +48,11 @@ static inline u64 identity__map_ip(struct map *map __used, u64 ip)
 	return ip;
 }
 
+
+/* rip -> addr suitable for passing to `objdump --start-address=` */
+u64 map__rip_2objdump(struct map *map, u64 rip);
+
+
 struct symbol;
 struct mmap_event;
 
-- 
1.6.6.79.gd514e.dirty
