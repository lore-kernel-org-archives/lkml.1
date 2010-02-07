Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab0BGQfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 11:35:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:41990 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab0BGQfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 11:35:33 -0500
Date: Sun, 7 Feb 2010 16:33:40 GMT
From: tip-bot for Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, kirr@landau.phys.spbu.ru, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1265550376-12665-1-git-send-email-acme@infradead.org>
References: <1265550376-12665-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Fix annotate for userspace
Message-ID: <tip-ee11b90b12eb1ec25e1044bac861e90bfd19ec9e@git.kernel.org>
Git-Commit-ID: ee11b90b12eb1ec25e1044bac861e90bfd19ec9e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 07 Feb 2010 16:33:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee11b90b12eb1ec25e1044bac861e90bfd19ec9e
Gitweb:     http://git.kernel.org/tip/ee11b90b12eb1ec25e1044bac861e90bfd19ec9e
Author:     Kirill Smelkov <kirr@landau.phys.spbu.ru>
AuthorDate: Sun, 7 Feb 2010 11:46:15 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Feb 2010 17:30:20 +0100

perf top: Fix annotate for userspace

First, for programs and prelinked libraries, annotate code was
fooled by objdump output IPs (src->eip in the code) being
wrongly converted to absolute IPs. In such case there were no
conversion needed, but in

   src->eip = strtoull(src->line, NULL, 16);
   src->eip = map->unmap_ip(map, src->eip); // = eip + map->start - map->pgoff

we were reading absolute address from objdump (e.g. 8048604) and
then almost doubling it, because eip & map->start are
approximately close for small programs.

Needless to say, that later, in record_precise_ip() there was no
matching with real runtime IPs.

And second, like with `perf annotate` the problem with
non-prelinked *.so was that we were doing rip -> objdump address
conversion wrong.

Also, because unlike `perf annotate`, `perf top` code does
annotation based on absolute IPs for performance reasons(*), new
helper for mapping objdump addresse to IP is introduced.

(*) we get samples info in absolute IPs, and since we do lots of
    hit-testing on absolute IPs at runtime in record_precise_ip(), it's
    better to convert objdump addresses to IPs once and do no conversion
    at runtime.

I also had to fix how objdump output is parsed (with hardcoded
8/16 characters format, which was inappropriate for ET_DYN dsos
with small addresses like '4ac')

Also note, that not all objdump output lines has associtated
IPs, e.g. look at source lines here:

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

So we mark them with eip=0, and ignore such lines in annotate
lookup code.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
[ Note: one hunk of this patch was applied by Mike in 57d8188 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1265550376-12665-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
