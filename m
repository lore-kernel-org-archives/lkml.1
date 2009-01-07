Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbZAGXRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbZAGXRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbZAGXNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:13:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:46741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbZAGXNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:13:32 -0500
Date: Wed, 7 Jan 2009 15:15:22 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: [PATCH 7/7] async: don't do the initcall stuff post boot
Message-ID: <20090107151522.6850faf7@infradead.org>
In-Reply-To: <20090107151151.458333c1@infradead.org>
References: <20090107151151.458333c1@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ad160d23198193135cb2bcc75222e0816b5838c0 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 7 Jan 2009 09:28:53 -0800
Subject: [PATCH] async: don't do the initcall stuff post boot

while tracking the asynchronous calls during boot using the initcall_debug
convention is useful, doing it once the kernel is done is actually
bad now that we use asynchronous operations post boot as well...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/async.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index afaa8a6..9737338 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -124,12 +124,12 @@ static void run_one_entry(void)
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 3) run it (and print duration)*/
-	if (initcall_debug) {
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk("calling  %lli_%pF @ %i\n", entry->cookie, entry->func, task_pid_nr(current));
 		calltime = ktime_get();
 	}
 	entry->func(entry->data, entry->cookie);
-	if (initcall_debug) {
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
 		printk("initcall %lli_%pF returned 0 after %lld usecs\n", entry->cookie,
@@ -220,14 +220,14 @@ void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *r
 {
 	ktime_t starttime, delta, endtime;
 
-	if (initcall_debug) {
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk("async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
 	wait_event(async_done, __lowest_in_progress(running) >= cookie);
 
-	if (initcall_debug) {
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		endtime = ktime_get();
 		delta = ktime_sub(endtime, starttime);
 
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
