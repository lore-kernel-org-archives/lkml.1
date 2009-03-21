Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZCUExs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZCUExs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 00:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZCUExi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 00:53:38 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53895 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZCUExh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 00:53:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
Date: Sat, 21 Mar 2009 15:53:29 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perfcounters: fix type/event_id layout on big-endian systems
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: build fix for powerpc

Commit db3a944aca35ae61 ("perf_counter: revamp syscall input ABI")
expanded the hw_event.type field into a union of structs containing
bitfields.  In particular it introduced a type field and a raw_type
field, with the intention that the 1-bit raw_type field should
overlay the most-significant bit of the 8-bit type field, and in fact
perf_counter_alloc() now assumes that (or at least, assumes that
raw_type doesn't overlay any of the bits that are 1 in the values of
PERF_TYPE_{HARDWARE,SOFTWARE,TRACEPOINT}).

Unfortunately this is not true on big-endian systems such as PowerPC,
where bitfields are laid out from left to right, i.e. from most
significant bit to least significant.  This means that setting
hw_event.type = PERF_TYPE_SOFTWARE will set hw_event.raw_type to 1.

This fixes it by making the layout depend on whether or not
__BIG_ENDIAN_BITFIELD is defined.  It's a bit ugly, but that's what
we get for using bitfields in a user/kernel ABI.

Also, that commit didn't fix up some places in arch/powerpc/kernel/
perf_counter.c where hw_event.raw and hw_event.event_id were used.
This fixes them too.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is in the master branch of my perfcounters.git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 arch/powerpc/kernel/perf_counter.c |    9 +++++----
 include/linux/perf_counter.h       |   12 ++++++++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 830ca9c..6413d9c 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -602,12 +602,13 @@ hw_perf_counter_init(struct perf_counter *counter)
 		return NULL;
 	if ((s64)counter->hw_event.irq_period < 0)
 		return NULL;
-	ev = counter->hw_event.event_id;
-	if (!counter->hw_event.raw) {
-		if (ev >= ppmu->n_generic ||
-		    ppmu->generic_events[ev] == 0)
+	if (!counter->hw_event.raw_type) {
+		ev = counter->hw_event.event_id;
+		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
 			return NULL;
 		ev = ppmu->generic_events[ev];
+	} else {
+		ev = counter->hw_event.raw_event_id;
 	}
 	counter->hw.config_base = ev;
 	counter->hw.idx = 0;
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index a4b76c0..98f5990 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -15,6 +15,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <asm/byteorder.h>
 
 /*
  * User-space ABI bits:
@@ -86,6 +87,7 @@ enum perf_counter_record_type {
  */
 struct perf_counter_hw_event {
 	union {
+#ifndef __BIG_ENDIAN_BITFIELD
 		struct {
 			__u64			event_id	: 56,
 						type		:  8;
@@ -94,6 +96,16 @@ struct perf_counter_hw_event {
 			__u64			raw_event_id	: 63,
 						raw_type	:  1;
 		};
+#else
+		struct {
+			__u64			type		:  8,
+						event_id	: 56;
+		};
+		struct {
+			__u64			raw_type	:  1,
+						raw_event_id	: 63;
+		};
+#endif /* __BIT_ENDIAN_BITFIELD */
 		__u64		event_config;
 	};
 
-- 
1.5.6.3
