Return-Path: <linux-kernel-owner+w=401wt.eu-S1764003AbYCSWgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764003AbYCSWgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936167AbYCSVIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:08:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:62349 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYCSVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:08:12 -0400
Message-ID: <47E0883A.9010507@gmail.com>
Date: Wed, 19 Mar 2008 12:27:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803181159.48327.volker.armin.hemmann@tu-clausthal.de> <47DFBBE2.7050304@gmail.com> <200803181433.12584.volker.armin.hemmann@tu-clausthal.de> <47E087DF.7070101@gmail.com>
In-Reply-To: <47E087DF.7070101@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------030907010109040300020502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030907010109040300020502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Tejun Heo wrote:
> Volker Armin Hemmann wrote:
>> On Dienstag, 18. März 2008, Tejun Heo wrote:
>>>  failed message on reboots).
>>>
>>>> Of course, I booted and rebooted several times. And it stays.
>>>>
>>>> Maybe it is the hardware. But I replaced the cables already and smart
>>>> says the disk is ok.
>>> Does the attached patch make any difference?
>> patching file drivers/ata/ahci.c
>> Hunk #1 succeeded at 397 (offset -5 lines).
>> Hunk #2 succeeded at 1819 (offset -45 lines).
> 
> It's okay.  It's because I was lazy and generated the patch against
> devel tree.
> 
>> built&booted, same results as allways. With non-raid setting, IDENTIFY error 
>> on cold boot and sofreset error on reboot:
>> (with patch, without nosmi):
> 
> Oh... I see.  I made a mistake.  In ahci.c, what I intended was making
> ahci_softreset NULL not ahci_hardreset.  Can you please change that and
> test again?
> 

Just in case, here's the updated patch.

-- 
tejun

--------------030907010109040300020502
Content-Type: text/x-patch;
 name="ahci-no-srst.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ahci-no-srst.patch"

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6978469..46b7e48 100644
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
@@ -1862,7 +1863,7 @@ static void ahci_error_handler(struct ata_port *ap)
 	}
 
 	/* perform recovery */
-	sata_pmp_do_eh(ap, ata_std_prereset, ahci_softreset,
+	sata_pmp_do_eh(ap, ata_std_prereset, NULL/*ahci_softreset*/,
 		       ahci_hardreset, ahci_postreset,
 		       sata_pmp_std_prereset, ahci_pmp_softreset,
 		       sata_pmp_std_hardreset, sata_pmp_std_postreset);

--------------030907010109040300020502--
