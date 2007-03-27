Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXC0QZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXC0QZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXC0QZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:25:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:65268 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064AbXC0QY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=oXFCxXO2ID7kIW6KNbLW1+E8M/OvN+JAwOFkUgs8OnMfrq8kyCa4bWwB3yom+LRpKEOqQii6QDzsRslZaGKbartHmgeOuSSkPgzQzMqWYqtH2SgEoM9TJ3oT1nO7jA2bBT113hB4pUIQi0yNhdcSjYFeU6v24yvZqMX8dJf6ZV0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: USB: on suspend to ram/disk all usb devices are replugged
Date: Tue, 27 Mar 2007 18:24:46 +0200
User-Agent: KMail/1.9.6
Cc: stern@rowland.harvard.edu, gregkh@suse.de
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703271824.46804.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	I noticed that after suspend/resume cycle all my usb devices are unplugged/replugged by uhci driver.
While it is not that big problem to me, that can be a real problem if a device is a flash card with mounted 
file-system, because disappeared device will cause file-system corruption.

I found why this happens.

drivers/usb/host/pci-quirks.c:uhci_check_and_reset_hc checks that the BIOS didn't play with USB controller, and on my system
with or without a USB Legacy support turned on in the BIOS, the BIOS does meddle with USB controller,

But I suggest adding a option that will allow the user to bypass that check, because for example on my system USB works perfectly
if I disable the checks that this function does (but I agree that those checks are  very valuable, since I almost sure that on many systems USB
won't work without resetting the USB controller.)

Secondary,  this function checks for UHCI_USBCMD_CONFIGURE, that is not set on resume,
According to both UHCI and ICH8 documentation this is software only bit, but I didn't find any place in kernel where it is set,
(But such place exist, because reading from usb IO ports confirm that it is set during normal work, I will try to find it)

Disabling both check for UHCI_USBLEGSUP and UHCI_USBCMD_CONFIGURE makes all usb devices (I have mouse,keyborad, and joystick)
work fine on resume from ram without this "virtual" replugging.

Suspend to disk still causes "virtual replugging"  and I think that controller is reset and will unplug/replug devices anyway
Resolving this problem is very difficult. Maybe it possible to check on unplugging event that this caused by suspend  if the same device is
replugged then don't remove/reinstall driver, but this is very difficult to implement properly,
Maybe just refuse to suspend if some valuable device is connected (sorry if it is done this way already)

Also I want to note that I didn't yet checked any EHCI devices, because I don't have any (I am going to buy a usb stick soon)
But I feel that the above will be true for ehci too....

Looking for comments,
	Best regards,
		Maxim Levitsky
