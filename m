Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbZEGJXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbZEGJXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbZEGJXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:23:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:40401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761307AbZEGJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:23:07 -0400
Date: Thu, 7 May 2009 09:22:31 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144553.773216000@intel.com>
References: <20090403144553.773216000@intel.com>
Subject: [tip:tracing/core] x86, bts: use trace_clock_global() for timestamps
Message-ID: <tip-15879d042164650b93d83281ad5f87ad323bfbfe@git.kernel.org>
Git-Commit-ID: 15879d042164650b93d83281ad5f87ad323bfbfe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:22:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15879d042164650b93d83281ad5f87ad323bfbfe
Gitweb:     http://git.kernel.org/tip/15879d042164650b93d83281ad5f87ad323bfbfe
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:17 +0200

x86, bts: use trace_clock_global() for timestamps

Rename the bts_struct timestamp field to event.

Use trace_clock_global() for time measurement.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144553.773216000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/ds.h |    4 ++--
 arch/x86/kernel/ds.c      |   17 +++++++++--------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/ds.h b/arch/x86/include/asm/ds.h
index a8f672b..772f141 100644
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -170,9 +170,9 @@ struct bts_struct {
 		} lbr;
 		/* BTS_TASK_ARRIVES or BTS_TASK_DEPARTS */
 		struct {
-			__u64 jiffies;
+			__u64 clock;
 			pid_t pid;
-		} timestamp;
+		} event;
 	} variant;
 };
 
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index f03f117..2071b99 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/trace_clock.h>
 
 #include <asm/ds.h>
 
@@ -471,7 +472,7 @@ enum bts_field {
 	bts_flags,
 
 	bts_qual		= bts_from,
-	bts_jiffies		= bts_to,
+	bts_clock		= bts_to,
 	bts_pid			= bts_flags,
 
 	bts_qual_mask		= (bts_qual_max - 1),
@@ -517,8 +518,8 @@ bts_read(struct bts_tracer *tracer, const void *at, struct bts_struct *out)
 	memset(out, 0, sizeof(*out));
 	if ((bts_get(at, bts_qual) & ~bts_qual_mask) == bts_escape) {
 		out->qualifier = (bts_get(at, bts_qual) & bts_qual_mask);
-		out->variant.timestamp.jiffies = bts_get(at, bts_jiffies);
-		out->variant.timestamp.pid = bts_get(at, bts_pid);
+		out->variant.event.clock = bts_get(at, bts_clock);
+		out->variant.event.pid = bts_get(at, bts_pid);
 	} else {
 		out->qualifier = bts_branch;
 		out->variant.lbr.from = bts_get(at, bts_from);
@@ -555,8 +556,8 @@ static int bts_write(struct bts_tracer *tracer, const struct bts_struct *in)
 	case bts_task_arrives:
 	case bts_task_departs:
 		bts_set(raw, bts_qual, (bts_escape | in->qualifier));
-		bts_set(raw, bts_jiffies, in->variant.timestamp.jiffies);
-		bts_set(raw, bts_pid, in->variant.timestamp.pid);
+		bts_set(raw, bts_clock, in->variant.event.clock);
+		bts_set(raw, bts_pid, in->variant.event.pid);
 		break;
 	default:
 		return -EINVAL;
@@ -1083,9 +1084,9 @@ static inline void ds_take_timestamp(struct ds_context *context,
 		return;
 
 	memset(&ts, 0, sizeof(ts));
-	ts.qualifier			= qualifier;
-	ts.variant.timestamp.jiffies	= jiffies_64;
-	ts.variant.timestamp.pid	= task->pid;
+	ts.qualifier		= qualifier;
+	ts.variant.event.clock	= trace_clock_global();
+	ts.variant.event.pid	= task->pid;
 
 	bts_write(tracer, &ts);
 }
