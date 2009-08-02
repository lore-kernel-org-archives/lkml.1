Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZHBRhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZHBRhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZHBRhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:37:41 -0400
Received: from s-utl02-sjpop.stsn.net ([72.254.0.202]:15513 "HELO
	s-utl02-sjpop.stsn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752740AbZHBRhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:37:40 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2009 13:37:40 EDT
Date: Sun, 2 Aug 2009 13:12:58 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@sony-vgn-z540
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI patches for 2.6.31-rc5
Message-ID: <alpine.LFD.2.00.0908021306270.3293@sony-vgn-z540>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463770880-836686589-1249233735=:3293"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770880-836686589-1249233735=:3293
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

The larger changes are simple, reverting a bad commit
and deleting some broken features.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.31/acpi-release-20090521-2.6.31-rc5.diff.gz

 Documentation/laptops/thinkpad-acpi.txt |  127 ----------
 drivers/acpi/acpi_memhotplug.c          |   34 ++-
 drivers/acpi/acpica/acobject.h          |    1 +
 drivers/acpi/acpica/dsopcode.c          |   24 ++
 drivers/acpi/acpica/exfldio.c           |    6 +
 drivers/acpi/osl.c                      |   25 ++
 drivers/acpi/system.c                   |    2 +-
 drivers/platform/x86/Kconfig            |   25 --
 drivers/platform/x86/eeepc-laptop.c     |    9 +-
 drivers/platform/x86/hp-wmi.c           |   12 +-
 drivers/platform/x86/thinkpad_acpi.c    |  390 ++++---------------------------
 include/acpi/acpiosxf.h                 |    4 +
 12 files changed, 148 insertions(+), 511 deletions(-)

through these commits:

Alan Jenkins (1):
      eeepc-laptop: fix hot-unplug on resume

Bjorn Helgaas (1):
      ACPI: bind workqueues to CPU 0 to avoid SMI corruption

Frans Pop (1):
      hp-wmi: check that an input device exists in resume handler

Henrique de Moraes Holschuh (3):
      thinkpad-acpi: disable broken bay and dock subdrivers
      thinkpad-acpi: remove dock and bay subdrivers
      thinkpad-acpi: fix incorrect use of TPACPI_BRGHT_MODE_ECNVRAM

Len Brown (2):
      Revert "ACPICA: Remove obsolete acpi_os_validate_address interface"
      ACPI: root-only read protection on /sys/firmware/acpi/tables/*

Michael Buesch (1):
      thinkpad-acpi: restrict procfs count value to sane upper limit

Zhao Yakui (2):
      ACPI: Don't treat generic error as ACPI error code in acpi memory hotplug driver
      ACPI: Ingore the memory block with zero block size in course of memory hotplug

with this log:

commit 3be4ee5199ba20475749d768bf29c8399c755a69
Merge: 95452a6 d0006f3
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 2 12:55:51 2009 -0400

    Merge branch 'misc-2.6.31' into release

commit 95452a6ce17244059e184fe5f722bff66a2b52bf
Merge: a571a79 7334546
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 2 12:36:01 2009 -0400

    Merge branch 'bugzilla-13825' into release

commit 7334546a52c6764df120459509b1f803a073eacc
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Mon Jun 29 09:40:07 2009 +0100

    eeepc-laptop: fix hot-unplug on resume
    
    OOPS on resume when the wireless adaptor is disabled during suspend was
    introduced by "eeepc-laptop: read rfkill soft-blocked state on resume".
    
    Unable to handle kernel NULL pointer dereference
    
    Process s2disk
    Tainted: G W
    IP: klist_put
    
    Call trace:
    ? klist_del
    ? device_del
    ? device_unregister
    ? pci_stop_dev
    ? pci_stop_bus
    ? pci_remove_device
    ? eeepc_rfkill_hotplug [eeepc_laptop]
    ? eeepc_hotk_resume [eeepc_laptop]
    ? acpi_device_resume
    ? device_resume
    ? hibernation_snapshot
    
    It appears the PCI device is removed twice.  The eeepc_rfkill_hotplug()
    call from the resume handler is racing against the call from the ACPI
    notifier callback.  The ACPI notification is triggered by the resume
    handler when it refreshes the value of CM_ASL_WLAN.
    
    The fix is to serialize hotplug calls using a workqueue.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13825
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Corentin Chary <corentin.chary@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a571a79a7e6b614f26d6bcc25b2ad48fd63fb829
Merge: 6a61487 5d2619f
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 2 12:27:26 2009 -0400

    Merge branch 'memhotplug-crash' into release

commit 5d2619fca753d270e63e76c9e18437b0d9bc8d75
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Jul 7 10:56:11 2009 +0800

    ACPI: Ingore the memory block with zero block size in course of memory hotplug
    
    If the memory block size is zero, ignore it and don't do the memory hotplug
    flowchart. Otherwise it will complain the following warning message:
      >System RAM resource 0 - ffffffffffffffff cannot be added
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aa7b2b2e973874df99a45b31adbed5978b46be1f
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Jul 3 10:49:03 2009 +0800

    ACPI: Don't treat generic error as ACPI error code in acpi memory hotplug driver
    
    Don't treat the generic error as ACPI error code. Otherwise when the generic
    code is returned, it will complain the following warning messag:
       >ACPI Exception (acpi_memhotplug-0171): UNKNOWN_STATUS_CODE,
    		Cannot get acpi bus device [20080609]
       >ACPI: Cannot find driver data
       > ACPI Error (utglobal-0127): Unknown exception code: 0xFFFFFFED [20080609]
       > Pid: 85, comm: kacpi_notify Not tainted 2.6.27.19-5-default #1
         Call Trace:
         [<ffffffff8020da29>] show_trace_log_lvl+0x41/0x58
         [<ffffffff8049a3da>] dump_stack+0x69/0x6f
        .....
    
    At the same time when the generic error code is returned, the ACPI_EXCEPTION
    is replaced by the printk.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6a61487791a8b8f85542c51132e8c7ed9bc7fd0b
Merge: f63440e 74b5820
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 2 12:10:02 2009 -0400

    Merge branch 'bugzilla-13751' into release

commit 74b5820808215f65b70b05a099d6d3c969b82689
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Jul 29 15:54:25 2009 -0600

    ACPI: bind workqueues to CPU 0 to avoid SMI corruption
    
    On some machines, a software-initiated SMI causes corruption unless the
    SMI runs on CPU 0.  An SMI can be initiated by any AML, but typically it's
    done in GPE-related methods that are run via workqueues, so we can avoid
    the known corruption cases by binding the workqueues to CPU 0.
    
    References:
        http://bugzilla.kernel.org/show_bug.cgi?id=13751
        https://bugs.launchpad.net/bugs/157171
        https://bugs.launchpad.net/bugs/157691
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f63440eff06265fc56e73044f8727b12641b33f1
Merge: 437f8c8 59fe4fe
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 2 11:34:24 2009 -0400

    Merge branch 'thinkpad' into release

commit 437f8c8ab99e7b6eed8e0d6d9cf46085c8de2e36
Merge: b8a848e daed953
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 2 11:33:01 2009 -0400

    Merge branch 'bugzilla-13865' into release

commit b8a848ed7ffda36ed069f63de085a9411d2aa39f
Merge: ed680c4 7cb7f45
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 2 11:31:32 2009 -0400

    Merge branch 'bugzilla-13620-revert' into release

commit d0006f3281c920fbfead0f5035c62ec8053f980a
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 30 16:00:53 2009 -0400

    ACPI: root-only read protection on /sys/firmware/acpi/tables/*
    
    they were world readable.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 59fe4fe34d7afdf63208124f313be9056feaa2f4
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Aug 1 12:04:20 2009 -0300

    thinkpad-acpi: fix incorrect use of TPACPI_BRGHT_MODE_ECNVRAM
    
    HBRV-based default selection of backlight control strategy didn't work
    well, at least the X41 defines it but doesn't use it and I don't think
    it will stop there.
    
    Switch to a white/blacklist.  All models that have HBRV defined have
    been included in the list, and initially all ATI GPUs will get
    ECNVRAM, and the Intel GPUs will get UCMS_STEP.
    
    Symptoms of incorrect backlight mode selection are:
    
    1. Non-working backlight control through sysfs;
    
    2. Backlight gets reset to the lowest level at every shutdown, reboot
       and when thinkpad-acpi gets unloaded;
    
    This fixes a regression in 2.6.30, bugzilla #13826
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Reported-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
    Cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b05d4696d38c3172e79e855cc1e2ed044589508
Author: Michael Buesch <mb@bu3sch.de>
Date:   Sat Aug 1 12:04:19 2009 -0300

    thinkpad-acpi: restrict procfs count value to sane upper limit
    
    Signed-off-by: Michael Buesch <mb@bu3sch.de>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1f6fc2de9525e34ee93bd392fa046369a8cfbf1e
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Aug 1 12:04:18 2009 -0300

    thinkpad-acpi: remove dock and bay subdrivers
    
    The standard ACPI dock driver can handle the hotplug bays and docks of
    the ThinkPads just fine (including batteries) as of 2.6.27, and the
    code in thinkpad-acpi for the dock and bay subdrivers is currently
    broken anyway...
    
    Userspace needs some love to support the two-stage ejection nicely,
    but it is simple enough to do through udev rules (you don't even need
    HAL) so this wouldn't justify fixing the dock and bay subdrivers,
    either.
    
    That leaves warm-swap bays (_EJ3) support for thinkpad-acpi, as well
    as support for the weird dock of the model 570, but since such support
    has never left the "experimental" stage, it is also not a strong
    enough reason to find a way to fix this code.
    
    Users of ThinkPads with warm-swap bays are urged to request that _EJ3
    support be added to the regular ACPI dock driver, if such feature is
    indeed useful for them.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 550e7fd8afb7664ae7cedb398c407694e2bf7d3c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Aug 1 12:04:17 2009 -0300

    thinkpad-acpi: disable broken bay and dock subdrivers
    
    Currently, the ThinkPad-ACPI bay and dock drivers are completely
    broken, and cause a NULL pointer derreference in kernel mode (and,
    therefore, an OOPS) when they try to issue events (i.e. on dock,
    undock, bay ejection, etc).
    
    OTOH, the standard ACPI dock driver can handle the hotplug bays and
    docks of the ThinkPads just fine (including batteries) as of 2.6.27.
    In fact, it does a much better job of it than thinkpad-acpi ever did.
    
    It is just not worth the hassle to find a way to fix this crap without
    breaking the (deprecated) thinkpad-acpi dock/bay ABI.  This is old,
    deprecated code that sees little testing or use.
    
    As a quick fix suitable for -stable backports, mark the thinkpad-acpi
    bay and dock subdrivers as BROKEN in Kconfig.  The dead code will be
    removed by a later patch.
    
    This fixes bugzilla #13669, and should be applied to 2.6.27 and later.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Reported-by: Joerg Platte <jplatte@naasa.net>
    Cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit daed953721850381673687c59f3a0df553eb6626
Author: Frans Pop <elendil@planet.nl>
Date:   Thu Jul 30 17:16:05 2009 -0400

    hp-wmi: check that an input device exists in resume handler
    
    Some systems may not support input events, or registering the input
    handler may have failed. So check that an input device exists before
    trying to set the docking and tablet mode state during resume.
    
    Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=13865
    
    Reported-and-tested-by: Cédric Godin <cedric@belbone.be>
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7cb7f45c7feef43c8f71f5cfedfc0b19be2142f7
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jul 27 18:42:38 2009 -0400

    Revert "ACPICA: Remove obsolete acpi_os_validate_address interface"
    
pp    This reverts commit f9ca058430333c9a24c5ca926aa445125f88df18.
    
    which caused a regression:
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13620
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
---1463770880-836686589-1249233735=:3293--

