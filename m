Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbXC3XDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbXC3XDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932893AbXC3XDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:03:21 -0400
Received: from gretel.pobox.com ([208.58.1.197]:42398 "EHLO gretel.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900AbXC3XDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:03:20 -0400
Message-ID: <460D8435.3060503@pobox.com>
Date: Fri, 30 Mar 2007 17:42:13 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 34/37] libata bugfix: HDIO_DRIVE_TASK
References: <20070330205938.984247529@mini.kroah.org> <20070330210659.GK29450@kroah.com>
In-Reply-To: <20070330210659.GK29450@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Mark Lord <liml@rtr.ca>
> 
> libata bugfix: HDIO_DRIVE_TASK
> 
> I was trying to use HDIO_DRIVE_TASK for something today,
> and discovered that the libata implementation does not copy
> over the upper four LBA bits from args[6].
> 
> This is serious, as any tools using this ioctl would have their
> commands applied to the wrong sectors on the drive, possibly resulting
> in disk corruption.
> 
> Ideally, newer apps should use SG_IO/ATA_16 directly,
> avoiding this bug.  But with libata poised to displace drivers/ide,
> better compatibility here is a must.
> 
> This patch fixes libata to use the upper four LBA bits passed
> in from the ioctl.
> 
> The original drivers/ide implementation copies over all bits
> except for the master/slave select bit.  With this patch,
> libata will copy only the four high-order LBA bits,
> just in case there are assumptions elsewhere in libata (?).
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> Cc: Chuck Ebbert <cebbert@redhat.com>
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
..

Mmmm.. I've just noticed another bit we should  be preserving there,
both for *stable* and current mainline.

Instead of:

> +	scsi_cmd[13] = args[6] & 0x0f;

We should be doing:

> +	scsi_cmd[13] = args[6] & 0x4f;

As-is, the patch still helps, but it is not as useful as it could be.
Here's the fixed version.  I'm also sending out a 2.6.21 patch via Jeff.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
 drivers/ata/libata-scsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -295,6 +295,7 @@ int ata_task_ioctl(struct scsi_device *s
 	scsi_cmd[8]  = args[3];
 	scsi_cmd[10] = args[4];
 	scsi_cmd[12] = args[5];
+	scsi_cmd[13] = args[6] & 0x4f;
 	scsi_cmd[14] = args[0];
 
 	/* Good values for timeout and retries?  Values below

-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com 
