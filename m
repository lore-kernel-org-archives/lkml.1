Return-Path: <linux-kernel-owner+w=401wt.eu-S965539AbXCLK7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539AbXCLK7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965538AbXCLK7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:59:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:43166 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965534AbXCLK7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=PT+n1EpImv0CfU331SL2RA8CQqfRGruyg/IlLHATyNYS2EnSC+OiDmfVDb2syjjCcpEQCZWvGn/LqtjmdUzyn/mKsBBKHrGD+1MVakOPhjhSCC+yLPaDX9hjG8vZU5fEWIWEZk3RYQf3oa0+8CiyzKuRBjMvJNYW5k8oevVMoHc=
Message-ID: <45F53282.5040504@gmail.com>
Date: Mon, 12 Mar 2007 19:59:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Len Brown <lenb@kernel.org>
Subject: Re: s2ram still broken with CONFIG_NO_HZ / HPET (macbook pro)
References: <1173645941.4204.5.camel@localhost>
In-Reply-To: <1173645941.4204.5.camel@localhost>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------040209020702070605060702"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040209020702070605060702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Soeren Sonnenburg wrote:
> Elsewise I still see the
> 
> ATA: abnormal status 0x80 on port 0x000140df
> ATA: abnormal status 0x80 on port 0x000140df
> ata1.00: configured for UDMA/33
> ata3.01: revalidation failed (errno=-2)
> ata3: failed to recover some devices, retrying in 5 secs
> ATA: abnormal status 0x7F on port 0x000140df
> ATA: abnormal status 0x7F on port 0x000140df
> ata3.01: configured for UDMA/133

I can't tell much about HPET timer, only the ATA messages.

Abnormal messages can be ignored.  Hmmm... revalidation failed without
explaining why.  Can you apply the attached patch and see whether the
added message gets printed?

-- 
tejun

--------------040209020702070605060702
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 14629a3..50a7954 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1484,8 +1484,8 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 				     id, sizeof(id[0]) * ATA_ID_WORDS);
 	if (err_mask) {
 		if (err_mask & AC_ERR_NODEV_HINT) {
-			DPRINTK("ata%u.%d: NODEV after polling detection\n",
-				ap->print_id, dev->devno);
+			ata_dev_printk(dev, KERN_INFO,
+				       "NODEV after polling detection\n");
 			return -ENOENT;
 		}
 

--------------040209020702070605060702--
