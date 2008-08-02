Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbYHBWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbYHBWqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 18:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYHBWqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 18:46:15 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:58336 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYHBWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 18:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L/dt0tAZ7ki8woKU7mMFnayVAZZbS+vjtAuTe4Z+i6v6ty0KwpRvHr8MjYoq7j8h+2
         pwOElbuKFMFGjKVRAJr8nmkG1AXhSprKQM29BWazzSiPacVcdHLpJ/aeAV59LyL9u8qb
         iKzhL7nr5cYdpTIcLE2Kmul0Msi0j2yOp2wDU=
Message-ID: <9e4733910808021546o4aa5ebdcv4caa2878e4c17cf0@mail.gmail.com>
Date: Sat, 2 Aug 2008 18:46:12 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Grant Likely" <grant.likely@secretlab.ca>,
       "Anton Vorontsov" <avorontsov@ru.mvista.com>
Subject: Re: [PATCH v3 0/4 REPOST] OF infrastructure for SPI devices
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org
In-Reply-To: <9e4733910807250746g436307d7sbbf799b73a9f2c67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <9e4733910807250746g436307d7sbbf799b73a9f2c67@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/08, Jon Smirl <jonsmirl@gmail.com> wrote:
> On 7/25/08, Grant Likely <grant.likely@secretlab.ca> wrote:
>  > I don't know what to do with these patches.  I'd really like to see them
>  >  in .27, and now that akpm has cleared his queue, the prerequisite patch
>  >  has been merged so they are ready to go in.  However, even though there
>  >  has been favourable reception on the SPI and linuxppc lists for these
>  >  changes I don't have any acks from anybody yet.
>
>
> I have compatible hardware but it has an MMC card socket hooked up. I
>  haven't figured out yet how to get this driver hooked to the MMC
>  subsystem and make the file system on the card work.  (I've been
>  working on ALSA).
>
>  I believe I need this:
>  http://lkml.org/lkml/2008/6/5/209
>
>  Then I need to get everything hooked together. Point me in the right
>  direction and I can help with testing.

Grant, your SPI driver works with MMC cards. I needed to add the patch
noted above.
http://lkml.org/lkml/2008/6/5/209
What's the status of merging Anton's patch?

And then tweak names until everything matches.

		spi@f00 {
			#address-cells = <1>;
			#size-cells = <0>;
			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
			reg = <0xf00 0x20>;
			interrupts = <0x2 0xd 0x0 0x2 0xe 0x0>;
			interrupt-parent = <&mpc5200_pic>;

			mmc-slot@0 {
				compatible = "linux,mmc-spi";
				reg = <0>;
				spi-max-frequency = <20000000>;
				/* Unregulated slot. */
				voltage-range = <3300 3300>;
				/*gpios = <&sdcsr_pio 1 0   /*  WP */
				/*		 &sdcsr_pio 0 1>; /* nCD */
			};
		};

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7503b81..eb056b9 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1400,7 +1400,7 @@ static int __devexit mmc_spi_remove(struct
spi_device *spi)

 static struct spi_driver mmc_spi_driver = {
 	.driver = {
-		.name =		"mmc_spi",
+		.name =		"mmc-spi",
 		.bus =		&spi_bus_type,
 		.owner =	THIS_MODULE,
 	},
diff --git a/drivers/of/of_mmc_spi.c b/drivers/of/of_mmc_spi.c
index aa4e017..f189cdb 100644
--- a/drivers/of/of_mmc_spi.c
+++ b/drivers/of/of_mmc_spi.c
@@ -95,7 +95,7 @@ static int of_mmc_spi_add(struct device *dev)
 	const u32 *voltage_range;
 	int size;

-	if (!np || !of_device_is_compatible(np, "mmc-spi"))
+	if (!np || !of_device_is_compatible(np, "linux,mmc-spi"))
 		return NOTIFY_DONE;

 	oms = kzalloc(sizeof(*oms), GFP_KERNEL);
@@ -152,7 +152,7 @@ static int of_mmc_spi_del(struct device *dev)
 	struct device_node *np = dev->archdata.of_node;
 	struct of_mmc_spi *oms;

-	if (!np || !of_device_is_compatible(np, "mmc-spi") ||
+	if (!np || !of_device_is_compatible(np, "linux,mmc-spi") ||
 			!dev->platform_data)
 		return NOTIFY_DONE;

-- 
Jon Smirl
jonsmirl@gmail.com
