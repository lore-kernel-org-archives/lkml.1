Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbZE0HR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbZE0HR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZE0HQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:16:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:50138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbZE0HQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:16:45 -0400
Date: Wed, 27 May 2009 07:16:03 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, rostedt@goodmis.org,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, rostedt@goodmis.org, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090526222057.GI4424@ghostprotocols.net>
References: <20090526222057.GI4424@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf report: Use hex2long instead of sscanf
Message-ID: <tip-d8d1656ee15d3085e0085a87e70f9093a0a102c5@git.kernel.org>
Git-Commit-ID: d8d1656ee15d3085e0085a87e70f9093a0a102c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 07:16:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8d1656ee15d3085e0085a87e70f9093a0a102c5
Gitweb:     http://git.kernel.org/tip/d8d1656ee15d3085e0085a87e70f9093a0a102c5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 26 May 2009 19:20:57 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 09:10:35 +0200

perf report: Use hex2long instead of sscanf

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

[ Impact: optimization ]

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090526222057.GI4424@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
