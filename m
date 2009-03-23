Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZCWNOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZCWNOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZCWNMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:12:13 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60474 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbZCWNMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=d0mwAVPs1bB0qYXjkDOrIOrWjBpc7dpZiQhdzEcSVtGCVMUoizQ/j/ctJluyFb495U
         mWRgd8M5va8X0FA28g4qqnN1N3Krg3FTAXD2IVvOYorrXYa4clE9Ep8Kn3qwTTtTkJ1z
         NgftaSDPkduqOqhly9pa44NzieI5yfJAsrMFM=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] kmemtrace: update usage of ring_buffer_lock_reserve()
Date: Mon, 23 Mar 2009 15:12:27 +0200
Message-Id: <c56426665804da261115c2883818c5fea6b217b6.1237813499.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
 <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
 <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
 <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
 <ae61c0f37156db8ec8dc0d5778018edde60a92e3.1237813499.git.eduard.munteanu@linux360.ro>
 <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
 <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ring buffer API has changed a bit and kmemtrace wasn't compiling
anymore. This fixes the issue and allows kmemtrace to build.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/kmemtrace.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 98e6f76..26ec3c3 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -59,10 +59,8 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 	struct ring_buffer_event *event;
 	struct kmemtrace_alloc_entry *entry;
 	struct trace_array *tr = kmemtrace_array;
-	unsigned long irq_flags;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
-					 &irq_flags);
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
@@ -77,7 +75,7 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 	entry->gfp_flags = gfp_flags;
 	entry->node	=	node;
 
-	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+	ring_buffer_unlock_commit(tr->buffer, event);
 
 	trace_wake_up();
 }
@@ -89,10 +87,8 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 	struct ring_buffer_event *event;
 	struct kmemtrace_free_entry *entry;
 	struct trace_array *tr = kmemtrace_array;
-	unsigned long irq_flags;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
-					 &irq_flags);
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
@@ -103,7 +99,7 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 	entry->call_site = call_site;
 	entry->ptr = ptr;
 
-	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+	ring_buffer_unlock_commit(tr->buffer, event);
 
 	trace_wake_up();
 }
-- 
1.6.0.6

