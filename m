Return-Path: <linux-kernel-owner+w=401wt.eu-S1764815AbZDHNvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764815AbZDHNvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbZDHNvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:51:07 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60754 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZDHNvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:51:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=H0KfcqUBqPOYOhpZhN86JiI/fMHVqNQOAbdIBLIur2EiuVHvA3JPUfTXiKrHzl1njI
         Mtyy7qWYTwwxv38ByrXWpMPq83c2ToH9maPZWDfIvapaarTNRdLEjoXuvdkv9rmiSGGJ
         uV//uptfWpTPaqnz/AfSjrUrUslGaydxevJCQ=
MIME-Version: 1.0
From: Nuno Lucas <ntlucas@gmail.com>
Date: Wed, 8 Apr 2009 14:50:45 +0100
Message-ID: <c4f20e170904080650v34def3a0neb5e09f402c202a1@mail.gmail.com>
Subject: usbtouchscreen: eGalax (clone?) not being ignored by the 
	usbtouchscreen driver
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.ritz@gmx.ch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a recent patch [1], Daniel Ritz added
USB_DEVICE_ID_MATCH_INT_PROTOCOL for the "match_flags" of the
USB_DEVICE_HID_CLASS macro, but I have another "eGalax" controller
with the same USB properties but that needs to be handled by the
usbhid driver.

My "/proc/bus/usb/devices" part:

T:  Bus=05 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0eef ProdID=0001 Rev= 1.00
S:  Manufacturer=eGalax Inc.
S:  Product=Touch
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr= 44mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms

If I remove the USB_DEVICE_ID_MATCH_INT_PROTOCOL then the
usbtouchscreen driver ignores the device and usbhid takes over as it
should be. But with the current code, usbtouchscreen claims the device
and as it doesn't understand the protocol makes the device unusable.

The device mentioned on the thread that needs the usbtouchscreen
driver was this:

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 13 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0eef ProdID=0001 Rev= 1.00
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr= 44mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=5ms

It seems the eGalax USB ID (0eef:0001) is being (ab)used by a lot of
different manufacturers, but shouldn't the default be to let the
usbhid driver to decide if it can or not use the device if the device
class is HID? All other "eGalax" devices I have seen that really need
the usbtouchscreen driver have the 0xff class, like the one below:

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0eef ProdID=0001 Rev= 1.00
S:  Manufacturer=eGalax Inc.
S:  Product=USB TouchController
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=usbtouchscreen
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=5ms

If there are devices that need to use usbtouchscreen and have the HID
class then, in my view, are plain broken. Maybe the solution would be
to somehow allow the user to re-attach the device to a different
driver.

As I'm no kernel programmer, anyone care to comment?


Regards,
~Nuno Lucas

[1] http://lkml.org/lkml/2009/2/8/70
