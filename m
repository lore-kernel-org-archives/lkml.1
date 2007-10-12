Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbXJLWNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbXJLWNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbXJLWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:13:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773AbXJLWNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:13:09 -0400
Date: Fri, 12 Oct 2007 18:12:53 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch merge fallout.
Message-ID: <20071012221253.GB4290@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20071012035743.GA12897@redhat.com> <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org> <20071012182504.GA9222@redhat.com> <alpine.LFD.0.999.0710121457230.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0710121457230.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 02:58:24PM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Fri, 12 Oct 2007, Dave Jones wrote:
 > > 
 > > The git on master.kernel.org (1.5.3.4) is pretty recent, so I don't think
 > > that's the problem, is it?
 > 
 > It may be that the "renamelimit" thing didn't go into the stable branch at 
 > all. If you build your git from the current HEAD, it should work.
 > 
 > Or just point me to the thing, and I'll see if I can merge it.

pull req below.  If it turns out to be more trouble than its worth,
let me know, and I'll fix up the patches by hand, and generate
a new git tree. (If it comes to that, I understand Thomas has a script
that may help).

	Dave




Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ 

 arch/arm/mach-imx/cpufreq.c                       |    1 -
 arch/arm/mach-sa1100/cpu-sa1110.c                 |    1 -
 arch/arm/plat-omap/cpu-omap.c                     |    1 -
 arch/blackfin/mach-bf533/cpu.c                    |    2 -
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c       |    1 -
 arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c    |    1 -
 arch/i386/kernel/cpu/cpufreq/e_powersaver.c       |    1 -
 arch/i386/kernel/cpu/cpufreq/elanfreq.c           |    1 -
 arch/i386/kernel/cpu/cpufreq/gx-suspmod.c         |    1 -
 arch/i386/kernel/cpu/cpufreq/longhaul.c           |    5 ++-
 arch/i386/kernel/cpu/cpufreq/p4-clockmod.c        |    1 -
 arch/i386/kernel/cpu/cpufreq/powernow-k6.c        |    1 -
 arch/i386/kernel/cpu/cpufreq/powernow-k7.c        |    2 -
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c        |   13 +++----
 arch/i386/kernel/cpu/cpufreq/sc520_freq.c         |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-ich.c      |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-smi.c      |    1 -
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c           |    2 -
 arch/powerpc/platforms/cell/cbe_cpufreq.c         |    2 -
 arch/powerpc/platforms/pasemi/cpufreq.c           |    2 -
 arch/powerpc/platforms/powermac/cpufreq_32.c      |    1 -
 arch/powerpc/platforms/powermac/cpufreq_64.c      |    1 -
 arch/sh/kernel/cpufreq.c                          |    1 -
 arch/sparc64/kernel/us2e_cpufreq.c                |    1 -
 drivers/cpufreq/Kconfig                           |   27 ++++++++++++--
 drivers/cpufreq/cpufreq.c                         |   34 +++++++++++++++---
 drivers/cpufreq/cpufreq_conservative.c            |   19 +++++-----
 drivers/cpufreq/cpufreq_ondemand.c                |   22 +++++-------
 drivers/cpufreq/cpufreq_stats.c                   |   18 ++++-----
 include/linux/cpufreq.h                           |   39 +++++++++++++++++---
 31 files changed, 119 insertions(+), 86 deletions(-)

commit 9eb59573d4b86f347e6cd04f47a4c2082009fa58
Author: Andi Kleen <ak@suse.de>
Date:   Wed Oct 10 02:18:27 2007 +0200

    [CPUFREQ] Don't take semaphore in cpufreq_quick_get()
    
    I don't see any reason to take an expensive lock in cpufreq_quick_get()
    Reading policy->cur is a single atomic operation and after
    the lock is dropped again the state could change any time anyways.
    
    So don't take the lock in the first place.
    
    This also makes this function interrupt safe which is useful
    for some code of mine.
    
    Signed-off-by: Andi Kleen <ak@suse.de>
    Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 562d94d98f7032bdc4a99d9124a78a543dbea225
Author: Mark Langsdorf <mark.langsdorf@amd.com>
Date:   Fri Aug 3 14:09:05 2007 -0500

    [CPUFREQ] Support different families in fid/did to frequency conversion
    
    The equation to find the frequency given the fid and did is family dependant.
    
    Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 55395ae72b6e5ae614d28df74158c47454652583
Author: Satyam Sharma <satyam@infradead.org>
Date:   Tue Oct 2 13:28:15 2007 -0700

    [CPUFREQ] cpufreq_stats: misc cpuinit section annotations
    
    * Stop referencing the callback directly from the __init and __exit
      functions of this driver, and instead explicitly call
      cpufreq_update_policy() et al. This enables the callback function
      to be marked as __cpuinit (and the notifier_block __cpuinitdata),
      thereby saving space when HOTPLUG_CPU=n. This also enables us to
      use other tricks to replace __cpuinit{data} in future.
    
    * cpufreq_stats_free_table() is only called from __cpuinit or __exit
      marked functions, making it an ideal candidate for __cpuexit.
    
    * Fix missing space in the module description
    
    Signed-off-by: Satyam Sharma <satyam@infradead.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 6070b5de50ab5e3f810628a9cbb04deecf30a85f
Author: Satyam Sharma <satyam@infradead.org>
Date:   Tue Oct 2 13:28:15 2007 -0700

    [CPUFREQ] implement !CONFIG_CPU_FREQ stub for  cpufreq_unregister_notifier()
    
    Callsites such as arch/powerpc/oprofile/op_model_cell.c are having to
    open-code #ifdef CONFIG_CPU_FREQ only to be able to get at the full definition
    of cpufreq_unregister_notifier(), because no empty stub is available for the
    !CONFIG_CPU_FREQ case.  Let's provide one, to be able to remove such #ifdef's
    from the rest of the kernel tree -- those will come in a subsequent patch.
    
    Signed-off-by: Satyam Sharma <satyam@infradead.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit dd184a01b8ece6bac2f7a63de99a4a4d29552746
Author: Satyam Sharma <satyam@infradead.org>
Date:   Tue Oct 2 13:28:14 2007 -0700

    [CPUFREQ] mark hotplug notifier callback as __cpuinit
    
    The notifier_block is already __cpuinitdata, thereby allowing us to safely
    mark the callback function as __cpuinit also, thereby saving space when
    HOTPLUG_CPU=n.
    
    Signed-off-by: Satyam Sharma <satyam@infradead.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 6afde10c3f58cc3ac593f5b4505b8b1cf719f5d6
Author: Thomas Renninger <trenn@suse.de>
Date:   Tue Oct 2 13:28:13 2007 -0700

    [CPUFREQ] Only check for transition latency on problematic governors (kconfig fix)
    
    Cc: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 1c2562459faedc35927546cfa5273ec6c2884cce
Author: Thomas Renninger <trenn@suse.de>
Date:   Tue Oct 2 13:28:12 2007 -0700

    [CPUFREQ] allow ondemand and conservative cpufreq governors to be used as default
    
    Depending on the transition latency of the HW for cpufreq switches, the
    ondemand or conservative governor cannot be used with certain cpufreq
    drivers.  Still the ondemand should be the default governor on a wide range
    of systems.  This patch allows this and lets the governor fallback to the
    performance governor at cpufreq driver load time, if the driver does not
    support fast enough frequency switching.
    
    Main benefit is that on e.g.  installation or other systems without
    userspace support a working dynamic cpufreq support can be achieved on most
    systems by simply loading the cpufreq driver.  This is especially essential
    for recent x86(_64) laptop hardware which may rely on working dynamic
    cpufreq OS support.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Cc: Russell King <rmk@arm.linux.org.uk>
    Cc: Bryan Wu <bryan.wu@analog.com>
    Cc: Andi Kleen <ak@suse.de>
    Cc: "Luck, Tony" <tony.luck@intel.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 8122c6cea033e8034e99d3b10a4e3f377ce23994
Author: Thomas Renninger <trenn@suse.de>
Date:   Tue Oct 2 13:28:09 2007 -0700

    [CPUFREQ] move policy's governor initialisation out of low-level drivers into cpufreq core
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Cc: Russell King <rmk@arm.linux.org.uk>
    Cc: Bryan Wu <bryan.wu@analog.com>
    Cc: Andi Kleen <ak@suse.de>
    Cc: "Luck, Tony" <tony.luck@intel.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit a09d60a622ea4a3592dc6836e709d4a7a4ed4025
Author: Rafał Bilski <rafalbilski@interia.pl>
Date:   Wed Sep 26 17:08:14 2007 +0200

    [CPUFREQ] Longhaul - Add support for PM133 northbridge
    
    Add support for PM133 northbridge. Tested by Sylvain Ferrand.
    
    Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit c925401b6dc2229adbb15b2f3c9f0f2d9253a5d5
Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date:   Wed Aug 22 18:44:20 2007 -0700

    [CPUFREQ] x86: use num_online_nodes to get physical cpus numbers for
    powernow_k8
    
    [PATCH] x86: use num_online_nodes to get physical cpus numbers for powernow_k8
    
    For opteron based system, don't assume all physical cpus have the same booted cpus even same cores. esp for downcore case.
    
    Signed-off-by: Yinghai Lu <yinghai.sun.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

-- 
http://www.codemonkey.org.uk
