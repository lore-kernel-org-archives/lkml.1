Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbXIQFG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbXIQFG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 01:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXIQFGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 01:06:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:60281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbXIQFGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 01:06:50 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.23-rc6
Date: Mon, 17 Sep 2007 01:06:28 -0400
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709170106.28235.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Before 2.6.23, please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

A build fix, a kconfig fix, a typo and a revert for the thinkpad folks.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.23/acpi-release-20070126-2.6.23-rc6.diff.gz

 Documentation/thinkpad-acpi.txt |   96 ++++++++++++++----
 drivers/acpi/event.c            |    2 
 drivers/acpi/sleep/proc.c       |   10 -
 drivers/misc/Kconfig            |   20 ---
 drivers/misc/msi-laptop.c       |    2 
 drivers/misc/thinkpad_acpi.c    |  144 ++++++++++++++++------------
 drivers/misc/thinkpad_acpi.h    |    1 
 7 files changed, 172 insertions(+), 103 deletions(-)

through these commits:

Christian Borntraeger (1):
      ACPI: (more) delete CONFIG_ACPI_PROCFS_SLEEP (again)

Henrique de Moraes Holschuh (3):
      ACPI: fix CONFIG_NET=n acpi_bus_generate_netlink_event build failure
      ACPI: thinkpad-acpi: revert new 2.6.23 CONFIG_THINKPAD_ACPI_INPUT_ENABLED option
      ACPI: thinkpad-acpi: bump up version to 0.16

Jonathan Woithe (1):
      msi-laptop: replace ',' with ';'

with this log:

commit ecfe7f093768f7af0959f5be8ec039dcc29724af
Merge: 95e3f66... 3b0c648...
Author: Len Brown <len.brown@intel.com>
Date:   Mon Sep 17 00:58:40 2007 -0400

    Pull thinkpad into release branch

commit 3b0c6485a733f5f0f5c362fb094df1466b18ab93
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Sep 4 11:13:16 2007 -0300

    ACPI: thinkpad-acpi: bump up version to 0.16
    
    Name it thinkpad-acpi version 0.16 to avoid any confusion with some 0.15
    thinkpad-acpi development snapshots and backports that had input layer
    support, but no hotkey_report_mode support.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff80f1370f2eff7dd7a828cf2416bf7be697247e
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Sep 4 11:13:15 2007 -0300

    ACPI: thinkpad-acpi: revert new 2.6.23 CONFIG_THINKPAD_ACPI_INPUT_ENABLED option
    
    Revert new 2.6.23 CONFIG_THINKPAD_ACPI_INPUT_ENABLED Kconfig option because
    it would create a legacy we don't want to support.
    
    CONFIG_THINKPAD_ACPI_INPUT_ENABLED was added to try to fix an issue that is
    now moot with the addition of the netlink ACPI event report interface to
    the ACPI core.
    
    Now that ACPI core can send events over netlink, we can use a different
    strategy to keep backwards compatibility with older userspace, without the
    need for the CONFIG_THINKPAD_ACPI_INPUT_ENABLED games.  And it arrived
    before CONFIG_THINKPAD_ACPI_INPUT_ENABLED made it to a stable mainline
    kernel, even, which is Good.
    
    This patch is in sync with some changes to thinkpad-acpi backports, that
    will keep things sane for userspace across different combinations of kernel
    versions, thinkpad-acpi backports (or the lack thereof), and userspace
    capabilities:
    
    Unless a module parameter is used, thinkpad-acpi will now behave in such a
    way that it will work well (by default) with userspace that still uses only
    the old ACPI procfs event interface and doesn't care for thinkpad-acpi
    input devices.
    
    It will also always work well with userspace that has been updated to use
    both the thinkpad-acpi input devices, and ACPI core netlink event
    interface, regardless of any module parameter.
    
    The module parameter was added to allow thinkpad-acpi to work with
    userspace that has been partially updated to use thinkpad-acpi input
    devices, but not the new ACPI core netlink event interface.  To use this
    mode of hot key reporting, one has to specify the hotkey_report_mode=2
    module parameter.
    
    The thinkpad-acpi driver exports the value of hotkey_report_mode through
    sysfs, as well.  thinkpad-acpi backports to older kernels, that do not
    support the new ACPI core netlink interface, have code to allow userspace
    to switch hotkey_report_mode at runtime through sysfs.  This capability
    will not be provided in mainline thinkpad-acpi as it is not needed there.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Michael S. Tsirkin <mst@dev.mellanox.co.il>
    Cc: Hugh Dickins <hugh@veritas.com>
    Cc: Richard Hughes <hughsient@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95e3f66fa60a8e573b0b7a58305c5c9fcbca1b70
Merge: 5e41d0d... 66baf32...
Author: Len Brown <len.brown@intel.com>
Date:   Mon Sep 17 00:28:58 2007 -0400

    Pull misc into release branch

commit 66baf327ae5d4c17e75d1f501145e79eaeeaf649
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Mon Sep 3 00:03:35 2007 -0300

    ACPI: fix CONFIG_NET=n acpi_bus_generate_netlink_event build failure
    
    drivers/acpi/event.c:243: error: 'acpi_generate_netlink_event' undeclared
    here (not in a function)
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cb90ab5b424e711390c2ef6f0882b615b042dcb6
Author: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Date:   Wed Aug 29 15:58:19 2007 +0930

    msi-laptop: replace ',' with ';'
    
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 134c21715ac3cb36db13c8d362cc80ccc87ee48d
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Aug 28 14:58:56 2007 -0400

    ACPI: (more) delete CONFIG_ACPI_PROCFS_SLEEP (again)
    
    Commit 2bcf9dddeb8e79a4ba55bf191533f70f39ce
    ('ACPI: delete CONFIG_ACPI_PROCFS_SLEEP (again)')
    was incomplete.
    
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
