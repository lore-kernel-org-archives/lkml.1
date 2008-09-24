Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYIXSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYIXSwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYIXSwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:52:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYIXSwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:52:09 -0400
Date: Wed, 24 Sep 2008 14:51:28 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, agk@redhat.com,
       mbroz@redhat.com, chris@arachsys.com
Subject: [PATCH 1/3] Memory management livelock
In-Reply-To: <20080923164623.ce82c1c2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809241450560.18811@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A generic function wait_action_schedule that allows to use wait_on_bit_lock just
like mutexes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/wait.h |    8 +++++++-
 kernel/wait.c        |    7 +++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc7-devel/include/linux/wait.h
===================================================================
--- linux-2.6.27-rc7-devel.orig/include/linux/wait.h	2008-09-24 03:20:59.000000000 +0200
+++ linux-2.6.27-rc7-devel/include/linux/wait.h	2008-09-24 03:26:34.000000000 +0200
@@ -513,7 +513,13 @@ static inline int wait_on_bit_lock(void 
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
 }
-	
+
+/**
+ * wait_action_schedule - this function can be passed to wait_on_bit or
+ * wait_on_bit_lock and it will call just schedule().
+ */
+int wait_action_schedule(void *);
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6.27-rc7-devel/kernel/wait.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/kernel/wait.c	2008-09-24 03:22:58.000000000 +0200
+++ linux-2.6.27-rc7-devel/kernel/wait.c	2008-09-24 03:24:10.000000000 +0200
@@ -251,3 +251,10 @@ wait_queue_head_t *bit_waitqueue(void *w
 	return &zone->wait_table[hash_long(val, zone->wait_table_bits)];
 }
 EXPORT_SYMBOL(bit_waitqueue);
+
+int wait_action_schedule(void *word)
+{
+	schedule();
+	return 0;
+}
+EXPORT_SYMBOL(wait_action_schedule);

