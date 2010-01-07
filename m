Return-Path: <linux-kernel-owner+w=401wt.eu-S932947Ab0AGCBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab0AGCBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568Ab0AGCBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:01:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab0AGCBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:01:03 -0500
X-Authority-Analysis: v=1.0 c=1 a=_QjKuCMXud0A:10 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=ioV-0B1SxrW33vtM7JwA:9 a=0tn1Yx9hcNZ1uFMtwoDH8Wll4KAA:4 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=IkVo3-6MxWUDWdZB:21 a=el7QQOQxSpHn4g8G:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100107020100.783759390@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 20:59:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Sharp <dhsharp@google.com>
Subject: [PATCH 1/2] ring-buffer: Wrap a list.next reference with rb_list_head()
References: <20100107015920.827200859@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Wrap-a-list.next-reference-with-rb_list_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

This reference at the end of rb_get_reader_page() was causing off-by-one
writes to the prev pointer of the page after the reader page when that
page is the head page, and therefore the reader page has the RB_PAGE_HEAD
flag in its list.next pointer. This eventually results in a GPF in a
subsequent call to rb_set_head_page() (usually from rb_get_reader_page())
when that prev pointer is dereferenced. The dereferenced register would
characteristically have an address that appears shifted left by one byte
(eg, ffxxxxxxxxxxxxyy instead of ffffxxxxxxxxxxxx) due to being written at
an address one byte too high.

Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1262826727-9090-1-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2326b04..d5b7308 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2906,7 +2906,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 *
 	 * Now make the new head point back to the reader page.
 	 */
-	reader->list.next->prev = &cpu_buffer->reader_page->list;
+	rb_list_head(reader->list.next)->prev = &cpu_buffer->reader_page->list;
 	rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
 
 	/* Finally update the reader page to the new head */
-- 
1.6.5


