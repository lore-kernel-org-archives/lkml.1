Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZF1SFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZF1SFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZF1SFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:05:12 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:52869 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330AbZF1SFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:05:11 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Inconsistent console logging using 'quiet' with encrypted root fs
Date: Sun, 28 Jun 2009 20:05:11 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
Cc: cryptsetup@packages.debian.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200906282005.12020.elendil@planet.nl>
X-OriginalArrivalTime: 28 Jun 2009 18:05:12.0771 (UTC) FILETIME=[FB6B2130:01C9F81A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boot option 'quiet' sets console_loglevel to 4 (KERN_WARNING) instead 
of the default 7 (KERN_DEBUG).

This is respected during the early part of the boot of my system (x86_64, 
Debian stable), when kernel and initrd are loaded/run. But after the 
boot process mounts root and starts udev, I suddenly get a lot of messages 
of level KERN_INFO. That can't be the intention of 'quiet'...

When I look at /proc/sys/kernel/printk after the boot, I see 
console_loglevel is set to 7 instead of 4.

After some instrumentation I've found the cause for this problem.

My root partition is part of an encrypted LVM volume. So the initramfs 
prompts for the passphrase needed to unlock the PV, and Debian's 
cryptsetup package disables console logging around that to avoid the user 
interaction getting messed up by kernel printks. That this is needed can 
be seen from the partial log below.

To disable and re-enable logging to console, Debian's cryptsetup uses
klogctl(6, NULL, 0) and klogctl(7, NULL, 0). Problem is that the latter 
resores console_loglevel to the *default* level instead of the previous 
level. And thus the 'quiet' boot becomes noisy from that point onwards.

It seems reasonable to have "enable logging to console" restore the 
previous level instead. I'll follow up with a patch that does that.

Cheers,
FJP

dmesg *after* patch in follow-up mail was applied, with instrumentation:
[...]
usb 5-2: configuration #1 chosen from 1 choice
[cryptsetup prompts for passphrase -> logging disabled]
FJP: console logging disabled (console_loglevel: 1)
FJP: console_loglevel change 4->1
usb 1-2.2: new full speed USB device using ehci_hcd and address 4
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929192210]
usb 1-2.2: configuration #1 chosen from 1 choice
usb 1-2.3: new low speed USB device using ehci_hcd and address 5
usb 1-2.3: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /class/input/input1
generic-usb 0003:046D:C50D.0001: input: USB HID v1.10 Mouse
   [Logitech USB Receiver] on usb-0000:00:1a.7-2.3/input0
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
usb 1-2.4: new low speed USB device using ehci_hcd and address 6
usb 1-2.4: configuration #1 chosen from 1 choice
input: USB Compliant Keyboard as /class/input/input2
generic-usb 0003:05A4:9841.0002: input: USB HID v1.10 Keyboard
   [USB Compliant Keyboard] on usb-0000:00:1a.7-2.4/input0
input: USB Compliant Keyboard as /class/input/input3
generic-usb 0003:05A4:9841.0003: input: USB HID v1.10 Device
   [USB Compliant Keyboard]  on usb-0000:00:1a.7-2.4/input1
[incorrect passphrase entered]
FJP: console logging enabled (console_loglevel: 4)
FJP: console_loglevel change 1->4
[incorrect passphrase, so cryptsetup asks again]
FJP: console logging disabled (console_loglevel: 1)
FJP: console_loglevel change 4->1
FJP: console logging enabled (console_loglevel: 4)
FJP: console_loglevel change 1->4
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
[root file system mounted]
[...]
