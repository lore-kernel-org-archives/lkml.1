Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZEZWVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZEZWVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbZEZWVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:21:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39425 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbZEZWVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:21:32 -0400
Date: Tue, 26 May 2009 19:20:57 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2 tip] perf: Use hex2long instead of sscanf
Message-ID: <20090526222057.GI4424@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 660a7bf4bd5ac8dad5f33b59527f670b4039208e Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 26 May 2009 18:34:18 -0300
Subject: [PATCH] perf: Use hex2long instead of sscanf

Before:

[acme@emilia ~]$ perf record -o perf_report.perf perf stat perf report > /dev/null

 Performance counter stats for 'perf':

     245.414985  task clock ticks     (msecs)
              6  context switches     (events)
              6  CPU migrations       (events)
           2108  pagefaults           (events)
       37493013  CPU cycles           (events)  (scaled from 67.04%)
       13576789  instructions         (events)  (scaled from 66.76%)
          57931  cache references     (events)  (scaled from 21.96%)
          12263  cache misses         (events)  (scaled from 21.98%)

 Wall-clock time elapsed:   246.575587 msecs

[acme@emilia ~]$ perf report -i perf_report.perf | head
12.15          perf [.] 0x000000000005432a /lib64/libc-2.5.so: _IO_vfscanf_internal
 9.38          perf [k] 0xffffffff8101b1d2 intel_pmu_enable_all
 8.53          perf [.] 0x00000000000056b8 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__insert_symbol
 6.61          perf [.] 0x00000000000057cb /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__find_symbol
 5.33          perf [k] 0xffffffff811ce082 number
 4.69          perf [.] 0x0000000000034829 /lib64/libc-2.5.so: ____strtoull_l_internal
 4.48          perf [.] 0x0000000000006505 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: thread__symbol_incnew
 3.41          perf [.] 0x000000000000fce6 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: rb_insert_color
 3.20          perf [k] 0xffffffff811cfc01 vsnprintf
 2.99          perf [k] 0xffffffff811ce5e8 format_decode

After:

[acme@emilia ~]$ perf record -o perf_report.perf perf stat perf report > /dev/null

 Performance counter stats for 'perf':

     218.186805  task clock ticks     (msecs)
              4  context switches     (events)
              7  CPU migrations       (events)
           2133  pagefaults           (events)
       32735365  CPU cycles           (events)  (scaled from 67.04%)
       11952309  instructions         (events)  (scaled from 66.26%)
          50314  cache references     (events)  (scaled from 21.96%)
          13228  cache misses         (events)  (scaled from 21.98%)

 Wall-clock time elapsed:   218.810451 msecs

[acme@emilia ~]$ perf report -i perf_report.perf | head
10.68          perf [.] 0x000000000000578d /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__find_symbol
 9.62          perf [.] 0x00000000000065f7 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: thread__symbol_incnew
 9.40          perf [.] 0x00000000000056b4 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__insert_symbol
 9.19          perf [k] 0xffffffff8101b1d2 intel_pmu_enable_all
 5.13          perf [.] 0x0000000000005ec7 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: hex2long
 4.49          perf [k] 0xffffffff81083808 kallsyms_expand_symbol
 3.85          perf [k] 0xffffffff811ce2c1 number
 3.63          perf [.] 0x0000000000005e81 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: hex
 2.99          perf [.] 0x000000000000fd5b /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: rb_insert_color
 2.99          perf [k] 0xffffffff811cf251 string
[acme@emilia ~]$

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/perf_counter/builtin-report.c |   63 +++++++++++++++++++++------
 1 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index a4c6ffa..c517483 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -348,6 +348,39 @@ void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
+static int hex(char ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/*
+ * While we find nice hex chars, build a long_val.
+ * Return number of chars processed.
+ */
+int hex2long(char *ptr, unsigned long *long_val)
+{
+	const char *p = ptr;
+	*long_val = 0;
+
+	while (*p) {
+		const int hex_val = hex(*p);
+
+		if (hex_val < 0)
+			break;
+
+		*long_val = (*long_val << 4) | hex_val;
+		p++;
+	}
+
+	return p - ptr;
+}
+
 static int load_kallsyms(void)
 {
 	kernel_dso = dso__new("[kernel]");
@@ -363,26 +396,30 @@ static int load_kallsyms(void)
 	size_t n;
 
 	while (!feof(file)) {
-		unsigned long long start;
-		char c, symbf[4096];
-
-		if (getline(&line, &n, file) < 0)
+		unsigned long start;
+		int line_len = getline(&line, &n, file);
+		if (line_len < 0)
 			break;
 
 		if (!line)
 			goto out_delete_dso;
 
-		if (sscanf(line, "%llx %c %s", &start, &c, symbf) == 3) {
-			/*
-			 * Well fix up the end later, when we have all sorted.
-			 */
-			struct symbol *sym = symbol__new(start, 0xdead, symbf);
+		line[--line_len] = '\0'; /* \n */
+
+		int len = hex2long(line, &start);
+		
+		len += 3; /* ' t ' */
+		if (len >= line_len)
+			continue;
+		/*
+		 * Well fix up the end later, when we have all sorted.
+		 */
+		struct symbol *sym = symbol__new(start, 0xdead, line + len);
 
-			if (sym == NULL)
-				goto out_delete_dso;
+		if (sym == NULL)
+			goto out_delete_dso;
 
-			dso__insert_symbol(kernel_dso, sym);
-		}
+		dso__insert_symbol(kernel_dso, sym);
 	}
 
 	/*
-- 
1.6.0.6

