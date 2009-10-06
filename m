Return-Path: <linux-kernel-owner+w=401wt.eu-S1750997AbZJFEIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbZJFEIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZJFEId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:08:33 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:43793 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZJFEId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:08:33 -0400
Date: Mon, 5 Oct 2009 23:06:45 -0500
From: David Fries <david@fries.net>
To: David Miller <davem@davemloft.net>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org, d.stussy@yahoo.com,
       joao.ramos@inov.pt, torvalds@osdl.org, rjw@sisk.pl, vojtech@suse.cz
Subject: Re: [bisected] 2.6.31 regression sis5513 PIO Mode 0 hang
Message-ID: <20091006040644.GB32331@spacedout.fries.net>
References: <20091003025415.GA28295@spacedout.fries.net> <4AC7F306.2040409@gmail.com> <20091005025549.GA32331@spacedout.fries.net> <20091004.205848.109978798.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004.205848.109978798.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 05 Oct 2009 23:07:04 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 08:58:48PM -0700, David Miller wrote:
> From: David Fries <david@fries.net>
> Date: Sun, 4 Oct 2009 21:55:50 -0500
> 
> > First, if I'm going to do much debugging, how would I force the
> > ethernet device to come up first so I have netconsole?
> > 
> > How is the problem patch,
> > +       ide_port_for_each_dev(i, drive, hwif) {
> > +               if (port_ops && port_ops->set_pio_mode)
> > +                       port_ops->set_pio_mode(drive, 0);
> > +       }
> > 
> > Different from using hdparm to set the mode?  I do this,
> > hdparm -p 0 /dev/hda
> > hdparm -X pio0 /dev/hda
> > and the benchmarks give me about what I would expect 7MB/s instead of
> > the normal 40MB/s.
> > 
> > Then I can re-enable with,
> > hdparm -p 4 /dev/hda
> > hdparm -X udma5 /dev/hda
> > hdparm -d 1 /dev/hda
> > hda: UDMA/100 mode selected
> > and the drive is back up to speed, and obviously the kernel didn't
> > freeze.  Should there be anything different between what the patch
> > tried, and and hdparm's doing, other than kernel initiated and start
> > and a user program later on?
> 
> >From your original hang trace I can only guess that the problematic
> sequence is putting your CDROM into PIO0, then putting it into
> PIO4, and then immediately reading the TOC.

You are correct, it is in ide_cd_read_toc, down in the ide_transfer_pc
and output_data calls, but it isn't time dependent.  I put a five
second sleep at the start of ide_cd_read_toc, so I don't think it is a
race condition.

> This is what the ide-cd.c code does right about where you get the
> hang.
> 
> Debugging this further is really totally pointless for a subsystem
> that should be in deep maintainence mode, so I'm just going to
> revert.

Works for me, thanks.

> Thanks.


Uniform CD-ROM driver Revision: 3.20
ide_cd_read_toc: enter
cdrom_check_status: enter
ide_cd_queue_pc
ide_cd_do_request
ide_cd_do_request: dev hdc: type=a, flags=108a440
  sector 18446744073709551615, nr/cnr 0/0
cdrom_do_block_pc: rq->cmd[0]: 0x0, rq->cmd_type: 0xa
cdrom_do_block_pc: leave
calling ide_prep_sense
ide_prep_sense returned
calling ide_issue_pc
calling ide_dma_prepare if 0
ide_dma_prepare returned
calling ide_init_packet_cmd
ide_init_packet_cmd returned
calling do_rw_taskfile
do_rw_taskfile returned
calling ide_execute_command
ide_execute_command returned
calling ide_transfer_pc
calling hwif->tp_ops->output_data

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
