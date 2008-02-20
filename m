Return-Path: <linux-kernel-owner+w=401wt.eu-S935101AbYBTUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935101AbYBTUu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935023AbYBTUul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:50:41 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:58340 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934722AbYBTUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:50:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=MgpVYYNuvAcQUpdQe+Sp3s9UW0xNvc08inXjgkLA88UId5R/gz4rJ1/sa121VLR/A7ua6xJdE1bAVCUFTI6nbyv9gsoFh4eobBxKoOGV+N8ztAtpo2XYkWEq6T83KevygVhmW7wnbuomtsjoDad6EXsj6iKTVpR2vDWBujAFZOw=
To: Chris Vine <chris@cvine.freeserve.co.uk>
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
Date: Wed, 20 Feb 2008 21:50:20 +0100
User-Agent: KMail/1.9.7
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris2553@googlemail.com,
       rt2400-devel@lists.sourceforge.net
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <1203523555.693.2.camel@localhost.localdomain> <1203539235.3189.4.camel@boulder.homenet>
In-Reply-To: <1203539235.3189.4.camel@boulder.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802202150.20303.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008, Chris Vine wrote:
> 
> On Wed, 2008-02-20 at 11:05 -0500, Dan Williams wrote: 
> > On Tue, 2008-02-19 at 23:04 +0000, Chris Vine wrote:
> > > On Tue, 2008-02-19 at 20:46 +0100, Ivo van Doorn wrote:
> > > > Hi,
> > > > 
> > > > [added rt2400-devel (rt2x00 development mailinglist) to the CC list.]
> > > > 
> > > > > > > > I have a series of tests I would like to request from you,
> > > > > > > > you mentioned you already enabled debugfs, and that is just what we need. ;)
> > > > > > > > Please use attached script to create dumps of the hardware register contents.
> > > > > > > > 
> > > > > > > > There are specific moments that should be dumped:
> > > > > > > > - kernel 2.6.24 (last known working version for you).
> > > > > > > > - kernel 2.6.25-rc2 (after ifup, before TX dies)
> > > > > > > > - kernel 2.6.25-rc2 (after ifup, after TX dies)
> > > > > > > >  
> > > > > > > 
> > > > > > > These diagnostics are attached, with obvious filenames.
> > > > > > 
> > > > > > Thanks. I think I found something, please test below patch:
> > > > > > 
> > > > > 
> > > > > I've tried the patch but, unfortunately, my wireless LAN still dies after a few pings.
> > > 
> > > rt2x00 2.0.14 is broken with my rt73 stick in the vanilla 2.6.25-rc2
> > > kernel (not wireless-2.6/rt2x00 git).  The modules load when I plug the
> > > stick in but I then get a complete kernel lock up with two flashing
> > > leds.  Nothing is recorded to system logs.  The last logged messages are
> > > that usbcore has registered new interface driver rt73usb, and that the
> > > rate control algorithm has been selected on phy0.  This happens whether
> > > the simple or pid mac80211 rate control algorithms have been chosen.
> > > 
> > > This is a shame because 2.0.14 was working really well for me until the
> > > mac80211 changes 2 or 3 weeks ago broke it.  (Shortly followed by the
> > > release of 2.1.*).
> > 
> > Switch to a VT with Ctl+Alt+1, then plug the stick in, and take a
> > picture of the panic if one shows up.  _Something_ should show up on the
> > VT.
> 
> I did that yesterday and it just reported a kernel panic on the terminal
> with the message:
> 
>   Kernel panic - not syncing: Aiee, killing interrupt handler!

I have an idea, could you try below patch?
Note that while applying it will mention something about a line offset, but that can be ignored.

This could perhaps also fix the TX/RX issue mentioned earlier in the thread, but I am not
quite sure about that.

---
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b63bc66..460ef2f 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -953,8 +953,12 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2400pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt2400pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2400pci_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt2400pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index add8aff..ffcd996 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1106,8 +1106,12 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt2500pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2500pci_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt2500pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index d9643c5..9f59db9 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -996,8 +996,12 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt2500usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2500usb_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt2500usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 46888f9..a1d8e33 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -127,7 +127,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * else the changes will be ignored by the device.
 	 */
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF_LINK);
 
 	/*
 	 * Write new antenna setup to device and reset the link tuner.
@@ -141,7 +141,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->link.ant.active.tx = libconf.ant.tx;
 
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index add1f09..0325bed 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -85,6 +85,8 @@ enum dev_state {
 	STATE_RADIO_OFF,
 	STATE_RADIO_RX_ON,
 	STATE_RADIO_RX_OFF,
+	STATE_RADIO_RX_ON_LINK,
+	STATE_RADIO_RX_OFF_LINK,
 	STATE_RADIO_IRQ_ON,
 	STATE_RADIO_IRQ_OFF,
 };
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ca83d94..091fe39 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1458,8 +1458,12 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt61pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt61pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt61pci_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt61pci_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 7d6ee97..6546b0d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1196,8 +1196,12 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt73usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+	case STATE_RADIO_RX_ON_LINK:
+		rt73usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt73usb_toggle_rx(rt2x00dev, state);
+	case STATE_RADIO_RX_OFF_LINK:
+		rt73usb_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:


