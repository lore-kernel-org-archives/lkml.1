Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbXJRBcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbXJRBcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759770AbXJRBb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:31:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50749 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbXJRBbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:31:55 -0400
Message-ID: <4716B786.80804@garzik.org>
Date: Wed, 17 Oct 2007 21:31:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Mathieu Fluhr <mfluhr@nero.com>, LKML <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: Inquiry data and emulated SG devices
References: <fa.PgEHbZ0E5ogcX8bZwvrUeZB+eJs@ifi.uio.no> <4716B56A.1090501@shaw.ca>
In-Reply-To: <4716B56A.1090501@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This doesn't seem a very reliable way to identify an IDE device, as all
> that 0 means is that the device does not claim conformance to any
> standard. I would think it would be legitimate for an IDE device to put
> a value like 5 in there as well, if it complies with SPC-4..

Via the this-doesnt-really-matter-but-it-should-be-noted department:

According to the latest on t10.org, MMC retroactively permitted SCSI 
version to be zero, for MMC-compliant USB and ATAPI devices.


> In the case of libata though, that appears to be due to this code in
> drivers/ata/libata-scsi.c:
> 
>     /* ATAPI devices typically report zero for their SCSI version,
>      * and sometimes deviate from the spec WRT response data
>      * format.  If SCSI version is reported as zero like normal,
>      * then we make the following fixups:  1) Fake MMC-5 version,
>      * to indicate to the Linux scsi midlayer this is a modern
>      * device.  2) Ensure response data format / ATAPI information
>      * are always correct.
>      */
>             if (buf[2] == 0) {
>                 buf[2] = 0x5;
>                 buf[3] = 0x32;
>             }
> 
> This technically seems to go against what the SCSI/ATA Translation (SAT)
> spec says regarding INQUIRY on ATAPI devices: "the SATL shall use the
> ATA PACKET Command feature set to pass all INQUIRY commands and
> parameter data to the ATAPI device without altering the INQUIRY
> commands or the parameter data." However, it might realistically be
> needed if the SCSI layer in the kernel has problems with a device
> indicating it supports no SCSI version..

The above tweak is entirely software->software communication...  as the 
comment you quoted notes, it's just a signal to the SCSI midlayer.

At the moment, the SCSI midlayer assumes any device that reports scsi 
version as less than 2 is forced to SCSI version 2.  Ultimately that's 
incorrect behavior for all ATAPI devices (and later MMC revisions).

At the time, libata simply worked around this SCSI buglet in its own 
code, since that was easier than auditing all SCSI code paths to ensure 
new ATAPI/USB MMC logic does not break ancient devices.

But if someone is motivated enough to revisit this...

	Jeff


