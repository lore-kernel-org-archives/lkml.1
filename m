Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbXKAQEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbXKAQEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXKAQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:04:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:29153 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXKAQEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=IhHpA99xHMb/+xXtfTl0sllGmE8EBgGNTyDjdoW0zNAunUJOfV+uQj6c9CgHeGnsD0xGaMIRHn/TrjjYQ83nbMrjo8joti8DuvWCMceIvL2v5GOUt6ESXNp7uAZhJxfebnl+T9qGX2LzH9KRwJ3+uJtK8tKjVGeKzljsFXJJt4M=
Message-ID: <4729F8F1.4040103@gmail.com>
Date: Fri, 02 Nov 2007 01:04:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org> <20071101141501.3746cec2@the-village.bc.nu> <4729F1BB.20306@gentoo.org>
In-Reply-To: <4729F1BB.20306@gentoo.org>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------080600020807090405070903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080600020807090405070903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Daniel Drake wrote:
> Alan Cox wrote:
>> Lots of *other* problems occur instead. Daniel is reporting that if he
>> makes a stupid request to a buggy drive he gets a reset and the system
>> continues happily. Even that reset being a reset not a new command issue
>> is actually us being excessively paranoid.
> 
> Sorry if I'm sprouting nonsense here -- I don't have the knowledge that
> you all do. However, just wanted to point out that I looked up the info
> about that mode page in the MMC specs.
> 
> http://www.t10.org/ftp/t10/drafts/mmc4/mmc4r05a.pdf page 513.
> "E.3.3 MM Capabilities and Mechanical Status Page (Page Code 2Ah)"
> 
> The length of this mode page varies from drive to drive, so there is no
> "one size" that you can supply to the SG_IO command (unless you want to
> use a stupidly large buffer) to retrieve all the data at once. Instead,
> as Tejun describes, you put a short read request in first, look at byte
> 1 of the page which tells you the length, and then read the whole lot.
> 
> Again, ignore me if I'm not contributing anything useful, but I'm
> increasingly thinking that the SG_IO command block in question is
> perfectly valid, and doing a short read of the mode page in question
> (and probably others too) is in fact required before you can know its
> true size to do a full read anyway.

Yeap, the SG command is fine.  The drive is being weird tho.  The
allocation length field says 10 bytes, so it should just have
transferred 10 bytes without causing HSM violation.

Can you please apply the attached patch and report what the kernel says
after triggering the error condition?

-- 
tejun

--------------080600020807090405070903
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8ee56e5..5424a59 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5251,9 +5251,13 @@ fsm_start:
 			if (likely(status & (ATA_ERR | ATA_DF)))
 				/* device stops HSM for abort/error */
 				qc->err_mask |= AC_ERR_DEV;
-			else
+			else {
 				/* HSM violation. Let EH handle this */
+				ata_dev_printk(qc->dev, KERN_WARNING,
+					       "HSM violation: HSM_ST_FIRST: "
+					       "!DRQ && !ERR && !DF\n");
 				qc->err_mask |= AC_ERR_HSM;
+			}
 
 			ap->hsm_task_state = HSM_ST_ERR;
 			goto fsm_start;
@@ -5344,13 +5348,17 @@ fsm_start:
 				if (likely(status & (ATA_ERR | ATA_DF)))
 					/* device stops HSM for abort/error */
 					qc->err_mask |= AC_ERR_DEV;
-				else
+				else {
 					/* HSM violation. Let EH handle this.
 					 * Phantom devices also trigger this
 					 * condition.  Mark hint.
 					 */
+					ata_dev_printk(qc->dev, KERN_WARNING,
+						"HSM violation: HSM_ST: "
+						"!DRQ && !ERR && !DF\n");
 					qc->err_mask |= AC_ERR_HSM |
 							AC_ERR_NODEV_HINT;
+				}
 
 				ap->hsm_task_state = HSM_ST_ERR;
 				goto fsm_start;
@@ -5375,8 +5383,12 @@ fsm_start:
 					status = ata_wait_idle(ap);
 				}
 
-				if (status & (ATA_BUSY | ATA_DRQ))
+				if (status & (ATA_BUSY | ATA_DRQ)) {
+					ata_dev_printk(qc->dev, KERN_WARNING,
+						"HSM violation: HSM_ST: "
+						"ERR/DF w/ BUSY/DRQ\n");
 					qc->err_mask |= AC_ERR_HSM;
+				}
 
 				/* ata_pio_sectors() might change the
 				 * state to HSM_ST_LAST. so, the state
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 496edaf..8caaa77 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1394,6 +1394,8 @@ static void ata_eh_analyze_serror(struct ata_link *link)
 		action |= ATA_EH_SOFTRESET;
 	}
 	if (serror & SERR_PROTOCOL) {
+		ata_link_printk(link, KERN_WARNING,
+			       "HSM violation: analyze_serror: SERR_PROTOCOL\n");
 		err_mask |= AC_ERR_HSM;
 		action |= ATA_EH_SOFTRESET;
 	}
@@ -1504,6 +1506,8 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 	u8 stat = tf->command, err = tf->feature;
 
 	if ((stat & (ATA_BUSY | ATA_DRQ | ATA_DRDY)) != ATA_DRDY) {
+		ata_dev_printk(qc->dev, KERN_WARNING,
+			       "HSM violation: eh_analyze_tf: BUSY|DRQ\n");
 		qc->err_mask |= AC_ERR_HSM;
 		return ATA_EH_SOFTRESET;
 	}
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h

--------------080600020807090405070903--
