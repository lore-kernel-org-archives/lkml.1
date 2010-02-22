Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0BVSOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:14:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab0BVSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:14:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf top: Use a macro instead of a constant variable
Date: Mon, 22 Feb 2010 16:14:22 -0300
Message-Id: <1266866062-6287-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To overcome a silly gcc warning:

cc1: warnings being treated as errors
builtin-top.c: In function ‘lookup_sym_source’:
builtin-top.c:291: warning: not protecting local variables: variable length buffer
make: *** [builtin-top.o] Error 1
make: *** Waiting for unfinished jobs....

That is emitted for this:

	const size_t pattern_len = BITS_PER_LONG / 4 + 2;
	char pattern[pattern_len + 1];

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a457bbb..1a197f4 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -291,7 +291,7 @@ static void lookup_sym_source(struct sym_entry *syme)
 {
 	struct symbol *symbol = sym_entry__symbol(syme);
 	struct source_line *line;
-	const size_t pattern_len = BITS_PER_LONG / 4 + 2;
+#define pattern_len (BITS_PER_LONG / 4 + 2)
 	char pattern[pattern_len + 1];
 
 	sprintf(pattern, "%0*Lx <", BITS_PER_LONG / 4,
@@ -305,6 +305,7 @@ static void lookup_sym_source(struct sym_entry *syme)
 		}
 	}
 	pthread_mutex_unlock(&syme->src->lock);
+#undef pattern_len
 }
 
 static void show_lines(struct source_line *queue, int count, int total)
-- 
1.5.5.1

