Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYHKSmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYHKSmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYHKSmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:42:04 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20754 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbYHKSmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:42:01 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: pnp bug in 2.6.27-rc1 (ad1816a / mpu401 / parport_pc issue)
Date: Mon, 11 Aug 2008 12:40:51 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@osdl.org, perex@perex.cz, abelay@mit.edu,
       debian-kernel@lists.debian.org, linux-kernel@vger.kernel.org
References: <200808041531.10557.uwe.bugla@gmx.de> <200808041419.21995.bjorn.helgaas@hp.com> <200808052106.35610.uwe.bugla@gmx.de>
In-Reply-To: <200808052106.35610.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111240.52005.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 01:06:35 pm Uwe Bugla wrote:
> 1. 2626debian.txt is the dmesg of the latest 2.6.26.1 shipped with Debian Sid.
> It's no self-compiled kernel and it spurks out the following message:
> 
> [   39.958560] MPU-401 device not found or device busy.
> 
> This one is confusing because
> 
> a. the device is there and it is assumed to work - it is shown to be existent 
> in KDE 4.1 info center, but not in the system info (perhaps phonon does not 
> know yet what an ISA sound card is?)
> b. it cannot be busy during startup - it can only be busy if some MIDI file is 
> being played to some piano or some piano performs some input into a sequencer 
> software or notation program.
> That's why I would call that message simply dumb......

I agree; that message is confusing.  It's from the "mpu401" driver
in sound/drivers/mpu401/mpu401.c.  Based on the driver source, it
just means we didn't find an MPU-401 device for some reason.  It could
be that no MPU-401 device exists, or it could be that one exists but
has already been claimed by another driver (that's what it means by
"device busy").

Your dmesg shows this:

  [   38.918625] ad1816a 01:01.00: activated
  [   38.950576] ad1816a 01:01.01: activated
  [   39.958560] MPU-401 device not found or device busy.

I think 01:01.01 is the MPU device on the ad1816a card, so I think
the ad1816a driver claimed it, which would prevent the mpu401 driver
from claiming it again.

> 2. 2626vanilla.txt is the dmesg from a vanilla kernel 2.6.26.1 with 
> CONFIG_PNP_DEBUG turned on.
> It's the only one out of three choices to spurk out correct messages:
> 
> pnp 01:01.01: ADS7181: calling quirk_isapnp_mpu_resources+0x0/0x1e
> pnp 01:01.01: adding IRQ-less MPU options

This message appears in both 2626debian.txt and 2626vanilla.txt.
In 2627rc1vanilla.txt, that quirk still exists in a slightly different
form, but I changed the message to this:

  pnp 01:01.01: added dependent option set 2 (same as set 0 except IRQ optional)
  pnp 01:01.01: added dependent option set 3 (same as set 1 except IRQ optional)

This is more confusing than the "adding IRQ-less MPU options"
text, but it means the same thing.  I'll try to figure out better
wording for this message.

> 3. 2627vanilla.txt is the dmesg from a vanilla kernel 2.6.27-rc1 with 
> CONFIG_PNP_DEBUG turned on.
> 
> It does not give out any message whether the MPU 401 MIDI device is there, 
> busy, broken or whatever the hell. All it says is tacet - nothing!
> It appears in the info centre of KDE 4.1 and that's it.

In the 2626vanilla.txt and 2627rc1vanilla.txt logs. it looks like the
mpu401 driver is not loaded, so I wouldn't expect any messages.  If
the mpu401 driver were being registered, we should see a message
like this:

  pnp: the driver 'mpu401' has been registered

but that doesn't appear in the log, so it's probably just not being
loaded.  (Note that PNP only prints these messages when
CONFIG_PNP_DEBUG is turned on.)

In your 2627rc2vanilla.txt log, we do see that line, together with the
"MPU-401 device not found or device busy" line.  I think this is
because the ad1816a driver has already claimed the MPU, so I don't
think this is anything to worry about, other than the fact that the
message itself is confusing.

> I swear I like Linux and open source software in general, but sometimes it 
> only nerves and sucks, especially if you are wasting hours to find out that 
> there is one big mess around.

Believe me, I understand your frustration!  Software sucks in general.
I like Linux because at least I have a chance to try to make it suck
a little less :-)

> I also CCed the Debian maintainers with that mail because I suppose that one 
> of their Debian specific kernel patches screwed up that whole thing too.

I don't think this is Debian-related.  I added LKML in case anybody
else has similar problems.

> Please help - let's get this chaos fixed!!

OK, let's back way up.  Apart from the confusing messages, it seems
like the real problem is related to this modprobe config line:

  options parport_pc io=0x378,0x278 irq=7,5

With that line present, I think you have:

  parport0 at port 0x378, irq 7
  parport1 at port 0x278, irq 5
  ad1816a at ports 0x220, 0x388, 0x500, irq 10, dma 1, 3
  ad1816a MPU401 at port 0x300, irq disabled

Without that line, it sounds like you have this:

  parport0 at port 0x378, irq ?
  parport1 at port 0x278, irq disabled (polling)
  ad1816a at ports 0x220, 0x388, 0x500, irq 5, dma 1, 3
  ad1816a MPU401 at port 0x300, irq ? (maybe 7?)

If the parallel ports only have 5 and 7 as IRQ possibilities, I
can imagine how loading the ad1816a driver first might claim those
IRQs, leaving them unavailable for parport_pc.  But all your logs
show parport_pc being loaded first.  And I would think that if
ad1816a were loaded first, it would claim both 5 and 7, leaving
*both* parallel ports in polling mode.

If this is indeed the problem, can you send a dmesg for this failing
case?  (Try "dmesg -s64000"; the first part of the log should show
parport resource info, but it is truncated in the logs you posted).

What would you think of something like the patch below?  It doesn't
fix anything, but maybe it would help show what's going on.



diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..6bcf17b 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -182,6 +182,7 @@ static void quirk_add_irq_optional_dependent_sets(struct pnp_dev *dev)
 	unsigned int num_sets, i, set;
 	struct pnp_irq *irq;
 
+	dev_info(&dev->dev, "adding MPU configurations with optional IRQ\n");
 	num_sets = dev->num_dependent_sets;
 	for (i = 0; i < num_sets; i++) {
 		new_option = pnp_clone_dependent_set(dev, i);
diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
index 68f1260..374d1d0 100644
--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -111,14 +111,14 @@ static int __devinit snd_card_ad1816a_pnp(int dev, struct snd_card_ad1816a *acar
 	acard->devmpu = pnp_request_card_device(card, id->devs[1].id, NULL);
 	if (acard->devmpu == NULL) {
 		mpu_port[dev] = -1;
-		snd_printk(KERN_WARNING PFX "MPU401 device busy, skipping.\n");
+		dev_warn(&acard->devmpu->dev, "MPU401 device busy, skipping\n");
 	}
 
 	pdev = acard->dev;
 
 	err = pnp_activate_dev(pdev);
 	if (err < 0) {
-		printk(KERN_ERR PFX "AUDIO PnP configure failure\n");
+		dev_err(&pdev->dev, "audio PNP configuration failed\n");
 		return -EBUSY;
 	}
 
@@ -127,6 +127,11 @@ static int __devinit snd_card_ad1816a_pnp(int dev, struct snd_card_ad1816a *acar
 	dma1[dev] = pnp_dma(pdev, 0);
 	dma2[dev] = pnp_dma(pdev, 1);
 	irq[dev] = pnp_irq(pdev, 0);
+	dev_info(&pdev->dev, "OPL3 FM synth at port %#llx, codec at port %#llx,"
+		 " playback DMA %d, capture DMA %d, IRQ %d\n",
+		 (unsigned long long) fm_port[dev],
+		 (unsigned long long) port[dev],
+		 dma1[dev], dma2[dev], irq[dev]);
 
 	if (acard->devmpu == NULL)
 		return 0;
@@ -135,12 +140,14 @@ static int __devinit snd_card_ad1816a_pnp(int dev, struct snd_card_ad1816a *acar
 
 	err = pnp_activate_dev(pdev);
 	if (err < 0) {
-		printk(KERN_ERR PFX "MPU401 PnP configure failure\n");
+		dev_err(&pdev->dev, "MPU401 PNP configuration failed\n");
 		mpu_port[dev] = -1;
 		acard->devmpu = NULL;
 	} else {
 		mpu_port[dev] = pnp_port_start(pdev, 0);
 		mpu_irq[dev] = pnp_irq(pdev, 0);
+		dev_info(&pdev->dev, "MPU401 at port %#llx, IRQ %d\n",
+			 (unsigned long long) mpu_port[dev], mpu_irq[dev]);
 	}
 
 	return 0;

