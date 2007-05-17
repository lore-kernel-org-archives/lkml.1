Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbXEQTZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbXEQTZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbXEQTZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:25:43 -0400
Received: from mail.screens.ru ([213.234.233.54]:41268 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbXEQTZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:25:42 -0400
Date: Thu, 17 May 2007 23:25:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] revert "cancel_delayed_work: use del_timer() instead of del_timer_sync()"
Message-ID: <20070517192537.GA969@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Jarek Poplawski, the patch

	[WORKQUEUE]: cancel_delayed_work: use del_timer() instead of del_timer_sync()
	commit: 071b638689464c6b39407025eedd810d5b5e6f5d

was wrong, it was merged by mistake after that.

>From the changelog:

	after this patch:
		...
		delayed_work_timer_fn->__queue_work() in progress.

		The latter doesn't differ from the caller's POV,

it does make a difference if the caller calls flush_workqueue() after
cancel_delayed_work(), in that case flush_workqueue() can miss this
work_struct.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/include/linux/workqueue.h~	2007-05-17 22:55:59.000000000 +0400
+++ t/include/linux/workqueue.h	2007-05-17 23:03:03.000000000 +0400
@@ -160,7 +160,7 @@ static inline int cancel_delayed_work(st
 {
 	int ret;
 
-	ret = del_timer(&work->timer);
+	ret = del_timer_sync(&work->timer);
 	if (ret)
 		work_clear_pending(&work->work);
 	return ret;

