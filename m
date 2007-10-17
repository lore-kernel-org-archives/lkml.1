Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbXJQNH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbXJQNH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbXJQNHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:07:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:14297 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbXJQNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=aeREX5lMbpaCfIW6jkW1n4Ct7m5SywTi0E8mqMNOoHLyG6ryN6GF1xNIXHDC5orWFKma1A2xNOVB+djRruWF5MfPe/guZKNPCk4BLKAZiUscSSvxHFqVSwyGekQouVUrdFULyHLbsWS3McIVxmaWc5bcjnpIhRIyNmLvMUsCEBg=
Message-ID: <47160961.7040607@gmail.com>
Date: Wed, 17 Oct 2007 17:08:49 +0400
From: Konstantin Kalin <konstantin.kalin@gmail.com>
User-Agent: Thunderbird 1.5.0.5 (Windows/20060719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
References: <4714C66D.4010607@gmail.com> <20071016154313.53d19c43@the-village.bc.nu>
In-Reply-To: <20071016154313.53d19c43@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 16 Oct 2007 18:10:53 +0400
> Konstantin Kalin <konstantin.kalin@gmail.com> wrote:
>
>   
>> Hello,
>>
>> Recently we've got some computers with new motherboard having NVidia 
>> chipset. The motherboard has nforce12 & nforce13 Ethernet cards. I've 
>> noticed that MAC address is setup random each boot. I debugged the 
>> driver and found that these cards have right-byte order of MAC address 
>> but the driver is expecting incorrect byte-order for these models.
>>     
>
> The only obvious thing I can think of to try would be to read the MAC
> address both ways around.
>
> The first 3 bytes of the resulting MAC should always be the Nvidia
> allocation as I understand it and if so you can then decide which way
> around is correct. 
>
> ie if it starts 00:04:0B then you know which way around it goes. (there
> is one address that is the same either way around but clearly that one
> doesn't matter).
>
> So perhaps do that and for the afflicted parts add an EITHER_WAY_AROUND
> flag ?
>
> Alan
>
>   

Hello,

I thought a bit today and made a patch. The patch adds new parameter to 
the driver that allows initializing MAC by manually. There is an issue 
that I didn't fix - if the driver has been loaded with wrong MAC 
detection when the parameter works inversely due to the driver replaces 
original mac. Please look at these line in "nv_probe" function:
 /* set permanent address to be correct aswell */
     np->orig_mac[0] = (dev->dev_addr[0] << 0) + (dev->dev_addr[1] << 8) +
....

P.S. The patch is based on vanila 2.6.21-7 because we use it in our 
servers.

Thank you,
Kostya.

-------------------------------------------------------------------------------------------------

--- linux-2.6.21.x86_64/drivers/net/forcedeth.c.orig    2007-10-17 
11:07:09.000000000 +0400
+++ linux-2.6.21.x86_64/drivers/net/forcedeth.c 2007-10-17 
11:07:32.000000000 +0400
@@ -850,6 +850,15 @@
 };
 static int dma_64bit = NV_DMA_64BIT_ENABLED;

+enum {
+       NV_FORCING_MAC_DISABLED = 0,
+       NV_FORCE_MAC_CORRECT_ORDER,
+       NV_FORCE_MAC_INVERSE_ORDER
+};
+
+static int force_mac = NV_FORCING_MAC_DISABLED;
+
+
 static inline struct fe_priv *get_nvpriv(struct net_device *dev)
 {
        return netdev_priv(dev);
@@ -4844,6 +4853,7 @@
        u32 powerstate, txreg;
        u32 phystate_orig = 0, phystate;
        int phyinitialized = 0;
+       bool mac_address_correct = false;

        dev = alloc_etherdev(sizeof(struct fe_priv));
        err = -ENOMEM;
@@ -5032,7 +5043,16 @@

        /* check the workaround bit for correct mac address order */
        txreg = readl(base + NvRegTransmitPoll);
-       if (txreg & NVREG_TRANSMITPOLL_MAC_ADDR_REV) {
+
+       /* Since Vendors begin fixing MAC address in oldest version of 
Etherenet card we should provide a way to initialize MAC by parameter */
+       mac_address_correct = (txreg & NVREG_TRANSMITPOLL_MAC_ADDR_REV) 
|| (force_mac == NV_FORCE_MAC_CORRECT_ORDER);
+       printk(KERN_DEBUG "force_mac=%d, txreg=%d, 
mac_address_correct=%d\n", force_mac, txreg, mac_address_correct);
+       if (force_mac == NV_FORCE_MAC_INVERSE_ORDER)
+       {
+               mac_address_correct = false;
+       }
+
+       if (mac_address_correct) {
                /* mac address is already in correct order */
                dev->dev_addr[0] = (np->orig_mac[0] >>  0) & 0xff;
                dev->dev_addr[1] = (np->orig_mac[0] >>  8) & 0xff;
@@ -5444,6 +5461,8 @@
 MODULE_PARM_DESC(msix, "MSIX interrupts are enabled by setting to 1 and 
disabled by setting to 0.");
 module_param(dma_64bit, int, 0);
 MODULE_PARM_DESC(dma_64bit, "High DMA is enabled by setting to 1 and 
disabled by setting to 0.");
+module_param(force_mac, int, 0);
+MODULE_PARM_DESC(force_mac, "Force MAC address in correct/inverse byte 
order. 0 - do nothing, 1 - correct order, 2 -inverse order");

 MODULE_AUTHOR("Manfred Spraul <manfred@colorfullife.com>");
 MODULE_DESCRIPTION("Reverse Engineered nForce ethernet driver");

