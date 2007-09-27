Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXI0E5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXI0E5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 00:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXI0E4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 00:56:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:4612 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbXI0E4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 00:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=FHI+ulbdo7dImP3e5KOPMlWIsRkwtOgTalgLbthvJO5/6hFj1joBmkHY2JuAuV888JPaJPketYn0v+y5fEmrBJYdzUqefqJTGVlW+5OkikgdUE0p6ohd3ju/Jr+AEZSId5YKlNEK46oZtATQxYXt2OuGGsm4wZNSGjGniCG7r1o=
Message-ID: <46FB3793.9060607@gmail.com>
Date: Thu, 27 Sep 2007 13:54:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
In-Reply-To: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------070705000905090309020408"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070705000905090309020408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Torsten Kaiser wrote:
> Comparing the driver/ata directory from rc3-mm1 and rc4-mm1 the
> following change looked the most suspicions to me:
> http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=blobdiff;f=drivers/ata/sata_sil24.c;h=3dcb223117be9739ee04d70b6bfc776a4b839a3f;hp=e0cd31aa8002350add53ba6ff07493e503275244;hb=020bc1bd8d369a77bd9379cd9763ac0057651753;hpb=8d4bdf8087e682df98bdb856f6ad451bf6d597e7
> 
> That after rc4-mm1 the sata_sil24.c did not change anymore also
> matches the occurrence of the error.
> 
> To confirm my theorie I exchanged the sata_sil24.c from rc8-mm1 with
> the version from rc3-mm1.
> I was able to boot the resulting kernel successfully 5 times, without
> the error happening again.

Thanks a lot for chasing down the problem.  The changed code is address
initialization path and it's weird that it causes intermittent failures,
not a consistent one.

Anyways, does the attached patch fix the problem?

-- 
tejun

--------------070705000905090309020408
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 3831920..dc3ddcb 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1117,6 +1117,7 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		host->ports[i]->ioaddr.cmd_addr = port;
 		host->ports[i]->ioaddr.scr_addr = port + PORT_SCONTROL;
+		ata_std_ports(&ap->ioaddr);
 
 		ata_port_pbar_desc(ap, SIL24_HOST_BAR, -1, "host");
 		ata_port_pbar_desc(ap, SIL24_PORT_BAR, offset, "port");

--------------070705000905090309020408--
