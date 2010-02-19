Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0BST0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:26:50 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34142 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab0BST0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:26:48 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/7] Add basic ARM device tree support
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, jeremy.kerr@canonical.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: tim.bird@am.sony.com
Date: Fri, 19 Feb 2010 12:26:40 -0700
Message-ID: <20100219185953.15318.4850.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone.  It's been a long time coming, but I thing Jeremy and I have
things to a point where the basic patches needs to add flattened device
tree support to ARM are pretty stable.  This series doesn't really do
much other than making CONFIG_OF selectable, allowing a device tree to
be passed in at boot via an ATAG, and unpacking the tree into the
struct device_node* tree used by drivers/of/*.  No platforms actually
use any of the data yet, but the tree can be browsed in /proc/device-tree

Patches 1-5 are the important ones.  As you can see, the impact is
pretty low.  Biggest change is some refactoring of
arch/arm/mm/init.c so that the memory region occupied by the
device tree blob (dtb) gets reserved in the same way as for an initrd.

Patches 6 is RFC only, and it doesn't fully work yet because it isn't
able to handle relocating the .dtb if it overlaps the final kernel
location.  I'm still working on it, but I'm not even convinced that it
is the best approach yet.  I include it here so that people can build
a kernel image that embeds the dtb and so give the device tree code a
spin without having to modify firmware.  Patch 7 is a complete hack to
work around the problem in patch 6.

These patches depend on the merge of PowerPC and Microblaze device tree
code.  The merge work is in linux-next and I'll be asking Linus to pull
it when he opens the window.  It also depends on the earlier patch
posted by Jeremy Kerr to use generic infrastructure for early_params.
These patches are available in the test-devicetree branch of my
linux-2.6 git tree:

git://git.secretlab.ca/git/linux-2.6 test-devicetree

>From here, there are 2 things being worked on.  Jeremy is working on
the early init code to make device tree data available earlier in the
boot process so that device tree data can be used for machine probing
and memory setup.  I'm focusing on parsing the device tree data for
registering platform, i2c and spi devices.  Each of those tasks are
mostly independent and can be posted/reviewed when they are working.

Thanks
g.

---

Grant Likely (3):
      arm/boot/hack: set uImage load address to 0x81000000
      arm/devicetree: Allow .dtb to be carried in the zImage payload
      arm/devicetree: Reserve memory used by dtb blob

Jeremy Kerr (4):
      arm-dt: unflatten device tree
      arm-dt: add devictree node reference to dev_archdata
      arm-dt: Allow CONFIG_OF on ARM
      arm-dt: Add ATAG_DEVTREE tag


 arch/arm/Kconfig                        |   27 ++++++++
 arch/arm/boot/Makefile                  |    2 -
 arch/arm/boot/compressed/Makefile       |   23 ++++++-
 arch/arm/boot/compressed/head.S         |   10 +++
 arch/arm/boot/compressed/misc.c         |   30 +++++++++
 arch/arm/boot/compressed/piggy.dtb.S    |    6 ++
 arch/arm/boot/compressed/vmlinux.lds.in |    2 +
 arch/arm/include/asm/device.h           |    3 +
 arch/arm/include/asm/prom.h             |   19 ++++++
 arch/arm/include/asm/setup.h            |    9 +++
 arch/arm/kernel/Makefile                |    1 
 arch/arm/kernel/devtree.c               |   34 ++++++++++
 arch/arm/kernel/setup.c                 |    3 +
 arch/arm/mm/init.c                      |  102 +++++++++++++++++++++++++------
 14 files changed, 248 insertions(+), 23 deletions(-)
 create mode 100644 arch/arm/boot/compressed/piggy.dtb.S
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c

-- 
Signature
