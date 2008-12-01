Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYLAVyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYLAVyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYLAVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:54:45 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:40228 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752146AbYLAVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:54:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PZWLDU7Yc6gGlNNAQ/IX8AZe4oVc2cCElL1HUo0ze///LGitBE/AQ5LF8cmRSU2znk29ycxJgTdvq63qCpLyJdly2p2K9tdEFJbCQcY1HcYe504z9M9R9K+t1MppgXZ76dR7PwRhrva1p0hVtO56qfn6BVFGRIjbR6lZbFBHlVk=  ;
X-YMail-OSG: kS.Mff0VM1lm7EhdG7fc65yHhhvJFQ8hOWOtNeEupOzfUqXVAsNWzgPtwkpXmWlASpJTsPADi6HSlXiPKUz_OzfnSan2rs2fIW6ZkAoUhiDs2hATQg0PbD...ngoklO2.ABoqz8yvwr.H6gxMpOmk1nidItn6r0J78sa3102Ryk0wFv_VFL7IW2UKYyB
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [patch 2.6.28-rc6 1/3] mfd: twl4030: simplified child creation code
Date: Mon, 1 Dec 2008 13:28:13 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
       Mark Brown <broonie@sirena.org.uk>
References: <200811261053.18805.david-b@pacbell.net> <20081201001046.GB3067@sortiz.org>
In-Reply-To: <20081201001046.GB3067@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011328.13636.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 November 2008, Samuel Ortiz wrote:
> All 3 patches pushed to my for-next branch, thanks.

Great ... here's a small tweak, which you may want to just
merge with the last one.

- Dave


========== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

This contains two bugfixes to the initial twl4030 regulator
support patch related to USB:

 (a) always overwrite the old list of consumers ... else
     the regulator handles all use the same "usb1v5" name;
 (b) don't set up the "usbcp" regulator, which turns out
     to be managed through separate controls, usually ULPI
     directly from the OTG controller.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mfd/twl4030-core.c  |   11 +----------
 include/linux/i2c/twl4030.h |    1 -
 2 files changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -433,7 +433,7 @@ add_regulator_linked(int num, struct reg
 	if (!pdata)
 		return NULL;
 
-	if (consumers && !pdata->consumer_supplies) {
+	if (consumers) {
 		pdata->consumer_supplies = consumers;
 		pdata->num_consumer_supplies = num_consumers;
 	}
@@ -556,9 +556,6 @@ add_children(struct twl4030_platform_dat
 		static struct regulator_consumer_supply usb3v1 = {
 			.supply =	"usb3v1",
 		};
-		static struct regulator_consumer_supply usbcp = {
-			.supply =	"usbcp",
-		};
 
 		/* this is a template that gets copied */
 		struct regulator_init_data usb_fixed = {
@@ -573,7 +570,6 @@ add_children(struct twl4030_platform_dat
 		usb1v5.dev = usb_transceiver;
 		usb1v8.dev = usb_transceiver;
 		usb3v1.dev = usb_transceiver;
-		usbcp.dev = usb_transceiver;
 
 		child = add_regulator_linked(TWL4030_REG_VUSB1V5, &usb_fixed,
 				&usb1v5, 1);
@@ -589,11 +585,6 @@ add_children(struct twl4030_platform_dat
 				&usb3v1, 1);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
-
-		child = add_regulator_linked(TWL4030_REG_VUSBCP, &usb_fixed,
-				&usbcp, 1);
-		if (IS_ERR(child))
-			return PTR_ERR(child);
 	}
 
 	/* maybe add LDOs that are omitted on cost-reduced parts */
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -351,6 +351,5 @@ int twl4030_sih_setup(int module);
 #define TWL4030_REG_VUSB1V5	17
 #define TWL4030_REG_VUSB1V8	18
 #define TWL4030_REG_VUSB3V1	19
-#define TWL4030_REG_VUSBCP	20
 
 #endif /* End of __TWL4030_H */

