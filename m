Return-Path: <linux-kernel-owner+w=401wt.eu-S1764723AbYA2S2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764723AbYA2S2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYA2S2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:28:39 -0500
Received: from brick.kernel.dk ([87.55.233.238]:4854 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYA2S2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:28:38 -0500
Date: Tue, 29 Jan 2008 19:28:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mike.miller@hp.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com
Subject: Re: kernel BUG at drivers/block/cciss.c:1260! (with recent  linux-2.6  tree)
Message-ID: <20080129182833.GG15220@kernel.dk>
References: <20080129175426.GJ12400@plap3.qlogic.org> <20080129180242.GZ15220@kernel.dk> <20080129180537.GA15220@kernel.dk> <20080129182217.GK12400@plap3.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129182217.GK12400@plap3.qlogic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Andrew Vasquez wrote:
> On Tue, 29 Jan 2008, Jens Axboe wrote:
> 
> > Andrew, can you try with this applied?
> > 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > index ef50068..bd7b352 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -1257,7 +1257,7 @@ static void cciss_softirq_done(struct request *rq)
> >  #endif				/* CCISS_DEBUG */
> >  
> >  	if (blk_end_request(rq, (rq->errors == 0) ? 0 : -EIO, blk_rq_bytes(rq)))
> > -		BUG();
> > +		blk_dump_rq_flags(rq, "cciss rq");
> >  
> >  	spin_lock_irqsave(&h->lock, flags);
> >  	cmd_free(h, cmd, 1);
> 
> Here the final snippet that was logged:
> 
> [   12.724997] input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
> [   12.728971] usbcore: registered new interface driver usbhid
> [   12.732866] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> [   12.741172] TCP cubic registered
> [   12.744506] NET: Registered protocol family 1
> [   12.744884] NET: Registered protocol family 17
> [   12.749217] Freeing unused kernel memory: 228k freed
> [   12.885823] cciss rq: dev cciss/c0d0: type=2, flags=104c8
> [   12.888929] 
> [   12.888930] sector 6510615555426900570, nr/cnr 0/0
> [   12.892895] bio ffff81042f130730, biotail ffff81042f130730, buffer 0000000000000000, data 0000000000000000, len 0
> [   12.896895] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 

Ah ok, I see the problem... cciss is overriding the data_len for
BLOCK_PC requests, hence it does not complete them properly. Hmm. Does
this work?

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ef50068..b6fa52e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2524,7 +2524,6 @@ after_error_processing:
 		resend_cciss_cmd(h, cmd);
 		return;
 	}
-	cmd->rq->data_len = 0;
 	cmd->rq->completion_data = cmd;
 	blk_complete_request(cmd->rq);
 }

-- 
Jens Axboe

