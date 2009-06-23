Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbZFWO7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbZFWO7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbZFWO64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:58:56 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:58347 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232AbZFWO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:58:55 -0400
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
Date: Tue, 23 Jun 2009 16:58:54 +0200
User-Agent: KMail/1.9.9
References: <200906221938.27574.bzolnier@gmail.com> <200906222335.06700.bzolnier@gmail.com> <20090623.031506.214747802.davem@davemloft.net>
In-Reply-To: <20090623.031506.214747802.davem@davemloft.net>
Cc: bzolnier@gmail.com, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231658.56489.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jun 2009 14:58:57.0677 (UTC) FILETIME=[227A5BD0:01C9F413]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, you wrote:
> We might need to bisect this one.  But Frans, just for the record
> could you simply test reverting just that hunk?  Thanks!

I'm way ahead of you :-)

Instead of a bisect [1] I decided to first see if some printks in both .26 
and .31 would show anything useful.

With 2.6.31 and code included below I get:
hda: ST34342A, ATA DISK drive
FJP: id_dma_bug 0x7: &4: 0x0-0x4 no error
hda: MWDMA2 mode selected
hdc: Maxtor 6E040L0, ATA DISK drive
hdd: CD-ROM 56X/AKH, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
FJP: ID_FIELD_VALID: 0x7 (true)
FJP: id_dma_bug 0x7: &4: 0x0-0x4 no error
hdc: MWDMA2 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
FJP: ID_FIELD_VALID: 0x2 (true)
FJP: id_dma_bug 0x2: &2: 0x1-0x1 bad modes		<-------------
hdd: bad DMA info in identify block

Note that this included a complete revert of 8d64fcd9 (with minor conflict 
resolved).

Here's the same output with 2.6.26.3 with equivalent debug statements:
hda: ST34342A, ATA DISK drive
FJP: id_dma_bug 0x7: &4: 0x0-0x0 no error
hda: MWDMA2 mode selected
hdc: Maxtor 6E040L0, ATA DISK drive
hdd: CD-ROM 56X/AKH, ATAPI CD/DVD-ROM drive
FJP: id_dma_bug 0x7: &4: 0x0-0x0 no error
hdc: MWDMA2 mode selected
FJP: id_dma_bug 0x2: &2: 0x0-0x0 no error		<-------------
hdd: MWDMA2 mode selected

So it seems to me that in 2.6.26 something was broken in the way these ID 
fields were handled, at least in this check. This is now fixed (possibly 
by the changes around 5b90e990..48fb2688) and *that* causes the 
regression. Note that the hard disks are also affected.

If I'm correct I guess that supports Bart's patch to just remove the whole 
thing. But did this only affect the id_dma_bug check or also the use of 
these fields elsewhere?

Cheers,
FJP

[1] I don't have a crossbuild environment for sparc, so a bisect would be
    painful with 300MHz; I at least have plenty memory luckily.

int ide_id_dma_bug(ide_drive_t *drive)
{
        u16 *id = drive->id;

	printk("FJP: id_dma_bug 0x%x:", id[ATA_ID_FIELD_VALID]);
        if (id[ATA_ID_FIELD_VALID] & 4) {
		printk(" &4: 0x%x-0x%x", (id[ATA_ID_UDMA_MODES] >> 8),
					 (id[ATA_ID_MWDMA_MODES] >> 8));
                if ((id[ATA_ID_UDMA_MODES] >> 8) &&
                    (id[ATA_ID_MWDMA_MODES] >> 8)) {
			printk(" bad modes");
                        goto err_out;
                }
        } else if (id[ATA_ID_FIELD_VALID] & 2) {
		printk(" &2: 0x%x-0x%x", (id[ATA_ID_MWDMA_MODES] >> 8),
					 (id[ATA_ID_SWDMA_MODES] >> 8));
                if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
                    (id[ATA_ID_SWDMA_MODES] >> 8)) {
			printk(" bad modes");
                        goto err_out;
                }
        }
	printk(" no error\n");
        return 0;
err_out:
	printk("\n");
        printk(KERN_ERR "%s: bad DMA info in identify block\n", 
drive->name);
        return 1;
}
