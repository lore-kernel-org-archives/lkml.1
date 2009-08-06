Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZHFUPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZHFUPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZHFUPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:15:04 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:34054 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbZHFUPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CcHb7M5Kz3vS0NzgUmhb+Dbg/QJvxngj2YEpnpSGtkERQhxz2hJ6IHXNoC9MtvsY27
         oFxBxIuPZMuBEPJ68lgXpruVjlB2ZbNy78bmBvOTNyPpR3eq6x8IMqlKvV6OXIt5/JZr
         7daA9m1sxQfxlJ4AZYXiTSrGsQRnE/PM24ANM=
MIME-Version: 1.0
Date: Thu, 6 Aug 2009 21:15:01 +0100
Message-ID: <ac71f2bb0908061315o1449e91dge1d5a63a2a4b986a@mail.gmail.com>
Subject: serio / atkbd / PS/2 Strangeness with Serial port adapter
From: Matt Causey <matt.causey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364d1dc546a28604707ec662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364d1dc546a28604707ec662
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello!

Apologies if this really is't the right forum (suggestions on the
right forum would be welcome).

We are switching from an old 2.4 kernel on our thin clients to 2.6
(2.6.28-gentoo-r5).

Things are working well - except for one problem.  One the new image,
some of the input devices don't work we expected.  We have a number of different
barcode scanners that attach to these terminals.  Many of the new ones
are USB HID compliant devices - which is great.  Most of them are
actually serial port devices, that connect to the terminal via a
serial --> PS/2 'wedge'.  The PS/2 wedge devices are the ones that
don't work correctly.

If we connect the scanner to the thin client, and boot the image, the
scanner does not work.  It does not show up at all as an input device:

blablahostname / # cat /proc/bus/input/devices
I: Bus=0003 Vendor=046d Product=c001 Version=0110
N: Name="Logitech USB Mouse"
P: Phys=usb-0000:00:03.0-1/input0
S: Sysfs=/devices/pci0000:00/0000:00:03.0/usb2/2-1/2-1:1.0/input/input0
U: Uniq=
H: Handlers=mouse0 event0
B: EV=17
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=103
B: MSC=10

I: Bus=0003 Vendor=03f0 Product=0024 Version=0110
N: Name="CHICONY HP Basic USB Keyboard"
P: Phys=usb-0000:00:03.1-2/input0
S: Sysfs=/devices/pci0000:00/0000:00:03.1/usb3/3-2/3-2:1.0/input/input1
U: Uniq=
H: Handlers=kbd event1
B: EV=120013
B: KEY=10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=7

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input2
U: Uniq=
H: Handlers=kbd event2
B: EV=40001
B: SND=6

So, I enabled debugging on the contoller driver(serio.c), and I see
that the device generates noise when connected:

[  458.875614] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [444989]
[  458.908119] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 0,
1, timeout) [445022]
[  458.908144] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [445022]
[  458.940151] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 0,
1, timeout) [445054]
[  458.940225] drivers/input/serio/i8042.c: d4 -> i8042 (command) [445054]
[  458.940234] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [445054]
[  458.972190] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1,
12, timeout) [445086]
[  458.972204] drivers/input/serio/i8042.c: d4 -> i8042 (command) [445086]
[  458.972212] drivers/input/serio/i8042.c: ed -> i8042 (parameter) [445086]
[  459.004227] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1,
12, timeout) [445118]
[20171.684870] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 0,
1) [20162195]

However - the atkbd driver does not pick the device up at all.

So, I did find a workaround (which is NOT acceptable for this
deployment).  Remember the PS/2 'wedge' I mentioned?  Well, it has an
extra PS/2 port for your keyboard.  If I connect a PS/2 keyboard to
that thing, suddenly my scanner starts working.

We see some chatter from the controller driver, then one of these:

[23811.805578] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input6

Aaaand a new device is registered as an input device:

yayayayhostname# cat /proc/bus/input/devices
I: Bus=0003 Vendor=046d Product=c001 Version=0110
N: Name="Logitech USB Mouse"
P: Phys=usb-0000:00:03.0-1/input0
S: Sysfs=/devices/pci0000:00/0000:00:03.0/usb2/2-1/2-1:1.0/input/input0
U: Uniq=
H: Handlers=mouse0 event0
B: EV=17
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=103
B: MSC=10

I: Bus=0003 Vendor=03f0 Product=0024 Version=0110
N: Name="CHICONY HP Basic USB Keyboard"
P: Phys=usb-0000:00:03.1-2/input0
S: Sysfs=/devices/pci0000:00/0000:00:03.1/usb3/3-2/3-2:1.0/input/input1
U: Uniq=
H: Handlers=kbd event1
B: EV=120013
B: KEY=10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=7

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input2
U: Uniq=
H: Handlers=kbd event2
B: EV=40001
B: SND=6

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/devices/platform/i8042/serio0/input/input6
U: Uniq=
H: Handlers=kbd event3
B: EV=120013
B: KEY=4 2000000 3803078 f800d001 feffffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=7

Here is an lsmod, and I've attached .config in case it's helpful:

Module                  Size  Used by
ppdev                   6276  0
parport_pc             26512  1
lp                      8560  0
parport                26824  3 ppdev,parport_pc,lp
pcspkr                  2176  0
atkbd                  15508  0
ohci_hcd               28308  0

So, I don't get it.  We had this all working fine with the (now
ancient version) LTSP configuration, linux 2.4, etc.  Did some drastic
things change in 2.6 with keyboard management?

I am completely out of ideas.  The only thing I can figure is that the
PS/2 wedge thing isn't doing the right thing, and as a result the 2.6
version of the atkbd driver isn't binding it?   Maybe there is some
udev magic I need to know?

Apologies if I've missed something obvious here.  Any help would be
much appreciated!
Thanks!

--0016364d1dc546a28604707ec662
Content-Type: application/x-gzip; name="config.gz"
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fy1xf0pb0

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
rE0ynrFDWpDhcfp/hbW88o/jAAA=
--0016364d1dc546a28604707ec662--
