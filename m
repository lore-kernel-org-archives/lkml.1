Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZAaD13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZAaD13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZAaDZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:25:32 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34934 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbZAaDZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:25:31 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Fri, 30 Jan 2009 19:25:14 -0800
Subject: [patch 6/7] epoll keyed wakeups - make eventfd use keyed wakeups
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.16376.1233372319.6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch introduces keyed event wakeups inside the eventfd code.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-01-30 12:11:32.000000000 -0800
+++ linux-2.6.mod/fs/eventfd.c	2009-01-30 12:11:48.000000000 -0800
@@ -50,7 +50,7 @@ int eventfd_signal(struct file *file, in
 		n = (int) (ULLONG_MAX - ctx->count);
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked(&ctx->wqh);
+		kwake_up_locked(&ctx->wqh, POLLIN);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
@@ -120,7 +120,7 @@ static ssize_t eventfd_read(struct file 
 	if (res > 0) {
 		ctx->count = 0;
 		if (waitqueue_active(&ctx->wqh))
-			wake_up_locked(&ctx->wqh);
+			kwake_up_locked(&ctx->wqh, POLLOUT);
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
@@ -169,7 +169,7 @@ static ssize_t eventfd_write(struct file
 	if (res > 0) {
 		ctx->count += ucnt;
 		if (waitqueue_active(&ctx->wqh))
-			wake_up_locked(&ctx->wqh);
+			kwake_up_locked(&ctx->wqh, POLLIN);
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 

