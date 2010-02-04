Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab0BDTeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:34:12 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:48484 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab0BDTeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:34:09 -0500
Date: Thu, 4 Feb 2010 22:34:04 +0300
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 8/9] perf annotate: fix it for non-prelinked *.so
Message-ID: <20100204193403.GA22781@landau.phys.spbu.ru>
References: <1265223128-11786-1-git-send-email-acme@infradead.org> <1265223128-11786-8-git-send-email-acme@infradead.org> <1265265106.6364.5.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265265106.6364.5.camel@marge.simson.net>
Organization: St.Petersburg State University
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 07:31:46AM +0100, Mike Galbraith wrote:
> On Wed, 2010-02-03 at 16:52 -0200, Arnaldo Carvalho de Melo wrote:
> >  		const char *path = NULL;
> > @@ -397,7 +397,8 @@ static void annotate_sym(struct hist_entry *he)
> >  		       dso, dso->long_name, sym, sym->name);
> >  
> >  	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s",
> > -		map->unmap_ip(map, sym->start), map->unmap_ip(map, sym->end),
> > +		map__rip_2objdump(map, sym->start),
> > +		map__rip_2objdump(map, sym->end),
> >  		filename, filename);
> >  
> 
> Monkey see monkey do.
> 
> perf tools: fix perf top module symbol annotation.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: <new-submission>
> 
> ---
>  tools/perf/builtin-top.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/tools/perf/builtin-top.c
> ===================================================================
> --- linux-2.6.orig/tools/perf/builtin-top.c
> +++ linux-2.6/tools/perf/builtin-top.c
> @@ -204,8 +204,8 @@ static void parse_source(struct sym_entr
>  	sprintf(command,
>  		"objdump --start-address=0x%016Lx "
>  			 "--stop-address=0x%016Lx -dS %s",
> -		map->unmap_ip(map, sym->start),
> -		map->unmap_ip(map, sym->end), path);
> +		map__rip_2objdump(map, sym->start),
> +		map__rip_2objdump(map, sym->end), path);

If I recall correctly, that's not enough.

The problem is top code is also wrong at mapping objdump addresses to
absolute ip. That is another part of builtin-top.c which does
map->unmap_ip(), and I've already suggested a fix back at holidays:

http://marc.info/?l=linux-kernel&m=126295508002536&w=2

For the reference, here it is again:

   ( P.S. and Arnaldo, I'm sorry I still had no luck with spare time.
          Overloaded me ... )

---- 8< ----

From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Date: Fri,  8 Jan 2010 15:23:08 +0300
Subject: [PATCH 5/6] perf top: fix annotate for userspace

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
