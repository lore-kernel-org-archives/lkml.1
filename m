Return-Path: <linux-kernel-owner+w=401wt.eu-S1765727AbXJZVPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765727AbXJZVPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbXJZVPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:15:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:22914 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbXJZVPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=ZfZBoO7O/aaX0Gn9tD/3WiqUD/zciLRaLe19ldCosJMxflKwmvxH+qDHrL+7vpOKMfz+PpsTC0I3dUjdixqCksEk5BI8208hGS+4hFopyqZG5XYu5R+Ga8nv2ZbQTS3iFXAIDwzYcaW9lVHwLGBXOqifREZktLgUpS1LeT/bezc=
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
Date: Fri, 26 Oct 2007 23:34:54 +0200
User-Agent: KMail/1.9.7
Cc: Adam Baker <linux@baker-net.org.uk>, rt2400-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-stuff@comcast.net
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop> <200710262058.56188.linux@baker-net.org.uk> <adaejfhzlnh.fsf@cisco.com>
In-Reply-To: <adaejfhzlnh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710262334.54684.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007, Roland Dreier wrote:
>  > The function that is returning ENODEV is the driver probe function. According 
>  > to Documentation/DocBook/writing_usb_driver/ch03.html when that function is 
>  > called 
>  > 
>  > "The driver now needs to verify that this device is actually one that it can 
>  > accept. If so, it returns 0. If not, or if any error occurs during 
>  > initialization, an errorcode (such as -ENOMEM or -ENODEV) is returned from 
>  > the probe function."
>  > 
>  > It isn't a device the driver can accept so it returns -ENODEV
> 
> That's all true but irrelevant.  That error return isn't propagated
> back to userspace when it runs modprobe (and in fact it *can't* be
> sanely returned to userspace -- what do you do if the probe function
> succeeds for two devices and fails for a third?).  So there's not
> really any way for userspace to loop through a list of modules until
> one succeeds.

We are mixing 2 things up I think.

We have module loading, which is called when the module is loaded and
will register what PCI or USB devices it supports.
And we have hardware probing, which results in the kernel calling the probe()
function of the usb_driver or pci_driver structure.

The the return value of the module loading is not an issue, since indeed that is called
while the hardware might not be present.
The hardware probing _is_ called when the hardware is present, reason is simple,
hotplugging detects the new card and checks all registered USB/PCI ID's for a driver
that matches the device. If it matches the probe() function is called.
And that is where the ENODEV error could be checked, if the driver decides that the
plugged in device it was offere by the kernel is not a device it supports it needs
to tell that to the kernel. In turn the kernel can continue looking into the registered
USB/PCI ID lists to find a different driver that does support the hardware.

Ivo
