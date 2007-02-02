Return-Path: <linux-kernel-owner+w=401wt.eu-S1423207AbXBBU2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423207AbXBBU2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 15:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946053AbXBBU2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 15:28:43 -0500
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:3632 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423206AbXBBU2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 15:28:42 -0500
Date: Fri, 02 Feb 2007 20:21:13 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx,
       drzeus-mmc@drzeus.cx
Subject: Re: [Sdhci-devel] [PATCH 2.6.20-rc2] Add a quirk to allow ENE PCI SD
Message-ID: <4EAF02D488%linux@youmustbejoking.demon.co.uk>
References: <4E9DA5E8EB%linux@youmustbejoking.demon.co.uk> <4597A791.60007@drzeus.cx> <4E9DE7C297%linux@youmustbejoking.demon.co.uk> 
 <4E9DF295D4%linux@youmustbejoking.demon.co.uk> <45C2EE52.4020103@drzeus.cx>
In-Reply-To: <45C2EE52.4020103@drzeus.cx>
User-Agent: Messenger-Pro/4.25b2 (MsgServe/3.29b4) (RISC-OS/4.02) POPstar/2.06+cvs
X-Editor: Zap 1.47 (27 Apr 2006) [TEST], ZapEmail 0.28.3 (25 Mar 2005) (32)
X-SDate: Fri, 4903 Sep 1993 20:21:13 +0000
X-Message-Flag: Outlook Express is broken. Upgrade to mail(1).
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1286361601--1847808911--600611029"
X-SA-Exim-Connect-IP: 192.168.0.2
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format which your mailer apparently does not support.
You either require a newer version of your software which supports MIME, or
a separate MIME decoding utility.  Alternatively, ask the sender of this
message to resend it in a different format.

--1286361601--1847808911--600611029
Content-Type: text/plain; charset=us-ascii

I demand that Pierre Ossman may or may not have written...

> Hi Darren,

> It has come to my attention that the current routine for setting power
> is not compliant with the specification. As such, I'd like you to try
> the following and see if removes the need for your patch:

Your patch was mangled by Thunderbird. IME, it always does this; you should
attach patches, not include them inline.

Still, it was easy enough to apply the patch manually.

> I'd appreciate if you could test this sooner rather than later as the merge
> window is just around the corner.

It doesn't work.

After applying my patch and fixing up the rejects, it still doesn't work. I
need to disable the first of the writeb() calls mentioned in the last hunk of
your patch for it to work again. I have the impression that the hardware
doesn't like the power-on bit not being set :-|

... hmm, it looks like there's a small bug in my patch: the label "out" needs
to be before the last writeb() otherwise, if power is -1, no write will
happen regardless. I'm attaching a fixed version along with an adapted
version of your patch.

Pierre, if you're happy to sign off the modified version of your patch, feel
free to convert my not-yet-signed-off-by into a normal signed-off-by.

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
|   <URL:http://www.youmustbejoking.demon.co.uk/> (PGP 2.6, GPG keys)

Break up a relationship. Buy a computer.

--1286361601--1847808911--600611029
Content-Type: text/plain; charset=iso-8859-1; name="add-a-quirk-to-allow-at-least-some-ENE-PCI-SD-card-readers-to-work-again.patch"
Content-Disposition: attachment; filename="add-a-quirk-to-allow-at-least-some-ENE-PCI-SD-card-readers-to-work-again.patch"
Content-Transfer-Encoding: quoted-printable

Add a quirk to allow at least some ENE PCI SD card readers to work again

Support for these devices was broken for 2.6.18-rc1 and later by commit
146ad66eac836c0b976c98f428d73e1f6a75270d, which added voltage level suppo=
rt.

This restores the previous behaviour for these devices (PCI ID 1524:0550)=
.

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

diff -ur linux-2.6.20-rc6.orig/drivers/mmc/sdhci.c linux-2.6.20-rc6/drive=
rs/mmc/sdhci.c
--- linux-2.6.20-rc6.orig/drivers/mmc/sdhci.c	2006-12-30 15:34:11.0000000=
00 +0000
+++ linux-2.6.20-rc6/drivers/mmc/sdhci.c	2007-02-02 20:04:54.000000000 +0=
000
@@ -37,6 +37,7 @@
 #define SDHCI_QUIRK_FORCE_DMA				(1<<1)
 /* Controller doesn't like some resets when there is no card inserted. *=
/
 #define SDHCI_QUIRK_NO_CARD_NO_RESET			(1<<2)
+#define SDHCI_QUIRK_SINGLE_POWER_WRITE			(1<<3)
=20
 static const struct pci_device_id pci_ids[] __devinitdata =3D {
 	{
@@ -65,6 +66,16 @@
 		.driver_data	=3D SDHCI_QUIRK_FORCE_DMA,
 	},
=20
+	{
+		.class		=3D PCI_CLASS_SYSTEM_SDHCI << 8,
+		.class_mask	=3D 0xFFFF00,
+		.vendor		=3D PCI_VENDOR_ID_ENE,
+		.device		=3D PCI_ANY_ID,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
+		.driver_data	=3D SDHCI_QUIRK_SINGLE_POWER_WRITE,
+	},
+
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
@@ -669,16 +680,17 @@
=20
 static void sdhci_set_power(struct sdhci_host *host, unsigned short powe=
r)
 {
-	u8 pwr;
+	u8 pwr =3D 0;
=20
 	if (host->power =3D=3D power)
 		return;
=20
-	writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
-
 	if (power =3D=3D (unsigned short)-1)
 		goto out;
=20
+	if ((host->chip->quirks & SDHCI_QUIRK_SINGLE_POWER_WRITE) =3D=3D 0)
+		writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
+
 	pwr =3D SDHCI_POWER_ON;
=20
 	switch (power) {
@@ -701,9 +713,9 @@
 		BUG();
 	}
=20
+out:
 	writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);
=20
-out:
 	host->power =3D power;
 }
=20

--1286361601--1847808911--600611029
Content-Type: text/plain; charset=iso-8859-1; name="make-the-routine-for-setting-power-compliant-with-the-SDHCI-specification.patch"
Content-Disposition: attachment; filename="make-the-routine-for-setting-power-compliant-with-the-SDHCI-specification.patch"
Content-Transfer-Encoding: quoted-printable

Make the routine for setting power compliant with the specification.

Certain ENE chips seem to be sufficiently non-compliant that they don't l=
ike
this change; however, the single-power-write quirk should be enough to ha=
ndle
them (and is, in the case of at least one such device).

Not-yet-signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

diff -ur linux-2.6.20-rc6.orig/drivers/mmc/sdhci.c linux-2.6.20-rc6/drive=
rs/mmc/sdhci.c
--- linux-2.6.20-rc6.orig/drivers/mmc/sdhci.c	2007-02-02 20:04:54.0000000=
00 +0000
+++ linux-2.6.20-rc6/drivers/mmc/sdhci.c	2007-02-02 20:14:28.000000000 +0=
000
@@ -691,28 +691,31 @@
 	if ((host->chip->quirks & SDHCI_QUIRK_SINGLE_POWER_WRITE) =3D=3D 0)
 		writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
=20
-	pwr =3D SDHCI_POWER_ON;
-
 	switch (power) {
 	case MMC_VDD_170:
 	case MMC_VDD_180:
 	case MMC_VDD_190:
-		pwr |=3D SDHCI_POWER_180;
+		pwr =3D SDHCI_POWER_180;
 		break;
 	case MMC_VDD_290:
 	case MMC_VDD_300:
 	case MMC_VDD_310:
-		pwr |=3D SDHCI_POWER_300;
+		pwr =3D SDHCI_POWER_300;
 		break;
 	case MMC_VDD_320:
 	case MMC_VDD_330:
 	case MMC_VDD_340:
-		pwr |=3D SDHCI_POWER_330;
+		pwr =3D SDHCI_POWER_330;
 		break;
 	default:
 		BUG();
 	}
=20
+	if ((host->chip->quirks & SDHCI_QUIRK_SINGLE_POWER_WRITE) =3D=3D 0)
+		writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);
+
+	pwr |=3D SDHCI_POWER_ON;
+
 out:
 	writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);
=20

--1286361601--1847808911--600611029--
