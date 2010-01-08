Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768Ab0AIWiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0AIWiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 17:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367Ab0AIWiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 17:38:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:39150 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0AIWiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 17:38:17 -0500
Date: Fri, 8 Jan 2010 09:33:37 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <1262826727-9090-1-git-send-email-dhsharp@google.com>
References: <1262826727-9090-1-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ring-buffer: Wrap a list.next reference with rb_list_head()
Message-ID: <tip-5ded3dc6a3c7549b36a8ac27bbd81b33756a2c29@git.kernel.org>
Git-Commit-ID: 5ded3dc6a3c7549b36a8ac27bbd81b33756a2c29
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (hera.kernel.org [127.0.0.1]); Sat, 09 Jan 2010 22:37:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ded3dc6a3c7549b36a8ac27bbd81b33756a2c29
Gitweb:     http://git.kernel.org/tip/5ded3dc6a3c7549b36a8ac27bbd81b33756a2c29
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Wed, 6 Jan 2010 17:12:07 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 Jan 2010 20:38:25 -0500

ring-buffer: Wrap a list.next reference with rb_list_head()

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
