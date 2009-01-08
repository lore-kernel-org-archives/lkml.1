Return-Path: <linux-kernel-owner+w=401wt.eu-S1761171AbZAHUvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbZAHUvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZAHUvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:51:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:33642 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZAHUvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:51:22 -0500
Date: Thu, 8 Jan 2009 12:53:17 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: Pekka Paalanen <pq@iki.fi>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, pq@iki.fi
Subject: [fix] Too async libata breakage
Message-ID: <20090108125317.648397d2@infradead.org>
In-Reply-To: <20090108221753.78648cd6@daedalus.pq.iki.fi>
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>
	<20090108221753.78648cd6@daedalus.pq.iki.fi>
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


> > Additional async_synchronize_full() helps and box boot to the end.

Hi Linus,

can you add the patch below to your tree? This makes the
async_synchronize_full() a real absolute async barrier, rather than
just synchronizing the work scheduled upto the starting point.
It's a bit too much for some cases (so later on I might introduce the
softer synchronization again) but it solves some real problems
for people so this should go into -rc1 please...

>From ca1827b142e41b54c612026b3c0b5d239f21a715 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 8 Jan 2009 12:35:11 -0800
Subject: [PATCH] async: make async_synchronize_full() more serializing

turns out that there are real problems with allowing async
tasks that are scheduled from async tasks to run after
the async_synchronize_full() returns.

This patch makes the _full more strict and a complete
synchronization. Later I might need to add back a lighter
form of synchronization for other uses.. but not right now.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/async.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 9737338..64cc916 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -206,7 +206,9 @@ EXPORT_SYMBOL_GPL(async_schedule_special);
 
 void async_synchronize_full(void)
 {
-	async_synchronize_cookie(next_cookie);
+	do {
+		async_synchronize_cookie(next_cookie);
+	} while (!list_empty(&async_running) || !list_empty(&async_pending));
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
