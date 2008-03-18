Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYCRM4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYCRM4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 08:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYCRM4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 08:56:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:41296 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYCRM4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 08:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=nv2x/raqMaYFUqvnlQ2Echqdrpm7P7nOrQqtBgnthm9SEtwyuTrXH5JK8WDnCQLH4SdawJNu+VMmd8vtNvIy3H1iavqNkyTnLvO1JM6eJl9NiYcxUJd67p7s2d8CeT6/1oglUPzdJEwOd5pSMpwvFC5kzD0eREgp7M0EGh/HxDg=
Message-ID: <47DFBBE2.7050304@gmail.com>
Date: Tue, 18 Mar 2008 21:56:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803170816.50597.volker.armin.hemmann@tu-clausthal.de> <47DF70F3.9080305@gmail.com> <200803181159.48327.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200803181159.48327.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------000704050502030908010800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000704050502030908010800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Volker Armin Hemmann wrote:
> it was for a little bit more than 24h. I booted and rebooted several times to 
> make sure - and everything was fine, but after a good night and on the Xth 
> boot, the hang occured again - and since then it is there. Reliable on every 
> boot :( 
> (and the softreset failed message on reboots).
> Of course, I booted and rebooted several times. And it stays.
> 
> Maybe it is the hardware. But I replaced the cables already and smart says the 
> disk is ok.

Does the attached patch make any difference?

>>> Setting AHCI in bios still results in timeouts and harddisks not found.
>> Does pci=nomsi help?
> 
> oh yes!
>  It does. I changed the 'Sata operation mode' setting from 'non raid' to AHCI, 
> booted with that option:
> 
> the most obvious change are the different interrupts: 23 instead of 315 
> (non-raid, without nosmi) or 218 (systemrescuecd 1.0, ahci setting, without 
> nosmi)

Yeah, that sounds about right.  Hmm... Can you post the result of "lspci
-nn"?

-- 
tejun

--------------000704050502030908010800
Content-Type: text/x-patch;
 name="ahci-no-hrst.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ahci-no-hrst.patch"

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6978469..5065404 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -402,6 +402,7 @@ static const struct ata_port_operations ahci_p5wdh_ops = {
 static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci */
 	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.link_flags	= AHCI_LFLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
@@ -1863,7 +1864,7 @@ static void ahci_error_handler(struct ata_port *ap)
 
 	/* perform recovery */
 	sata_pmp_do_eh(ap, ata_std_prereset, ahci_softreset,
-		       ahci_hardreset, ahci_postreset,
+		       NULL/*ahci_hardreset*/, ahci_postreset,
 		       sata_pmp_std_prereset, ahci_pmp_softreset,
 		       sata_pmp_std_hardreset, sata_pmp_std_postreset);
 }

--------------000704050502030908010800--
