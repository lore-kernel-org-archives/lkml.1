Return-Path: <linux-kernel-owner+w=401wt.eu-S965317AbXCLIYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965317AbXCLIYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXCLIYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:24:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:42766 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965317AbXCLIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Mp92l80JuBSmcSRGRVVYs0WLQZj5T3nFrZluDw6zEM+A3w+UDQv6kQYTDsk/WLOf0DcPqQ+wcEa/9UHIWcdNJxDQAu1vJ18viAzkdTgOFVMqsiVBBuaSMTePqnlOwYxzzGLhXovWrezoJ/pD6b/bhSfvFAo1uKv/Vw+It4q4hpw=
Message-ID: <45F50E28.7010509@gmail.com>
Date: Mon, 12 Mar 2007 17:24:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Fabio Comolli <fabio.comolli@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: [PATCH] libata: don't whine if ->prereset() returns -ENOENT
References: <20070309163148.GA12848@havoc.gtf.org>	<b637ec0b0703091324q7f15fddbpc8c24b4e1131e3f4@mail.gmail.com> <20070309234839.2070a265@lxorguk.ukuu.org.uk>
In-Reply-To: <20070309234839.2070a265@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

->prereset() returns -ENOENT to tell libata that the port is empty and
reset sequencing should be stopped.  This is not an error condition.
Update ata_eh_reset() such that it sets device classes to ATA_DEV_NONE
and return success in on -ENOENT.  This makes spurious error message
go away.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---

This should do it and better fits the intention of the return value.
Two things to note.

1. I think these ports should be made dummy instead of returning
-ENOENT on prereset().  -ENOENT from prereset() was a hack to keep
ata_piix's behavior unchanged while converting it to new EH.  If no
one objcts, I'll convert similar usages to use dummy ports after new
init model and drop -ENOENT hack in #upstream.

2. -ENODEV sounds more appropriate.  Why have I used -ENOENT.  :-)

Thanks.

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 7349c3d..361953a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1625,8 +1625,14 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 		rc = prereset(ap);
 		if (rc) {
 			if (rc == -ENOENT) {
-				ata_port_printk(ap, KERN_DEBUG, "port disabled. ignoring.\n");
+				ata_port_printk(ap, KERN_DEBUG,
+						"port disabled. ignoring.\n");
 				ap->eh_context.i.action &= ~ATA_EH_RESET_MASK;
+
+				for (i = 0; i < ATA_MAX_DEVICES; i++)
+					classes[i] = ATA_DEV_NONE;
+
+				rc = 0;
 			} else
 				ata_port_printk(ap, KERN_ERR,
 					"prereset failed (errno=%d)\n", rc);
