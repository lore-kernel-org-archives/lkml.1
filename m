Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbZADSra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbZADSra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZADSrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:47:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:43740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZADSrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:47:17 -0500
Date: Sun, 4 Jan 2009 10:49:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090104104905.21c3f24e@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901041024360.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092857.5fbf6b2d@infradead.org>
	<alpine.LFD.2.00.0901041024360.3179@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 10:33:34 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> IOW, I'd just suggest changing the interface so that
> "async_schedule()" also returns the cookie. 
> 

>From 6b436c0fab92c50cae7ba3bcd9bcfebf2c9596f7 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 4 Jan 2009 10:47:27 -0800
Subject: [PATCH] fastboot: return the cookie from async_schedule()

Put this code back as suggested by Linus; even if there's no users right
now it makes conceptual sense and the cost is basically zero.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/async.h |    2 +-
 kernel/async.c        |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index b54d83a..678d4fd 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -15,7 +15,7 @@
 typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 
-extern void async_schedule(async_func_ptr *ptr, void *data);
+extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
 extern void async_synchronize_full(void);
 extern void async_synchronize_cookie(async_cookie_t cookie);
 
diff --git a/kernel/async.c b/kernel/async.c
index 9918fe5..8ecebf5 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -156,32 +156,34 @@ out:
 }
 
 
-void async_schedule(async_func_ptr *ptr, void *data)
+async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 {
 	struct async_entry *entry;
 	unsigned long flags;
+	async_cookie_t newcookie;
+	
 
 	/* allow irq-off callers */
 	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
 	if (!entry) {
-		async_cookie_t newcookie;
 		spin_lock_irqsave(&async_lock, flags);
 		newcookie = next_cookie++;
 		spin_unlock_irqrestore(&async_lock, flags);
 
 		/* low on memory.. run synchronously */
 		ptr(data, newcookie);
-		return;
+		return newcookie;
 	}
 	entry->func = ptr;
 	entry->data = data;
 
 	spin_lock_irqsave(&async_lock, flags);
-	entry->cookie = next_cookie++;
+	newcookie = entry->cookie = next_cookie++;
 	list_add_tail(&entry->list, &async_pending);
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
 	wake_up(&async_new);
+	return newcookie;
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
