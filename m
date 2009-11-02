Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZKBQUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZKBQUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZKBQUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:20:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:51855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbZKBQUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:20:05 -0500
Date: Mon, 2 Nov 2009 16:19:16 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256927305-4628-3-git-send-email-acme@infradead.org>
References: <1256927305-4628-3-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Improve message about missing symtabs for deleted DSOs
Message-ID: <tip-d70a5402f9c2e2671b809363616b3508b4c5a565@git.kernel.org>
Git-Commit-ID: d70a5402f9c2e2671b809363616b3508b4c5a565
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d70a5402f9c2e2671b809363616b3508b4c5a565
Gitweb:     http://git.kernel.org/tip/d70a5402f9c2e2671b809363616b3508b4c5a565
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 30 Oct 2009 16:28:25 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 16:52:12 +0100

perf tools: Improve message about missing symtabs for deleted DSOs

Instead of:

  no symbols found in /usr/lib/gstreamer-0.10/libgsttypefindfunctions.so (deleted), maybe install a debug package?
  no symbols found in /usr/lib/gstreamer-0.10/libgstaudioconvert.so (deleted), maybe install a debug package?

We now emit:

  /usr/lib/gstreamer-0.10/libgsttypefindfunctions.so was updated, restart the long running apps that use it!
  /usr/lib/gstreamer-0.10/libgstaudioconvert.so was updated, restart the long running apps that use it!

Which is far less misleading about what the cause of the
symbol mismatch is.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1256927305-4628-3-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
