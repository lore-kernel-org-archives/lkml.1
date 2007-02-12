Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbXBLGpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbXBLGpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933045AbXBLGpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:45:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:58702 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbXBLGpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:45:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=h8yQlHHvRLRkd+P7aD00SfJvT6mPvn/6Fa+kvfGoDI73Mwwz/8mAYs6rR2GLlfaNxiD9TTXIUqS+/EVU/+CdhRix5vopbXkn1hQ7d+wSgusZvpogvcDaJCwI5zPl4p7D2Qsr9jsUFf/K/xZIx75/Y9vnjwq+P268485G2gUoOxg=
Message-ID: <45CFBBD1.5090703@gmail.com>
Date: Sun, 11 Feb 2007 16:58:57 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Joel Soete <soete.joel@scarlet.be>
CC: Luming Yu <luming.yu@gmail.com>, Alan Cox <alan@redhat.com>,
       Ioan Ionita <opslynx@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>	 <20061116235048.3cd91beb@localhost.localdomain>	 <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com>	 <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com>	 <20061117100559.GA10275@devserv.devel.redhat.com>	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>	 <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com> <45BB64F1.1000105@scarlet.be>
In-Reply-To: <45BB64F1.1000105@scarlet.be>
Content-Type: multipart/mixed;
 boundary="------------050204080005060307070708"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050204080005060307070708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Please test the attached patch over 2.6.20.

Thanks.

-- 
tejun

--------------050204080005060307070708
Content-Type: text/x-patch;
 name="clear-TF-before-IDENTIFY.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="clear-TF-before-IDENTIFY.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 667acd2..d6fcf0a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1478,7 +1478,16 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	}
 
 	tf.protocol = ATA_PROT_PIO;
-	tf.flags |= ATA_TFLAG_POLLING; /* for polling presence detection */
+
+	/* Some devices choke if TF registers contain garbage.  Make
+	 * sure those are properly initialized.
+	 */
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+
+	/* Device presence detection is unreliable on some
+	 * controllers.  Always poll IDENTIFY if available.
+	 */
+	tf.flags |= ATA_TFLAG_POLLING;
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
 				     id, sizeof(id[0]) * ATA_ID_WORDS);

--------------050204080005060307070708--

