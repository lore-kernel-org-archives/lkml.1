Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbXLZBZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbXLZBZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 20:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXLZBZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 20:25:22 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:25307 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751278AbXLZBZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 20:25:21 -0500
Date: Wed, 26 Dec 2007 10:24:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH - SH/Dreamcast] CD-Rom (GD-Rom) support for the SEGA Dreamcast
Message-ID: <20071226012455.GA10332@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
References: <8b67d60712231143n51a17cdeu536b501855e870b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60712231143n51a17cdeu536b501855e870b2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 07:43:24PM +0000, Adrian McMenamin wrote:
> This patch adds support for the CD-Rom (the so-called "GD-Rom") on the
> SEGA Dreamcast.
> 
Looks quite a bit better. Just a few minor things.

> +static void gdrom_spicommand(void *spi_string, int buflen)
> +{
> +	short *cmd = spi_string;
> +	/* ensure IRQ_WAIT is set */
> +	ctrl_outb(0x08, GDROM_ALTSTATUS_REG);
> +	/* specify how many bytes we expect back */
> +	ctrl_outb(buflen & 0xFF, GDROM_BCL_REG);
> +	ctrl_outb((buflen >> 8) & 0xFF, GDROM_BCH_REG);
> +	/* other parameters */
> +	ctrl_outb(0, GDROM_INTSEC_REG);
> +	ctrl_outb(0, GDROM_SECNUM_REG);
> +	ctrl_outb(0, GDROM_ERROR_REG);
> +	/* Wait until we can go */
> +	gdrom_wait_clrbusy();
> +	ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
> +	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8)
> +		; /* wait for DRQ to be set to 1 */

cpu_relax()

> +static int gdrom_get_last_session(struct cdrom_device_info *cd_info,
> struct cdrom_multisession *ms_info)
> +{
> +	struct gdromtoc *tocA, *tocB;
> +	int fentry, lentry, track, data, tocuse;
> +	int err = -ENOMEM;
> +	tocA = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
> +	if (!tocA)
> +		goto exit;	
> +	tocB = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
> +	if (!tocB)
> +		goto clean_tocA;
> +	tocuse = 1;
> +	err = gdrom_readtoc_cmd(tocB, 1);
> +	if (err) {
> +		tocuse = 0;
> +		err = gdrom_readtoc_cmd(tocA, 0);
> +		if (err) {
> +			err = -ENXIO;
> +			printk(KERN_INFO "Could not get CD table of contents\n");
> +			goto clean_tocB;
> +		}	
> +	} else
> +		printk(KERN_DEBUG "Disk is GDROM\n");
> +
> +	kfree(gd.toc);
> +
> +	if (tocuse) {
> +		gd.toc = tocB;
> +		kfree(tocA);
> +	} else {
> +		gd.toc = tocA;
> +		kfree(tocB);
> +	}

tocA and tocB seem to be useless, as you're not using them for anything
but gd.toc assignment. If you're catching errors from gdrom_readtoc_cmd()
directly, then just pass in gd.toc in both cases, then you can skip all
of this temporary state stuff entirely.

> +	sense_key = sense[1] & 0x0F;
> +	switch (sense_key){
> +	case 0xB:
> +		printk(KERN_INFO "GDROM: Command aborted\n");
> +		break;
> +	case 0x7:
> +		printk(KERN_INFO "GDROM: Data protection error\n");
> +		break;
> +	case 0x6:
> +		printk(KERN_NOTICE "GDROM: Unit needs attention - possible disk switch\n");
> +		break;
> +	case 0x5:
> +		printk(KERN_INFO "GDROM: Illegal request - command has failed\n");
> +		break;
> +	case 0x4:
> +		printk(KERN_CRIT "GDROM: Hardware error\n");
> +		break;
> +	case 0x3:
> +		printk(KERN_WARNING "GDROM: Disk read error\n");
> +		break;
> +	case 0x2:
> +		printk(KERN_INFO "GDROM: Not ready\n");
> +		break;
> +	case 0x1:
> +		printk(KERN_DEBUG "GDROM: Recovered from error\n");
> +		break;
> +	case 0x0:
> +		/*success - stay silent*/
> +		break;
> +		
> +	default:
> +		printk(KERN_INFO "GDROM: Unknown error\n");
> +	}

These are all pretty close together, maybe it would be cleaner to throw
these strings in to an array and just use the sense_key as the array
index. Some other drivers do this already.
