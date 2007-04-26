Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbXDZGkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbXDZGkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXDZGkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:40:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28096 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbXDZGka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:40:30 -0400
Date: Thu, 26 Apr 2007 08:39:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, linux-ide@vger.kernel.org
Subject: Re: BUG: Null pointer dereference in fs/open.c
Message-ID: <20070426063910.GB3640@kernel.dk>
References: <Pine.LNX.4.64.0704231633210.25153@server.thyself> <Pine.LNX.4.64.0704240347470.25153@server.thyself> <20070423215810.5a24ed9a.akpm@linux-foundation.org> <Pine.LNX.4.64.0704240507110.25153@server.thyself> <20070423221726.ccfa982c.akpm@linux-foundation.org> <Pine.LNX.4.64.0704240527030.25153@server.thyself> <20070425004816.bd0c240a.akpm@linux-foundation.org> <Pine.LNX.4.64.0704251701290.25153@server.thyself> <20070425160534.00c3a3d4.akpm@linux-foundation.org> <Pine.LNX.4.64.0704260029400.25153@server.thyself>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704260029400.25153@server.thyself>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, William Heimbigner wrote:
> On Wed, 25 Apr 2007, Andrew Morton wrote:
> >On Wed, 25 Apr 2007 22:53:00 +0000 (GMT) William Heimbigner 
> ><icxcnika@mar.tar.cc> wrote:
> >
> >>On Wed, 25 Apr 2007, Andrew Morton wrote:
> >><snip>
> >>>OK.  I am able to use the pktcdvd driver OK in mainline with a piix/sata
> >>>drive.  It could be that something is going wrong at the IDE level for 
> >>>you.
> >>Perhaps; I'll try an external usb cd burner, and see where that goes.
> >>
> >>>Are you able to identify the most recent kernel which actually worked?
> >>No, because I haven't set packet writing up in Linux before - however, I 
> >>do know
> >>that I've successfully set up packet writing (using 2 of the 3 cd burners 
> >>I
> >>have) in another operating system before. I'll try 2.6.18 and see if that 
> >>gets
> >>me anywhere different, though.
> >
> >OK.
> >
> >A quick summary: mainline's pktcdvd isn't working for William using IDE.
> >It is working for me using sata.
> >
> <snip>
> >
> >So what has happened here is that this code, in ide-cd.c's
> >cdrom_decode_status() is now triggering:
> >
> >	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
> >		/* All other functions, except for READ. */
> >		unsigned long flags;
> >
> >		/*
> >		 * if we have an error, pass back CHECK_CONDITION as the
> >		 * scsi status byte
> >		 */
> >		if (blk_pc_request(rq) && !rq->errors)
> >			rq->errors = SAM_STAT_CHECK_CONDITION;
> >
> >
> >I suspect this is a bug introduced by
> >406c9b605cbc45151c03ac9a3f95e9acf050808c (in which case it'll be the third
> >bug so far).
> >
> >Perhaps the IDE driver was previously not considering these requests to be
> >of type blk_pc_request(), and after
> >406c9b605cbc45151c03ac9a3f95e9acf050808c it _is_ treating them as
> >blk_pc_request() and is incorrectly reporting an error.  Or something like
> >that.
> >
> >Guys: help!
> >
> A follow-up: after looking around a bit, I have managed to get packet 
> writing to work properly on /dev/hdc (before, it was reporting only 1.8 MB 
> available or so; this was a formatting issue).
> I've also gotten the external cd-rw drive to work. However, I'm still at a 
> loss as to why /dev/hdd won't work. I tried formatting a dvd-rw for this 
> drive, however, it consistently gives me:
> [27342.503933] drivers/ide/ide-cd.c:729: setting error to 2
> [27342.509251]  [<c010521a>] show_trace_log_lvl+0x1a/0x30
> [27342.514411]  [<c0105952>] show_trace+0x12/0x20
> [27342.518864]  [<c0105a46>] dump_stack+0x16/0x20
> [27342.523317]  [<c033f6e4>] cdrom_decode_status+0x1f4/0x3b0
> [27342.528732]  [<c033fae8>] cdrom_newpc_intr+0x38/0x320
> [27342.533791]  [<c0331106>] ide_intr+0x96/0x200
> [27342.538157]  [<c0150cf8>] handle_IRQ_event+0x28/0x60
> [27342.543139]  [<c0151f96>] handle_edge_irq+0xa6/0x130
> [27342.548121]  [<c0106449>] do_IRQ+0x49/0xa0
> [27342.552228]  [<c0104c3a>] common_interrupt+0x2e/0x34
> [27342.557200]  [<c01022d2>] mwait_idle+0x12/0x20
> [27342.561653]  [<c01023ca>] cpu_idle+0x4a/0x80
> [27342.565934]  [<c0101147>] rest_init+0x37/0x40
> [27342.570300]  [<c068ac7b>] start_kernel+0x34b/0x420
> [27342.575109]  [<00000000>] 0x0
> [27342.578089]  =======================
> and doesn't work (the above output was generated by Andrew's patch to log 
> certain areas).
> 
> # dvd+rw-format /dev/hdd -force
> * BD/DVDRW/-RAM format utility by <appro@fy.chalmers.se>, version 7.0.
> :-( failed to locate "Quick Format" descriptor.
> * 4.7GB DVD-RW media in Sequential mode detected.
> * formatting 0.0\:-[ READ TRACK INFORMATION failed with 
> SK=3h/ASC=11h/ACQ=05h]: Input/output error

That's an uncorrectable read error. Is the media good?

> I tried putting in a different dvd-rw, and this time I get:
> # dvd+rw-format /dev/hdd -force
> * BD/DVDRW/-RAM format utility by <appro@fy.chalmers.se>, version 7.0.
> * 4.7GB DVD-RW media in Sequential mode detected.
> * formatting 0.0|:-[ FORMAT UNIT failed with SK=5h/ASC=26h/ACQ=00h]: 
> Input/output error

That's the drive complaining about an invalid bit being set in the
command descriptor block. That's usually a bug in the issuer.

-- 
Jens Axboe

