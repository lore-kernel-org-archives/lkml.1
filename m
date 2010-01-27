Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170Ab0A0OJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0A0OJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057Ab0A0OJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:09:36 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49045 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755018Ab0A0OJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:09:36 -0500
Date: Wed, 27 Jan 2010 17:09:34 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Josh Boyer <jwboyer@gmail.com>,
       Stefani Seibold <stefani@seibold.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 1/3] kfifo: Make kfifo_initialized work after kfifo_free
Message-ID: <20100127140934.GA31608@oksana.dev.rtsoft.ru>
References: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After kfifo rework it's no longer possible to reliably know if kfifo is
usable, since after kfifo_free(), kfifo_initialized() would still return
true. The correct behaviour is needed for at least FHCI USB driver.

This patch fixes the issue by resetting the kfifo to zero values (the
same approach is used in kfifo_alloc() if allocation failed).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 kernel/kfifo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 32c5c15..3b00bf8 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -97,6 +97,7 @@ EXPORT_SYMBOL(kfifo_alloc);
 void kfifo_free(struct kfifo *fifo)
 {
 	kfree(fifo->buffer);
+	_kfifo_init(fifo, NULL, 0);
 }
 EXPORT_SYMBOL(kfifo_free);
 
-- 
1.6.5.7

