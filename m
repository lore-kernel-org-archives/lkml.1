Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbZEHQWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbZEHQWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZEHQVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:21:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZEHQVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:21:32 -0400
Message-Id: <20090508162132.193226406@goodmis.org>
References: <20090508162033.397923239@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 12:20:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] ring-buffer: check for divide by zero in ring-buffer-benchmark
Content-Disposition: inline; filename=0002-ring-buffer-check-for-divide-by-zero-in-ring-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Although we check if "missed" is not zero, we divide by hit + missed,
and the addition can possible overflow and become a divide by zero.

This patch checks for this case, and will report it when it happens
then modify "hit" to make the calculation be non zero.

[ Impact: prevent possible divide by zero in ring-buffer-benchmark ]

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 7d3aef9..8d68e14 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -294,6 +294,12 @@ static void ring_buffer_producer(void)
 
 		pr_info("Total iterations per millisec: %ld\n", hit + missed);
 
+		/* it is possible that hit + missed will overflow and be zero */
+		if (!(hit + missed)) {
+			pr_info("hit + missed overflowed and totalled zero!\n");
+			hit--; /* make it non zero */
+		}
+
 		/* Caculate the average time in nanosecs */
 		avg = NSEC_PER_MSEC / (hit + missed);
 		pr_info("%ld ns per entry\n", avg);
-- 
1.6.2.4

-- 
