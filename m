Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYJFTnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYJFTnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYJFTnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:43:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:55311 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYJFTnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=JvhGW1qQTL38pDaEMhc5GtPv5zda3Wrki0VhKRgwmP0vW4TDRzSG6Rwo13gYKSkR0t
         go1EmFc2+zGAoSOP40InUAurVzX/PXuBLlBhTXHOqvNMy5vf4/02covLKLVYB6P0RQgM
         5abWAGFUexBun4FqpmRqMugKnC5+mk0pUGJsw=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [RFC PATCH 0/4] V3 - Implementation of IR support using the input
	subsystem
To: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net
Date: Mon, 06 Oct 2008 15:43:06 -0400
Message-ID: <20081006194032.15992.8393.stgit@terra>
User-Agent: StGIT/0.14.3.224.g199b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third pass at implementing evdev support for IR. The goal of in-kernel IR is to integrate IR events into the evdev input event queue and maintain ordering of events from all input devices.

New feature, raw mode. There are three sysfs attributes - ir_raw, ir_carrier, ir_xmitter. Read from ir_raw to get the raw timing data from the IR device. Set carrier and active xmitters and then copy raw data to ir_raw to send. These attributes may be better on a debug switch. You would use raw mode when decoding a new protocol. After you figure out the new protocol, write an in-kernel encoder/decoder for it.

What should the IR API look like? 

How are IR events mapped into keyboard events? Should they be mapped? Map them in the kernel or in user space? The maps are tiny, less than 1K per remote.  Sysfs can be used to load maps into the kernel driver. Make maps only for the common buttons and don't map unusual ones?

How should multiple remotes be handled? Split them out into individual input devices, or group them onto a single IR device? I can implement either.

The in-kernel code is tiny, about 20K including a driver.

>From last post...
Note that user space IR device drivers can use the existing support in evdev to inject events into the input queue.

Send and receive are implemented. Received IR messages are decoded and sent to user space as input messages. Send is done via an IOCTL on the input device.

Two drivers are supplied. mceusb2 implements send and receive support for the Microsoft USB IR dongle.

The GPT driver implements receive only support for a GPT pin - GPT is a GPIO with a timer attached.

Code is only lightly tested. Encoders and decoders have not been written for all protocols. 
Repeat is not handled for any protocol.
I'm looking for help. There are 15 more existing LIRC drivers.

---

Jon Smirl (4):
      Microsoft mceusb2 driver for in-kernel IR subsystem
      Example of PowerPC device tree support for GPT based IR
      GPT driver for in-kernel IR support.
      Changes to core input subsystem to allow send and receive of IR messages. Encode and decode state machines are provided for common IR porotocols such as Sony, JVC, NEC, Philips, etc.


 arch/powerpc/boot/dts/dspeak01.dts |   19 -
 drivers/input/Kconfig              |    2 
 drivers/input/Makefile             |    3 
 drivers/input/evdev.c              |   55 +++
 drivers/input/input.c              |   21 +
 drivers/input/ir-core.c            |  659 ++++++++++++++++++++++++++++++++
 drivers/input/ir/Kconfig           |   26 +
 drivers/input/ir/Makefile          |    7 
 drivers/input/ir/ir-gpt.c          |  221 +++++++++++
 drivers/input/ir/ir-mceusb2.c      |  741 ++++++++++++++++++++++++++++++++++++
 include/linux/input.h              |  101 +++++
 include/linux/mod_devicetable.h    |    3 
 12 files changed, 1846 insertions(+), 12 deletions(-)
 create mode 100644 drivers/input/ir-core.c
 create mode 100644 drivers/input/ir/Kconfig
 create mode 100644 drivers/input/ir/Makefile
 create mode 100644 drivers/input/ir/ir-gpt.c
 create mode 100644 drivers/input/ir/ir-mceusb2.c

-- 
Jon Smirl
jonsmirl@gmail.com
