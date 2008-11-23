Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYKWTYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYKWTYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYKWTYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:24:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:55745 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYKWTYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=dJLCv23/icoMnQqayFotCPKonz+iS/TGY8b4bIVGqBkJTcg70GdCtMNsmihTElb8X/
         zDTmMWxmeEGe9z1zuZ6B2q46A3SBUUZtlnL42pWddAY2MjTFN3E9Dw+Uo1vb/xLkK6GR
         O1BIk93itR+gLlRcIiVfvO86vOtDRydXHIzPk=
Date: Sun, 23 Nov 2008 21:24:30 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Message-ID: <20081123212430.4f6700e9@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d5d72f3515ba3abffa317b985d7597718a024841 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 23 Nov 2008 19:18:18 +0200
Subject: [PATCH] mmiotrace: fix buffer overrun detection

When ftrace framework moved to use the ring buffer facility, the buffer
overrun detection was broken after 2.6.27 by commit

commit 3928a8a2d98081d1bc3c0a84a2d70e29b90ecf1c
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Mon Sep 29 23:02:41 2008 -0400

    ftrace: make work with new ring buffer

    This patch ports ftrace over to the new ring buffer.

The detection is now fixed by using the ring buffer API.

When mmiotrace detects a buffer overrun, it will report the number of
lost events. People reading an mmiotrace log must know if something was
missed, otherwise the data may not make sense.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

Ingo, could these two patches still make it into .28?

 kernel/trace/trace_mmiotrace.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index f284846..e62cbf7 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -18,12 +18,14 @@ struct header_iter {
 
 static struct trace_array *mmio_trace_array;
 static bool overrun_detected;
+static unsigned long prev_overruns;
 
 static void mmio_reset_data(struct trace_array *tr)
 {
 	int cpu;
 
 	overrun_detected = false;
+	prev_overruns = 0;
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
@@ -128,16 +130,12 @@ static void mmio_close(struct trace_iterator *iter)
 
 static unsigned long count_overruns(struct trace_iterator *iter)
 {
-	int cpu;
 	unsigned long cnt = 0;
-/* FIXME: */
-#if 0
-	for_each_online_cpu(cpu) {
-		cnt += iter->overrun[cpu];
-		iter->overrun[cpu] = 0;
-	}
-#endif
-	(void)cpu;
+	unsigned long over = ring_buffer_overruns(iter->tr->buffer);
+
+	if (over > prev_overruns)
+		cnt = over - prev_overruns;
+	prev_overruns = over;
 	return cnt;
 }
 
-- 
1.5.6.4

