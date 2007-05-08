Return-Path: <linux-kernel-owner+w=401wt.eu-S966299AbXEHTlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966299AbXEHTlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXEHTk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:40:57 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:52822 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754638AbXEHTk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:40:56 -0400
Date: Tue, 8 May 2007 21:40:54 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: nbd problem. 
Message-ID: <20070508194053.GA23615@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The nbd client still reliably hangs when I use it. 

While looking into this, I found:


446                 req->errors = 0;
447                 spin_unlock_irq(q->queue_lock);
                   ^^^^^^^^^^^^^^^^^^^^
448 
449                 mutex_lock(&lo->tx_lock);
450                 if (unlikely(!lo->sock)) {
451                         mutex_unlock(&lo->tx_lock);
452                         printk(KERN_ERR "%s: Attempted send on closed socket\n",
453                                lo->disk->disk_name);
454                         req->errors++;
455                         nbd_end_request(req);
456                         spin_lock_irq(q->queue_lock);
457                         continue;
458                 }
459 
460                 lo->active_req = req;
461 
462                 if (nbd_send_req(lo, req) != 0) {
463                         printk(KERN_ERR "%s: Request send failed\n",
464                                         lo->disk->disk_name);
465                         req->errors++;
466                         nbd_end_request(req);
467                 } else {
468                         spin_lock(&lo->queue_lock);
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
469                         list_add(&req->queuelist, &lo->queue_head);
470                         spin_unlock(&lo->queue_lock);
471                 }
472 
473                 lo->active_req = NULL;


As far as I read things, the function is called with the lock
held and interrupts disabled., the lock can then be released and 
retaken without disabling interrupts again. 

Should this be fixed?

(it doesn't fix my hang though....)

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
