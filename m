Return-Path: <linux-kernel-owner+w=401wt.eu-S935194AbXHGXjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935194AbXHGXjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbXHGXjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:39:19 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:60596 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311AbXHGXjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:39:17 -0400
From: Chr <chunkeey@web.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [2.6.22.2 review 06/84] Add a PCI ID for santa rosas PATA controller.
Date: Wed, 8 Aug 2007 01:39:12 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Gaston@debian64.daheim, Jason D <jason.d.gaston@intel.com>,
       chunkeey@web.de
References: <20070807204034.882009319@mini.kroah.org> <20070807204257.GG23028@kroah.com>
In-Reply-To: <20070807204257.GG23028@kroah.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iKQuGSrzEEbK6nq"
Message-Id: <200708080139.14248.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+eEx/Ho9zuPqX6+IQidr4bHe25vn8z3T+RAjYV
	Z2DU9ONb9leNDSjHI4V0+oqNWMGXB6BFB63Ggdg8JtKizuxKI8
	qyVX54S/8=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_iKQuGSrzEEbK6nq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday, 7. August 2007, Greg KH wrote:
> 
> From: Christian Lamparter <chunkeey@web.de>
> 
> This is commit c1e6f28cc5de37dcd113b9668a185c0b9334ba8a which is
> merged during 23-rc1 window.  Considering the popularity of these
> chips, I think including it in -stable release would be good idea.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 

I did not receive any complains. I guess it's stable enough for -stable ;-) ...

--- 

Not OT: 

There is another outstanding issue with ata_piix.c.
Intel has never officially supported anything faster than PATA 100MB/s.

But, the ata_piix.c driver "define" the ICH5 & ICH7 as UDMA6 (aka 133MB/s) capable.
[ Well, no one has probably noticed it before, because there is bug in do_pata_set_dmamode... 
Just look at libata_atapiix_enable_real_udma133.patch and you'll see what wrong with it. ] 

Here are Intel's datasheets for the affected chipsets:
ICH5 Datasheet: http://www.intel.com/design/chipsets/datashts/252516.htm
(See note on page 183: "... the ICH5 supports reads at the maximum rate of 100MB/s.")

ICH7 Datasheet: http://www.intel.com/design/chipsets/datashts/307013.htm
(See first note on page 190: "... the ICH7 supports reads at the maximum rate of 100MB/s.")

-

They are two different ways to deal with it:

- Either -

1. replace all ich_pata_133 with ich_pata_100. 
   (libata_atapiix_disable_udma6.diff - diff from 2.6.22 )

- Or -

2. keep all ich_pata_133 and fix the bug in "do_pata_set_dmamode".
   (libata_atapiix_enable_real_udma133.patch - diff from 2.6.22) 
   If there are any concerns about the safety of the patch patch: 
   http://lkml.org/lkml/2007/7/6/292 (It was already tested by an Intel employee,
   but I guess a bit more user input is necessary here... )

Both ways have their pros and cons. Unfortunately, I don't have the time to follow this
discussion right now, so here's a: 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
(Just in case, if one of the patches really gets merged!)

Thanks,
	Chr. 


--Boundary-00=_iKQuGSrzEEbK6nq
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="libata_atapiix_disable_udma6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libata_atapiix_disable_udma6.diff"

--- a/drivers/ata/ata_piix.c	2007-08-08 00:52:52.000000000 +0200
+++ b/drivers/ata/ata_piix.c	2007-08-08 00:55:45.000000000 +0200
@@ -122,7 +122,7 @@ enum {
 	ich_pata_33		= 1,	/* ICH up to UDMA 33 only */
 	ich_pata_66		= 2,	/* ICH up to 66 Mhz */
 	ich_pata_100		= 3,	/* ICH up to UDMA 100 */
-	ich_pata_133		= 4,	/* ICH up to UDMA 133 */
+	/* ICH up to UDMA 133 is not supported */
 	ich5_sata		= 5,
 	ich6_sata		= 6,
 	ich6_sata_ahci		= 7,
@@ -190,7 +190,7 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x24CA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	{ 0x8086, 0x24CB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* Intel ICH5 */
-	{ 0x8086, 0x24DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
+	{ 0x8086, 0x24DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* C-ICH (i810E2) */
 	{ 0x8086, 0x245B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* ESB (855GME/875P + 6300ESB) UDMA 100  */
@@ -198,7 +198,7 @@ static const struct pci_device_id piix_p
 	/* ICH6 (and 6) (i915) UDMA 100 */
 	{ 0x8086, 0x266F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* ICH7/7-R (i945, i975) UDMA 100*/
-	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
+	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 
 	/* NOTE: The following PCI ids must be kept in sync with the
@@ -479,7 +479,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &ich_pata_ops,
 	},
 
-	/* ich_pata_133: 4 	ICH with full UDMA6 */
+	/* ich_pata_133: 4 - Not supported - */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,

--Boundary-00=_iKQuGSrzEEbK6nq
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="libata_atapiix_enable_real_udma133.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libata_atapiix_enable_real_udma133.patch"

--- a/drivers/ata/ata_piix.c	2007-08-08 00:52:52.000000000 +0200
+++ b/drivers/ata/ata_piix.c	2007-08-08 00:53:03.000000000 +0200
@@ -765,8 +765,8 @@ static void do_pata_set_dmamode (struct 
 		 *	       except UDMA0 which is 00
 		 */
 		u_speed = min(2 - (udma & 1), udma);
-		if (udma == 5)
-			u_clock = 0x1000;	/* 100Mhz */
+		if (udma >= 5)
+			u_clock = 0x1000;	/* 133Mhz */
 		else if (udma > 2)
 			u_clock = 1;		/* 66Mhz */
 		else

--Boundary-00=_iKQuGSrzEEbK6nq--
