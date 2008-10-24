Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYJXHJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYJXHJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYJXHJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:09:35 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:19067 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751913AbYJXHJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:09:34 -0400
Date: Fri, 24 Oct 2008 16:08:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
       jeff@garzik.org
Subject: Re: [PATCH 2/2] libata: switch to using block layer tagging support
Message-ID: <20081024070857.GA3785@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, tj@kernel.org, jeff@garzik.org
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com> <1224661243-7929-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224661243-7929-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 09:40:43AM +0200, Jens Axboe wrote:
> libata currently has a pretty dumb ATA_MAX_QUEUE loop for finding
> a free tag to use. Instead of fixing that up, convert libata to
> using block layer tagging - gets rid of code in libata, and is also
> much faster.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Unfortunately this change breaks SATA for me, bisecting picked out this
commit especially.

Before:

sata_sil 0000:00:01.0: Applying R_ERR on DMA activate FIS errata fix
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xfd000200 tf 0xfd000280 irq 66
ata2: SATA max UDMA/100 mmio m512@0xfd000200 tf 0xfd0002c0 irq 66
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7: SAMSUNG HM080JI, YC100-02, max UDMA7
ata1.00: 156368016 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 310)
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM080JI  YC10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156368016 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156368016 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk

After:

sata_sil 0000:00:01.0: Applying R_ERR on DMA activate FIS errata fix
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xfd000200 tf 0xfd000280 irq 66
ata2: SATA max UDMA/100 mmio m512@0xfd000200 tf 0xfd0002c0 irq 66
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7: SAMSUNG HM080JI, YC100-02, max UDMA7
ata1.00: 156368016 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 310)
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM080JI  YC10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156368016 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156368016 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:

Where it hangs until it times out after 180 seconds.

Built with:

CONFIG_ATA=y
CONFIG_SATA_PMP=y
CONFIG_ATA_SFF=y
CONFIG_SATA_SIL=y

I have no idea where to start looking at this, so hopefully someone has some
suggestions :-)
