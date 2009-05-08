Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZEHEtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZEHEtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbZEHEs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:48:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:10706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbZEHEs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,315,1239001200"; 
   d="scan'208";a="140549029"
Message-ID: <4A03B9B9.90904@intel.com>
Date: Thu, 07 May 2009 21:48:57 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org
CC: chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, joseph.cihula@intel.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: [RFC v3][PATCH 0b/2] intel_txt: Intel(R) Trusted Execution Technology
 support for Linux - Details
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How Does it Work?
=================

o  Tboot is an executable that is launched by the bootloader as the
"kernel"
   (the binary the bootloader executes).
o  It performs all of the work necessary to determine if the platform
supports
   Intel TXT and, if so, executes the GETSEC[SENTER] processor instruction
   that initiates the dynamic root of trust.
   -  If tboot determines that the system does not support Intel TXT or
is not
      configured correctly (e.g. the SINIT AC Module was incorrect), it
will
      directly launch the kernel with no changes to any state.
   -  Tboot will output various information about its progress to the
terminal,
      serial port, and/or an in-memory log; the output locations can be
configured
      with a command line switch.
o  The GETSEC[SENTER] instruction will return control to tboot and tboot
then
   verifies certain aspects of the environment (e.g. TPM NV lock, e820
table
   does not have invalid entries, etc.).
o  It will wake the APs from the special sleep state the GETSEC[SENTER]
   instruction had put them in and place them into a wait-for-SIPI state.
   -  Because the processors will not respond to an INIT or SIPI when in
the
      TXT environment, it is necessary to create a small VT-x guest for the
      APs.  When they run in this guest, they will simply wait for the
      INIT-SIPI-SIPI sequence, which will cause VMEXITs, and then
disable VT
      and jump to the SIPI vector.  This approach seemed like a better
choice
      than having to insert special code into the kernel's MP wakeup
sequence.
o  Tboot then applies an (optional) user-defined launch policy to verify
the
   kernel and initrd.
   -  This policy is rooted in TPM NV and is described in the tboot
project.
      The tboot project also contains code for tools to create and
provision
      the policy.
   -  Policies are completely under user control and if not present then
any
      kernel will be launched.
   -  Policy action is flexible and can include halting on failures or
simply
      logging them and continuing.
o  Tboot adjusts the e820 table provided by the bootloader to reserve
its own
   location in memory as well as to reserve certain other TXT-related
regions.
o  As part of it's launch, tboot DMA protects all of RAM (using the VT-d
PMRs).
   Thus, the kernel must be booted with 'intel_iommu=on' in order to
remove this
   blanket protection and use VT-d's page-level protection.
o  Tboot will populate a shared page with some data about itself and
pass this
   to the Linux kernel as it transfers control.
   -  The location of the shared page is passed via the boot_params
struct as
      a physical address.
o  The kernel will look for the tboot shared page address and, if it
exists,
   map it.
o  As one of the checks/protections provided by TXT, it makes a copy of
the VT-d
   DMARs in a DMA-protected region of memory and verifies them for
correctness.
   The VT-d code will detect if the kernel was launched with tboot and
use this
   copy instead of the one in the ACPI table.
o  At this point, tboot and TXT are out of the picture until a shutdown
(S<n>)
o  In order to put a system into any of the sleep states after a TXT
launch,
   TXT must first be exited.  This is to prevent attacks that attempt to
crash
   the system to gain control on reboot and steal data left in memory.
   -  The kernel will perform all of its sleep preparation and populate the
      shared page with the ACPI data needed to put the platform in the
desired
      sleep state.
   -  Then the kernel jumps into tboot via the vector specified in the
shared
      page.
   -  Tboot will clean up the environment and disable TXT, then use the
      kernel-provided ACPI information to actually place the platform
into the
      desired sleep state.
   -  In the case of S3, tboot will also register itself as the resume
vector.
      This is necessary because it must re-establish the measured
environment
      upon resume.  Once the TXT environment has been restored, it will
      restore the TPM PCRs and then transfer control back to the
kernel's S3
      resume vector.
      In order to preserve system integrity across S3, the kernel
provides tboot
      with a set of memory ranges (kernel code/data/bss, S3 resume code,
and AP
      trampoline) that tboot will calculate a MAC (message
authentication code)
      over and then seal with the TPM.  On resume and once the measured
environment
      has been re-established, tboot will re-calculate the MAC and
verify it
      against the sealed value.  Tboot's policy determines what happens
if the
      verification fails.

That's pretty much it for TXT support.


Configuring the System:
======================

This code works with 32bit, 32bit PAE, and 64bit (x86_64) kernels.

In BIOS, the user must enable:  TPM, TXT, VT-x, VT-d.  Not all BIOSes
allow these to be individually enabled/disabled and the screens in which
to find them are BIOS-specific.

grub.conf needs to be modified as follows:
       title Linux 2.6.30-rc4 w/ tboot
         root (hd0,0)
               kernel /tboot.gz logging=serial,vga,memory
               module /vmlinuz-2.6.30-rc4 intel_iommu=on ro root=LABEL=/
rhgb console=ttyS0,115200 3
               module /initrd-2.6.30-rc4.img
               module /Q35_SINIT_17.BIN

The kernel option for enabling Intel TXT support is found under the
Security top-level menu and is called "Enable Intel(R) Trusted Execution
Technology (TXT)".  It is marked as EXPERIMENTAL and depends only on the
generic x86 support (to allow maximum flexibility in kernel build
options) and CONFIG_DMAR, since the tboot code will detect whether the
platform actually supports Intel TXT and thus whether any of the kernel
code is executed.

The Q35_SINIT_17.BIN file is what Intel TXT refers to as an
Authenticated Code Module.  It is specific to the chipset in the system
and can also be found on the Trusted Boot site.  It is a firmware module
digitally signed by Intel that is used as part of the DRTM process to
verify and configure the system.  It is signed because it operates at a
higher privilege level in the system than any other macrocode and its
correct operation is critical to the establishment of the DRTM.  The
process for determining the correct SINIT ACM for a system is documented
in the SINIT-guide.txt file that is on the tboot SourceForge site under
the SINIT ACM downloads.


TODOs:
=====

This patch implements the basic TXT support as described above.  There
will be additional patches sent to add functionality and improve the
security of the launched kernel.  Some of those tasks are:
o  userspace S3 integrity protection
   The current patch only provides memory integrity protection of the
kernel code and data.
   Complete S3 protection requires providing integrity over userspace
and kernel dynamic
   data as well.
   We have this implemented for 64b builds and are working out some
issues on 32b.
o  BIOS call scrubbing
   One of the goals of TXT is to reduce the TCB by eliminating
pre-kernel code from
   the trust boundary.  This includes BIOS (with the exception of SMM). 
We will see
   how many of the BIOS calls can be eliminated on a TXT boot and
whether the remainder
   of BIOS-provided code and data can be measured or "protected" (e.g.
validate ACPI
   pointers before using).

This information is also contained in the file
Documentation/intel_txt.txt (in the patch).

We welcome your comments and suggestions and genuinely value your feedback.

Joseph Cihula
Shane Wang
Intel Corp.

