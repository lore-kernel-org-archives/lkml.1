Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0BGNrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 08:47:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:55020 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0BGNrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 08:47:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf top: fix annotate for userspace
Date: Sun,  7 Feb 2010 11:46:15 -0200
Message-Id: <1265550376-12665-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Smelkov <kirr@landau.phys.spbu.ru>

First, for programs and prelinked libraries, annotate code was fooled by
objdump output IPs (src->eip in the code) being wrongly converted to
absolute IPs. In such case there were no conversion needed, but in

   src->eip = strtoull(src->line, NULL, 16);
   src->eip = map->unmap_ip(map, src->eip); // = eip + map->start - map->pgoff

we were reading absolute address from objdump (e.g. 8048604) and then
almost doubling it, because eip & map->start are approximately close for
small programs.

Needless to say, that later, in record_precise_ip() there was no
matching with real runtime IPs.

And second, like with `perf annotate` the problem with non-prelinked
*.so was that we were doing rip -> objdump address conversion wrong.

Also, because unlike `perf annotate`, `perf top` code does annotation based on
absolute IPs for performance reasons(*), new helper for mapping objdump
addresse to IP is introduced.

(*) we get samples info in absolute IPs, and since we do lots of
    hit-testing on absolute IPs at runtime in record_precise_ip(), it's
    better to convert objdump addresses to IPs once and do no conversion
    at runtime.

I also had to fix how objdump output is parsed (with hardcoded 8/16
characters format, which was inappropriate for ET_DYN dsos with small
addresses like '4ac')

Also note, that not all objdump output lines has associtated IPs, e.g.
look at source lines here:

    000004ac <my_strlen>:
    extern "C"
    int my_strlen(const char *s)
     4ac:   55                      push   %ebp
     4ad:   89 e5                   mov    %esp,%ebp
     4af:   83 ec 10                sub    $0x10,%esp
    {
        int len = 0;
     4b2:   c7 45 fc 00 00 00 00    movl   $0x0,-0x4(%ebp)
     4b9:   eb 08                   jmp    4c3 <my_strlen+0x17>

        while (*s) {
            ++len;
     4bb:   83 45 fc 01             addl   $0x1,-0x4(%ebp)
            ++s;
     4bf:   83 45 08 01             addl   $0x1,0x8(%ebp)

So we mark them with eip=0, and ignore such lines in annotate lookup
code.

Commiter note: one hunk of this patch was applied by Mike in 57d8188.

Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   18 +++++++++---------
 tools/perf/util/map.c    |    8 ++++++++
 tools/perf/util/map.h    |    4 ++--
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e4156bc..befa57e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -216,7 +216,7 @@ static void parse_source(struct sym_entry *syme)
 	while (!feof(file)) {
 		struct source_line *src;
 		size_t dummy = 0;
-		char *c;
+		char *c, *sep;
 
 		src = malloc(sizeof(struct source_line));
 		assert(src != NULL);
@@ -235,14 +235,11 @@ static void parse_source(struct sym_entry *syme)
 		*source->lines_tail = src;
 		source->lines_tail = &src->next;
 
-		if (strlen(src->line)>8 && src->line[8] == ':') {
-			src->eip = strtoull(src->line, NULL, 16);
-			src->eip = map->unmap_ip(map, src->eip);
-		}
-		if (strlen(src->line)>8 && src->line[16] == ':') {
-			src->eip = strtoull(src->line, NULL, 16);
-			src->eip = map->unmap_ip(map, src->eip);
-		}
+		src->eip = strtoull(src->line, &sep, 16);
+		if (*sep == ':')
+			src->eip = map__objdump_2ip(map, src->eip);
+		else /* this line has no ip info (e.g. source line) */
+			src->eip = 0;
 	}
 	pclose(file);
 out_assign:
@@ -277,6 +274,9 @@ static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
 		goto out_unlock;
 
 	for (line = syme->src->lines; line; line = line->next) {
+		/* skip lines without IP info */
+		if (line->eip == 0)
+			continue;
 		if (line->eip == ip) {
 			line->count[counter]++;
 			break;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index af5805f..138e3cb 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -222,3 +222,11 @@ u64 map__rip_2objdump(struct map *map, u64 rip)
 			rip;
 	return addr;
 }
+
+u64 map__objdump_2ip(struct map *map, u64 addr)
+{
+	u64 ip = map->dso->adjust_symbols ?
+			addr :
+			map->unmap_ip(map, addr);	/* RIP -> IP */
+	return ip;
+}
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 9cee9c7..86f77cb 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -61,9 +61,9 @@ static inline u64 identity__map_ip(struct map *map __used, u64 ip)
 }
 
 
-/* rip -> addr suitable for passing to `objdump --start-address=` */
+/* rip/ip <-> addr suitable for passing to `objdump --start-address=` */
 u64 map__rip_2objdump(struct map *map, u64 rip);
-
+u64 map__objdump_2ip(struct map *map, u64 addr);
 
 struct symbol;
 struct mmap_event;
-- 
1.6.2.5

