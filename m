Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZEFIC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZEFIC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757061AbZEFIBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:01:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59184 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567AbZEFIBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:01:51 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
CC: "pierre@ossman.eu" <pierre@ossman.eu>, Tony Lindgren <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 6 May 2009 13:31:29 +0530
Subject: RE: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if
	using DMA
Thread-Topic: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if
	using DMA
Thread-Index: AcnNZ/m5/8MKE+GxRGWQOER2Yy6DygAuIxug
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB030555A1A2@dbde02.ent.ti.com>
In-Reply-To: <20090505095721.GA12287@angel.research.nokia.com>
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

On Tue, May 5, 2009, Jarkko Lavinen wrote: 
> On Tue, Apr 21, 2009 at 09:39:22AM +0200, ext Gadiyar, Anand wrote:
> > From: Anand Gadiyar <gadiyar@ti.com>
> > 
> > OMAP: HSMMC: Do not enable buffer ready interrupt if using DMA
> > 
> > This considerably reduces the number of interrupts during a transfer
> > and ought to result in some power saving.
> 
> I tried the patch with reading from the raw mmc block device to
> /dev/null with dd (with bs 32k and 1M).  I cannot see any
> difference in interrupt count from /proc/interrupts or in read
> speed. At least the patch works. Cpu was 34340es3.
> 
> I also trid without the patch just disabling the Buffer
> Read/write Ready bits from INT_EN_MASK which is then written to
> both MMCHS_IE and MMCHS_ISE.  Still no change in read speed nor
> mmc irq count.
> 
> Cheers
> Jarkko Lavinen

I discovered this while doing MMC writes. I did not check if there
was any difference during a read. I notice you have only tested with
MMC reads.

Here's what I get with and without the patch.

- Anand

Without patch
/ # mount -t vfat /dev/mmcblk0 /mnt/mmc
/ # cat /proc/interrupts | grep mmc
 83:         90        INTC  mmc0
384:          1     twl4030  mmc0
/ # dd if=/dev/zero of=/mnt/mmc/32kbs.txt bs=32k count=1000
1000+0 records in
1000+0 records out
/ # cat /proc/interrupts | grep mmc
 83:       3760        INTC  mmc0
384:          1     twl4030  mmc0
/ # dd if=/dev/zero of=/mnt/mmc/1Mbs.txt bs=1M count=32
32+0 records in
32+0 records out
/ # cat /proc/interrupts | grep mmc
 83:       7570        INTC  mmc0
384:          1     twl4030  mmc0
/ # ls -l /mnt/mmc
-rwxr-xr-x    1 root     root     33554432 Dec 31 18:03 1Mbs.txt
-rwxr-xr-x    1 root     root     32768000 Dec 31 18:03 32kbs.txt
/ # umount /mnt/mmc


With patch
/ # mount -t vfat /dev/mmcblk0 /mnt/mmc
/ # cat /proc/interrupts | grep mmc
 83:         67        INTC  mmc0
384:          0     twl4030  mmc0
/ # dd if=/dev/zero of=/mnt/mmc/32kbs.txt bs=32k count=1000
1000+0 records in
1000+0 records out
/ # cat /proc/interrupts | grep mmc
 83:       3103        INTC  mmc0
384:          0     twl4030  mmc0
/ # dd if=/dev/zero of=/mnt/mmc/1Mbs.txt bs=1M count=32
32+0 records in
32+0 records out
/ # cat /proc/interrupts | grep mmc
 83:       6170        INTC  mmc0
384:          0     twl4030  mmc0
/ # ls -l /mnt/mmc
-rwxr-xr-x    1 root     root     33554432 Dec 31 18:01 1Mbs.txt
-rwxr-xr-x    1 root     root     32768000 Dec 31 18:00 32kbs.txt
/ # umount /mnt/mmc