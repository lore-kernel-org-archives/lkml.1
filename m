Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXC3VNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXC3VNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXC3VMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:12:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51777 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbXC3VMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:12:37 -0400
Date: Fri, 30 Mar 2007 14:06:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mark Lord <mlord@pobox.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 34/37] libata bugfix: HDIO_DRIVE_TASK
Message-ID: <20070330210659.GK29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-bugfix-hdio_drive_task.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mark Lord <liml@rtr.ca>

libata bugfix: HDIO_DRIVE_TASK

I was trying to use HDIO_DRIVE_TASK for something today,
and discovered that the libata implementation does not copy
over the upper four LBA bits from args[6].

This is serious, as any tools using this ioctl would have their
commands applied to the wrong sectors on the drive, possibly resulting
in disk corruption.

Ideally, newer apps should use SG_IO/ATA_16 directly,
avoiding this bug.  But with libata poised to displace drivers/ide,
better compatibility here is a must.

This patch fixes libata to use the upper four LBA bits passed
in from the ioctl.

The original drivers/ide implementation copies over all bits
except for the master/slave select bit.  With this patch,
libata will copy only the four high-order LBA bits,
just in case there are assumptions elsewhere in libata (?).

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/ata/libata-scsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -295,6 +295,7 @@ int ata_task_ioctl(struct scsi_device *s
 	scsi_cmd[8]  = args[3];
 	scsi_cmd[10] = args[4];
 	scsi_cmd[12] = args[5];
+	scsi_cmd[13] = args[6] & 0x0f;
 	scsi_cmd[14] = args[0];
 
 	/* Good values for timeout and retries?  Values below

-- 
