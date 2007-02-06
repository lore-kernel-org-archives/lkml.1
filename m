Return-Path: <linux-kernel-owner+w=401wt.eu-S965580AbXBFXbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbXBFXbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXBFXaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:30:55 -0500
Received: from mail.screens.ru ([213.234.233.54]:58441 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030573AbXBFXaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:30:18 -0500
Date: Wed, 7 Feb 2007 02:30:16 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] workqueue: make cancel_rearming_delayed_workqueue() work on idle dwork
Message-ID: <20070206233016.GA108@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cancel_rearming_delayed_workqueue(dwork) will hang forever if dwork was not
scheduled, because in that case cancel_delayed_work()->del_timer_sync() never
returns true.

I don't know if there are any callers which may have problems, but this is
not so convenient, and the fix is very simple.

Q: looks like we don't need "struct workqueue_struct *wq" parameter. If the
timer was aborted successfully, get_wq_data() == wq. Is it worth to add the
new function?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/workqueue.c~3_cdw	2007-02-06 23:09:34.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-06 23:42:43.000000000 +0300
@@ -565,6 +565,10 @@ EXPORT_SYMBOL(flush_work_keventd);
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
 				       struct delayed_work *dwork)
 {
+	/* Was it ever queued ? */
+	if (!get_wq_data(&dwork->work))
+		return;
+
 	while (!cancel_delayed_work(dwork))
 		flush_workqueue(wq);
 }

