Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXFUTrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXFUTrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXFUTre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:47:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45330 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbXFUTrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:47:33 -0400
Date: Thu, 21 Jun 2007 14:47:31 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stuart_Hayes@dell.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070621194731.GB8840@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com> <4677FFF1.2010308@ru.mvista.com> <20070619164854.GR5836@austin.ibm.com> <200706192043.40298.bzolnier@gmail.com> <46783777.10607@ru.mvista.com> <20070620162845.GY5836@austin.ibm.com> <20070620180123.642316ae@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620180123.642316ae@the-village.bc.nu>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 06:01:23PM +0100, Alan Cox wrote:
> 
> Its unlikely the command got lost. The IRQ could have done but the error
> path tries to spot that case by reading the status register - which
> hangs. So in theory it could be a lost IRQ and if the reset works we'll
> find that out.

OK, here's the libata trace info (transcribed by hand, may have typos,
the numerical values should be correct).

This is during the first read of the partition table, during boot.

ata_scsi_dumb_cb: CDB(:1:0,0,0) 28 00 00 00 00 00 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_fill_sg: PRD[0] = (0x2FEEF000, 0x1000)
ata1: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: feat 0x0 nsect 0x8 lba 0x0 0x0 0x0
ata_tf_load: device 0xE0
ata_exec_command: ta1: cmd 0xc8
ata_scsi_translate: EXIT

then, 30 seconds later:

sd 0:0:0:0 [sda] Done: 0xeff3aba0 TIMEOUT
sd 0:0:0:0 [sda] Result: host_byte=DID_OK driver_byte=DRV_OK, SUG_OK
sd 0:0:0:0 [sda] CDB: Read(10): 28 00 00 ... 00 08 00
sd 0:0:0:0 [sda] scsi host busy 1 failed 0
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_port_flush_task: ENTER
ata_port_flush_task: flush #1
ata1: ata_port_flush_task: flush #2
ata_port_flush_task: EXIT

Then a hard hang here.

This was on 2.6.22-rc5-git1
Again, this disk and controller combo work spotlessly when using 
the ide drivers.


--linas
