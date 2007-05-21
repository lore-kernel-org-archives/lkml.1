Return-Path: <linux-kernel-owner+w=401wt.eu-S1761706AbXEULvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706AbXEULvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXEULvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:51:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:64199 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbXEULvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=k7ahOCRV4cqhfyl1UQ+CwHmmTizwVKTN1hdwUC4MSNgBKcYAkaXLQjqw3yvniL4asTRIOZQOUMM586wzy9TbkTrshhRUq5/9UBDBpe7Fbjc4ZTsjFehHIxV1RqjO2AJX4doGHMSR/0b77eH0gNwhyWftD9d2hHFLtmI1XU3fLo0=
Message-ID: <46518798.2020808@gmail.com>
Date: Mon, 21 May 2007 13:50:48 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@redhat.com, bzolnier@gmail.com,
       jgarzik@pobox.com
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com>
In-Reply-To: <4650B9E3.7070409@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------040100050801050204020801"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040100050801050204020801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Robert de Rooy wrote:
> Thanks for looking into this!
> 
> I tried the patches on 2.6.22rc1-git5. The second patch unfortunately
> did not resolve the issue, although it seems to get a bit further. Here
> are the logs.
> 
> ** 2.6.22rc1-git5 + timing-debug.patch

Oh I see.  The 2.6.22rc1-git5 has new reset sequencing which uses
deadline table so it takes 10sec to fail to first reset try while 2.6.21
needs 30secs.  That's where the 20sec difference per each try comes
from, so newer version is better.  Great.

> ** 2.6.22rc1-git5 + timing-debug.patch + disable-dev_init_params.patch
> May 20 23:02:26 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
> May 20 23:02:56 localhost kernel: ata3.00: qc timeout (cmd 0xef)
> May 20 23:02:56 localhost kernel: ata3.00: failed to set xfermode
> (err_mask=0x4)

Hmmm... It doesn't like SETXFERMASK either.  Please try the attached patch.

-- 
tejun

--------------040100050801050204020801
Content-Type: text/x-patch;
 name="disable-dev_init_param-and-setxfermode-for-CFA.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="disable-dev_init_param-and-setxfermode-for-CFA.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d5939e6..ad5fd5b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1769,6 +1769,7 @@ int ata_dev_read_id(struct ata_device *d
 			goto retry;
 	}
 
+#if 0
 	if ((flags & ATA_READID_POSTRESET) && class == ATA_DEV_ATA) {
 		/*
 		 * The exact sequence expected by certain pre-ATA4 drives is:
@@ -1793,6 +1794,7 @@ int ata_dev_read_id(struct ata_device *d
 			goto retry;
 		}
 	}
+#endif
 
 	*p_class = class;
 
@@ -2778,7 +2780,9 @@ static int ata_dev_set_mode(struct ata_d
 	if (dev->xfer_shift == ATA_SHIFT_PIO)
 		dev->flags |= ATA_DFLAG_PIO;
 
-	err_mask = ata_dev_set_xfermode(dev);
+	err_mask = 0;
+	if (!(dev->xfer_shift == ATA_SHIFT_PIO && ata_id_is_cfa(dev->id)))
+		err_mask = ata_dev_set_xfermode(dev);
 	/* Old CFA may refuse this command, which is just fine */
 	if (dev->xfer_shift == ATA_SHIFT_PIO && ata_id_is_cfa(dev->id))
         	err_mask &= ~AC_ERR_DEV;

--------------040100050801050204020801--
