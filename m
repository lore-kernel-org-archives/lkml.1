Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbYC0Gv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbYC0Gv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 02:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYC0Gvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 02:51:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:39593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbYC0Gvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 02:51:44 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: ACPI patches for 2.6.25-rc7
Date: Thu, 27 Mar 2008 02:51:14 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803270251.14446.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Note that I generated the diffstat below with
git diff -b -M --stat linus..release

I've not used "-b" until now.  I added it because Julia's patch was simple,
but since it changed indenting of a couple of blocks its diffstat was otherwise large.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.25/acpi-release-20070126-2.6.25-rc7.diff.gz

 drivers/acpi/fan.c             |    2 --
 drivers/acpi/processor_core.c  |    2 --
 drivers/acpi/processor_idle.c  |    5 ++++-
 drivers/acpi/sbshc.c           |    1 -
 drivers/acpi/scan.c            |   16 +++++++++++-----
 drivers/acpi/video.c           |    2 --
 drivers/cpuidle/cpuidle.c      |    4 ++--
 drivers/cpuidle/sysfs.c        |   10 ++++++++--
 drivers/pnp/pnpacpi/rsparser.c |    8 ++++----
 include/linux/cpuidle.h        |    4 ++--
 10 files changed, 31 insertions(+), 23 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPI: SBS: remove typo from sbchc.c

Julia Lawall (1):
      ACPI: drivers/acpi: elide a non-zero test on a result that is never 0

Len Brown (1):
      pnpacpi: reduce printk severity for "pnpacpi: exceeded the max number of ..."

Venki Pallipadi (2):
      ACPI: fix mis-merge -- invoke acpi_unlazy_tlb() only on C3 entry
      cpuidle: fix 100% C0 statistics regression

Yi Yang (1):
      cpuidle: fix cpuidle time and usage overflow

Zhang Rui (1):
      ACPI: fix a regression of ACPI device driver autoloading

with this log:

commit 1192aeb957402b45f311895f124e4ca41206843c
Author: Julia Lawall <julia@diku.dk>
Date:   Thu Mar 27 01:48:22 2008 -0400

    ACPI: drivers/acpi: elide a non-zero test on a result that is never 0
    
    The function thermal_cooling_device_register always returns either a valid
    pointer or a value made with ERR_PTR, so a test for non-zero on the result
    will always succeed.
    
    The problem was found using the following semantic match.
    (http://www.emn.fr/x-info/coccinelle/)
    
    //<smpl>
    @a@
    expression E, E1;
    statement S,S1;
    position p;
    @@
    
    E = thermal_cooling_device_register(...)
    ... when != E = E1
    if@p (E) S else S1
    
    @n@
    position a.p;
    expression E,E1;
    statement S,S1;
    @@
    
    E = NULL
    ... when != E = E1
    if@p (E) S else S1
    
    @depends on !n@
    expression E;
    statement S,S1;
    position a.p;
    @@
    
    * if@p (E)
      S else S1
    //</smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 86d9fc1293aa9456677eab94e9fd2d3a10920548
Merge: 08dcf29... 8e92b66... 33fd7af... 7642d21... 5c9fcb5...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 26 22:50:09 2008 -0400

    Merge branches 'release', 'idle', 'redhat-bugzilla-436589', 'sbs' and 'video' into release

commit 33fd7afd66ffdc6addf1b085fe6403b6af532f8e
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 26 13:29:32 2008 -0400

    pnpacpi: reduce printk severity for "pnpacpi: exceeded the max number of ..."
    
    We have been printing these messages at KERN_ERR since 2.6.24,
    per http://bugzilla.kernel.org/show_bug.cgi?id=9535
    
    But KERN_ERR pops up on a console booted with "quiet"
    and causes users to get alarmed and file bugs
    about the message itself:
    https://bugzilla.redhat.com/show_bug.cgi?id=436589
    
    So reduce the severity of these messages to
    KERN_WARNING, which is not printed by "quiet".
    
    This message will still be seen without "quiet",
    but a lot of messages are printed in that mode
    and it will be less likely to cause undue alarm.
    
    We could go all the way to KERN_DEBUG, but this
    is a real warning after all, so it seems prudent
    not to require "debug" to see it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8e92b6605da989c0aa8ff7e33306f36f0efd957c
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Fri Feb 29 10:24:32 2008 -0800

    cpuidle: fix 100% C0 statistics regression
    
    commit 9b12e18cdc1553de62d931e73443c806347cd974
    'ACPI: cpuidle: Support C1 idle time accounting'
    was implicated in a 100% C0 idle regression.
    http://bugzilla.kernel.org/show_bug.cgi?id=10076
    
    It pointed out a potential problem where the menu governor
    may get confused by the C-state residency time from poll
    idle or C1 idle, where this timing info is not accurate.
    This inaccuracy is due to interrupts being handled
    before we account for C-state exit.
    
    Do not mark TIME_VALID for CO poll state.
    Mark C1 time as valid only with the MWAIT (CSTATE_FFH) entry method.
    
    This makes governors use the timing information only when it is correct and
    eliminates any wrong policy decisions that may result from invalid timing
    information.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8b78cf602fd3bd97c0080edd22fe8fd5d0fa7832
Author: Yi Yang <yi.y.yang@intel.com>
Date:   Mon Feb 25 08:46:12 2008 +0800

    cpuidle: fix cpuidle time and usage overflow
    
    cpuidle C-state sysfs node time and usage are very easy to overflow because
    they are all of unsigned int type, time will overflow within about two hours,
    usage will take longer time to overflow, but they are increasing for ever.
    
    This patch will convert them to unsigned long long.
    
    Signed-off-by: Yi Yang <yi.y.yang@intel.com>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 996520c1fdd2948addb629be56c9febf2967e02b
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Mar 24 14:24:10 2008 -0700

    ACPI: fix mis-merge -- invoke acpi_unlazy_tlb() only on C3 entry
    
    This original patch
    http://ussg.iu.edu/hypermail/linux/kernel/0712.2/1451.html
    was intending to add acpi_unlazy_tlb() to acpi_idle_enter_bm(),
    which is used for C3 entry.
    
    But it was merged incorrectly as commmit
    
    bde6f5f59c2b2b48a7a849c129d5b48838fe77ee
    'x86: voluntary leave_mm before entering ACPI C3'
    
    so the call was instead added to acpi_idle_enter_simple()
    (which is C2 entry routine), probably due to identical
    context in that function.
    
    Move the call back to acpi_idle_enter_bm().
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5c9fcb5deef4d3a49798d76c48b726d2e3c7df72
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Mar 20 16:40:32 2008 +0800

    ACPI: fix a regression of ACPI device driver autoloading
    
    commit 3620f2f2f39e7870cf1a4fb2e34063a142f28716 sets the cid of
    ACPI video/dock/bay device and leaves the hid empty.
    As a result, "modalias" should export the cid for
    devices which don't have a hid.
    
    ACPI Video driver is not autoloaded with
    commit 3620f2f2f39e7870cf1a4fb2e34063a142f28716 applied.
    "cat /sys/.../device:03(acpi video bus)/modalias" shows nothing.
    
    ACPI Video driver is autoloaded after revert that commit.
    "cat /sys/.../LNXVIDEO:0x/modalias" shows "acpi:LNXVIDEO:"
    
    ACPI Video driver is autoloaded with commit
    3620f2f2f39e7870cf1a4fb2e34063a142f28716 and this patch applied.
    "cat /sys/.../device:03(acpi video bus)/modalias"
    shows "acpi:LNXVIDEO:"
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7642d2113098f1270e9f9f0120f44d0035091636
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Feb 28 19:17:39 2008 +0300

    ACPI: SBS: remove typo from sbchc.c
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
