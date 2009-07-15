Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZGOIR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZGOIR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 04:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZGOIR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 04:17:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49374 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZGOIRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 04:17:25 -0400
Message-ID: <4A5D90B1.3020304@cn.fujitsu.com>
Date: Wed, 15 Jul 2009 16:17:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] ring_buffer: fix warning (V2)
References: <4A5C3549.7000905@cn.fujitsu.com>
In-Reply-To: <4A5C3549.7000905@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kernel/trace/ring_buffer.c: In function 'rb_tail_page_update':
kernel/trace/ring_buffer.c:849: warning: value computed is not used
kernel/trace/ring_buffer.c:850: warning: value computed is not used

Add "(void)"s to fix this warning.

Changed from V1:
  Add a comment(which is written by Steven) for it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e648ba4..51633d7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -845,9 +845,14 @@ static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
 		 * This will only succeed if an interrupt did
 		 * not come in and change it. In which case, we
 		 * do not want to modify it.
+		 *
+		 * We add (void) to let the compiler know that we do not care
+		 * about the return value of these functions. We use the
+		 * cmpxchg to only update if an interrupt did not already
+		 * do it for us. If the cmpxchg fails, we don't care.
 		 */
-		local_cmpxchg(&next_page->write, old_write, val);
-		local_cmpxchg(&next_page->entries, old_entries, eval);
+		(void)local_cmpxchg(&next_page->write, old_write, val);
+		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
 
 		/*
 		 * No need to worry about races with clearing out the commit.

