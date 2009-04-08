Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbZDHNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbZDHNI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765343AbZDHNDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:48873 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765335AbZDHNDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:36 -0400
Message-Id: <20090408130408.769271806@chello.nl>
References: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/9] perf_counter: provide misc bits in the event header
Content-Disposition: inline; filename=perf_counter-header-reserve.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the size of each record to 64k (or should we count in multiples
of u64 and have a 512K limit?), this gives 16 bits or spare room in the
header, which we can use for misc bits, so as to not have to grow the
record with u64 every time we have a few bits to report.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    6 +++++-
 kernel/perf_counter.c        |    3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -201,9 +201,13 @@ struct perf_counter_mmap_page {
 	__u32   data_head;		/* head in the data section */
 };
 
+#define PERF_EVENT_MISC_KERNEL	(1 << 0)
+#define PERF_EVENT_MISC_USER	(1 << 1)
+
 struct perf_event_header {
 	__u32	type;
-	__u32	size;
+	__u16	misc;
+	__u16	size;
 };
 
 enum perf_event_type {
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1831,6 +1831,9 @@ static void perf_counter_output(struct p
 	header.type = PERF_EVENT_COUNTER_OVERFLOW;
 	header.size = sizeof(header);
 
+	header.misc = user_mode(regs) ?
+		PERF_EVENT_MISC_USER : PERF_EVENT_MISC_KERNEL;
+
 	if (record_type & PERF_RECORD_IP) {
 		ip = instruction_pointer(regs);
 		header.type |= __PERF_EVENT_IP;

-- 

