Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbZJ3S3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbZJ3S3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932795AbZJ3S3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:29:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:45621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbZJ3S3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:29:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Improve message about missing symtabs for deleted DSOs
Date: Fri, 30 Oct 2009 16:28:25 -0200
Message-Id: <1256927305-4628-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1256927305-4628-2-git-send-email-acme@infradead.org>
References: <1256927305-4628-1-git-send-email-acme@infradead.org>
 <1256927305-4628-2-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of:

no symbols found in /usr/lib/gstreamer-0.10/libgsttypefindfunctions.so (deleted), maybe install a debug package?
no symbols found in /usr/lib/gstreamer-0.10/libgstaudioconvert.so (deleted), maybe install a debug package?

We now emit:

/usr/lib/gstreamer-0.10/libgsttypefindfunctions.so was updated, restart the long running apps that use it!
/usr/lib/gstreamer-0.10/libgstaudioconvert.so was updated, restart the long running apps that use it!

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 679011c..f1e2169 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -75,6 +75,8 @@ out_delete:
 	return NULL;
 }
 
+#define DSO__DELETED "(deleted)"
+
 struct symbol *
 map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter)
 {
@@ -86,8 +88,18 @@ map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter)
 				   self->dso->long_name);
 			return NULL;
 		} else if (nr == 0) {
-			pr_warning("No symbols found in %s, maybe install a debug package?\n",
-				   self->dso->long_name);
+			const char *name = self->dso->long_name;
+			const size_t len = strlen(name);
+			const size_t real_len = len - sizeof(DSO__DELETED);
+
+			if (len > sizeof(DSO__DELETED) &&
+			    strcmp(name + real_len + 1, DSO__DELETED) == 0)
+				pr_warning("%.*s was updated, restart the "
+					   "long running apps that use it!\n",
+					   real_len, name);
+			else
+				pr_warning("no symbols found in %s, maybe "
+					   "install a debug package?\n", name);
 			return NULL;
 		}
 	}
-- 
1.6.2.5

