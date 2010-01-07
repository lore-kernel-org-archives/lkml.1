Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454Ab0AGBNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0AGBNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730Ab0AGBNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:13:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:42590 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0AGBNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:13:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=xnXLbyghZM4OvL5cA9965kaYnD12MFTAmCB0RV61EmSx2wQt/X8g6u6LWU4fNQjNj
	kN0bBABj53OWlSowUG7Cg==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: srostedt@redhat.com, mrubin@google.com, jiayingz@google.com,
       David Sharp <dhsharp@google.com>
Subject: [PATCH] ring_buffer: wrap a list.next reference with rb_list_head()
Date: Wed,  6 Jan 2010 17:12:07 -0800
Message-Id: <1262826727-9090-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.5.3

