Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZBVDHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZBVDHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 22:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZBVDHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 22:07:22 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:34107 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZBVDHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 22:07:20 -0500
Date: Sat, 21 Feb 2009 22:07:01 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull] ACPI & PM patches for 2.6.29-rc5
Message-id: <alpine.LFD.2.00.0902212205330.5009@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.29/acpi-release-20081204-2.6.29-rc5.diff.gz

 arch/x86/kernel/acpi/wakeup_64.S      |   30 ++++++++++--------------------
 drivers/acpi/Kconfig                  |    7 -------
 drivers/acpi/Makefile                 |    2 +-
 drivers/acpi/battery.c                |   25 ++++++++++++++++++++++++-
 drivers/acpi/ec.c                     |    9 +++++++++
 drivers/platform/x86/fujitsu-laptop.c |   25 ++++++++++++++++++-------
 6 files changed, 62 insertions(+), 36 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPI: EC: Add delay for slow MSI controller

Bjorn Helgaas (1):
      ACPI: remove CONFIG_ACPI_SYSTEM

Jiri Slaby (2):
      x86_64: acpi/wakeup_64 cleanup
      x86_64: Fix S3 fail path

Richard Hughes (1):
      battery: don't assume we are fully charged when not charging or discharging

Tony Vroon (1):
      fujitsu-laptop: Use RFKILL support bitmask from firmware

with this log:

commit 5acfac5a6473b459ed38c0edf515be030f3b5874
Merge: 5423a0c 56f382a ba193d6 6defa2f
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 21 22:01:43 2009 -0500

    Merge branches 'release', 'bugzilla-12011', 'bugzilla-12632', 'misc' and 'suspend' into release

commit ba193d64abfe644e8752affa310a368eda01f46e
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Feb 19 12:56:16 2009 -0700

    ACPI: remove CONFIG_ACPI_SYSTEM
    
    Remove CONFIG_ACPI_SYSTEM.  It was always set the same as CONFIG_ACPI,
    and it had no menu label, so there was no way to set it to anything
    other than "y".
    
    Some things under CONFIG_ACPI_SYSTEM (acpi_irq_handled, acpi_os_gpe_count(),
    event_is_open, register_acpi_notifier(), etc.) are used unconditionally
    by the CA, the OSPM, and drivers, so we depend on them always being
    present.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4898c2b2f04051e19f4230683c0f0b15f71af887
Author: Tony Vroon <tony@linx.net>
Date:   Mon Feb 2 11:11:10 2009 +0000

    fujitsu-laptop: Use RFKILL support bitmask from firmware
    
    Up until now, we polled the rfkill status for every incoming FUJ02E3 ACPI event.
    It turns out that the firmware has a bitmask which indicates what rfkill-related
    state it can report.
    The rfkill_supported bitmask is now used to avoid polling for rfkill at all in
    the notification handler if there is no support. Also, it is used in the platform
    device callbacks. As before we register all callbacks and report "unknown" if the
    firmware does not give us status updates for that particular bit.
    
    This was fed through checkpatch.pl and tested on the S6420, S7020 and P8010
    platforms.
    
    Signed-off-by: Tony Vroon <tony@linx.net>
    Tested-by: Stephen Gildea <stepheng+linux@gildea.com>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6defa2fe2019f3729933516fba5cfd75eecd07de
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Sun Feb 15 22:46:45 2009 +0100

    x86_64: Fix S3 fail path
    
    As acpi_enter_sleep_state can fail, take this into account in
    do_suspend_lowlevel and don't return to the do_suspend_lowlevel's
    caller. This would break (currently) fpu status and preempt count.
    
    Technically, this means use `call' instead of `jmp' and `jmp' to
    the `resume_point' after the `call' (i.e. if
    acpi_enter_sleep_state returns=fails). `resume_point' will handle
    the restore of fpu and preempt count gracefully.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e6bd6760c92dc8475c79c4c4a8a16ac313c0b93d
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Sun Feb 15 22:45:49 2009 +0100

    x86_64: acpi/wakeup_64 cleanup
    
    - remove %ds re-set, it's already set in wakeup_long64
    - remove double labels and alignment (ENTRY already adds both)
    - use meaningful resume point labelname
    - skip alignment while jumping from wakeup_long64 to the resume point
    - remove .size, .type and unused labels
    [v2]
    - added ENDPROCs
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 56f382a08722186623400180adbb9d1be1721cee
Author: Richard Hughes <hughsient@gmail.com>
Date:   Sun Jan 25 15:05:50 2009 +0000

    battery: don't assume we are fully charged when not charging or discharging
    
    On hardware like the T61 it can take a couple of seconds for the battery
    to start charging after the power is connected, and we incorrectly tell
    userspace that we are fully charged, and then go back to charging.
    
    Only mark a battery as fully charged when the preset charge matches either
    the last full charge, or the design charge.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12632
    
    Signed-off-by: Richard Hughes <hughsient@gmail.com>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5423a0cb3f74c16e90683f8ee1cec6c240a9556e
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Feb 21 12:18:13 2009 -0500

    ACPI: EC: Add delay for slow MSI controller
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12011
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
