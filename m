Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYKTEzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYKTEzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 23:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYKTEz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 23:55:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYKTEz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 23:55:26 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Exiting queue and task might race to free cic
Date: Thu, 20 Nov 2008 10:27:06 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, Fabio Checconi <fchecconi@gmail.com>
References: <200811191527.18539.knikanth@suse.de> <20081119141531.GG26308@kernel.dk>
In-Reply-To: <20081119141531.GG26308@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201027.07860.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2008 19:45:31 Jens Axboe wrote:
> On Wed, Nov 19 2008, Nikanth Karthikesan wrote:

> Not sure this is enough, we probably need to copy the key to ensure that
> we get a fresh value. How does this look?
>

Agreed. Read barrier required. But the compiler hint, "likely" can stay?

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..4504b94 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1318,7 +1318,15 @@ static void cfq_exit_single_io_context(struct 
io_context *ioc,
 		unsigned long flags;
 
 		spin_lock_irqsave(q->queue_lock, flags);
-		__cfq_exit_single_io_context(cfqd, cic);
+
+		/*
+		 * Ensure we get a fresh copy of the ->key to prevent
+		 * race between exiting task and queue
+		 */
+		smp_read_barrier_depends();
+		if (likely(cic->key))
+			__cfq_exit_single_io_context(cfqd, cic);
+
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }


> Did you actually trigger this, or is it just from code inspection?
>

No. But I am looking at another bug report on Suse Kernel where the bug is 
triggered during reboot when the kernel thread usb_stor_scan_thread exits.

Thanks
Nikanth Karthikesan
