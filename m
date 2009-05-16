Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZEPGJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZEPGJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 02:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZEPGJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 02:09:33 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:24263 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZEPGJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 02:09:31 -0400
Date: Sat, 16 May 2009 02:09:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI & driver fixes for 2.6.30-rc5
Message-id: <alpine.LFD.2.00.0905160203340.4571@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Mostly regression fixes, plus a few isolated bug fixes
that seemed appropriate to send upstream now
instead of waiting for 2.6.31.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.30/acpi-release-20090422-2.6.30-rc5.diff.gz

 drivers/acpi/acpica/Makefile        |   27 +++++++++++---------
 drivers/acpi/acpica/aclocal.h       |    7 ++++-
 drivers/acpi/bus.c                  |    2 +-
 drivers/acpi/processor_idle.c       |   42 ++++++++++++++++++++++++------
 drivers/acpi/processor_throttling.c |   25 ++++++++++++++++++
 drivers/acpi/video.c                |   38 ++++++++++++++++++++++++++++
 drivers/gpu/drm/Kconfig             |    6 ++++
 drivers/platform/x86/asus-laptop.c  |    6 ++--
 drivers/platform/x86/eeepc-laptop.c |   47 +++++++++++++++++++++++++++++-----
 drivers/pnp/pnpacpi/core.c          |    8 ++---
 drivers/thermal/thermal_sys.c       |    8 +++---
 11 files changed, 174 insertions(+), 42 deletions(-)

through these commits:

Alan Jenkins (2):
      eeepc-laptop: fix wlan rfkill state change during init
      eeepc-laptop: Work around rfkill firmware bug

Corentin Chary (2):
      asus-laptop: fix input keycode
      eeepc-laptop: unregister_rfkill_notifier on failure

Darren Salt (1):
      eeepc-laptop: report brightness control events via the input layer

Grigori Goronzy (1):
      eeepc-laptop: support for super hybrid engine (SHE)

Len Brown (8):
      ACPICA: use acpi.* modparam namespace
      ACPI: video: DMI workaround another broken Acer BIOS enabling display brightness
      ACPI: power: update error message
      ACPI: suspend: don't let device _PS3 failure prevent suspend
      ACPI: suspend: restore BM_RLD on resume
      ACPI, i915: build fix
      ACPI: idle: fix init-time TSC check regression
      ACPI: Idle C-states disabled by max_cstate should not disable the TSC

Lin Ming (1):
      ACPI: resume: re-enable SCI-enable workaround

Vladimir Zajac (1):
      thermal: fix off-by-1 error in trip point trigger condition

Zhang Rui (3):
      ACPI video: dmi check for broken _BQC on Acer Aspire 5720
      ACPI processor: introduce module parameter processor.ignore_tpc
      ACPI processor: reset the throttling state once it's invalid

with this log:

commit 4e3507f7189111b0cb66c30def3423c6aba8f85a
Merge: 7c7327d 815ab0f 5199176 5afc4ab ecb4aed 19bde77 4973b22 975b3c4 2932135 a0bf284 bd32005
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 16 01:55:59 2009 -0400

    Merge branches 'release', 'bugzilla-13032', 'bugzilla-13041+', 'bugzilla-13121', 'bugzilla-13165', 'bugzilla-13243', 'bugzilla-13259', 'resume-sci-en-regression', 'thermal-regression', 'tsc-regression' and 'asus-2.6.30' into release

commit a0bf284bfedd6dc95bbee7ebf5ccf3b5f753a008
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 15 01:29:31 2009 -0400

    ACPI: Idle C-states disabled by max_cstate should not disable the TSC
    
    Processor idle power states C2 and C3 stop the TSC on many machines.
    Linux recognizes this situation and marks the TSC as unstable:
    
    Marking TSC unstable due to TSC halts in idle
    
    But if those same machines are booted with "processor.max_cstate=1",
    then there is no need to validate C2 and C3, and no need to
    disable the TSC, which can be reliably used as a clocksource.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>

commit 520daf7217bc1806c02eb4cfa7805447a3da2f66
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 14 17:27:38 2009 -0400

    ACPI: idle: fix init-time TSC check regression
    
    A previous 2.6.30 patch, a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2,
    (ACPI: idle: mark_tsc_unstable() at init-time, not run-time)
    erroneously disabled the TSC on systems that did not actually
    have valid deep C-states.
    
    Move the check after the deep-C-states are validated,
    via new helper, tsc_check_state(), hich replaces tsc_halts_in_c().
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>
    Tested-by: Frans Pop <elendil@planet.nl>

commit 4973b22aa8c70fe036e3e0039f104cf5bb7fe2b1
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon May 11 09:36:01 2009 +0800

    ACPI processor: reset the throttling state once it's invalid
    
    If the BIOS hands us an invalid throttling state,
    write a valid state.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13259
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Tested-by: James Ettle <theholyettlz@googlemail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 56c213fa012f2bad9eff908292ff2500f840b020
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon May 11 09:35:57 2009 +0800

    ACPI processor: introduce module parameter processor.ignore_tpc
    
    Introduce module parameter processor.ignore_tpc.
    
    Some laptops are shipped with buggy _TPC,
    this module parameter is used to to disable the buggy support.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13259
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Tested-by: James Ettle <theholyettlz@googlemail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ecb4aed78dcf09e48c8c34c8c2fa7f5c69344be6
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 11:33:47 2009 -0400

    ACPI, i915: build fix
    
    drivers/built-in.o: In function `intel_opregion_init':
    (.text+0x9d540): undefined reference to `acpi_video_register'
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13165
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 815ab0fd40579ad2aa42058298073503648762b9
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 7 22:19:45 2009 -0400

    ACPI: suspend: restore BM_RLD on resume
    
    In 2.6.29,
    31878dd86b7df9a147f5e6cc6e07092b4308782b
    "ACPI: remove BM_RLD access from idle entry path"
    moved BM_RLD initialization to init-time from run time.
    
    But we discovered that some BIOS do not restore BM_RLD
    after suspend, causing device errors on C3 and C4
    after resume.  So now the kernel restores BM_RLD.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13032
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 975b3c474c13d29337eaf7da8f5f5c0299e4943f
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri May 15 22:27:49 2009 -0400

    ACPI: resume: re-enable SCI-enable workaround
    
    The BIOS bug workaround mistakenly got disabled
    when we followed the ACPI specification more closely
    by ignoring OS updates to that bit.
    
    (The BIOS is supposed to update SCI_EN, not the OS)
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13289
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 29321357ac6db54eeb8574da1f6c3e0ce8cfbb60
Author: Vladimir Zajac <eightgraph@gmail.com>
Date:   Wed May 6 19:34:21 2009 +0200

    thermal: fix off-by-1 error in trip point trigger condition
    
    This patch fixes a regression caused by commit
    b1569e99c795bf83b4ddf41c4f1c42761ab7f75e
    "ACPI: move thermal trip handling to generic thermal layer"
    which accidentally changed trip point trigger condition to
      temp > trip_temp
    
    This patch changes the trigger condition back to
      temp >= trip_temp
    
    Signed-off-by: Vladimir Zajac <eightgraph@gmail.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bd32005e126a465deda5d046a62f6bb842f4d9cf
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Mon Apr 27 09:23:43 2009 +0200

    eeepc-laptop: unregister_rfkill_notifier on failure
    
    If there is a failure during eeepc_hotk_add() we need
    to remove the acpi_notify_handler.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 309f5fbda37d5e8f1233e8b80b8e9de77262e864
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Mon Apr 27 09:23:42 2009 +0200

    asus-laptop: fix input keycode
    
    KEY_STOP is now KEY_STOPCD
     It's the correct key to stop a media
    BTN_EXTRA is now KEY_SCREENLOCK:
     The laptop manual tells us that this key is for screenlock
    KEY_TV is now KEY_PROG1
     So it can be reported to X server
    
    Ref: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/361505
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 158ca1d75dd0d6223f3b1dd741d30777da62ab80
Author: Grigori Goronzy <greg@chown.ath.cx>
Date:   Mon Apr 27 09:23:40 2009 +0200

    eeepc-laptop: support for super hybrid engine (SHE)
    
    The older eeepc-acpi driver allowed to control the SHE performance
    preset through a ACPI function for just this purpose. SHE underclocks
    and undervolts the FSB and undervolts the CPU (at preset 2,
    "powersave"), or slightly overclocks the CPU (at preset 0,
    "performance"). Preset 1 is the default setting with default clocks and
    voltage.
    
    The new eeepc-laptop driver doesn't support it anymore.
    The attached patch adds support for it to eeepc-laptop. It's very
    straight-forward and almost trivial.
    
    Signed-off-by: Grigori Goronzy <greg@chown.ath.cx>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 978605c4fd8e7470f225eec7b5aab69d8796afcc
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Mon Apr 27 09:23:39 2009 +0200

    eeepc-laptop: Work around rfkill firmware bug
    
    1) Buggy firmware can change the RFKILL state by itself. This is easily
       detected.  The RFKILL API states that in such cases, we should call
       rfkill_force_state() to notify the core.
    
       I have reported the bug to Asus. I believe this is the right thing
       to do for robustness, even if this particular firmware bug is fixed.
    
    2) The same bug causes the wireless toggle key to be reported as 0x11
       instead of 0x10.  0x11 is otherwise unused, so it should be safe to
       add this as a new keycode.
    
    The bug is triggered by removing the laptop battery while hibernated.
    
    On resume, the wireless toggle key causes the firmware to toggle the
    wireless state itself.  (Also, the key is reported as 0x11 when the
    current wireless state is OFF).
    
    This is very poor behaviour because the OS can't predict whether the
    firmware is controlling the RFKILL state.
    
    Without this workaround, the bug means users have to press the wireless
    toggle key twice to enable, due to the OS/firmware conflict.  (Assuming
    rfkill-input or equivalent is being used).  The workaround avoids this.
    
    I believe that acpid scripts which toggle the value of the sysfs state file
    when the toggle key is pressed will be rendered ineffective by the bug,
    regardless of this workaround.  If they simply toggle the state, when the
    firmware has already toggled it, then you will never see a state change.
    
    Tested on "EEEPC 4G" only.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 64b86b6583db832b28bb54575e32b9e2a1a7d84f
Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date:   Mon Apr 27 09:23:38 2009 +0200

    eeepc-laptop: report brightness control events via the input layer
    
    This maps the brightness control events to one of two keys, either
    KEY_BRIGHTNESSDOWN or KEY_BRIGHTNESSUP, as needed.
    
    Some mapping has to be done due to the fact that the BIOS reports them as
    <base value> + <current brightness index>; the selection is done according to
    the sign of the change in brightness (if this is 0, no keypress is reported).
    
    (Ref. http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-April/002001.html)
    
    Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fbc97e4c5c31ea198f912196b1379d7493362800
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Mon Apr 27 09:23:37 2009 +0200

    eeepc-laptop: fix wlan rfkill state change during init
    
    When an rfkill device is registered, the rfkill core will change its
    state to the system default. So we need to prepare for state changes
    *before* we register it. That means installing the eeepc-specific ACPI
    callback which handles the hotplug of the wireless network adaptor.
    
    This problem doesn't occur during normal operation.  You have to
    
    1) Boot with wireless enabled. eeepc-laptop should load automatically.
    2) modprobe -r eeepc-laptop
    3) modprobe eeepc-laptop
    
    On boot, the default rfkill state will be set to enabled.
    With the current core code, step 2) will disable the wireless.
    Therefore in step 3), the wireless will change state during registration,
    from disabled to enabled.  But without this fix, the PCI device for the
    wireless adaptor will not appear.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 19bde778c1fd2574cc020a618d7d576f260271ca
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 8 00:22:29 2009 -0400

    ACPI: suspend: don't let device _PS3 failure prevent suspend
    
    6328a57401dc5f5cf9931738eb7268fcd8058c49
    "Enable PNPACPI _PSx Support, v3"
    
    added a call to acpi_bus_set_power(handle, ACPI_STATE_D3)
    to pnpacpi_disable_resource() before the existing call
    to evaluate _DIS on the device.
    
    This caused suspend to fail on the system in
    http://bugzilla.kernel.org/show_bug.cgi?id=13243
    because the sanity check to verify we entered _PS3
    failed on the serial port.
    
    As a work-around, that sanity check can be disabled
    system-wide with "acpi.power_nocheck=1"
    
    Or perhaps we should just shrug off the _PS3 failure
    and carry on with _DIS like we used to -- which is
    what this patch does.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ddc50b6ad634d9ce2526a777d4b7da80effdfb60
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 8 00:07:30 2009 -0400

    ACPI: power: update error message
    
    "Transitioning device [%s] to D%d" is not correct.
    We print this line when we attempted to transition
    the device, and it failed.
    
    So instead, print
    "Device [%s] failed to transition to D%d\n"
    
    This can happen under two conditions:
    
    1. acpi_power_transition() fails when trying to handle the
       _ON/_OFF for associated power resource.
    
    2. acpi_evaluate_object() on the explicit _PS0/_PS3
       for that actual device could fail.
    
    this change clarifies, but doesn't fix
    http://bugzilla.kernel.org/show_bug.cgi?id=13243
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5afc4abe7902b8453c248321daa9b13b12d9c838
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 7 21:11:56 2009 -0400

    ACPI: video: DMI workaround another broken Acer BIOS enabling display brightness
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13121
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 51991763416251f259efbfe459c16f331f31d01f
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 7 15:24:31 2009 -0400

    ACPICA: use acpi.* modparam namespace
    
    Add acpi/acpica/*.c to the acpi.* modparam namespace
    so that any modparams we stick into ACPICA do not
    expose ACPICA filenames to users.
    
    There are currently only two modparams in ACPICA,
    just recently added for
    http://bugzilla.kernel.org/show_bug.cgi?id=13041
    
    With this change, they become
    
    acpi.gts=1
    acpi.bfs=1
    
    rather than
    
    hwsleep.gts=1
    hwsleep.bfs=1
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 45cb50e646d1560eff01c5ad0f0df3c7fd6148dd
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Apr 24 12:13:18 2009 -0400

    ACPI video: dmi check for broken _BQC on Acer Aspire 5720
    
    On Acer Aspire 5720, _BQC always returns a value 9 smaller than
    the actual brightness level.  Add dmi quirk for this laptop.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13121
    
    Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
