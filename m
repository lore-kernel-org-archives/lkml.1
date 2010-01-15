Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0AOUIj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125Ab0AOUIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:08:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab0AOUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:08:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf symbols: Accept an alias when looking for "_text"
Date: Fri, 15 Jan 2010 18:08:27 -0200
Message-Id: <1263586107-1756-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263586107-1756-1-git-send-email-acme@infradead.org>
References: <1263586107-1756-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As it is in PARISC64:

parisc:~# uname -a
Linux parisc 2.6.33-rc4-tip+ #1 SMP Thu Jan 14 13:33:34 BRST 2010 parisc64 GNU/Linux
parisc:~# grep -w _text /proc/kallsyms
0000000040100000 A _text
parisc:~# grep 0000000040100000 /proc/kallsyms
0000000040100000 T stext
0000000040100000 T _stext
0000000040100000 A _text
parisc:~#

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 966d207..dc13cad 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -227,7 +227,12 @@ static int find_symbol_cb(void *arg, const char *name, char type, u64 start)
 {
 	struct process_symbol_args *args = arg;
 
-	if (!symbol_type__is_a(type, MAP__FUNCTION) || strcmp(name, args->name))
+	/*
+	 * Must be a function or at least an alias, as in PARISC64, where "_text" is
+	 * an 'A' to the same address as "_stext".
+	 */
+	if (!(symbol_type__is_a(type, MAP__FUNCTION) ||
+	      type == 'A') || strcmp(name, args->name))
 		return 0;
 
 	args->start = start;
-- 
1.6.2.5

