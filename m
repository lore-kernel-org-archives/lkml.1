Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZJCF4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZJCF4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 01:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZJCF4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 01:56:48 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:44946 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZJCF4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 01:56:47 -0400
Date: Sat, 03 Oct 2009 01:56:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Shaohua Li <shaohua.li@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [git pull request] ACPI Processor Aggregator Driver for 2.6.32-rc1
Message-id: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git acpi-pad

This will add the ACPI Processor Aggregator Driver to the kernel.
acpi_pad implements a new ACPI feature where the baseboard management
controller can ask Linux to force busy processors to stay idle.

The BMC does this under dire electrical or thermal conditions
after it has already lowered the P-state to low frequencey mode
on all processors, yet the emergency persists.  This offline
technique is used before employing even more invasive measures,
such as taking T-states down to 1/8th of LFM, or powering-off
the server completely.

This driver will have no effect on the installed base,
no no old systems implement this new feature.  However, this
simle driver in Linux will be useful as this feature
is deployed by OEMs on new hardware.

As I mentioned previously, this is an ACPI patch, not a scheduler patch.
PeterZ is hoping to implement a more sophisticated method for forcing
idle time in the system with the scheduler, and when that is available,
I'll be delighted to update this driver to invoke it.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.31/acpi-acpi-pad-20090521-2.6.31-rc4.diff.gz

 MAINTAINERS             |    8 +
 drivers/acpi/Kconfig    |   12 +
 drivers/acpi/Makefile   |    2 +
 drivers/acpi/acpi_pad.c |  514 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 536 insertions(+), 0 deletions(-)
 create mode 100644 drivers/acpi/acpi_pad.c

through these commits:

Len Brown (1):
      acpi_pad: build only on X86

Shaohua Li (1):
      ACPI: create Processor Aggregator Device driver

with this log:

commit d91f79ebc3191b15dbe385925af4840f4e68df77
Author: Len Brown <len.brown@intel.com>
Date:   Sun Sep 27 02:35:55 2009 -0400

    acpi_pad: build only on X86
    
    X86_FEATURE_MWAIT doesn't exist on ia64...
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8e0af5141ab950b78b3ebbfaded5439dcf8b3a8d
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Mon Jul 27 18:11:02 2009 -0400

    ACPI: create Processor Aggregator Device driver
    
    ACPI 4.0 created the logical "processor aggregator device" as
    a mechinism for platforms to ask the OS to force otherwise busy
    processors to enter (power saving) idle.
    
    The intent is to lower power consumption to ride-out
    transient electrical and thermal emergencies,
    rather than powering off the server.
    
    On platforms that can save more power/performance via P-states,
    the platform will first exhaust P-states before forcing idle.
    However, the relative benefit of P-states vs. idle states
    is platform dependent, and thus this driver need not know
    or care about it.
    
    This driver does not use the kernel's CPU hot-plug mechanism
    because after the transient emergency is over, the system must
    be returned to its normal state, and hotplug would permanently
    break both cpusets and binding.
    
    So to force idle, the driver creates a power saving thread.
    The scheduler will migrate the thread to the preferred CPU.
    The thread has max priority and has SCHED_RR policy,
    so it can occupy one CPU.  To save power, the thread will
    invoke the deep C-state entry instructions.
    
    To avoid starvation, the thread will sleep 5% of the time
    time for every second (current RT scheduler has threshold
    to avoid starvation, but if other CPUs are idle,
    the CPU can borrow CPU timer from other,
    which makes the mechanism not work here)
    
    Vaidyanathan Srinivasan has proposed scheduler enhancements
    to allow injecting idle time into the system.  This driver doesn't
    depend on those enhancements, but could cut over to them
    when they are available.
    
    Peter Z. does not favor upstreaming this driver until
    the those scheduler enhancements are in place.  However,
    we favor upstreaming this driver now because it is useful
    now, and can be enhanced over time.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    NACKed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
