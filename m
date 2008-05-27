Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYEZU2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYEZU2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 16:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYEZU2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 16:28:04 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:5678 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbYEZU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 16:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=wBM4dI1mkp/TQjbG4tLif//TnABKybhhJNqjKVcR91JreLDYjzlrMvzSBiKa1RoYXkpuHu2+h+79F8XCsXKAVq12+GzxW0HVswvqy/pG4UaDEr5L0i6zwuNzqdAaDK+b9TTCacbpOfv7jeS8CDFYHNPF3oZXWL8zxOlLj6L/9aU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] block: handle blk_pm_resume_request() requests in blk_execute_rq_nowait()
Date: Tue, 27 May 2008 22:02:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Borislav Petkov <petkovbb@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805272202.01360.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For blk_pm_resume_request() requests (which are used only by IDE subsystem
currently) the queue is stopped so we need to call ->request_fn explicitly.

Thanks to:
- Rafael for reporting/bisecting the bug
- Borislav/Rafael for testing the fix

This is a preparation for converting IDE to use blk_execute_rq().

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes before "ide: convert ide_do_drive_cmd path to use blk_execute_rq" patch
in IDE tree

 block/blk-exec.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/block/blk-exec.c
===================================================================
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -58,6 +58,9 @@ void blk_execute_rq_nowait(struct reques
 	spin_lock_irq(q->queue_lock);
 	__elv_add_request(q, rq, where, 1);
 	__generic_unplug_device(q);
+	/* the queue is stopped so it won't be plugged+unplugged */
+	if (blk_pm_resume_request(rq))
+		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
