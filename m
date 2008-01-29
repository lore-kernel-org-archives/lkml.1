Return-Path: <linux-kernel-owner+w=401wt.eu-S1765932AbYA2TEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765932AbYA2TEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYA2TEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:04:32 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:40181 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562AbYA2TEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:04:30 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "k-ueda@ct.jp.nec.com" <k-ueda@ct.jp.nec.com>,
       "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
Date: Tue, 29 Jan 2008 19:03:41 +0000
Subject: RE: kernel BUG at drivers/block/cciss.c:1260! (with recent
  linux-2.6  tree)
Thread-Topic: kernel BUG at drivers/block/cciss.c:1260! (with recent
  linux-2.6  tree)
Thread-Index: AchiqFTmMRkPtSoKTUic88r1xRIGgwAAR1gA
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE0423F6D181@G6W0268.americas.hpqcorp.net>
References: <20080129175426.GJ12400@plap3.qlogic.org>
 <20080129180242.GZ15220@kernel.dk> <20080129180537.GA15220@kernel.dk>
 <20080129182217.GK12400@plap3.qlogic.org> <20080129182833.GG15220@kernel.dk>
 <20080129183705.GL12400@plap3.qlogic.org> <20080129184442.GK15220@kernel.dk>
 <20080129184929.GN12400@plap3.qlogic.org> <20080129185358.GM15220@kernel.dk>
In-Reply-To: <20080129185358.GM15220@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens wrote:

> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com]
> Sent: Tuesday, January 29, 2008 12:54 PM
> To: Andrew Vasquez
> Cc: Linux Kernel Mailing List; Miller, Mike (OS Dev);
> k-ueda@ct.jp.nec.com; j-nomura@ce.jp.nec.com
> Subject: Re: kernel BUG at drivers/block/cciss.c:1260! (with
> recent linux-2.6 tree)
>
> On Tue, Jan 29 2008, Andrew Vasquez wrote:
> > On Tue, 29 Jan 2008, Jens Axboe wrote:
> >
> > > On Tue, Jan 29 2008, Andrew Vasquez wrote:
> > > > On Tue, 29 Jan 2008, Jens Axboe wrote:
> > > >
> > > > > > Here the final snippet that was logged:
> > > > > >
> > > > > > [   12.724997] input: USB HID v1.01 Mouse [HP
> Virtual Keyboard] on usb-0000:01:04.4-1
> > > > > > [   12.728971] usbcore: registered new interface
> driver usbhid
> > > > > > [   12.732866] drivers/hid/usbhid/hid-core.c:
> v2.6:USB HID core driver
> > > > > > [   12.741172] TCP cubic registered
> > > > > > [   12.744506] NET: Registered protocol family 1
> > > > > > [   12.744884] NET: Registered protocol family 17
> > > > > > [   12.749217] Freeing unused kernel memory: 228k freed
> > > > > > [   12.885823] cciss rq: dev cciss/c0d0: type=2, flags=104c8
> > > > > > [   12.888929]
> > > > > > [   12.888930] sector 6510615555426900570, nr/cnr 0/0
> > > > > > [   12.892895] bio ffff81042f130730, biotail
> ffff81042f130730, buffer 0000000000000000, data
> 0000000000000000, len 0
> > > > > > [   12.896895] cdb: 12 00 00 00 fe 00 00 00 00 00
> 00 00 00 00 00 00
> > > > >
> > > > > Ah ok, I see the problem... cciss is overriding the
> data_len for
> > > > > BLOCK_PC requests, hence it does not complete them properly.
> > > > > Hmm. Does this work?
> > > > >
> > > > > diff --git a/drivers/block/cciss.c
> b/drivers/block/cciss.c index
> > > > > ef50068..b6fa52e 100644
> > > > > --- a/drivers/block/cciss.c
> > > > > +++ b/drivers/block/cciss.c
> > > > > @@ -2524,7 +2524,6 @@ after_error_processing:
> > > > >                 resend_cciss_cmd(h, cmd);
> > > > >                 return;
> > > > >         }
> > > > > -       cmd->rq->data_len = 0;
> > > > >         cmd->rq->completion_data = cmd;
> > > > >         blk_complete_request(cmd->rq);  }
> > > >
> > > >
> > > > Things look good so far -- with the patch above I can
> finally boot
> > > > the machine.
> > >
> > > Cool, sorry about that. Will get that applied asap. So after this
> > > patch was applied, you didn't see any debug messages from
> > > blk_dump_rq_flags() anymore, right?
> >
> > That's correct.  I've yet to see any additional debug-messages from
> > blk_dump_rq_flags().
>
> Great, thanks for confirming. It does look like a clear bug
> in cciss, it just got exposed now that it uses proper end
> request handling. We never need to clear ->data_len, since
> for blk_fs_request() it will be cleared on init. So just
> setting a residual count there for blk_fs_request() like
> cciss does is fine.

Just so I'm clear: just removing the one line is enough to resolve the problem?

-- mikem


>
> Anyway, it's in my pending queue for Linus.
>
> --
> Jens Axboe
>
>
