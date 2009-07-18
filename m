Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbZGRHRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbZGRHRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932532AbZGRHRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:17:12 -0400
Received: from mail-qy0-f198.google.com ([209.85.221.198]:33018 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbZGRHRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sdAjinVkO7nm9BleE5TM/KOvNGHOLq2T7D70WOxWkwph7Z+S+z4Wq0tPonT2vFh/Cq
         Nt0nfGE7Gz6N5ikXWqi4IPNqxwDVp8RYH1YhlbUhiLfzLoFk9jMGUi8yhBfwK3lgZZiF
         QfodnhshanH2aUS2oDr3VRy1/GJTJlWjf9Yss=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4] ring_buffer: Fix warning while ignoring cmpxchg return value
Date: Sat, 18 Jul 2009 03:16:58 -0400
Message-Id: <1247901421-6389-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
References: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

kernel/trace/ring_buffer.c: In function 'rb_tail_page_update':
kernel/trace/ring_buffer.c:849: warning: value computed is not used
kernel/trace/ring_buffer.c:850: warning: value computed is not used

Add "(void)"s to fix this warning, because we don't need here to handle
the fail case of cmpxchg, it's fine if an interrupt already did the
job.

Changed from V1:
  Add a comment(which is written by Steven) for it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ring_buffer.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

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
-- 
1.6.2.3

