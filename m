Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbYKETrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbYKETrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYKETrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:47:42 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:12406 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYKETrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:47:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=MKCgSBTnOnxBf6WjBiiTqwIqEWr1zYs96wqjeQEmjYZcxWhDVWlRK/5PGS/iOVPCnG
         4fb91NJE/eiGfYjAairJuDPgs+1oQqSiw0dhUb7mEbf5fWemAgSX3Uy4N1AvQUEEfXY0
         BCnVpcFpV+PuqhGYnWgAmDLiE4lngTEPjg93Y=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [RFC PATCH V4 0/6] In-kernel IR remote control support
To: linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2008 14:47:36 -0500
Message-ID: <20081105194640.19407.19682.stgit@localhost>
User-Agent: StGit/0.14.3.275.gdc7f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New release of in-kernel IR support implementing evdev support. The goal of in-kernel IR is to integrate IR events into the evdev input event queue and maintain ordering of events from all input devices. Still looking for help with this project.

Git tree: git://github.com/jonsmirl/digispeaker.git

ir-core is now a module. Minimal IR code is built into input, that code can't be separated from input. The rest of the core IR code is moved to a module. The IR code in input will be passive if IR-core isn't loaded.

Now uses configfs to build mappings from remote buttons to key strokes. When ir-core loads it creates /config/remotes. Make a directory for each remote you have; this will cause a new input devices to be created. Inside these directories make a directory for each key on the remote. In the key directory attributes fill in the protocol, device, command, keycode. Since this is configfs all of this can be easily scripted.

Now when a key is pressed on a remote, the configfs directories are searched for a match on protocol, device, command. If a matches is found, a key stroke corresponding to keycode is created and sent on the input device that was created when the directory for the remote was made.

The configfs directories are pretty flexible. You can use them to map multiple remotes to the same key stroke, or send a single button push to multiple apps.

>From last release...

Raw mode. There are three sysfs attributes - ir_raw, ir_carrier, ir_xmitter. Read from ir_raw to get the raw timing data from the IR device. Set carrier and active xmitters and then copy raw data to ir_raw to send. These attributes may be better on a debug switch. You would use raw mode when decoding a new protocol. After you figure out the new protocol, write an in-kernel encoder/decoder for it.

The in-kernel code is tiny, about 20K including a driver.

>From last post...
Note that user space IR device drivers can use the existing support in evdev to inject events into the input queue.

Send and receive are implemented. Received IR messages are decoded and sent to user space as input messages. Send is done via an IOCTL on the input device.

Two drivers are supplied. mceusb2 implements send and receive support for the Microsoft USB IR dongle.

The GPT driver implements receive only support for a GPT pin - GPT is a GPIO with a timer attached.

Code is only lightly tested. Encoders and decoders have not been written for all protocols.
Repeat is not handled for any protocol. I'm looking for help. There are 15 more existing LIRC drivers.

---

Jon Smirl (6):
      Microsoft mceusb2 driver for in-kernel IR subsystem
      Example of PowerPC device tree support for GPT based IR
      GPT driver for in-kernel IR support.
      Configfs support for IR
      Core IR module
      Minimal changes to the core input system


 arch/powerpc/boot/dts/dspeak01.dts |   19 -
 drivers/input/Kconfig              |    2 
 drivers/input/Makefile             |    1 
 drivers/input/evdev.c              |   55 +++
 drivers/input/input.c              |   17 +
 drivers/input/ir/Kconfig           |   27 +
 drivers/input/ir/Makefile          |   12 +
 drivers/input/ir/ir-configfs.c     |  333 ++++++++++++++++
 drivers/input/ir/ir-core.c         |  678 +++++++++++++++++++++++++++++++++
 drivers/input/ir/ir-gpt.c          |  224 +++++++++++
 drivers/input/ir/ir-mceusb2.c      |  744 ++++++++++++++++++++++++++++++++++++
 drivers/input/ir/ir.h              |   48 ++
 include/linux/input.h              |   75 ++++
 include/linux/mod_devicetable.h    |    3 
 14 files changed, 2227 insertions(+), 11 deletions(-)
 create mode 100644 drivers/input/ir/Kconfig
 create mode 100644 drivers/input/ir/Makefile
 create mode 100644 drivers/input/ir/ir-configfs.c
 create mode 100644 drivers/input/ir/ir-core.c
 create mode 100644 drivers/input/ir/ir-gpt.c
 create mode 100644 drivers/input/ir/ir-mceusb2.c
 create mode 100644 drivers/input/ir/ir.h

-- 
Jon Smirl
jonsmirl@gmail.com
