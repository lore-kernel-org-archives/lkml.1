Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZCPFbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZCPFbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 01:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZCPFbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 01:31:20 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:18409 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZCPFbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 01:31:19 -0400
Date: Mon, 16 Mar 2009 01:31:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git PATCH] ACPI & driver patches for 2.6.29-rc8
Message-id: <alpine.LFD.2.00.0903160124320.6195@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

A couple of regression fixes and smattering of small driver-specific 
fixes.  This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.29/acpi-release-20081204-2.6.29-rc8.diff.gz

 drivers/acpi/bus.c                   |    9 +-----
 drivers/acpi/numa.c                  |    2 +-
 drivers/acpi/osl.c                   |   50 ----------------------------------
 drivers/acpi/sleep.c                 |   16 +++++++++++
 drivers/platform/x86/Kconfig         |   14 ++++-----
 drivers/platform/x86/acer-wmi.c      |    2 +-
 drivers/platform/x86/asus-laptop.c   |    5 +++-
 drivers/platform/x86/eeepc-laptop.c  |    6 +++-
 drivers/platform/x86/thinkpad_acpi.c |    8 +++---
 drivers/platform/x86/wmi.c           |    2 +-
 10 files changed, 39 insertions(+), 75 deletions(-)

through these commits:

Andy Whitcroft (1):
      suspend: switch the Asus Pundit P1-AH2 to old ACPI sleep ordering

Carlos Corbacho (2):
      acpi-wmi: Unmark as 'experimental'
      acer-wmi: Unmark as 'experimental'

Corentin Chary (4):
      asus-laptop: restore acpi_generate_proc_event()
      eeepc-laptop: restore acpi_generate_proc_event()
      asus-laptop: use select instead of depends on
      platform/x86: depends instead of select for laptop platform drivers

Cyrill Gorcunov (1):
      acpi: check for pxm_to_node_map overflow

Dan Carpenter (1):
      acer-wmi: double free in acer_rfkill_exit()

Jiri Slaby (1):
      ACPI: remove doubled status checking

Len Brown (1):
      Revert "ACPI: make some IO ports off-limits to AML"

Mathieu Chouquet-Stringer (1):
      thinkpad-acpi: fix module autoloading for older models

Roel Kluin (1):
      acpi-wmi: unsigned cannot be less than 0

Zhang Rui (1):
      ACPI suspend: Blacklist Toshiba Satellite L300 that requires to set SCI_EN directly on resume

with this log:

commit 1b958a3e5353c2995f3550a20010bdb403f33831
Merge: 27ce341 da51199
Author: Len Brown <len.brown@intel.com>
Date:   Mon Mar 16 00:38:52 2009 -0400

    Merge branches 'misc-up-now' and 'platform-drivers' into release

commit da511997d2bbc09f5e39385e0ed209578db07c91
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Wed Mar 4 11:55:30 2009 -0800

    acpi-wmi: unsigned cannot be less than 0
    
    include/linux/pci-acpi.h:74:
    
    typedef u32                 acpi_status;
    
    result is unsigned, so an error returned by acpi_bus_register_driver()
    will not be noticed.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b36a50f92d1c4300a88f606b4d2bbdc4f442a2d7
Author: Mathieu Chouquet-Stringer <mchouque@free.fr>
Date:   Sat Mar 14 16:35:26 2009 +0100

    thinkpad-acpi: fix module autoloading for older models
    
    Looking at the source, there seems to be a missing * to match my DMI
    string.  I mean for newer IBM and Lenovo's laptops you match either one
    of the following:
    MODULE_ALIAS("dmi:bvnIBM:*:svnIBM:*:pvrThinkPad*:rvnIBM:*");
    MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO:*:pvrThinkPad*:rvnLENOVO:*");
    
    While for older Thinkpads, you do this (for instance):
    IBM_BIOS_MODULE_ALIAS("1[0,3,6,8,A-G,I,K,M-P,S,T]");
    
    with IBM_BIOS_MODULE_ALIAS being MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW")
    
    Note there's no * terminating the string.  As result, udev doesn't load
    anything because modprobe cannot find anything matching this (my
    machine actually):
    
    udevtest: run: '/sbin/modprobe dmi:bvnIBM:bvr1IET71WW(2.10):bd06/16/2006:svnIBM:pn236621U:pvrNotAv
    
    Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 54b1ec893e869c815d390afa42aacf1499858112
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Feb 14 09:53:59 2009 +0000

    acer-wmi: Unmark as 'experimental'
    
    This driver has been around and used long enough that we can drop the
    'experimental'.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5fcdd177d063f1d8d569d746ab1bf206b0dfb2e8
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Feb 14 09:53:53 2009 +0000

    acpi-wmi: Unmark as 'experimental'
    
    ACPI-WMI isn't experimental anymore, and there are other drivers that now
    depend on it that aren't either.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 013d67fd4f0da8f6af60a376f1a254266ab658ef
Author: Dan Carpenter <error27@gmail.com>
Date:   Sat Feb 14 09:53:48 2009 +0000

    acer-wmi: double free in acer_rfkill_exit()
    
    This is acer_rfkill_exit() from drivers/platform/x86/acer-wmi.c.
    
    The code frees wireless_rfkill->data again instead of
    bluetooth_rfkill->data.
    
    This was found using a code checker (http://repo.or.cz/w/smatch.git/).
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d263da311ab403e3a84fa24920edc826147a550c
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Wed Feb 25 09:37:09 2009 +0100

    platform/x86: depends instead of select for laptop platform drivers
    
    "I hate `select' and will gleefully leap on any s/select/depends/ patch,
    whether it works or not :)"
      Andrew Morton
    
    select INPUT is not needed here, because if someone doesn't want INPUT,
    he won't want these drivers either.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e73e2c62f7646d54e30ef8863ac0be0b8e4ef0eb
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun Feb 15 19:30:21 2009 +0100

    asus-laptop: use select instead of depends on
    
    Like thinkpad_acpi or eeepc-laptop, asus-laptop will
    now use "select" instead of "depends on"
    for LEDS_CLASS, NEW_LEDS and BACKLIGHT_CLASS_DEVICE
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7950b71c3bd7b27b2874088a6c4efe3e13579f8b
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun Feb 15 19:30:20 2009 +0100

    eeepc-laptop: restore acpi_generate_proc_event()
    
    Restore acpi_generate_proc_event() for backward
    compatibility with old acpi scripts.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6050c8dd70b21a9d927983aeb6357fecffa7fb23
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun Feb 15 19:30:19 2009 +0100

    asus-laptop: restore acpi_generate_proc_event()
    
    Restore acpi_generate_proc_event() for backward
    compatibility with old acpi scripts.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 27ce34198345886854643b9572f9a06d2e7500d2
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Wed Mar 4 11:55:29 2009 -0800

    acpi: check for pxm_to_node_map overflow
    
    It is hardly (if ever) possible but in case of broken _PXM entry we could
    reach out of pxm_to_node_map array bounds in acpi_map_pxm_to_node() call.
    
    Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 176f9c1804df09f3e9b998c0642e212592ac6283
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Wed Mar 4 11:55:27 2009 -0800

    ACPI: remove doubled status checking
    
    There was a misplaced status test (two consequent tests without a
    statement in between) in acpi_bus_init for ages.  Remove it, since the
    function which should be checked (acpi_os_initialize1) has BUG_ONs on
    failure paths.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 45e7798886af101c4a908a896bbba5a84ee5cc32
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Sun Mar 15 22:13:44 2009 -0400

    ACPI suspend: Blacklist Toshiba Satellite L300 that requires to set SCI_EN directly on resume
    
    This is a supplement of commit 65df78473ffbf3bff5e2034df1638acc4f3ddd50.
    http://bugzilla.kernel.org/show_bug.cgi?id=12798
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7b46ecd5fcebf381a7bde966db352d8fb1b8e944
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 25 18:00:18 2009 -0500

    Revert "ACPI: make some IO ports off-limits to AML"
    
    This reverts commit 5ec5d38a1c8af255ffc481c81eef13e9155524b3.
    because it caused spurious dmesg warmings.
    We'll implement the check for off-limit ports
    in a more clever way in the future.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12758
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a140449584522c3eea1bb381f746d40939e6f62a
Author: Andy Whitcroft <apw@canonical.com>
Date:   Wed Feb 11 18:11:22 2009 +0000

    suspend: switch the Asus Pundit P1-AH2 to old ACPI sleep ordering
    
    Switch the Asus Pundit P1-AH2 (M2N8L motherboard) to the old ACPI 1.0
    sleep ordering by default.  Without this it will not suspend/resume
    correctly.
    
    Signed-off-by: Andy Whitcroft <apw@canonical.com>
    Tested-by: Dustin Kirkland <kirkland@canonical.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
