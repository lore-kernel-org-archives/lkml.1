Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZHHC0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZHHC0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZHHC0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:26:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:34627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbZHHC0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=CVZa0wnispIhZIgHsCOVBzCebnsqje+PM16g5ZhEMfDDg+VBIpWPjpGinUrpczuHju
         i64PYsqvQnqANUHyxlhJ1yoGMDNtbp88kxHbz2vhqVjHqhBIkNxU9GHFHhABseuV4+6y
         KamM8xbOsknKsgD4YPS3cCZgzuJwPOXi5fjE4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perfcounter: Initialize tracepoint record before any use
Date: Sat,  8 Aug 2009 04:26:35 +0200
Message-Id: <1249698400-5441-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite that the tracepoint record is always present when the
PERF_SAMPLE_TP_RECORD flag is set, gcc whines, thinking it might not
be initialized:

kernel/perf_counter.c: In function ‘perf_counter_output’:
kernel/perf_counter.c:2650: warning: ‘tp’ may be used uninitialized in this function

Then, initialize it to NULL and always check if it's not NULL before
dereference it.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_counter.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 142ae5a..a6963e2 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2647,7 +2647,7 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 		u64 counter;
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
-	struct perf_tracepoint_record *tp;
+	struct perf_tracepoint_record *tp = NULL;
 	int callchain_size = 0;
 	u64 time;
 	struct {
@@ -2718,7 +2718,8 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 
 	if (sample_type & PERF_SAMPLE_TP_RECORD) {
 		tp = data->private;
-		header.size += tp->size;
+		if (tp)
+			header.size += tp->size;
 	}
 
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
@@ -2784,7 +2785,7 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
-	if (sample_type & PERF_SAMPLE_TP_RECORD)
+	if ((sample_type & PERF_SAMPLE_TP_RECORD) && tp)
 		perf_output_copy(&handle, tp->record, tp->size);
 
 	perf_output_end(&handle);
-- 
1.6.2.3

