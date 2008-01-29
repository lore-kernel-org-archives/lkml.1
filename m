Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbYA2TL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbYA2TL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYA2TLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:11:19 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:48878 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbYA2TLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:11:18 -0500
Date: Tue, 29 Jan 2008 11:11:07 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "k-ueda@ct.jp.nec.com" <k-ueda@ct.jp.nec.com>,
       "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
Subject: Re: kernel BUG at drivers/block/cciss.c:1260! (with recent
	linux-2.6  tree)
Message-ID: <20080129191107.GP12400@plap3.qlogic.org>
References: <20080129175426.GJ12400@plap3.qlogic.org> <20080129180242.GZ15220@kernel.dk> <20080129180537.GA15220@kernel.dk> <20080129182217.GK12400@plap3.qlogic.org> <20080129182833.GG15220@kernel.dk> <20080129183705.GL12400@plap3.qlogic.org> <20080129184442.GK15220@kernel.dk> <20080129184929.GN12400@plap3.qlogic.org> <20080129185358.GM15220@kernel.dk> <DEE40752C8AF224BB890E455C7B8E0FE0423F6D181@G6W0268.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DEE40752C8AF224BB890E455C7B8E0FE0423F6D181@G6W0268.americas.hpqcorp.net>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Jan 2008 19:11:17.0348 (UTC) FILETIME=[B9569240:01C862AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Miller, Mike (OS Dev) wrote:

> Jens wrote:
> 
> > -----Original Message-----
> > From: Jens Axboe [mailto:jens.axboe@oracle.com]
> > Sent: Tuesday, January 29, 2008 12:54 PM
> > To: Andrew Vasquez
> > Cc: Linux Kernel Mailing List; Miller, Mike (OS Dev);
> > k-ueda@ct.jp.nec.com; j-nomura@ce.jp.nec.com
> > Subject: Re: kernel BUG at drivers/block/cciss.c:1260! (with
> > recent linux-2.6 tree)
> >
> > On Tue, Jan 29 2008, Andrew Vasquez wrote:
> > > On Tue, 29 Jan 2008, Jens Axboe wrote:
> > >
> > > > On Tue, Jan 29 2008, Andrew Vasquez wrote:
> > > > > On Tue, 29 Jan 2008, Jens Axboe wrote:
> > > > >
> > > > > > > Here the final snippet that was logged:
> > > > > > >
> > > > > > > [   12.724997] input: USB HID v1.01 Mouse [HP
> > Virtual Keyboard] on usb-0000:01:04.4-1
> > > > > > > [   12.728971] usbcore: registered new interface
> > driver usbhid
> > > > > > > [   12.732866] drivers/hid/usbhid/hid-core.c:
> > v2.6:USB HID core driver
> > > > > > > [   12.741172] TCP cubic registered
> > > > > > > [   12.744506] NET: Registered protocol family 1
> > > > > > > [   12.744884] NET: Registered protocol family 17
> > > > > > > [   12.749217] Freeing unused kernel memory: 228k freed
> > > > > > > [   12.885823] cciss rq: dev cciss/c0d0: type=2, flags=104c8
> > > > > > > [   12.888929]
> > > > > > > [   12.888930] sector 6510615555426900570, nr/cnr 0/0
> > > > > > > [   12.892895] bio ffff81042f130730, biotail
> > ffff81042f130730, buffer 0000000000000000, data
> > 0000000000000000, len 0
> > > > > > > [   12.896895] cdb: 12 00 00 00 fe 00 00 00 00 00
> > 00 00 00 00 00 00
> > > > > >
> > > > > > Ah ok, I see the problem... cciss is overriding the
> > data_len for
> > > > > > BLOCK_PC requests, hence it does not complete them properly.
> > > > > > Hmm. Does this work?
> > > > > >
> > > > > > diff --git a/drivers/block/cciss.c
> > b/drivers/block/cciss.c index
> > > > > > ef50068..b6fa52e 100644
> > > > > > --- a/drivers/block/cciss.c
> > > > > > +++ b/drivers/block/cciss.c
> > > > > > @@ -2524,7 +2524,6 @@ after_error_processing:
> > > > > >                 resend_cciss_cmd(h, cmd);
> > > > > >                 return;
> > > > > >         }
> > > > > > -       cmd->rq->data_len = 0;
> > > > > >         cmd->rq->completion_data = cmd;
> > > > > >         blk_complete_request(cmd->rq);  }
> > > > >
> > > > >
> > > > > Things look good so far -- with the patch above I can
> > finally boot
> > > > > the machine.
> > > >
> > > > Cool, sorry about that. Will get that applied asap. So after this
> > > > patch was applied, you didn't see any debug messages from
> > > > blk_dump_rq_flags() anymore, right?
> > >
> > > That's correct.  I've yet to see any additional debug-messages from
> > > blk_dump_rq_flags().
> >
> > Great, thanks for confirming. It does look like a clear bug
> > in cciss, it just got exposed now that it uses proper end
> > request handling. We never need to clear ->data_len, since
> > for blk_fs_request() it will be cleared on init. So just
> > setting a residual count there for blk_fs_request() like
> > cciss does is fine.
> 
> Just so I'm clear: just removing the one line is enough to resolve the problem?

That's correct.  The only other change to cciss.c in my tree is where
the BUG() call was replaced with a call to blk_dump_rq_flags():

	@@ -1257,7 +1257,8 @@ static void cciss_softirq_done(struct request *rq)
	 #endif                         /* CCISS_DEBUG */

		if (blk_end_request(rq, (rq->errors == 0) ? 0 : -EIO, blk_rq_bytes(rq)))
	-               BUG();
	+               blk_dump_rq_flags(rq, "cciss rq");
	+//             BUG();

		spin_lock_irqsave(&h->lock, flags);
		cmd_free(h, cmd, 1);
