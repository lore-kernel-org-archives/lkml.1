Return-Path: <linux-kernel-owner+w=401wt.eu-S965251AbXAWRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965251AbXAWRzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 12:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965259AbXAWRzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 12:55:50 -0500
Received: from mail.screens.ru ([213.234.233.54]:50038 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965251AbXAWRzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 12:55:49 -0500
Date: Tue, 23 Jan 2007 20:57:14 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] videobuf_qbuf: fix? possible videobuf_queue->stream corruption and lockup
Message-ID: <20070123175714.GA299@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am pretty sure the bug is real, but the patch may be wrong, please review.

We are doing ->buf_prepare(buf) before adding buf to q->stream list. This
means that videobuf_qbuf() should not try to re-add a STATE_PREPARED buffer.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.19/drivers/media/video/video-buf.c~v4l_lockup	2006-11-17 19:42:25.000000000 +0300
+++ 6.19/drivers/media/video/video-buf.c	2007-01-23 19:44:19.000000000 +0300
@@ -700,6 +700,7 @@ videobuf_qbuf(struct videobuf_queue *q,
 		goto done;
 	}
 	if (buf->state == STATE_QUEUED ||
+	    buf->state == STATE_PREPARED ||
 	    buf->state == STATE_ACTIVE) {
 		dprintk(1,"qbuf: buffer is already queued or active.\n");
 		goto done;

