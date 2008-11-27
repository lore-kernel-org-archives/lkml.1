Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYK0HhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYK0HhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 02:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYK0Hgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 02:36:54 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:54148 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYK0Hgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 02:36:53 -0500
Date: Thu, 27 Nov 2008 02:36:49 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: [GIT PULL] ACPI patches for Linux-2.6.28-rc6
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Message-id: <alpine.LFD.2.00.0811270232310.3895@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

8 regression fixes, a bugfix, and some dmesg and DMI reduction.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.28/acpi-release-20080926-2.6.28-rc6.diff.gz

 drivers/acpi/battery.c       |    9 +
 drivers/acpi/blacklist.c     |  401 +-----------------------------------------
 drivers/acpi/ec.c            |    3 +-
 drivers/acpi/osl.c           |  104 +++--------
 drivers/acpi/scan.c          |   10 -
 drivers/acpi/sleep/main.c    |   40 ++++-
 drivers/acpi/utils.c         |   16 +--
 drivers/misc/sony-laptop.c   |    4 +-
 drivers/misc/thinkpad_acpi.c |   57 +++++--
 include/acpi/acpredef.h      |    4 +-
 10 files changed, 133 insertions(+), 515 deletions(-)

through these commits:

Alessandro Guido (2):
      sony-laptop: brightness regression fix
      sony-laptop: printk tweak

Alexey Starikovskiy (2):
      ACPI: EC: count interrupts only if called from interrupt handler.
      ACPI: battery: Convert discharge energy rate to current properly

Bob Moore (1):
      ACPICA: Allow _WAK method to return an Integer

Henrique de Moraes Holschuh (1):
      ACPI: thinkpad-acpi: fix fan sleep/resume path

Len Brown (2):
      Revert "ACPI: don't enable control method power button as wakeup device when Fixed Power button is used"
      ACPI: delete OSI(Linux) DMI dmesg spam

Lin Ming (1):
      ACPICA: disable _BIF warning

Pavel Machek (1):
      ACPI: scheduling in atomic via acpi_evaluate_integer ()

Rafael J. Wysocki (1):
      ACPI suspend: Blacklist boxes that require us to set SCI_EN directly on resume

with this log:

commit e899b6485c332aa2d7510739507ab5e5d7b28e59
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Nov 27 14:42:30 2008 +0800

    ACPICA: disable _BIF warning
    
    A generic work-around from ACPICA is in the queue,
    but since Linux has a work-around in its battery
    driver, we can disable this warning now.
    
    Allow _BIF method to return an Package with Buffer elements
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11822
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a6e0887f21bbab337ee32d9c0a84d7c0b6e9141b
Author: Len Brown <len.brown@intel.com>
Date:   Sat Nov 8 01:21:10 2008 -0500

    ACPI: delete OSI(Linux) DMI dmesg spam
    
    Linux will continue to ignore OSI(Linux),
    except for a white-list containing a few systems.
    
    So delete the black-list,
    and stop soliciting user-feedback on the console.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95a28ed08619cc70f31611886ac7b26ab0e462dc
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 13 11:01:34 2008 +0800

    ACPICA: Allow _WAK method to return an Integer
    
    This can happen if the _WAK method returns nothing (as per ACPI
    1.0) but does return an integer if the implicit return mechanism
    is enabled.  This is the only method that has this problem,
    since it is also defined to return a package of two integers
    (ACPI 1.0b+). In all other cases, if a method returns an object
    when one was not expected, no warning is issued.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0081b162023690877e0096ef17a82ba1969befa8
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Nov 9 10:54:02 2008 -0200

    ACPI: thinkpad-acpi: fix fan sleep/resume path
    
    This fixes a regression from v2.6.27, caused by commit
    5814f737e1cd2cfa2893badd62189acae3e1e1fd, "ACPI: thinkpad-acpi:
    attempt to preserve fan state on resume".
    
    It is possible for fan_suspend() to fail to properly initialize
    fan_control_desired_level as required by fan_resume(), resulting on
    the fan always being set to level 7 on resume if the user didn't
    touch the fan controller.
    
    In order to get fan sleep/resume handling to work right:
    
    1. Fix the fan_suspend handling of the T43 firmware quirk. If it is
    still undefined, we didn't touch the fan yet and that means we have no
    business doing it on resume.
    
    2. Store the fan level on its own variable to avoid any possible
    issues with hijacking fan_control_desired_level (which isn't supposed
    to have anything other than 0-7 in it, anyway).
    
    3. Change the fan_resume code to me more straightforward to understand
    (although we DO optimize the boolean logic there, otherwise it looks
    disgusting).
    
    4. Add comments to help understand what the code is supposed to be
    doing.
    
    5. Change fan_set_level to be less strict about how auto and
    full-speed modes are requested.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11982
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Reported-by: Tino Keitel <tino.keitel@tikei.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3fedd90fdf17643df1da473c5da983137d51bbdb
Author: Alessandro Guido <ag@alessandroguido.name>
Date:   Wed Nov 12 23:13:35 2008 +0100

    sony-laptop: printk tweak
    
    There's no need to print "Sony: " just after "sony-laptop: " (DRV_PFX).
    
    Signed-off-by: Alessandro Guido <ag@alessandroguido.name>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 38cfc148e1bc470175b3ad131db7dd7bdcff37ee
Author: Alessandro Guido <ag@alessandroguido.name>
Date:   Wed Nov 12 23:03:28 2008 +0100

    sony-laptop: brightness regression fix
    
    After commit 540b8bb9c33935183ceb5bed466a42ad72b2af56:
    
      sony-laptop: fingers off backlight if video.ko is serving this functionality
    
    I can't set brightness on my sony laptop (nothing in /sys/class/backlight).
    dmesg says "sony-laptop: Sony: Brightness ignored, must be controlled by ACPI
    video driver".
    
    The function acpi_video_backlight_support returns 0 if we should use the
    vendor-specific backlight support, while non-0 if the ACPI generic should
    be used. Because of this, the check introduced by the said commit appears
    reversed.
    
    Signed-off-by: Alessandro Guido <ag@alessandroguido.name>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3bdca1b863c1ebcb2244fc0cb683876d7330e62b
Author: Len Brown <len.brown@intel.com>
Date:   Wed Nov 26 17:55:15 2008 -0500

    Revert "ACPI: don't enable control method power button as wakeup device when Fixed Power button is used"
    
    This reverts commit faee816b1502385dc9bc5abf2960d1cc645844d1.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12091
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 65df78473ffbf3bff5e2034df1638acc4f3ddd50
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Nov 26 17:53:13 2008 -0500

    ACPI suspend: Blacklist boxes that require us to set SCI_EN directly on resume
    
    Some Apple boxes evidently require us to set SCI_EN on resume
    directly, because if we don't do that, they hung somewhere in the
    resume code path.  Moreover, on these boxes it is not sufficient to
    use acpi_enable() to turn ACPI on during resume.  All of this is
    against the ACPI specification which states that (1) the BIOS is
    supposed to return from the S3 sleep state with ACPI enabled
    (SCI_EN set) and (2) the SCI_EN bit is owned by the hardware and we
    are not supposed to change it.
    
    For this reason, blacklist the affected systems so that the SCI_EN
    bit is set during resume on them.
    
    [NOTE: Unconditional setting SCI_EN for all system on resume doesn't
     work, because it makes some other systems crash (that's to be
     expected).  Also, it is not entirely clear right now if all of the
     Apple boxes require this workaround.]
    
    This patch fixes the recent regression tracked as
    http://bugzilla.kernel.org/show_bug.cgi?id=12038
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Tested-by: Tino Keitel <tino.keitel@gmx.de>
    Tested-by: Bob Copeland <me@bobcopeland.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 40599072dca3ec7d4c9ff8271978be169f974638
Author: Pavel Machek <pavel@suse.cz>
Date:   Tue Nov 25 12:05:08 2008 +0100

    ACPI: scheduling in atomic via acpi_evaluate_integer ()
    
    Now I know why I had strange "scheduling in atomic" problems:
    acpi_evaluate_integer() does malloc(..., irqs_disabled() ? GFP_ATOMIC
    : GFP_KERNEL)... which is (of course) broken.
    
    There's no way to reliably tell if we need GFP_ATOMIC or not from
    code, this one for example fails to detect spinlocks held.
    
    Fortunately, allocation seems small enough to be done on stack.
    
    Signed-off-by: Pavel Machek <pavel@suse.cz>
    Acked-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 558073dd56707864f09d563b64e7c37c021e89d2
Author: Alexey Starikovskiy <aystarik@gmail.com>
Date:   Fri Nov 21 22:41:01 2008 +0800

    ACPI: battery: Convert discharge energy rate to current properly
    
    ACPI battery interface reports its state either in mW or in mA, and
    discharge rate in your case is reported in mW. power_supply interface
    does not have such a parameter, so current_now parameter is used
    for all cases. But in case of mW, reported discharge should
    be converted into mA.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Tested-by: Ferenc Wagner <wferi@niif.hu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7b4d469228a92a00e412675817cedd60133de38a
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Nov 13 12:00:03 2008 +0300

    ACPI: EC: count interrupts only if called from interrupt handler.
    
    fix 2.6.28 EC interrupt storm regression
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
