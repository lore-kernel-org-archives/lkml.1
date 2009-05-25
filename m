Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZEYD6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZEYD6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZEYD56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:57:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62459 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZEYD55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:57:57 -0400
Message-ID: <4A1A1770.6070103@cn.fujitsu.com>
Date: Mon, 25 May 2009 11:58:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@elte.hu
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] ring_buffer: use list_replace() in rb_get_reader_page()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_replace() to splice list in rb_get_reader_page()

[ Impact: cleanup ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/trace/ring_buffer.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f558b37..f88bfcc 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2179,22 +2179,14 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	if (cpu_buffer->commit_page == cpu_buffer->reader_page)
 		goto out;
 
-	/*
-	 * Splice the empty reader page into the list around the head.
-	 * Reset the reader page to size zero.
-	 */
-
+	/* Reset the reader page to size zero */
 	reader = cpu_buffer->head_page;
-	cpu_buffer->reader_page->list.next = reader->list.next;
-	cpu_buffer->reader_page->list.prev = reader->list.prev;
-
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 
 	/* Make the reader page now replace the head */
-	reader->list.prev->next = &cpu_buffer->reader_page->list;
-	reader->list.next->prev = &cpu_buffer->reader_page->list;
+	list_replace(&reader->list, &cpu_buffer->reader_page->list);
 
 	/*
 	 * If the tail is on the reader, then we must set the head
-- 
1.6.1.2


