Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZI0Iig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZI0Iig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZI0Iif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:38:35 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:39532 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZI0Iid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:38:33 -0400
Date: Sun, 27 Sep 2009 04:38:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI patches for 2.6.32-rc0 - part 3
Message-id: <alpine.LFD.2.00.0909270433090.16783@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This is a .31 regression fix, two build fixes, plus some dmesg tweaks --
updating the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.31/acpi-release-20090903-2.6.31.diff.gz

 arch/ia64/include/asm/acpi.h         |    2 ++
 arch/x86/kernel/acpi/cstate.c        |    2 +-
 drivers/acpi/osl.c                   |    8 +++++++-
 drivers/acpi/processor_idle.c        |    7 -------
 drivers/platform/x86/thinkpad_acpi.c |    2 ++
 5 files changed, 12 insertions(+), 9 deletions(-)

through these commits:

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: fix CONFIG_THINKPAD_ACPI_HOTKEY_POLL build problem

Jean Delvare (1):
      ACPI: Clarify resource conflict message

Len Brown (1):
      ACPI: IA64=y ACPI=n build fix

Roland Dreier (1):
      ACPI: Kill overly verbose "power state" log messages

Zhao Yakui (1):
      ACPI: fix Compaq Evo N800c (Pentium 4m) boot hang regression

with this log:

commit e56d953d190061938b31cabbe01b7f3d76c60bd0
Author: Len Brown <len.brown@intel.com>
Date:   Sun Sep 27 04:17:21 2009 -0400

    ACPI: IA64=y ACPI=n build fix
    
    ia64's sim_defconfig uses CONFIG_ACPI=n
    which now #define's acpi_disabled in <linux/acpi.h>
    
    So we shouldn't re-define it here in <asm/acpi.h>
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3d5b6fb47a8e68fa311ca2c3447e7f8a7c3a9cf3
Author: Roland Dreier <rdreier@cisco.com>
Date:   Thu Sep 24 14:52:36 2009 -0700

    ACPI: Kill overly verbose "power state" log messages
    
    I was recently lucky enough to get a 64-CPU system, so my kernel log
    ends up with 64 lines like:
    
        ACPI: CPU0 (power states: C1[C1] C2[C3])
    
    This is pretty useless clutter because this info is already available
    after boot from both /sys/devices/system/cpu/cpu*/cpuidle/state?/ as
    well as /proc/acpi/processor/CPU*/power.
    
    So just delete the code that prints the C-states in processor_idle.c.
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e2ada5867b7e9fa0b296d30fa8f3726ebd0a8b7
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Sun Sep 27 03:30:51 2009 -0400

    ACPI: fix Compaq Evo N800c (Pentium 4m) boot hang regression
    
    Don't disable ARB_DISABLE when the familary ID is 0x0F.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14211
    
    This was a 2.6.31 regression, and so this patch
    needs to be applied to 2.6.31.stable
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 14f03343ad1080c2fea29ab2c13f05b976c4584e
Author: Jean Delvare <jdelvare@suse.de>
Date:   Tue Sep 8 15:31:46 2009 +0200

    ACPI: Clarify resource conflict message
    
    The message "ACPI: Device needs an ACPI driver" is misleading. The
    device _may_ need an ACPI driver, if the BIOS implemented a custom
    API for the device in question (which, AFAIK, can't be checked.) If
    not, then either a generic ACPI driver may be used (for example
    "thermal"), or nothing can be done (other than a white list).
    
    I propose to reword the message to:
    
    ACPI: If an ACPI driver is available for this device, you should use
    it instead of the native driver
    
    which I think is more correct. Comments and suggestions welcome.
    
    I also added a message warning about possible problems and system
    instability when users pass acpi_enforce_resources=lax, as suggested
    by Len.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Cc: Thomas Renninger <trenn@suse.de>
    Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b684a3637e0887683a0a3d6fd471fc41d7c1606a
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Sep 26 21:42:49 2009 -0300

    thinkpad-acpi: fix CONFIG_THINKPAD_ACPI_HOTKEY_POLL build problem
    
    Fix this problem when CONFIG_THINKPAD_ACPI_HOTKEY_POLL is undefined:
    
      CHECK   drivers/platform/x86/thinkpad_acpi.c
    drivers/platform/x86/thinkpad_acpi.c:1968:21: error: not an lvalue
      CC [M]  drivers/platform/x86/thinkpad_acpi.o
    drivers/platform/x86/thinkpad_acpi.c: In function 'tpacpi_hotkey_driver_mask_set':
    drivers/platform/x86/thinkpad_acpi.c:1968: error: lvalue required as left operand of assignment
    
    Reported-by: Noah Dain <noahdain@gmail.com>
    Reported-by: Audrius Kazukauskas <audrius@neutrino.lt>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

