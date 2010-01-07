Return-Path: <linux-kernel-owner+w=401wt.eu-S932878Ab0AGCBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab0AGCBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570Ab0AGCBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:01:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab0AGCBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:01:04 -0500
X-Authority-Analysis: v=1.0 c=1 a=Hw-hmr2oe7AA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ccNjCLAQ8wV_PqRCNVwA:9 a=lm1cQHFurmaefnUHrzwA:7 a=V1xYrhxQBU29Le1QSivU9-UhFi0A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100107020101.337969100@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 20:59:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] ring-buffer: Add rb_list_head() wrapper around new reader page next field
References: <20100107015920.827200859@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Add-rb_list_head-wrapper-around-new-read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the very unlikely case happens where the writer moves the head by one
between where the head page is read and where the new reader page
is assigned _and_ the writer then writes and wraps the entire ring buffer
so that the head page is back to what was originally read as the head page,
the page to be swapped will have a corrupted next pointer.

Simple solution is to wrap the assignment of the next pointer with a
rb_list_head().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d5b7308..edefe3b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2869,7 +2869,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
-	cpu_buffer->reader_page->list.next = reader->list.next;
+	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
 	/*
-- 
1.6.5


