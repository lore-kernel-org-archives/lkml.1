Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0BRJJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:09:16 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:38791 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0BRJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:09:12 -0500
Date: Thu, 18 Feb 2010 04:09:09 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI & driver patches for 2.6.33-rc8
Message-id: <alpine.LFD.2.00.1002180406450.4135@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
Mostly regression bug fixes.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.33/acpi-release-20091214-2.6.33-rc8.diff.gz

 Documentation/kernel-parameters.txt  |    4 ++++
 arch/ia64/include/asm/acpi.h         |    1 +
 arch/x86/kernel/acpi/boot.c          |    8 --------
 drivers/acpi/dock.c                  |    1 +
 drivers/acpi/processor_idle.c        |    8 ++++++++
 drivers/acpi/processor_pdc.c         |   14 ++++++++++++++
 drivers/acpi/scan.c                  |   27 ++++++++++++++++++++++-----
 drivers/acpi/tables.c                |    4 ++--
 drivers/gpu/drm/i915/intel_lvds.c    |    7 +++++++
 drivers/pci/hotplug/acpiphp_glue.c   |    6 ------
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 11 files changed, 60 insertions(+), 22 deletions(-)

through these commits:

Alex Chiang (3):
      ACPI: processor: add kernel command line support for early _PDC eval
      ACPI: processor: only evaluate _PDC once per processor
      ACPI: dock: properly initialize local struct dock_station in dock_add()

Arjan van de Ven (1):
      ACPI: fix High cpu temperature with 2.6.32

Len Brown (2):
      ACPI: remove Asus P2B-DS from acpi=ht blacklist
      ACPI: fix "acpi=ht" boot option

Roel Kluin (1):
      thinkpad-acpi: wrong thermal attribute_group removed in thermal_exit()

Thomas Renninger (2):
      ACPI: Add NULL pointer check in acpi_bus_start
      ACPI: acpi_bus_{scan,bus,add}: return -ENODEV if no device was found

Zhang Rui (1):
      ACPI, i915: blacklist Clevo M5x0N bad_lid state

with this log:

commit 0e2ecbaefd219cb538aa7827f37da064d1a3328b
Merge: b0483e7 49bf83a 49c6fb2 370d5cd 1379d2f a493229 7779688 f04d5e0
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 18 03:51:04 2010 -0500

    Merge branches 'bugzilla-14886', 'bugzilla-15000', 'bugzilla-15040', 'bugzilla-15108', 'pdc', 'hotplug-null-ref' and 'thinkpad' into release

commit 49bf83a45fc677db1ed44d0e072e6aaeabe4e124
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 16 03:45:45 2010 -0500

    ACPI: fix "acpi=ht" boot option
    
    We broke "acpi=ht" in 2.6.32 by disabling MADT parsing
    for acpi=disabled.  e5b8fc6ac158f65598f58dba2c0d52ba3b412f52
    This also broke systems which invoked acpi=ht via DMI blacklist.
    
    acpi=ht is a really ugly hack,
    but restore it for those that still use it.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14886
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1379d2fef0ec07c7027a5e89036025ce761470c8
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Feb 16 04:16:55 2010 -0500

    ACPI, i915: blacklist Clevo M5x0N bad_lid state
    
    Wrong Lid state reported.
    Need to blacklist this machine for LVDS detection.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 370d5cd88509b93b76eb2f5f97efbd71c25061cb
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Wed Jan 27 15:25:39 2010 -0800

    ACPI: fix High cpu temperature with 2.6.32
    
    Since the rewrite of the CPU idle governor in 2.6.32, two laptops have
    surfaced where the BIOS advertises a C2 power state, but for some reason
    this state is not functioning (as verified in both cases by powertop
    before the patch in .32).
    
    The old governor had the accidental behavior that if a non-working state
    was chosen too many times, it would end up falling back to C1.  The new
    governor works differently and this accidental behavior is no longer
    there; the result is a high temperature on these two machines.
    
    This patch adds these 2 machines to the DMI table for C state anomalies;
    by just not using C2 both these machines are better off (the TSC can be
    used instead of the pm timer, giving a performance boost for example).
    
    Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14742
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Reported-by: <akwatts@ymail.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 49c6fb2e41d41c4c0c5c753b6960bc81fe658d20
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 1 10:35:18 2010 -0700

    ACPI: dock: properly initialize local struct dock_station in dock_add()
    
    Commit fe06fba2 (ACPI: dock: add struct dock_station * directly
    to platform device data) changed dock_add() to use the
    platform_device_register_data() API.
    
    We passed that interface a stack variable, which is kmemdup'ed
    and assigned to the device's platform_data pointer.
    
    Unfortunately, whatever random garbage is in the stack variable
    gets coped during the kmemdup, and that leads to broken behavior.
    
    Explicitly zero out the structure before passing it to the API.
    
    This fixes the T41 docking button issue:
    http://bugzilla.kernel.org/show_bug.cgi?id=15000
    
    Cc: stable@kernel.org
    Reported-by: Chris Mason <chris.mason@oracle.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 97c169d39b6846a564dc8d883832e7fef9bdb77d
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 16 03:30:06 2010 -0500

    ACPI: remove Asus P2B-DS from acpi=ht blacklist
    
    We realized when we broke acpi=ht
    http://bugzilla.kernel.org/show_bug.cgi?id=14886
    that acpi=ht is not needed on this box
    and folks have been using acpi=force on it anyway.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f04d5e012d73ea441bd39804ace39fd6d1ce5611
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Tue Feb 2 14:37:58 2010 -0800

    thinkpad-acpi: wrong thermal attribute_group removed in thermal_exit()
    
    sysfs_remove_group() removed the wrong attribute_group for
    thermal_read_mode TPEC_8, ACPI_TMP07 and ACPI_UPDT
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Acked-by: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7779688fc3d1ceddad84846a7b0affbe8e78ec6e
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Jan 29 17:48:52 2010 +0100

    ACPI: acpi_bus_{scan,bus,add}: return -ENODEV if no device was found
    
    Callers (acpi_memhotplug.c, dock.c and others) check for the return
    value of acpi_bus_add() and assume a valid device was returned in
    case zero was returned.
    
    Thus return -ENODEV if no device was found in acpi_bus_scan and
    propagate this through acpi_bus_add and acpi_bus_start.
    
    Also remove a confusing comment in acpiphp_glue.c, acpi_bus_scan
    will and cannot invoke if acpi_bus_add returns no valid device.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d2f6650a950dadd20667a04a9dc785f240d43695
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Jan 29 17:48:51 2010 +0100

    ACPI: Add NULL pointer check in acpi_bus_start
    
    If acpi_bus_add does not return a device and it's passed
    to acpi_bus_start, bad things will happen:
    
    BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
    IP: [<ffffffff8128402d>] acpi_bus_start+0x14/0x24
    ...
    [<ffffffffa008977a>] acpiphp_bus_add+0xba/0x130 [acpiphp]
    [<ffffffffa008aa72>] enable_device+0x132/0x2ff [acpiphp]
    [<ffffffffa0089b68>] acpiphp_enable_slot+0xb8/0x130 [acpiphp]
    [<ffffffffa0089df7>] handle_hotplug_event_func+0x87/0x190 [acpiphp]
    
    Next patch would make this NULL pointer check obsolete, but
    better having one more than one missing...
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4932299d03a1c20e58e4cc40a66fb0a048fb3a7
Author: Alex Chiang <achiang@hp.com>
Date:   Wed Jan 20 00:06:35 2010 -0700

    ACPI: processor: only evaluate _PDC once per processor
    
    If we evaluate _PDC in the early path, we do not want to evaluate
    it again when the processor driver is loaded.
    
    Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0406ad336c066190770cbf350b552d608e43ed09
Author: Alex Chiang <achiang@hp.com>
Date:   Wed Jan 20 00:06:30 2010 -0700

    ACPI: processor: add kernel command line support for early _PDC eval
    
    Allow platforms not listed in DMI table
    to opt-in and evaluate _PDC early.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
