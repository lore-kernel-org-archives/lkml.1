Return-Path: <linux-kernel-owner+w=401wt.eu-S1765439AbYBBIl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765439AbYBBIl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 03:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYBBIlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 03:41:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:14631 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbYBBIlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 03:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=gwL3BKZIZ3oVAvPx/gZJ64/T3aUbaMIJQoSglijvRVUKumex1Tp1e3R8uv9gf5Xe8JyttEFMaGAU90morpHhh1X8eCXQlmMAzTxXzQbaarReEAOLJs3zQq8XGs4lQ89VOH8XwcT8rysobLQCeZo9iSPO7aRJCxYf7jX/8Y9Sm1U=
Message-ID: <47A42CC7.1080401@gmail.com>
Date: Sat, 02 Feb 2008 17:41:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mao Rui <maorui@yuvad.com>
CC: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: SATA DOM is not identified by ata_piix module
References: <00da01c85999$0856e540$7740a8c0@cmaorui2>
In-Reply-To: <00da01c85999$0856e540$7740a8c0@cmaorui2>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------090003090208080906010600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090003090208080906010600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Mao Rui wrote:
> I tried to nail down when the problem was introduced. I compiled some
> official kernel release. Here is the result.
> 2.6.17.14   IDE -- Failed   SATA -- passed
> 2.6.18   IDE -- Failed   SATA -- failed
> 2.6.18.8   IDE -- Failed   SATA -- failed
> 2.6.24-rc7-git6  IDE -- passed   SATA DOM -- failed
> linux-2.6.24-rc8-git1   IDE -- passed    SATA -- failed
> All IDE failed reason is xfermode error, and all SATA failure is IDENTIFY
> error.
> 
> As you can find out, the failure of SATA DOM was introduced from kernel
> 2.6.18.
> 
> I'm not good at low level driver programming, so I cannot find out the root
> cause by myself. But if Alan or someone else needs more info or wants to
> test the patch, I'm glad to do it in my platform.

Does the attached patch make any difference?

-- 
tejun

--------------090003090208080906010600
Content-Type: text/x-patch;
 name="ata_dev_init_params-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ata_dev_init_params-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ce803d1..76d779a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1975,17 +1975,21 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 		 */
 		if (ata_id_major_version(id) < 4 || !ata_id_has_lba(id)) {
 			err_mask = ata_dev_init_params(dev, id[3], id[6]);
-			if (err_mask) {
+			if (err_mask == 0) {
+				/* current CHS translation info (id[53-58])
+				 * might be changed. reread the identify
+				 * device info.
+				 */
+				flags &= ~ATA_READID_POSTRESET;
+				goto retry;
+			} else if (err_mask == AC_ERR_DEV) {
+				ata_dev_printk(dev, KERN_INFO,
+					"INIT_DEV_PARAMS rejected by device\n");
+			} else {
 				rc = -EIO;
 				reason = "INIT_DEV_PARAMS failed";
 				goto err_out;
 			}
-
-			/* current CHS translation info (id[53-58]) might be
-			 * changed. reread the identify device info.
-			 */
-			flags &= ~ATA_READID_POSTRESET;
-			goto retry;
 		}
 	}
 

--------------090003090208080906010600--
