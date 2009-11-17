Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZKQRTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZKQRTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZKQRTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:19:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:40390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZKQRTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:19:36 -0500
Date: Tue, 17 Nov 2009 17:18:35 GMT
From: tip-bot for Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       npiggin@suse.de, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       npiggin@suse.de, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate: Allocate history size correctly
Message-ID: <tip-d62d77fd18cc82e839e49b7ef3360e4411f7d2e5@git.kernel.org>
Git-Commit-ID: d62d77fd18cc82e839e49b7ef3360e4411f7d2e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d62d77fd18cc82e839e49b7ef3360e4411f7d2e5
Gitweb:     http://git.kernel.org/tip/d62d77fd18cc82e839e49b7ef3360e4411f7d2e5
Author:     Nick Piggin <npiggin@suse.de>
AuthorDate: Tue, 17 Nov 2009 12:29:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 16:47:09 +0100

perf annotate: Allocate history size correctly

Symbol offset history table size does not get updated properly
when it is being resized. This leads to garbage results in
perf annotate.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/symbol.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 226f44a..cbac575 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -227,6 +227,10 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int v)
 			      *curr = rb_entry(nd, struct symbol, rb_node);
 
 		prev->end = curr->start - 1;
+		if (prev->hist) {
+			free(prev->hist);
+			prev->hist = calloc(sizeof(u64), prev->end - prev->start);
+		}
 		prevnd = nd;
 	}
 
@@ -883,6 +887,10 @@ static inline void dso__fill_symbol_holes(struct dso *self)
 					pos->end = prev->end;
 				else if (hole)
 					pos->end = prev->start - 1;
+				if (pos->hist) {
+					free(pos->hist);
+					pos->hist = calloc(sizeof(u64), pos->end - pos->start);
+				}
 			}
 		}
 		prev = pos;
