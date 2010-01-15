Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0AOBqV (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312Ab0AOBpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:45:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:49914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0AOBpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:45:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/4] perf symbols: Create thread__find_addr_map from thread__find_addr_location
Date: Thu, 14 Jan 2010 23:45:29 -0200
Message-Id: <1263519930-22803-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263519930-22803-1-git-send-email-acme@infradead.org>
References: <1263519930-22803-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Because some tools will only want to know with maps had hits, not
needing the full symbol resolution done by thread__find_addr_location.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |   26 +++++++++++++++++---------
 tools/perf/util/thread.h |    5 +++++
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1abaefc..5a6e827 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -422,11 +422,10 @@ int event__process_task(event_t *self, struct perf_session *session)
 	return 0;
 }
 
-void thread__find_addr_location(struct thread *self,
-				struct perf_session *session, u8 cpumode,
-				enum map_type type, u64 addr,
-				struct addr_location *al,
-				symbol_filter_t filter)
+void thread__find_addr_map(struct thread *self,
+			   struct perf_session *session, u8 cpumode,
+			   enum map_type type, u64 addr,
+			   struct addr_location *al)
 {
 	struct map_groups *mg = &self->mg;
 
@@ -441,7 +440,6 @@ void thread__find_addr_location(struct thread *self,
 	else {
 		al->level = 'H';
 		al->map = NULL;
-		al->sym = NULL;
 		return;
 	}
 try_again:
@@ -460,11 +458,21 @@ try_again:
 			mg = &session->kmaps;
 			goto try_again;
 		}
-		al->sym = NULL;
-	} else {
+	} else
 		al->addr = al->map->map_ip(al->map, al->addr);
+}
+
+void thread__find_addr_location(struct thread *self,
+				struct perf_session *session, u8 cpumode,
+				enum map_type type, u64 addr,
+				struct addr_location *al,
+				symbol_filter_t filter)
+{
+	thread__find_addr_map(self, session, cpumode, type, addr, al);
+	if (al->map != NULL)
 		al->sym = map__find_symbol(al->map, session, al->addr, filter);
-	}
+	else
+		al->sym = NULL;
 }
 
 static void dso__calc_col_width(struct dso *self)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index c06c135..e35653c 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -48,6 +48,11 @@ static inline struct map *thread__find_map(struct thread *self,
 	return self ? map_groups__find(&self->mg, type, addr) : NULL;
 }
 
+void thread__find_addr_map(struct thread *self,
+			   struct perf_session *session, u8 cpumode,
+			   enum map_type type, u64 addr,
+			   struct addr_location *al);
+
 void thread__find_addr_location(struct thread *self,
 				struct perf_session *session, u8 cpumode,
 				enum map_type type, u64 addr,
-- 
1.6.2.5

