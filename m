Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0CLPrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 10:47:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0CLPq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 10:46:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf hist: Don't fprintf the callgraph unconditionally
Date: Fri, 12 Mar 2010 12:46:48 -0300
Message-Id: <1268408808-13595-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268408808-13595-1-git-send-email-acme@infradead.org>
References: <1268408808-13595-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

  [root@doppio ~]# perf report -i newt.data | head -10
  # Samples: 11999679868
  #
  # Overhead  Command                  Shared Object  Symbol
  # ........  .......  .............................  ......
  #
      63.61%     perf  libslang.so.2.1.4              [.] SLsmg_write_chars
       6.30%     perf  perf                           [.] symbols__find
       2.19%     perf  libnewt.so.0.52.10             [.] newtListboxAppendEntry
       2.08%     perf  libslang.so.2.1.4              [.] SLsmg_write_chars@plt
       1.99%     perf  libc-2.10.2.so                 [.] _IO_vfprintf_internal
  [root@doppio ~]#

Not good, the newt form for report works, but slang has to eat the cost of the
additional callgraph lines everytime it prints a line, and the callgraph
doesn't appear on the screen, so move the callgraph printing to a separate
function and don't use it in newt.c.

Newt tree widgets are being investigated to properly support callgraphs, but
till that gets merged, lets remove this huge overhead and show at least the
symbol overheads for a callgraph rich perf.data with good performance.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d43be34..1a4e837 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -532,23 +532,23 @@ size_t hist_entry__fprintf(struct hist_entry *self,
 		ret += se->print(fp, self, se->width ? *se->width : 0);
 	}
 
-	ret += fprintf(fp, "\n");
-
-	if (symbol_conf.use_callchain) {
-		int left_margin = 0;
+	return ret + fprintf(fp, "\n");
+}
 
-		if (sort__first_dimension == SORT_COMM) {
-			se = list_first_entry(&hist_entry__sort_list, typeof(*se),
-						list);
-			left_margin = se->width ? *se->width : 0;
-			left_margin -= thread__comm_len(self->thread);
-		}
+static size_t hist_entry__fprintf_callchain(struct hist_entry *self, FILE *fp,
+					    u64 session_total)
+{
+	int left_margin = 0;
 
-		ret += hist_entry_callchain__fprintf(fp, self, session_total,
-						     left_margin);
+	if (sort__first_dimension == SORT_COMM) {
+		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
+							 typeof(*se), list);
+		left_margin = se->width ? *se->width : 0;
+		left_margin -= thread__comm_len(self->thread);
 	}
 
-	return ret;
+	return hist_entry_callchain__fprintf(fp, self, session_total,
+					     left_margin);
 }
 
 size_t perf_session__fprintf_hists(struct rb_root *hists,
@@ -655,6 +655,10 @@ print_entries:
 		}
 		ret += hist_entry__fprintf(h, pair, show_displacement,
 					   displacement, fp, session_total);
+
+		if (symbol_conf.use_callchain)
+			ret += hist_entry__fprintf_callchain(h, fp, session_total);
+
 		if (h->map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
 						   MAP__FUNCTION, fp);
-- 
1.6.2.5

