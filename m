Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYG3T1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYG3T1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYG3T1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:27:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:25580 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYG3T1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=ahoBHN6HGxR5/hMymZS1LTdM/KfoL1jnJG8qfUsNEeDhG3fJwolIe+JAUwljvPVD1h
         88Pvn0LbREl9tZmpq16P7BWc3E+3RpYUunZsfOeBm/hRRjsr51a0XUblwOtvnWPGj0TN
         9Ke1hy2rJ9dBY04bMP4Xm85mdXMBE2TghJaSQ=
Date: Wed, 30 Jul 2008 21:27:13 +0200
To: Greg KH <gregkh@suse.de>
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cd: fix endianity for the error message in
	cdrom_read_capacity
Message-ID: <20080730192713.GA4836@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Greg KH <gregkh@suse.de>,
	stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Petr Tesarik <ptesarik@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1217405406.11834.11.camel@elijah.suse.cz> <20080730011832.0ee55d47.akpm@linux-foundation.org> <9ea470500807300152p5d5414aaq2d0d0053c12ef3f5@mail.gmail.com> <20080730163327.GA23086@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080730163327.GA23086@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and here the rediffed one for 2.6.25.y:

---
From: Petr Tesarik <ptesarik@suse.cz>

Aesthetic regards aside, commit e8e7b9eb11c34ee18bde8b7011af41938d1ad667
still leaves a bug in the error message, because it uses the unconverted
big-endian value for printk.

Fix this by using a local variable in machine byte order. The result is
correct, more readable, and also produces slightly shorter code on i386.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
---
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index e54da02..3b388ca 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1411,6 +1411,7 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 
 	int stat;
 	struct request req;
+	__u32 blocklen;
 
 	ide_cd_init_rq(drive, &req);
 
@@ -1427,23 +1428,24 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	/*
 	 * Sanity check the given block size
 	 */
-	switch (capbuf.blocklen) {
-	case __constant_cpu_to_be32(512):
-	case __constant_cpu_to_be32(1024):
-	case __constant_cpu_to_be32(2048):
-	case __constant_cpu_to_be32(4096):
+	blocklen = be32_to_cpu(capbuf.blocklen);
+	switch (blocklen) {
+	case 512:
+	case 1024:
+	case 2048:
+	case 4096:
 		break;
 	default:
 		printk(KERN_ERR "%s: weird block size %u\n",
-			drive->name, capbuf.blocklen);
+			drive->name, blocklen);
 		printk(KERN_ERR "%s: default to 2kb block size\n",
 			drive->name);
-		capbuf.blocklen = __constant_cpu_to_be32(2048);
+		blocklen = 2048;
 		break;
 	}
 
 	*capacity = 1 + be32_to_cpu(capbuf.lba);
-	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	*sectors_per_frame = blocklen >> SECTOR_BITS;
 	return 0;
 }
 

-- 
Regards/Gruﬂ,
    Boris.
