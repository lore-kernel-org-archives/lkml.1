Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbYJ0Gno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbYJ0Gno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 02:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYJ0Gng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 02:43:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50563 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYJ0Gng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 02:43:36 -0400
Date: Mon, 27 Oct 2008 17:43:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: trace: fix printk warning for u64
Message-Id: <20081027174328.084649ab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A powerpc ppc64_defconfig build produces these warnings:

kernel/trace/ring_buffer.c: In function 'rb_add_time_stamp':
kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 2 has type 'u64'
kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'
kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'u64'

Just cast the u64s to unsigned long long like we do everywhere else.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

---

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 94af1fe..faf3be9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -966,7 +966,9 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 	if (unlikely(*delta > (1ULL << 59) && !once++)) {
 		printk(KERN_WARNING "Delta way too big! %llu"
 		       " ts=%llu write stamp = %llu\n",
-		       *delta, *ts, cpu_buffer->write_stamp);
+		       (unsigned long long)*delta,
+		       (unsigned long long)*ts,
+		       (unsigned long long)cpu_buffer->write_stamp);
 		WARN_ON(1);
 	}
 
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
