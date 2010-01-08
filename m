Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535Ab0AHMvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0AHMvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437Ab0AHMts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:49:48 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:37361 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0AHMtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:49:45 -0500
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 5/6] perf top: fix annotate for userspace
Date: Fri,  8 Jan 2010 15:23:08 +0300
Message-Id: <892bc7d6cb68ef90ff1e5ae166514bca9603a6b4.1262952612.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.6.6.79.gd514e.dirty
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, for programs and prelinked libraries, annotate code was fooled by
objdump output IPs (src->eip in the code) being wrongly converted to
absolute IPs. In such case there were no conversion needed, but in

    src->eip = strtoull(src->line, NULL, 16);
    src->eip = map->unmap_ip(map, src->eip);    // = eip + map->start - map->pgoff

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

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-top.c |   24 ++++++++++++++----------
 tools/perf/util/map.c    |    8 ++++++++
 tools/perf/util/map.h    |    3 ++-
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4067e4d..6aa9b02 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -176,6 +176,7 @@ static void parse_source(struct sym_entry *syme)
 	FILE *file;
 	char command[PATH_MAX*2];
 	const char *path;
+	char *tmp;
 	u64 len;
 
 	if (!syme)
@@ -204,8 +205,8 @@ static void parse_source(struct sym_entry *syme)
 	sprintf(command,
 		"objdump --start-address=0x%016Lx "
 			 "--stop-address=0x%016Lx -dS %s",
-		map->unmap_ip(map, sym->start),
-		map->unmap_ip(map, sym->end), path);
+		map__rip_2objdump(map, sym->start),
+		map__rip_2objdump(map, sym->end), path);
 
 	file = popen(command, "r");
 	if (!file)
@@ -235,14 +236,13 @@ static void parse_source(struct sym_entry *syme)
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
+
+		src->eip = strtoull(src->line, &tmp, 16);
+		if (*tmp == ':')
+			src->eip = map__objdump_2ip(map, src->eip);
+		else
+			/* this line has no ip info (e.g. source line) */
+			src->eip = 0;
 	}
 	pclose(file);
 out_assign:
@@ -277,6 +277,10 @@ static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
 		goto out_unlock;
 
 	for (line = syme->src->lines; line; line = line->next) {
+		/* skip lines without IP info */
+		if (line->eip == 0)
+			continue;
+
 		if (line->eip == ip) {
 			line->count[counter]++;
 			break;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index d6da969..37bfcc5 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -215,3 +215,11 @@ u64 map__rip_2objdump(struct map *map, u64 rip)
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
index 39fa478..2bcd9d4 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -49,8 +49,9 @@ static inline u64 identity__map_ip(struct map *map __used, u64 ip)
 }
 
 
-/* rip -> addr suitable for passing to `objdump --start-address=` */
+/* rip/ip <-> addr suitable for passing to `objdump --start-address=` */
 u64 map__rip_2objdump(struct map *map, u64 rip);
+u64 map__objdump_2ip(struct map *map, u64 addr);
 
 
 struct symbol;
-- 
1.6.6.79.gd514e.dirty
