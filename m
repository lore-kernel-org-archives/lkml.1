Return-Path: <linux-kernel-owner+w=401wt.eu-S1422635AbXBGTU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422635AbXBGTU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030652AbXBGTU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:20:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:33213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030651AbXBGTUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:20:23 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: [GIT PATCH] ACPI patches for 2.6.21
Date: Wed, 7 Feb 2007 14:18:50 -0500
User-Agent: KMail/1.9.5
Cc: tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       "Accardi, Kristen" <kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702071418.51058.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

ACPICA Core version 2070126 simplifies the ACPI table manager
code by consolidating multiple table definitions into one.
It also saves memory by mapping the tables where the BIOS provides them
rather than copying them into the kernel.

Per your request, and the request of the distros, we've changed
how ACPICA Core releases are integrated into Linux so that each
upstream (CVS) check-in appears as a single git commit.
While this process is not yet perfect, it should be vastly better
than previous "code drops" in allowing git bisect to work,
and allowing distros to cherry-pick individual fixes.

The "bay" driver is new (and marked EXPERIMENTAL) -- adding initial
hot-plug support for ACPI controlled drive bays such as the
IBM ultrabay or the Dell Module Bay.

The "asus-laptop" driver is also new.  Consistent with msi-laptop,
it uses ACPI in platform-specific ways, but strives to avoid
exposing ACPI-specific implementation details to the user.
asus-laptop is mutually exclusive with asus_acpi, which it will
replace over time.

This series includes steps to convert the ACPI sub-system
over to the Linux driver model, and steps to start replacing
the old /proc/acpi/ interfaces with cleaner interfaces in sysfs --
non-ACPI-specific generic ones whenever possible.  This effort
is not complete, but it has been in -mm for a long time and
I believe that it is time to push it upstream to benefit
from broader exposure and testing.

There are also some patches for Altix support
which have ACPI dependencies.  This support is new,
so I anticipate some updates to it, but I think it is
a good idea to push what SGI has now upstream so they
stop getting stomped on with merge conflicts in -mm.

This will update the files shown below.

thanks!

-Len

ps. a plain patch is also available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.20/acpi-release-20070126-2.6.20.diff.gz

 Documentation/feature-removal-schedule.txt  |   10 
 Documentation/video-output.txt              |   34 
 MAINTAINERS                                 |    8 
 arch/i386/defconfig                         |    3 
 arch/i386/kernel/acpi/boot.c                |  235 +-
 arch/i386/kernel/acpi/earlyquirk.c          |    4 
 arch/i386/kernel/cpu/cpufreq/longhaul.c     |   15 
 arch/i386/kernel/mpparse.c                  |    4 
 arch/i386/kernel/srat.c                     |   84 
 arch/i386/mach-es7000/es7000.h              |    9 
 arch/i386/mach-es7000/es7000plat.c          |   53 
 arch/i386/pci/mmconfig.c                    |   24 
 arch/ia64/kernel/acpi.c                     |  200 +-
 arch/ia64/sn/kernel/io_acpi_init.c          |  314 +++
 arch/ia64/sn/kernel/io_common.c             |   90 -
 arch/ia64/sn/kernel/io_init.c               |   54 
 arch/ia64/sn/kernel/iomv.c                  |    5 
 arch/ia64/sn/pci/pcibr/pcibr_provider.c     |    6 
 arch/x86_64/kernel/early-quirks.c           |    4 
 arch/x86_64/kernel/genapic.c                |    4 
 arch/x86_64/kernel/mpparse.c                |    2 
 arch/x86_64/kernel/time.c                   |   18 
 arch/x86_64/mm/srat.c                       |   48 
 arch/x86_64/pci/mmconfig.c                  |   29 
 drivers/acpi/Kconfig                        |   37 
 drivers/acpi/Makefile                       |    5 
 drivers/acpi/asus_acpi.c                    |    9 
 drivers/acpi/battery.c                      |    4 
 drivers/acpi/bay.c                          |  490 +++++
 drivers/acpi/blacklist.c                    |   29 
 drivers/acpi/bus.c                          |   44 
 drivers/acpi/button.c                       |    2 
 drivers/acpi/container.c                    |    6 
 drivers/acpi/debug.c                        |   62 
 drivers/acpi/dispatcher/dsfield.c           |   32 
 drivers/acpi/dispatcher/dsinit.c            |   25 
 drivers/acpi/dispatcher/dsmethod.c          |   55 
 drivers/acpi/dispatcher/dsmthdat.c          |    2 
 drivers/acpi/dispatcher/dsobject.c          |   78 
 drivers/acpi/dispatcher/dsopcode.c          |    6 
 drivers/acpi/dispatcher/dsutils.c           |    2 
 drivers/acpi/dispatcher/dswexec.c           |   12 
 drivers/acpi/dispatcher/dswload.c           |   19 
 drivers/acpi/dispatcher/dswscope.c          |    2 
 drivers/acpi/dispatcher/dswstate.c          |    2 
 drivers/acpi/dock.c                         |   16 
 drivers/acpi/ec.c                           |   13 
 drivers/acpi/events/evevent.c               |   17 
 drivers/acpi/events/evgpe.c                 |   91 -
 drivers/acpi/events/evgpeblk.c              |   64 
 drivers/acpi/events/evmisc.c                |  201 +-
 drivers/acpi/events/evregion.c              |   17 
 drivers/acpi/events/evrgnini.c              |  168 +
 drivers/acpi/events/evsci.c                 |   14 
 drivers/acpi/events/evxface.c               |    8 
 drivers/acpi/events/evxfevnt.c              |   27 
 drivers/acpi/events/evxfregn.c              |    2 
 drivers/acpi/executer/exconfig.c            |  235 --
 drivers/acpi/executer/exconvrt.c            |    2 
 drivers/acpi/executer/excreate.c            |   21 
 drivers/acpi/executer/exdump.c              |   29 
 drivers/acpi/executer/exfield.c             |    2 
 drivers/acpi/executer/exfldio.c             |    7 
 drivers/acpi/executer/exmisc.c              |    2 
 drivers/acpi/executer/exmutex.c             |   86 
 drivers/acpi/executer/exnames.c             |    2 
 drivers/acpi/executer/exoparg1.c            |    4 
 drivers/acpi/executer/exoparg2.c            |    2 
 drivers/acpi/executer/exoparg3.c            |    2 
 drivers/acpi/executer/exoparg6.c            |    2 
 drivers/acpi/executer/exprep.c              |    2 
 drivers/acpi/executer/exregion.c            |   16 
 drivers/acpi/executer/exresnte.c            |    2 
 drivers/acpi/executer/exresolv.c            |   10 
 drivers/acpi/executer/exresop.c             |   12 
 drivers/acpi/executer/exstore.c             |    2 
 drivers/acpi/executer/exstoren.c            |    2 
 drivers/acpi/executer/exstorob.c            |    2 
 drivers/acpi/executer/exsystem.c            |  110 -
 drivers/acpi/executer/exutils.c             |  106 -
 drivers/acpi/fan.c                          |    8 
 drivers/acpi/glue.c                         |  123 -
 drivers/acpi/hardware/hwacpi.c              |   56 
 drivers/acpi/hardware/hwgpe.c               |   15 
 drivers/acpi/hardware/hwregs.c              |   98 -
 drivers/acpi/hardware/hwsleep.c             |   81 
 drivers/acpi/hardware/hwtimer.c             |    9 
 drivers/acpi/motherboard.c                  |  191 --
 drivers/acpi/namespace/nsaccess.c           |   36 
 drivers/acpi/namespace/nsalloc.c            |   14 
 drivers/acpi/namespace/nsdump.c             |   13 
 drivers/acpi/namespace/nsdumpdv.c           |    2 
 drivers/acpi/namespace/nseval.c             |   13 
 drivers/acpi/namespace/nsinit.c             |    9 
 drivers/acpi/namespace/nsload.c             |  160 -
 drivers/acpi/namespace/nsnames.c            |    2 
 drivers/acpi/namespace/nsobject.c           |    2 
 drivers/acpi/namespace/nsparse.c            |   52 
 drivers/acpi/namespace/nssearch.c           |    9 
 drivers/acpi/namespace/nsutils.c            |    9 
 drivers/acpi/namespace/nswalk.c             |   65 
 drivers/acpi/namespace/nsxfeval.c           |   13 
 drivers/acpi/namespace/nsxfname.c           |   47 
 drivers/acpi/namespace/nsxfobj.c            |    2 
 drivers/acpi/numa.c                         |   77 
 drivers/acpi/osl.c                          |   97 -
 drivers/acpi/parser/psargs.c                |    2 
 drivers/acpi/parser/psloop.c                | 1408 ++++++++--------
 drivers/acpi/parser/psopcode.c              |    2 
 drivers/acpi/parser/psparse.c               |    7 
 drivers/acpi/parser/psscope.c               |    2 
 drivers/acpi/parser/pstree.c                |    2 
 drivers/acpi/parser/psutils.c               |    2 
 drivers/acpi/parser/pswalk.c                |    2 
 drivers/acpi/parser/psxface.c               |  116 -
 drivers/acpi/pci_link.c                     |    4 
 drivers/acpi/pci_root.c                     |   38 
 drivers/acpi/processor_core.c               |  189 +-
 drivers/acpi/processor_idle.c               |   52 
 drivers/acpi/processor_perflib.c            |   27 
 drivers/acpi/processor_throttling.c         |    4 
 drivers/acpi/resources/rsaddr.c             |    2 
 drivers/acpi/resources/rscalc.c             |    2 
 drivers/acpi/resources/rscreate.c           |    2 
 drivers/acpi/resources/rsdump.c             |    2 
 drivers/acpi/resources/rsinfo.c             |    2 
 drivers/acpi/resources/rsio.c               |    2 
 drivers/acpi/resources/rsirq.c              |    2 
 drivers/acpi/resources/rslist.c             |    2 
 drivers/acpi/resources/rsmemory.c           |    2 
 drivers/acpi/resources/rsmisc.c             |    2 
 drivers/acpi/resources/rsutils.c            |    2 
 drivers/acpi/resources/rsxface.c            |    2 
 drivers/acpi/scan.c                         | 1265 ++++++--------
 drivers/acpi/sleep/proc.c                   |   36 
 drivers/acpi/system.c                       |   39 
 drivers/acpi/tables.c                       |  508 -----
 drivers/acpi/tables/Makefile                |    3 
 drivers/acpi/tables/tbconvrt.c              |  622 -------
 drivers/acpi/tables/tbfadt.c                |  434 ++++
 drivers/acpi/tables/tbfind.c                |  126 +
 drivers/acpi/tables/tbget.c                 |  471 -----
 drivers/acpi/tables/tbgetall.c              |  311 ---
 drivers/acpi/tables/tbinstal.c              |  664 +++----
 drivers/acpi/tables/tbrsdt.c                |  307 ---
 drivers/acpi/tables/tbutils.c               |  513 +++--
 drivers/acpi/tables/tbxface.c               |  671 ++++---
 drivers/acpi/tables/tbxfroot.c              |  552 +-----
 drivers/acpi/thermal.c                      |    4 
 drivers/acpi/utilities/utalloc.c            |   11 
 drivers/acpi/utilities/utcache.c            |   10 
 drivers/acpi/utilities/utcopy.c             |   11 
 drivers/acpi/utilities/utdebug.c            |    7 
 drivers/acpi/utilities/utdelete.c           |   16 
 drivers/acpi/utilities/uteval.c             |    2 
 drivers/acpi/utilities/utglobal.c           |  199 --
 drivers/acpi/utilities/utinit.c             |  114 -
 drivers/acpi/utilities/utmath.c             |    2 
 drivers/acpi/utilities/utmisc.c             |  102 +
 drivers/acpi/utilities/utmutex.c            |    2 
 drivers/acpi/utilities/utobject.c           |    2 
 drivers/acpi/utilities/utresrc.c            |    2 
 drivers/acpi/utilities/utstate.c            |    2 
 drivers/acpi/utilities/utxface.c            |   29 
 drivers/acpi/video.c                        |  166 +
 drivers/char/ipmi/ipmi_si_intf.c            |   18 
 drivers/char/tpm/tpm_bios.c                 |    8 
 drivers/firmware/pcdp.c                     |    2 
 drivers/misc/Kconfig                        |   19 
 drivers/misc/Makefile                       |    1 
 drivers/misc/asus-laptop.c                  | 1165 +++++++++++++
 drivers/pci/hotplug/acpiphp_glue.c          |   10 
 drivers/pci/hotplug/sgi_hotplug.c           |  155 +
 drivers/pnp/pnpacpi/Kconfig                 |    4 
 drivers/pnp/system.c                        |   52 
 drivers/video/output.c                      |  129 +
 include/acpi/acconfig.h                     |   13 
 include/acpi/acdebug.h                      |    8 
 include/acpi/acdisasm.h                     |   22 
 include/acpi/acdispat.h                     |    4 
 include/acpi/acevents.h                     |    2 
 include/acpi/acexcep.h                      |   10 
 include/acpi/acglobal.h                     |  117 -
 include/acpi/achware.h                      |    6 
 include/acpi/acinterp.h                     |   14 
 include/acpi/aclocal.h                      |   77 
 include/acpi/acmacros.h                     |   71 
 include/acpi/acnames.h                      |    2 
 include/acpi/acnamesp.h                     |   21 
 include/acpi/acobject.h                     |   19 
 include/acpi/acopcode.h                     |    4 
 include/acpi/acoutput.h                     |    2 
 include/acpi/acparser.h                     |    2 
 include/acpi/acpi.h                         |    2 
 include/acpi/acpi_bus.h                     |   23 
 include/acpi/acpi_drivers.h                 |   15 
 include/acpi/acpiosxf.h                     |    8 
 include/acpi/acpixf.h                       |   34 
 include/acpi/acresrc.h                      |    2 
 include/acpi/acstruct.h                     |    5 
 include/acpi/actables.h                     |  106 -
 include/acpi/actbl.h                        |  333 +--
 include/acpi/actbl1.h                       |  568 +++---
 include/acpi/actbl2.h                       |   49 
 include/acpi/actbl71.h                      |  134 -
 include/acpi/actypes.h                      |  106 -
 include/acpi/acutils.h                      |    8 
 include/acpi/amlcode.h                      |    4 
 include/acpi/amlresrc.h                     |    2 
 include/acpi/platform/acenv.h               |    2 
 include/acpi/platform/acgcc.h               |    2 
 include/acpi/platform/aclinux.h             |    2 
 include/asm-i386/acpi.h                     |   24 
 include/asm-i386/mach-es7000/mach_mpparse.h |   17 
 include/asm-ia64/acpi.h                     |   10 
 include/asm-ia64/sn/acpi.h                  |    3 
 include/asm-ia64/sn/pcibr_provider.h        |    2 
 include/asm-ia64/sn/pcidev.h                |    8 
 include/asm-x86_64/acpi.h                   |   24 
 include/linux/acpi.h                        |  339 ---
 include/linux/video_output.h                |   42 
 221 files changed, 8693 insertions(+), 8903 deletions(-)

through these commits:

Adrian Bunk (1):
      ACPI: bay: make drive_bays static

Alexey Starikovskiy (16):
      ACPI: correct id for fixed buttons
      ACPICA: minimal patch to integrate new tables into Linux
      ACPICA: Store GPE number instead of bitmask
      ACPICA: Remove duplicate table manager
      ACPICA: use new ACPI headers.
      ACPICA: Remove duplicate table definitions.
      ACPICA: Remove duplicate table definitions (non-conflicting)
      ACPICA: Remove duplicate table definitions (non-conflicting), cont
      ACPICA: Miscellaneous table manager updates and optimizations
      ACPICA: Fixes for load() operator.
      ACPICA: Allow ACPI id to be u32 instead of u8.
      ACPICA: Allow processor to be declared with the Device() instead of Processor()
      ACPI: build fix for IBM x440 - CONFIG_X86_SUMMIT
      ACPI: fix HP RX2600 IA64 boot
      ACPI_NUMA: fix HP IA64 simulator issue with extended memory domain
      ACPICA: fix gcc build warnings

Bjorn Helgaas (6):
      ACPI: move FADT resource reservations from motherboard driver to osl
      PNP: reserve system board iomem resources as well as ioport resources
      PNP: system.c whitespace cleanup
      i386: turn on CONFIG_PNP in defconfig
      ACPI: remove motherboard driver (redundant with PNP system driver)
      PNPACPI: remove EXPERIMENTAL dependency

Bob Moore (66):
      ACPICA: Update function header
      ACPICA: Handle mis-matched package length
      ACPICA: Handle case NumElements > Package length
      ACPICA: Delete recursive feature of ACPI Global Lock
      ACPICA: Release global lock from interrupt handler
      ACPICA: Cast acpi_thread_id to UINT32 for debug output only
      ACPICA: Temporary fix for BankValue parameter
      ACPICA: Update version to 20060721
      ACPICA: Update debug output
      ACPICA: Implement simplified Table Manager
      ACPICA: misc fixes for new Table Manager:
      ACPICA: Update comments for individual table fields
      ACPICA: Fix for FADT conversion in 64-bit mode
      ACPICA: Lint changes
      ACPICA: Add support for DMAR table
      ACPICA: Add acpi_gpe_count global to track the number of GPE events
      ACPICA: Disable all wake GPEs after first one recieved
      ACPICA: Fix unalignment in acpi_ut_repair_name
      ACPICA: Split acpi_format_exception into two parts
      ACPICA: Update version to 20060831
      ACPICA: Cleanup of FADT verification function.
      ACPICA: Create tbfadt.c to hold all FADT-related functions
      ACPICA: Re-implement interpreters' "serialized mode"
      ACPICA: Delete stale FADT functions outside tbfadt.c.
      ACPICA: Update comments in tbfadt.c
      ACPICA: add ASF comment
      ACPICA: re-factor table init routines for benefit of iASL
      ACPICA: Allow type ANY to be the target of the Scope operator.
      ACPICA: IsResourceTemplate now returns ACPI_STATUS
      ACPICA: Add declarations for ASF! sub-tables
      ACPICA: FADT verification is now table driven.
      ACPICA: Report error if method creates 2 objects with the same name
      ACPICA: New common routine for creating and verifying a local FADT.
      ACPICA: Fix memory leak in table load error path
      ACPICA: Fix trace output name and whitespace
      ACPICA: Update version to 20060912
      ACPICA: Add full table name to disassembler output
      ACPICA: Fix for Global Lock semaphore.
      ACPICA: Remove obsolete Flags parameter.
      ACPICA: Use faster ByIndex interface to get FACS
      ACPICA: On AML mutex force-release, set depth to zero (was 1).
      ACPICA: Update interpreter error paths to always report the error
      ACPICA: Add new subsystem state bit that is set after SubsystemInitialize is called
      ACPICA: Update version to 20060927
      ACPICA: Fix race condition with AcpiWalkNamespace.
      ACPICA: _CID support for PCI Root Bridge detection.
      ACPICA: Use manifest constants for parse pass number
      ACPICA: Update comments
      ACPICA: Abort downward walk on temporary node detection.
      ACPICA: Fixes for parameter validation.
      ACPICA: Update version to 20061011
      ACPICA: Update debug output routines for data structure changes
      ACPICA: Remove global lock handler on AcpiTerminate.
      ACPICA: Ensure that all structures in acobject.h are aligned, via #pragma.
      ACPICA: Add ACPI_MAX macro
      ACPICA: Fail AcpiEnable if ACPI tables not loaded.
      ACPICA: Add include of actables.h
      ACPICA: Update version to 20061109
      ACPICA: Removed all 16-bit support.
      ACPICA: Debugger multithreading enhancements.
      ACPICA: Update a comment.
      ACPICA: Added option to display memory statistics upon termination.
      ACPICA: Update version to 20061215
      ACPICA: Update copyright to 2007.
      ACPICA: Fix for incorrect parameter passed to AcpiTbDeleteTable during table load.
      ACPICA: Update version to 20070126

Corentin Chary (7):
      asus-laptop: add base driver
      asus-laptop: add led support
      asus-laptop: add bluetooth and wlan support
      asus-laptop: add backlight support
      asus-laptop: add display switching support
      asus-laptop: add ledd support
      asus-laptop: add light sensor support

Fiodor Suietov (2):
      ACPICA: fix for object premature deletion
      ACPICA: Fix for possible memory leak and fault.

John Keller (2):
      Altix: ACPI SSDT PCI device support
      Altix: Add ACPI SSDT PCI device support (hotplug)

Justin Chen (1):
      ACPI: Optimize acpi_get_pci_rootbridge_handle() to boot faster

Kristen Carlson Accardi (4):
      ACPI: dock: check if parent is on dock
      ACPI: bay: new driver adding removable drive bay support
      ACPI: bay: remove prototype procfs code
      ACPI: bay: make bay a platform driver

Len Brown (8):
      asus-laptop: Lindent
      ACPI: delete unused acpi_device_get_debug_info()
      ACPI: prevent build failure when CONFIG_X86_NUMAQ=y
      ACPICA: reduce conflicts with Altix patch series
      ACPI: bay: delete unused variable
      ACPI: bay: new driver is EXPERIMENTAL
      asus-laptop: merge with ACPICA table update
      ACPICA: reduce table header messages to fit within 80 columns

Li Shaohua (5):
      ACPI: adjust init order
      ACPI: add acpi_bus_ops in acpi_device
      ACPI: add acpi_bus_removal_type in acpi_device
      ACPI: consolidate two motherboard drivers into one
      ACPI: Convert ACPI PCI .bind/.unbind to use PCI bridge driver

Mikhail Kouzmich (1):
      ACPICA: Restructured module into multiple functions.

Patrick Mochel (4):
      ACPI: add device_driver and hepler functions
      ACPI: add ACPI bus_type for driver model
      ACPI: change registration interface to follow driver model
      ACPI: convert to sysfs framework

Robert P. J. Day (1):
      ACPI: Correct ACPI_DEBUG_OUTPUT typo

Rui Zhang (2):
      ACPI: fix Supermicro X7DB8+ Boot regression
      ACPI: video: fix LCD monitor seen as CRT

Valery A. Podrezov (1):
      ACPICA: Enhance debugger statistics/memory command.

Valery Podrezov (1):
      ACPICA: Eliminate control method 2-pass parse/execute.

Yu Luming (3):
      output: Add display output class support
      output: Add output class document
      ACPI: Adds backlight sysfs support for acpi video driver.

Zhang Rui (9):
      ACPI: clean up scan.c
      ACPI: rename some functions
      ACPI: Set fake hid for non-PNPID ACPI devices
      ACPI: use PNPID:instance_no as bus_id of ACPI device
      ACPI: use more understandable bus_id for ACPI devices
      ACPI: add a Kconfig option for ACPI procfs interface
      ACPI: add ACPI debug attribute in sysfs
      ACPI: add ACPICA version in sysfs
      ACPI: bay: Convert ACPI Bay driver to be compatible with sysfs update.

with this log:

commit 57e1c5c87db512629dd44ddeb882a5aaf0e4299e
Merge: 62d0cfc... 76a2e84...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 6 15:31:00 2007 -0500

    Pull test into release branch

commit 76a2e849df47697706024262a8bbb83432b8bde7
Merge: 894d79b... 03c6d13...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 6 15:30:03 2007 -0500

    Pull acpica into test branch

commit 03c6d130f690dba46387480de80acf458a6fd14c
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 6 15:28:23 2007 -0500

    ACPICA: reduce table header messages to fit within 80 columns
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 894d79bedd8b48fe838083f2d2a42ac09817c530
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 3 02:13:53 2007 -0500

    asus-laptop: merge with ACPICA table update
    
    No longer need a buffer for a copy of the DSDT,
    just a pointer to the mapped table.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 274ec7a8c07036bd02e8f2301456e443ef30b8a8
Merge: 6b25970... b03637b...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 3 01:39:22 2007 -0500

    Pull output-switch into test branch

commit 6b259707d53f0f25f0b24318a0774f1ae7e7e92c
Merge: a4144e4... db503422...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 3 01:39:07 2007 -0500

    Pull trivial into test branch
    
    Conflicts:
    
    	drivers/acpi/scan.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4144e451ce1951e8dad2aa8e2288f75ab745172
Merge: eee3c85... 8def05f...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 3 01:38:30 2007 -0500

    Pull asus into test branch

commit eee3c859c486d4f110f154807430eaf825ff4a3d
Merge: 5473526... fb5c3e1...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 3 01:38:16 2007 -0500

    Pull motherboard into test branch
    
    Conflicts:
    
    	drivers/acpi/motherboard.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 547352660506ab99d6b0bad58dea495bf3718cee
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 11 02:09:09 2007 -0500

    ACPI: bay: Convert ACPI Bay driver to be compatible with sysfs update.
    
    	Set fake hid for ejectable drive bay.
    	Match bay devices by checking the hid.
    	Remove .match method of Bay driver.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 975a8e3ed2b9eab9f062a1e0ba7fe180e15204e1
Merge: 1fcb71b... bfd8022...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 3 01:14:35 2007 -0500

    Pull sysfs into test branch
    
    Conflicts:
    
    	Documentation/feature-removal-schedule.txt
    	include/acpi/acpi_drivers.h
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1fcb71b84b05ff3bfd5b5b2eca9a9b3d13a76e3a
Merge: e8bdc5a... 0ed1e38...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 3 01:12:39 2007 -0500

    Pull bay into test branch

commit 0ed1e38d513ea683ce125e698dd41d31441e0e8c
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 2 22:39:16 2007 -0500

    ACPI: bay: new driver is EXPERIMENTAL
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5d22e1e83aac1f81f948ac8bff281487c11cc967
Author: Adrian Bunk <bunk@stusta.de>
Date:   Mon Dec 4 14:49:39 2006 -0800

    ACPI: bay: make drive_bays static
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b167c01190b647c976e7fab312f2e3d3b3a785f
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Mon Dec 18 18:07:00 2006 -0500

    ACPI: bay: make bay a platform driver
    
    Convert the bay driver to be a platform driver, so that we can have
    sysfs entries.
    
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e9dd85e5bdff2a3981dfaa55869ba920e985ea8a
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Mon Dec 18 18:06:00 2006 -0500

    ACPI: bay: remove prototype procfs code
    
    Remove all the procfs related code.
    
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5447cbb278fd01c402180ab1e820b95101e782fa
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 21 01:15:41 2006 -0400

    ACPI: bay: delete unused variable
    
    drivers/acpi/bay.c: In function ‘bay_notify’:
    drivers/acpi/bay.c:491: warning: unused variable ‘bay’
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 01b57e73728880b787c85e27ad06c249412813b1
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Fri Oct 20 14:30:25 2006 -0700

    ACPI: bay: new driver adding removable drive bay support
    
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fe9a2f77e5ad508b18671571c0b3f6f79ea709a8
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Fri Feb 2 22:33:00 2007 -0500

    ACPI: dock: check if parent is on dock
    
    When determining if a device is on a dock station, we should
    check the parent of the device as well.
    
    Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e8bdc5a9c56c140c732246a298922c3cf3777460
Merge: c6f4bc2... b0b7eaa...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 3 01:08:52 2007 -0500

    Pull acpica into test branch

commit b0b7eaaf0c7aefd118d3ff8640fbed75a9fad9a1
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Thu Jan 25 22:39:44 2007 -0500

    ACPICA: fix gcc build warnings
    
    drivers/acpi/namespace/nsparse.c:126: warning: int format, different type arg (arg 7)
    drivers/acpi/tables/tbfadt.c:224: warning: unsigned int format, different type arg (arg 6)
    drivers/acpi/utilities/utdebug.c:184: warning: cast from pointer to integer of different size
    drivers/acpi/utilities/utdebug.c:184: warning: cast from pointer to integer of different size
    drivers/acpi/utilities/utdebug.c:197: warning: cast from pointer to integer of different size
    drivers/acpi/processor_idle.c:1093: warning: long long unsigned int format, u64 arg (arg 5)
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c6f4bc211122c86de85a6c93f139319957fd1f8a
Merge: 7e23772... 82cae99...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 2 22:42:44 2007 -0500

    Pull bugzilla-7349 into test branch

commit 7e23772f414cdbfb2a08aed237d6e926bb1cb728
Merge: bcd8b54... 2f3d000...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 2 22:42:02 2007 -0500

    Pull video into test branch

commit bcd8b54f7d9c980b945d3f1cc48f76f2fa6e2e1b
Merge: e47fddf... d91a007...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 2 22:21:10 2007 -0500

    Pull hp-pci-root into test branch

commit 3e643e77a929202455a0cc868c2030a5ba8d1371
Author: John Keller <jpk@sgi.com>
Date:   Tue Jan 30 01:18:38 2007 -0500

    Altix: Add ACPI SSDT PCI device support (hotplug)
    
    Support for dynamic loading and unloading of ACPI SSDT tables upon slot
    hotplugs and unplugs.
    
    On SN platforms, we now represent every populated root bus slot with a single
    ACPI SSDT table containing info for every device and PPB attached to the slot.
     These SSDTs are generated by the prom at initial boot and hotplug time.  The
    info in these SSDT tables is used by the SN kernel IO "fixup" code (which is
    called at boot and hotplug time).
    
    On hotplugs (i.e.  enable_slot()), if running with an ACPI capable prom,
    attempt to obtain a new ACPI SSDT table for the slot being hotplugged.  If
    successful, add the table to the ACPI namespace (acpi_load_table()) and then
    walk the new devices and add them to the ACPI infrastructure (acpi_bus_add()).
    
    On hot unplugs (i.e.  disable_slot()), if running with an ACPI capable prom,
    attempt to remove the SSDT table associated with the slot from the ACPI
    namespace (acpi_unload_table_id()) and infastructure (acpi_bus_trim()).
    
    From: John Keller <jpk@sgi.com>
    
     A bug was fixed where the sgi hotplug driver was removing
     the slot's SSDT table from the ACPI namespace a bit too early in
     disable_slot(). Also, we now call acpi_bus_start() subsequent
     to acpi_bus_add().
    
    Signed-off-by: Aaron Young <ayoung@sgi.com>
    Cc: Greg KH <greg@kroah.com>
    Cc: "Luck, Tony" <tony.luck@intel.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown<len.brown@intel.com>

commit 6f09a9250a5d76c0765cd51a33e0a042e9761cfc
Author: John Keller <jpk@sgi.com>
Date:   Tue Jan 30 01:17:37 2007 -0500

    Altix: ACPI SSDT PCI device support
    
    Add SN platform support for running with an ACPI
    capable PROM that defines PCI devices in SSDT
    tables. There is a SSDT table for every occupied
    slot on a root bus, containing info for every
    PPB and/or device on the bus. The SSDTs will be
    dynamically loaded/unloaded at hotplug enable/disable.
    
    Platform specific information that is currently
    passed via a SAL call, will now be passed via the
    Vendor resource in the ACPI Device object(s) defined
    in each SSDT.
    
    Signed-off-by: John Keller <jpk@sgi.com>
    Cc: Greg KH <greg@kroah.com>
    Cc: "Luck, Tony" <tony.luck@intel.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 647fb47dfabeffd2f1706013ebf5cfc92b70d273
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 2 22:14:22 2007 -0500

    ACPICA: reduce conflicts with Altix patch series
    
    Syntax only -- no functional changes.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit defad23020bb7701b3ad414135c73fc03054507b
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Fri Feb 2 22:02:55 2007 -0500

    ACPI_NUMA: fix HP IA64 simulator issue with extended memory domain
    
    ACPI 3.0 incorporated the SRAT spec, upping the table version to 2,
    and extending the size of the proximity domain from 1-byte to 4-bytes.
    This extension was into a reserved field that firmware should
    set to 0, but the HP simulator had non-zero values there
    resulting in unexpected huge numbers.
    
    So mask the domain down to 8-bits for now.
    A more general fix will be to check the table version
    supplied by firmware and get paranoid about reserved fields.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 45eded8703c0f9d58a8807f80baa9fe98ac0ec67
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Fri Feb 2 21:48:40 2007 -0500

    ACPI: fix HP RX2600 IA64 boot
    
    Copy space_id of GAS structure to newly created GAS.
    The previous FADT conversion code defaulted to IO space.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0e5683350f5bcd23d5d579f91d488caeda432617
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Fri Feb 2 21:37:53 2007 -0500

    ACPI: build fix for IBM x440 - CONFIG_X86_SUMMIT
    
    i386 srat.c broke due to re-names from ACPICA table-manager re-write.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5763d3c7a0c2b165504954b1eeb898fb8d97d8f5
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:24 2007 +0300

    ACPICA: Update version to 20070126
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 035f994b3ccfcfc555f838e2f33a2e49721e8533
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:24 2007 +0300

    ACPICA: Fix for incorrect parameter passed to AcpiTbDeleteTable during table load.
    
    Bad pointer was passed in the case where the DSDT is overridden.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6c9deb7201d96733dcd1b4cc44e99232308db359
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:24 2007 +0300

    ACPICA: Update copyright to 2007.
    
    Added 2007 copyright to all module headers and signons. This affects
    virtually every file in the ACPICA core subsystem, iASL compiler,
    and the utilities.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 11bf04c44fd284a5f4e2348a04da6f749cace250
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Allow processor to be declared with the Device() instead of Processor()
    
    Allow processor to be declered with the Device(), such as:
    Device(CPU1234) {
    	Name(_HID, "ACPI007")
    	Name(_UID, 1234)
    }
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f18c5a08bf035b51939281f5b49aa3ae45cea6ce
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Allow ACPI id to be u32 instead of u8.
    
    Allow ACPI id to be u32 instead of u8.
    Requires drop of conversion tables with the acpiid as index.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5008740e27540e4069a2f8235f8308aba46036a2
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Update version to 20061215
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d41eb99bac4063aa3fac2dbb8ca01bedd9f0b3bf
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Added option to display memory statistics upon termination.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit afbb9e659d584bd5bf0604848c91afd5761ed7a1
Author: Valery A. Podrezov <valery.a.podrezov@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Enhance debugger statistics/memory command.
    
    Debugger: Enhanced the Statistics/Memory command to emit the
    total (maximum) memory used during execution, as well as the
    maximum memory consumed by each of the various object types.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ea5415785146afe37dd2d1179a6c3a34fd26b52f
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Update a comment.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2e23f8513e9d0cc6d07d36e4555badc2518df433
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Debugger multithreading enhancements.
    
    Implemented enhancements to the multithreading support within
    the debugger to enable better multithreading evaluation of the subsystem.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 59fa85057e12ff135df54266722b2064c418fc05
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Removed all 16-bit support.
    
    Support for 16-bit ACPICA has been completely removed since it is
    no longer necessary and it clutters the code. All 16-bit macros,
    types, and conditional compiles have been removed, cleaning up
    and simplifying the code across the entire subsystem.
    DOS support is no longer needed since the Linux firmware kit
    is now available.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff40c8a3f258e9a54b0b94b92d5e2d9d88a39954
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Update version to 20061109
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1a666f8be16a0e1580e0f37e1322d06affb84e1b
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Add include of actables.h
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c857303ad496e1f52955e95994a67869882e89f9
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Fail AcpiEnable if ACPI tables not loaded.
    
    AcpiEnable will now fail if all of the required ACPI tables are not
    loaded (FADT, FACS, DSDT). BZ 477
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 987c21a0b0081d480ec3cd04875509cdc10e15e7
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Add ACPI_MAX macro
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7c9626bade13de3f160f0926455328650045d6cd
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:23 2007 +0300

    ACPICA: Ensure that all structures in acobject.h are aligned, via #pragma.
    
    Thus, even if the default compiler setting is non-aligned, the header is compiled
     correctly.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8876016bb384044a59c1e2ddcad4cf41b06344b9
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Remove global lock handler on AcpiTerminate.
    
    Added AcpiEvRemoveGlobalLockHandler
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a6823e12ca3f79a8c0f8b2d14976ab2152d117e5
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Fixes for load() operator.
    
    Optimized the Load operator in the case where the source operand is an
    operation region. Simply map the operation region memory, instead of
    performing a bytewise read.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 428f211297bc95fd41f23830eab4180339020dd0
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Miscellaneous table manager updates and optimizations
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 77f6a9fca39f4f19d2d9d5fff1ff5c2ccf20629c
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Update debug output routines for data structure changes
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 15a58ed12142939d51076380e6e58af477ad96ec
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Remove duplicate table definitions (non-conflicting), cont
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5f3b1a8b6737b09ce5df4ec9fad4ad271aecb5fb
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Remove duplicate table definitions (non-conflicting)
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad363f80c386bc4701b1bc2cdf08ca9b96a9337b
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Remove duplicate table definitions.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cee324b145a1e5488b34191de670e5ed1d346ebb
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: use new ACPI headers.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ceb6c46839021d5c7c338d48deac616944660124
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Remove duplicate table manager
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a7a22fa9c368ba22f13b87585052b8cdbbc18f7a
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Update version to 20061011
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f1c2b1daf040d2feebfbbd4a0cd80cde856fc031
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:22 2007 +0300

    ACPICA: Fixes for parameter validation.
    
    Extra checks for valid handle/path combinations, BZ 478
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1014629c0fc563be65e675e72bcc9bd7db50195
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Abort downward walk on temporary node detection.
    
    Enhancement to code that ignores temporary  namespace nodes
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3effba32069514e56bcb778f90cd34fdbac79a50
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Update comments
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ec3153fb0e96988dc7e378b3ab01e05131ba713b
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Use manifest constants for parse pass number
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7a69806308600711589e4ca306d18dd029ef0cf
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: _CID support for PCI Root Bridge detection.
    
    Implemented _CID support for PCI Root Bridge detection. If the _HID
    does not match the predefined root bridge IDs, the _CID list (if present)
     is now obtained and also checked for an ID match
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d1fdda83f7c567f376ddd4305833de09f7919ca9
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Fix race condition with AcpiWalkNamespace.
    
    Fixed a problem with a possible race condition between threads executing
    AcpiWalkNamespace and the AML interpreter. This condition was removed by
    modifying AcpiWalkNamespace to (by default) ignore all temporary
    namespace entries created during any concurrent control method execution
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9bc75cff4919f9d947982d805aed89582a20d04d
Author: Valery Podrezov <valery.a.podrezov@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Eliminate control method 2-pass parse/execute.
    
    Completed an AML interpreter performance enhancement for control method
    execution. Previously a 2-pass parse/execution, control methods are now
    completely parsed and executed in single pass. This improves overall
    interpreter performance by ~25%, reduces code size, and reduces CPU stack use.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d0b4af958453afe871022e44abd57fac09baf67
Author: Mikhail Kouzmich <mikhail.v.kouzmich@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Restructured module into multiple functions.
    
    Restructured the AML ParseLoop function, breaking it into several
    subfunctions in order to reduce CPU stack use and improve maintainability
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b705a8abbce1753c1e5af5ae2ed97e374277654
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Update version to 20060927
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cb219bb6bf6f8cabdf07fbbca8487eee5a91ff05
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Add new subsystem state bit that is set after SubsystemInitialize is called
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 65e4b9b05dc10ee84b5c9fc3039fbcc6863743d7
Author: Fiodor Suietov <fiodor.f.suietov@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Fix for possible memory leak and fault.
    
    Fixed a possible memory leak and fault in acpi_ex_resolve_object_to_value()
    during a read from a buffer or region field. (BZ 458)
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 867c9aec576e0c0d89dfa3922019320619002129
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Update interpreter error paths to always report the error
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f70a5e7b6c28e0b08f721204f4b98c5d1cfb44d9
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: On AML mutex force-release, set depth to zero (was 1).
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 310a7f7fee489b7dadd27b0d8487bd0ce66281e7
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Use faster ByIndex interface to get FACS
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8c71b6d3b21cf21ad775e1cf6da95bf87bd5ad4
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Remove obsolete Flags parameter.
    
    Remove flags parameter for acpi_{get,set}_register().
    It is no longer necessary now that these functions use a
    spinlock for mutual exclusion.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 73ca0fbcc25a6080db4136f55dbcd5fe7b33398f
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Fix for Global Lock semaphore.
    
    Fixed a problem with the Global Lock where the lock could appear to be obtained before it is actually obtained, semaphore created with one unit.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 14d64b5e36a82ef21a51d8a15639d26b75a79499
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:21 2007 +0300

    ACPICA: Add full table name to disassembler output
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4cdf469090f732ab8a45b2d30b43ec5745699285
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Update version to 20060912
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 977a6226feae3e2c10a4d8227625ff0f04b49239
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Fix trace output name and whitespace
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0fab8997f18f71b2391e72e49d8d31a395352dcc
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Fix memory leak in table load error path
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7139284460fba90c4dfcfae76680ad36b45f5982
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: New common routine for creating and verifying a local FADT.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 13b572a35ed904ae1e162f8ee89ca7fd6992b44c
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Report error if method creates 2 objects with the same name
    
    Fixed a regression where an error was no
    longer emitted if a control method attempts to create 2
    objects of the same name. This previously and now returns
    AE_ALREADY_EXISTS. When this exception occurs, it invokes
    the mechanism that will dynamically serialize the control
    method to possible prevent future errors. (BZ 440)
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ea5d8ebcbb7ca3bcb35a2133805571295f3f06e8
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: FADT verification is now table driven.
    
    Disassembler now verifies an input
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 775d85b6aa33116da8aacad4168c540ce86a1803
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Add declarations for ASF! sub-tables
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cc2a472b8411ce0b71738039e15d45917da30fbe
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: IsResourceTemplate now returns ACPI_STATUS
    
    to differentiate the failure modes.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 15f0c0d1ef7804d098fe3eb0a3f350a490ca269c
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Allow type ANY to be the target of the Scope operator.
    
    Useful during disassembly where the target may
    be in a different table and thus the type is unknown.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 77389e1263a7c9bc8040bda726e08b6501ba1c8b
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: re-factor table init routines for benefit of iASL
    
    Required new table init interface since iASL does not use RSDP/XSDT.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 694b0b2092bce3f4610626b04158a6f3a95058e6
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: add ASF comment
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e56b638bbee3c17b0dee39495bd15afe64db1b94
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Update comments in tbfadt.c
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 765ec20180fb70b4ee9d730167b2a0b76879f791
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Delete stale FADT functions outside tbfadt.c.
    
    Moved all FADT-related functions to a new file, tbfadt.c.
    Eliminated the acpi_hw_initialize function - the
    FADT registers are now validated when the table is loaded.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1ba753acb372c2955a4843302e92e49ce82e2fea
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Re-implement interpreters' "serialized mode"
    
    Enhanced the implementation of the interpreters'
    serialized mode (boot with "acpi_serialize" to set
    acpi_glb_all_methods_serialized flag.)
    When this mode is specified, instead of creating a serialization
    semaphore per control method, the interpreter lock is
    simply no longer released before a blocking operation
    during control method execution. This effectively makes
    the AML Interpreter single-threaded. The overhead of a
    semaphore per-method is eliminated.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95befdb398e0112ede80529f6770644ecfa5a82e
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Create tbfadt.c to hold all FADT-related functions
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b89b71a0019660d73e3c9671205c49e443d7085c
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Cleanup of FADT verification function.
    
    Removed offset display, not needed.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0eaa14c02809cc93386b907846da5c024fd73012
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:20 2007 +0300

    ACPICA: Update version to 20060831
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 84fb2c97731c1631c5548c15f3698ad82c274245
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Split acpi_format_exception into two parts
    
    Split acpi_format_exception into two parts. New
    function is acpi_ut_verify_exception and will be used to
    verify exception codes returned by user.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 69874165ab953a62f9adb3096ccd84ed2561a602
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Store GPE number instead of bitmask
    
    Update internal GPE data structure to simplify
    debug, use gpe_number instead of register bitmask.
    
    Signed-off-by: Bob Moore <bob.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3d81b236a82a26fa8bdef9096829675d81890dc9
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Fix unalignment in acpi_ut_repair_name
    
    Update interface to acpi_ut_repair_name() to avoid
    alignment issues on IA64
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c5a7156959e89b32260ad6072bbf5077bcdfbeee
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Disable all wake GPEs after first one recieved
    
    Change for GPE support: when a wake GPE is
    received, now all wake GPEs are immediately disabled to
    prevent the waking GPE from firing again, and to prevent
    other wake GPEs from interrupting the wake process.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fdffb72d23172c91af56983f303d1986994df522
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Add acpi_gpe_count global to track the number of GPE events
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2502fffb1958da66fa50a475081cb6827acdd9f3
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Add support for DMAR table
    
    Implement support for ACPI DMAR table (DMA
    Remapping Table) in header files and disassembler.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad71860a17ba33eb0e673e9e2cf5ba0d8e3e3fdd
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: minimal patch to integrate new tables into Linux
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4bbb810dedaecf74d54b16b6dd3c33e95e1024c
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Lint changes
    
    Lint changes
    Move RSDT/XSDT pointer extraction to separate function
    Warning on 32-bit platforms if XSDT pointers use more than 32 bits.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4bf273939c99fae5bae399f51c417a552d74b97f
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Fix for FADT conversion in 64-bit mode
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8f34890dce60f7df6dd23a0d04977c6572adaab8
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: Update comments for individual table fields
    
    comments only
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c5fc42ac4d4d6d3e3f619290b86890cb3725d2f8
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:19 2007 +0300

    ACPICA: misc fixes for new Table Manager:
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f3d2e7865c816258c699ff965768e46b50d536d3
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Implement simplified Table Manager
    
    The Table Manager component has been completely
    redesigned and reimplemented. The new design is much
    simpler, and reduces the overall code and data size of
    the kernel-resident ACPICA by approximately 5%. Also,
    it is now possible to obtain the ACPI tables very early
    during kernel initialization, even before dynamic memory
    management is initialized.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2e42005bcdb4f63bed1cea7f537a5534d4bd7a57
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Update debug output
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f93a21c7184de3db962d01f11eb2ddad5396c824
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Update version to 20060721
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9c52657a2ac8aac5149e11049497b10918e1f58f
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Temporary fix for BankValue parameter
    
    Temporary fix for BankValue parameter of a Bank
    Field to support all constant values, including Zero
    and One. Must eventually be converted to a full TermArg
    evaluation.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6b366e2fe1b68bd9af55caf166eaaf0609ba18a9
Author: Fiodor Suietov <fiodor.f.suietov@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: fix for object premature deletion
    
    Fix for object premature deletion after CopyObject
    on Operation Region (BZ 350)
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0654a6d3c7a777ddccd35c5bbc5765ffbfe3ea96
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Cast acpi_thread_id to UINT32 for debug output only
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a72d47563bce9542b9a83521a4e8175076278ee9
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Release global lock from interrupt handler
    
    The ACPI Global Lock interrupt handler no longer
    queues the execution of a separate thread to signal the
    global lock semaphore. Instead, the semaphore is signaled
    directly from the interrupt handler.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c81da66608d65dab04730582dfdfcdcab779e2fe
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Delete recursive feature of ACPI Global Lock
    
    Completed a new design and implementation for
    the ACPI Global Lock support. On the OS side, the global
    lock is now treated as a standard AML mutex. Previously,
    multiple OS threads could acquire the global lock
    simultaneously, but this could cause the BIOS to be starved
    by the lock in cases such as the Embedded Controller driver,
    where there is a tight coupling between the OS and the BIOS.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8f9337c88335846b01801b1047a4caf10527a320
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Handle case NumElements > Package length
    
    Additional update for NumElements fix. Must handle
    case where NumElements > Package list length, pad package
    with null elements.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 24058054d781934df526be114c612cf2b29cf4e7
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Handle mis-matched package length
    
    Implement support within the AML interpreter for
    package objects that contain a mismatch between the AML
    length and package element count. In this case, the lesser
    of the two is used. Some BIOS code apparently modifies
    the package length on the fly, and this change supports
    this. Provides compatibility with the MS AML interpreter.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9e3ba2c1d178195e17bb4f1d49c32e0be8dbb16
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Feb 2 19:48:18 2007 +0300

    ACPICA: Update function header
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db50342205deabaff9ce1fbe53d5ba351992fa08
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 2 21:05:04 2007 -0500

    ACPI: prevent build failure when CONFIG_X86_NUMAQ=y
    
    ...by disabling CONFIG_ACPI when CONFIG_X86_NUMAQ=y
    
    otherwise arch/i386/pci/Makefile forgets
    that it needs to build acpi.o
    
    drivers/built-in.o: In function `acpi_pci_root_add':
    pci_root.c:(.text+0x45ec4): undefined reference to `pci_acpi_scan_root'
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bfd80223d73f80e1d1c69dace9151756b3ef3b49
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Wed Jan 31 16:00:20 2007 -0800

    ACPI: correct id for fixed buttons
    
    ACPI_BUTTON_HID_POWERF was changed, but this change was not propogated to
    button.c, thus breaking detection of fixed power and sleep buttons.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7ac2735462349ca35d8807d93d66cf4d9ea7b729
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jan 30 02:13:44 2007 -0500

    ACPI: delete unused acpi_device_get_debug_info()
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 37cabc81640ddba28a2aa7f0d1286a1012eae248
Author: Robert P. J. Day <rpjday@mindspring.com>
Date:   Sat Jan 27 01:55:18 2007 -0500

    ACPI: Correct ACPI_DEBUG_OUTPUT typo
    
    -#ifdef CONFIG_ACPI_DEBUG_OUTPUT
    +#ifdef ACPI_DEBUG_OUTPUT
    
    As the former doesn't exist.
    
    Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8def05fa82bfa4af0c8e83a00ff377ddd9074480
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jan 30 01:46:43 2007 -0500

    asus-laptop: Lindent
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8b857353237c144113b9bbbf9e0236b3f0e7d315
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jan 26 14:04:58 2007 +0100

    asus-laptop: add light sensor support
    
    /proc/acpi/asus/lslvl is now /sys/.../asus-laptop/ls_level
    /proc/acpi/asus/lssw is now /sys/.../asus-laptop/ls_switch nothing
    else ..
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 722ad97153015aaf5becba3084565e98e71a2aed
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jan 26 14:04:55 2007 +0100

    asus-laptop: add ledd support
    
    Ledd is a special led ... /sys/.../asus-laptop/ledd works like
    /proc/acpi/asus/ledd
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 78127b4a90469d6973de2837d483f80f3709e6e0
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jan 26 14:04:49 2007 +0100

    asus-laptop: add display switching support
    
    /sys/.../asus-laptop/display can now be used to switch displays
    like the old /proc/acpi/asus/disp does
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6b7091e74fe176da97917ca60524e2b3554305f0
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jan 26 14:04:45 2007 +0100

    asus-laptop: add backlight support
    
    Adds backlight support using backlight class. We now
    change the brightness *and toggle the backlight !* via
    /sys/class/backlight/asus-laptop/.
    
    If the user switchs the backlight using the keyboard,
    asus_hotk_notify looks for ATKD_LCD_OFF and ATKD_LCD_ON events,
    and stores the right state into hotk->status and bd->props->power .
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4564de172dcdce641c0d6c689e79e95b5f6bee2c
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jan 26 14:04:40 2007 +0100

    asus-laptop: add bluetooth and wlan support
    
    WLED and BLED are not handled like other leds (MLED, etc ..),
    because sometime they also control the wlan/bluetooth device.
    If the method for wireless_status is found, it's used to get the
    status, otherwise hotk->status is used.  We also use the HWRS
    method, which tell if the bluetooth/wlan device is present or not.
    This patch show why we need a ASUS_SET_DEVICE_ATTR macro : if
    there is a bluetooth device, /sys/dev.../asus-laptop/bluetooth
    is usable, else it's not but it's clean.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit be18cdabb8ed40ff4b8a240e0d6f4e6c30ff866d
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jan 26 14:04:35 2007 +0100

    asus-laptop: add led support
    
    Add led support, using generic led class.  Thomas Tuttle's patch
    <http://lkml.org/lkml/2006/7/6/247> was very usefull.  We use
    hotk->status to store led status because it's very hard to find
    acpi method to get the right status...  To reduce the code,
    I use a lot of macro (ASUS_LED, ASUS_LED_REGISTER, etc ...),
    because the code is the same for all leds ...
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 85091b718969be7b8e6f795af7e264b8afcd7a6d
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Jan 26 14:04:30 2007 +0100

    asus-laptop: add base driver
    
    Adds the new driver and make ASUS_LAPTOP and ACPI_ASUS
    incompatible.  It may be strange to use ASUS_CREATE_DEVICE_ATTR
    and ASUS_SET_DEVICE_ATTR now, but these macro will be very
    usefull in next patchs.  ASUS_HANDLE and ASUS_HANDLE_INIT comes
    from IBM_HANDLE and IBM_HANDLE_INIT, with some modification,
    and will also be used in next patchs.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5bb730fda8aa4e3f7e94b259c468ecd095f60770
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jan 29 11:02:42 2007 +0800

    ACPI: add ACPICA version in sysfs
    
    Add an ACPI attribute to indicate ACPICA version.
    /proc/acpi/version is deprecated by /sys/module/acpi/parameters/acpica_version.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 219c3c8e268b9307eae9fae4c765a0c589b98338
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jan 29 11:02:38 2007 +0800

    ACPI: add ACPI debug attribute in sysfs
    
    Add ACPI debug attributes in sysfs.
    /proc/acpi/debug_layer && debug_level are deprecated by
    /sys/module/acpi/parameters/debug_layer && debug_level.
    
    NOTE: The operations to them are quite the same.
    E.g. if you want to enable ACPI_DB_INFO, ACPI_DB_WARN,
     ACPI_DB_ERROR and disable the others,
    #echo 0x13 >/sys/module/acpi/parameters/debug_level is OK,
    and a boot option "acpi.debug_level = 0x13" also works.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b981c591891dc8885de36498d38fa8d8a5481069
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jan 29 11:02:30 2007 +0800

    ACPI: add a Kconfig option for ACPI procfs interface
    
    Add a kconfig option CONFIG_ACPI_PROCFS to make procfs interface
    a configurable attribute of ACPI.
    
    No procfs interface is actually deprecated,
    and no sysfs interface is added in this patch.
    
    CONGI_ACPI_PROCFS is used to mark procfs interface as deprecated
    once the same function is duplicated in sysfs.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fb5c3e1b6d304bcf5f8d697471e36f2fa8d53f1c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Jan 24 00:49:19 2007 -0800

    PNPACPI: remove EXPERIMENTAL dependency
    
    PNPACPI is pretty widely used and seems fairly stable, so remove the
    dependency on EXPERIMENTAL.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Cc: Adam Belay <ambx1@neo.rr.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5eca338fb510af78eee5372ff6a3525768ab913f
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jan 18 16:44:48 2007 -0700

    ACPI: remove motherboard driver (redundant with PNP system driver)
    
    The PNP system board driver (drivers/pnp/system.c) contains all the
    same functionality, so we don't need the ACPI version.
    
    Previously, a motherboard device would be claimed by *both* the ACPI and
    PNP drivers, resulting in stuff like this in /proc/ioports:
    
        1200-121f : motherboard	<-- from drivers/acpi/motherboard.c
          1200-121f : pnp 00:0d	<-- from drivers/pnp/system.c
    
    Make sure to enable CONFIG_PNP (and CONFIG_PNPACPI) to include the
    PNP system board driver.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 10fccf5fda7529258325769e9da136064b481aab
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jan 18 16:44:24 2007 -0700

    i386: turn on CONFIG_PNP in defconfig
    
    I'm trying to remove drivers/acpi/motherboard.c, which is mostly
    redundant with drivers/pnp/system.c.  So make sure that we include the
    PNP driver in the default config.  Most distros enable this already.
    
    Turning on CONFIG_PNP also causes the following options to be enabled:
    
        CONFIG_PNPACPI
        CONFIG_SERIAL_8250_PNP
    
    CONFIG_SERIAL_8250_PNP causes legacy serial ports to be discovered
    twice, which is ugly but harmless:
    
        serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
        00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5859554c3ad31b722f0b5a1d3a40e19d8ccedd0b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jan 18 16:43:46 2007 -0700

    PNP: system.c whitespace cleanup
    
    No functional change.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a8c78f7fb1571764f48b8af5459abdd2c66a765f
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jan 18 16:43:27 2007 -0700

    PNP: reserve system board iomem resources as well as ioport resources
    
    Most x86 boxes have no iomem system board resources, but some ia64
    boxes do.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9a47cdb1bb85e7944fb7419e4078c46516ef7335
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jan 18 16:42:55 2007 -0700

    ACPI: move FADT resource reservations from motherboard driver to osl
    
    Resources described by the FADT aren't really a good fit for the
    ACPI motherboard driver.
    
    The motherboard driver cares about PNP0C01 and PNP0C02 devices and
    their resources.
    
    The FADT describes some resources used by the ACPI core.  Often, they
    are also described by by the _CRS of a motherboard device, but I think
    it's better to reserve them specifically in the ACPI osl.c because
    (a) the motherboard driver is optional and ACPI uses the resources even
    if the driver is absent, and (b) I want to remove the ACPI motherboard
    driver because it's mostly redundant with the PNP system.c driver.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d91a0078476ca536d76419f3b53196873b2931bc
Author: Justin Chen <justin.chen@hp.com>
Date:   Wed Dec 6 10:17:10 2006 -0700

    ACPI: Optimize acpi_get_pci_rootbridge_handle() to boot faster
    
    Move acpi_get_pci_rootbridge_handle() from glue.c to pci_root.c and get the
    root bridge ACPI handles by searching the &acpi_pci_roots list instead of
    walking through the ACPI name space.  This significantly reduces boot time
    on large I/O systems.
    
    Signed-off-by: Justin Chen <justin.chen@hp.com>
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bb0958544f3c7c016b2a3025ab3694363e403aa1
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 4 15:03:18 2007 +0800

    ACPI: use more understandable bus_id for ACPI devices
    
    Some of the ACPI devices use the internal fake hids
    which are exposed to userspace as devces' bus_id after sysfs conversion.
    To make it more friendly, we convert them to more understandable strings.
    
    For those devices w/o PNPids, we use "device:instance_no" as the bus_id
    instead of "PNPIDNON:instance_no".
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 82cae99980c158cb9724415547ca59cf95c58792
Author: Rui Zhang <rui.zhang@intel.com>
Date:   Wed Jan 3 23:40:53 2007 -0500

    ACPI: video: fix LCD monitor seen as CRT
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7349
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2786f6e388e9dfe9e7b1c3c6bd7fcfba9cfb9831
Author: Rui Zhang <rui.zhang@intel.com>
Date:   Thu Dec 21 02:21:13 2006 -0500

    ACPI: fix Supermicro X7DB8+ Boot regression
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7695
    
    Originally we converted bind/unbind to use a new pci bridge driver.
    The driver will add/remove _PRT, so we can eventually remove
    .bind/.unbind methods.
    
    But we found that some of the _ADR-Based devices don't have _PRT,
    i.e. they are not managed by the new ACPI PCI bridge driver.
    So that .bind method is not called for some _ADR-Based devices,
    which leads to a failure.
    
    Now we make ACPI PCI Root Bridge Driver scan and binds all _ADR-Based devices
    once the driver is loaded, in the .add method of ACPI PCI Root Bridge driver.
    
    Extra code path for calling .bind/.unbind when _ADR-Based devices
    are hot added/removed is also added.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e49bd2dd5a503bb94fe2f2af45422b610940b75d
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Dec 8 17:23:43 2006 +0800

    ACPI: use PNPID:instance_no as bus_id of ACPI device
    
    Previously we used the device name in the DSDT, but would
    crash upon encountering a duplicate. Also, exposing the
    DSDT device name to the user in a patch isn't a good idea,
    because it is arbitrary.
    
    After some discussion, we finally decided to use
    "PNPID:instance_no" as the bus_id of ACPI devices.
    
    Two attributes for each device are added at the same time,
    the full pathname in ACPI namespace and hardware_id if it has.
    
    NOTE:	acpi_bus_id_list is used to keep the information of PNPID
    	and instance number of the given PNPID. Loop the
    	acpi_bus_id_list to find the instance_no of the	same PNPID
    	when register a device. If failed, i.e. we don't have a
    	node with this PNPID, allocate one and link it to this list.
    
    NOTE:	Now I don't take the memory free work in charge.
    	If necessary, I can add a reference count in
    	struct acpi_device_bus_id, and check the reference and
    	when unregister a device, i.e. memory is freed when
    	the reference count of a given PNPID is 0.
    
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2f3d000a133f68250635f14f6caf24d32d358090
Author: Yu Luming <luming.yu@gmail.com>
Date:   Sat Nov 11 02:40:34 2006 +0800

    ACPI: Adds backlight sysfs support for acpi video driver.
    
    Adds backlight sysfs support for acpi video driver.
    
    signed-off-by: Luming Yu <Luming.yu@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b03637b8863159a4518cb0a9ab90577460fe3417
Author: Yu Luming <luming.yu@gmail.com>
Date:   Tue Dec 19 12:56:18 2006 -0800

    output: Add output class document
    
    Signed-off-by: Luming Yu <Luming.yu@intel.com>
    Cc: "Antonino A. Daplas" <adaplas@pol.net>
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2dec3ba8d872aa3ffbcdb8f6f8a2c0bcd44e9910
Author: Yu Luming <luming.yu@gmail.com>
Date:   Tue Dec 19 12:56:17 2006 -0800

    output: Add display output class support
    
    Add generic abstract layer for display output switch control.  The output
    sysfs class driver provides an abstract video output layer that can be used to
    hook platform specific methods to enable/disable video output device through
    common sysfs interface.
    
    Signed-off-by: Luming Yu <Luming.yu@intel.com>
    Cc: "Antonino A. Daplas" <adaplas@pol.net>
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ae8433324be16673c75951986dcf85f29c090557
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Dec 7 20:57:10 2006 +0800

    ACPI: Set fake hid for non-PNPID ACPI devices
    
    We do this mainly because:
    1.	hid is used to match ACPI devices and drivers.
    	.match method which is incompatible to driver model
    	can be deleted from acpi_driver.ops then.
    2.	As the .uevent method mark ACPI drivers by PNPID,
    	fake hid is set to non-PNPID devices so that udev script
    	can load the right ACPI driver by looking for
    	"HWID = " or "COMPTID = ".
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db3e1cc3257758d8a694d0a6ab29f109fb019853
Author: Li Shaohua <shaohua.li@intel.com>
Date:   Thu Dec 7 20:57:05 2006 +0800

    ACPI: Convert ACPI PCI .bind/.unbind to use PCI bridge driver
    
    acpi_device had a .bind/.unbind methods, but Linux driver model does not.
    Cut ACPI PCI code over to use the Linux driver model methods.
    
    Convert bind/unbind to use a new pci bridge driver.
    The driver will add/remove _PRT, so we can eventually
    remove .bind/.unbind methods.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 54a07001b9efb6a3bb9a9d8ac9ddb226e29b5406
Author: Li Shaohua <shaohua.li@intel.com>
Date:   Thu Dec 7 20:56:51 2006 +0800

    ACPI: consolidate two motherboard drivers into one
    
    Consolidate motherboard1 and motherboard2 drivers into one
    so that driver core doesn't complain that two drivers have
    the same name.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96333578b023957537c3e98b50af7f3b7e08e411
Author: Li Shaohua <shaohua.li@intel.com>
Date:   Thu Dec 7 20:56:46 2006 +0800

    ACPI: add acpi_bus_removal_type in acpi_device
    
    Add removal_type in structure acpi_device for hot removal.
    
    ACPI_BUS_REMOVAL_EJECT is used for ACPI device hot removal.
    Only one parameter is allowed in .remove method due to driver model.
    So removal_type is added to indicate different removal type.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c4168bff32e218b8400cb48b48adb9b7f7bb31b8
Author: Li Shaohua <shaohua.li@intel.com>
Date:   Thu Dec 7 20:56:41 2006 +0800

    ACPI: add acpi_bus_ops in acpi_device
    
    Add acpi_bus_ops in acpi_device to support acpi hot plug.
    
    NOTE:	Two methods .add and .start in acpi_driver.ops are
    	called separately to probe ACPI devices, while only
    	.probe method is called in driver model.
    	As executing .add and .start separately is critical
    	for ACPI device hot plug, we use acpi_bus_ops to
    	distinguish different code path.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f883d9db008deb20d4969c26475100cec2b7f6f8
Author: Patrick Mochel <mochel@linux.intel.com>
Date:   Thu Dec 7 20:56:38 2006 +0800

    ACPI: convert to sysfs framework
    
    Setup new sysfs framework
    
    1.	Remove /sys/firmware/acpi
    2.	Add ACPI device in device tree.
    
    File "eject" for every device that has _EJ0 method is moved from
    /sys/firmware to /sys/devices.
    Operation on this file is exactly the same as before.
    i.e. echo 1 to "eject" will cause hot removal of this device.
    Corresponding changes should be made in userspace for hot removal.
    
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Zhang Rui<rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a7178df5e7e5730e5daa6cf6d8b8bf73adbe75c0
Author: Li Shaohua <shaohua.li@intel.com>
Date:   Thu Dec 7 20:56:34 2006 +0800

    ACPI: adjust init order
    
    Adjust link order to add ACPI devices to global list before PCI devices.
    In addition, acpi_bus type must be initialized before any driver loads.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1890a97ab3f66d1e99768439f8067608b9b97fe3
Author: Patrick Mochel <mochel@linux.intel.com>
Date:   Thu Dec 7 20:56:31 2006 +0800

    ACPI: change registration interface to follow driver model
    
    ACPI device/driver registration Interfaces are modified
    to follow Linux driver model.
    
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5d9464a46918ced087c351a10f38cee95725f85b
Author: Patrick Mochel <mochel@linux.intel.com>
Date:   Thu Dec 7 20:56:27 2006 +0800

    ACPI: add ACPI bus_type for driver model
    
    Add ACPI bus_type for Linux driver model.
    
    1.	.shutdown method is added into acpi_driver.ops
    	needed by bus_type operations.
    2.	remove useless parameter 'int state' in .resume method.
    3.	change parameter 'int state'
    	to 'pm_message_t state' in .suspend method.
    
    Note:	The new .uevent method mark ACPI drivers by PNPID instead of by name.
    	Udev script needs to look for "HWID=" or "COMPTID=" to load
    	ACPI drivers as a result.
    
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d43ec68e9837dfa6618ab473622683fdbf6e68a9
Author: Patrick Mochel <mochel@linux.intel.com>
Date:   Thu Dec 7 20:56:23 2006 +0800

    ACPI: add device_driver and hepler functions
    
    Add device_driver into acpi_driver for driver model.
    Add helper functions 'to_acpi_device' and 'to_acpi_driver'
    to get structure acpi_device/acpi_driver by device/device_driver.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d268b0a0f5407138caf0dec9559d68e657a3a74
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Dec 7 20:56:19 2006 +0800

    ACPI: rename some functions
    
    We want the name 'to_acpi_device'.
    And the current macro 'to_acpi_device' will be removed
    after device model is setup.
    So just simply rename them.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e89dde2b063ca73fcdc9244fe68e2dea32c5088
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Dec 7 20:56:16 2006 +0800

    ACPI: clean up scan.c
    
    Adjust the code and make code doing similar things together.
    No logic changes.
    
    Signed-off-by : Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
