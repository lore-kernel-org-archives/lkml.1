Return-Path: <linux-kernel-owner+w=401wt.eu-S1762478AbXLUMOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762478AbXLUMOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761568AbXLUMOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:14:40 -0500
Received: from brick.kernel.dk ([87.55.233.238]:17687 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761495AbXLUMOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:14:38 -0500
Date: Fri, 21 Dec 2007 13:14:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH - SH/Dreamcast] Add support for GD-Rom device
Message-ID: <20071221121441.GB11583@kernel.dk>
References: <8b67d60712201559h5dbb2a17q8f16223b26b88006@mail.gmail.com> <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21 2007, Adrian McMenamin wrote:
> On 20/12/2007, Adrian McMenamin <lkmladrian@gmail.com> wrote:
> > This patch adds support for the CD Rom device (called a "GD Rom") on
> > the SEGA Dreamcast.This device has a command block similar to a
> > standard ATA-3 device, though implements Sega's proprietary packet
> > interface - the so-called "Sega Packet Interface".
> >
> 
> Fairly typically, I noticed I had chopped the final line from the
> patch as soon as I had sent it.
> 
> I've also fixed a small difference in the Kconfig

You should properly protect gdrom_deferred, the locking is not clear
there. In gdrom_readdisk_dma() I would do:

static void gdrom_readdisk_dma(struct work_struct *work)
{
        ...

        read_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
        if (!read_command)
                probably just defer the work to some time later

        spin_lock(&gdrom_lock);
        while (!list_empty(&gdrom_deferred)) {
                req = list_entry(gdrom_deferred.next, struct request, queuelist);
                list_del_init(&req->queuelist);
                spin_unlock(&gdrom_lock);

                ...

                spin_lock(&gdrom_lock);
        };

        kfree(read_command);
}

That's a lot more obvious imho and doesn't suffer from potential races
or list reordering. Your read_command allocation and free for every
command also seems pretty pointless, so move that outside the loop.

What is pages doing in gdrom_request()?

Your design is also heavily geared towards there just being a single
CDROM, I'm assuming this wont be a problem given your hw (it sets a bad
example for others to follow though, lots of violations against normal
programming practice for multiple devices and smp).

-- 
Jens Axboe

