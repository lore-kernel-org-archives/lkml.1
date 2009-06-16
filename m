Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbZFPL5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbZFPL5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbZFPL5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:57:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52099 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbZFPL5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:57:39 -0400
Date: Tue, 16 Jun 2009 13:57:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Steve Rottinger <steve@pentek.com>, linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
Message-ID: <20090616115741.GW11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <c384c5ea0906061425x3b1ef6eer51d8a7ddeec51e47@mail.gmail.com> <20090608070503.GB11363@kernel.dk> <c384c5ea0906121505g7ab137dp3bbc202da0d43bcd@mail.gmail.com> <20090613072611.GO11363@kernel.dk> <c384c5ea0906131304r5ef33826w81e6aa5bf9028340@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0906131304r5ef33826w81e6aa5bf9028340@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13 2009, Leon Woestenberg wrote:
> Hello Jens, Steve,
> 
> On Sat, Jun 13, 2009 at 9:26 AM, Jens Axboe<jens.axboe@oracle.com> wrote:
> > On Sat, Jun 13 2009, Leon Woestenberg wrote:
> >> On Mon, Jun 8, 2009 at 9:05 AM, Jens Axboe<jens.axboe@oracle.com> wrote:
> >> > On Sat, Jun 06 2009, Leon Woestenberg wrote:
> >> >> How can I pass information from the splice_read(), which spawns a hardware
> >> >> DMA to the pages in my case, to the confirm() hook which is called at some
> >> >> (random) time in the future?
> >> >
> >> > There's a ->private for each pipe_buffer, so you can pass along info on
> >> > a per-page granularity.
> >> >
> >> So, this means in my driver's splice_read(), I must set
> >> pipe->bufs[i]->private for each 0 <= i < PIPE_BUFFERS?
> >
> > Yes. There's no way to make it bigger granularity, since you could have
> > a mix of source pages in the pipe.
> >
> 
> My current splice support code is copied at the end of this email.
> 
> I would like to batch up some pages before I start the DMA transfer,
> as starting a device-driven DMA on page granularity (with a
> corresponding interrupt)
> looks like too much overhead to me.
> 
> I allocate a device transfer in splice_write(), which I would like to
> fill-in in my write actor pipe_to_device(). At some point, I have to
> start a transfer.
> 
> (sd-> len == sd->total_len) is not a strong enough condition, and I
> find that SPLICE_F_MORE is never set:
> 
> root@mpc8315e-rdb:~# /splice-in /7000-bytes.bin  | /splice-out -s8192 /dev/alt
> altpciesgdma_open(0xc74fc368, 0xc7be7000)
> 
> splice_write(len=8192)
> 
> transfer = 0xc7114140
> 
> pipe_to_device(buf->offset=0, sd->len/total_len=4096/8192, sd->data =
> 0xc7114140)
> 
> pipe_to_device() expect no more
> 
> pipe_to_device(buf->offset=0, sd->len/total_len=2904/4096, sd->data =
> 0xc7114140)
> 
> pipe_to_device() expect no more
> 
> splice_write(len=8192)
> 
> transfer = 0xc7114ac0
> 
> altpciesgdma_close(0xc74fc368, 0xc7be7000)
> 
> Is total_len <= PAGE_SIZE a sensible and robust (always occuring)
> condition that indicates the last buffer?

It's probably good enough I think. For best results, you want the caller
to pass you that information (since he knows). splice-in is just a dummy
test app, you could easily modify that to pass in SPLICE_F_MORE.

-- 
Jens Axboe

