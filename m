Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYJGUe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYJGUe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbYJGUel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:34:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:52324 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbYJGUej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:34:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="448278113"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [RFC][PATCH 0b/3] TXT: Intel(R) Trusted Execution Technology support for Linux - Details
Date: Tue, 7 Oct 2008 13:34:38 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005AC105C@orsmsx416.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 0b/3] TXT: Intel(R) Trusted Execution Technology support for Linux - Details
Thread-Index: AckovB44mAQ13ZnSS3G1NK5cp2t+7g==
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 07 Oct 2008 20:34:38.0945 (UTC) FILETIME=[1E9EB510:01C928BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How Does it Work?
================

o  Tboot is an executable that is launched by the bootloader as the
"kernel"
   (the binary the bootloader executes).
o  It performs all of the work necessary to determine if the platform
supports
   Intel TXT and, if so, executes the GETSEC[SENTER] processor
instruction
   that initiates the dynamic root of trust.
   -  If tboot determines that the system does not support Intel TXT or
is not
      configured correctly (e.g. the SINIT AC Module was incorrect), it
will
      directly launch the kernel with no changes to any state.
   -  Tboot will output various information about its progress to the
first
      (ttyS0/COM1) serial port; this can be disabled by a command line
switch.
      It can also be compiled to put the information into a hardcoded
memory
      location in low memory so that systems without a serial port can
still
      get the log.
o  The GETSEC[SENTER] instruction will return control to tboot and it
then
   verifies certain aspects of the environment (e.g. TPM NV lock, e820
table
   does not have invalid entries, etc.).
o  It will wake the APs from the special sleep state the GETSEC[SENTER]
   instruction had put them in and place them into a wait-for-SIPI
state.
   -  Because the processors will not respond to an INIT or SIPI when in
the
      TXT environment, it is necessary to create a small VT-x guest for
the
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
      logging them an continuing.
o  Tboot adjusts the e820 table provided by the bootloader to reserve
its own
   location in memory as well as to reserve certain other TXT-related
regions.
o  Tboot will populate a shared page with some data about itself and
pass this
   to the Linux kernel as it transfers control.
   -  The location of the shared page is passed via the boot_params
struct as
      a physical address.
o  The kernel will look for the tboot shared page address and, if it
exists,
   map it.
o  At this point, tboot and TXT are out of the picture until a shutdown
(S<n>)
o  In order to put a system into any of the sleep states after a TXT
launch,
   TXT must first be exited.  This is to prevent attacks that attempt to
crash
   the system to gain control on reboot and steal data left in memory.
   -  The kernel will perform all of its sleep preparation and populate
the
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
   -  S4 is not supported by this patch, but we expect to fix that
shortly
      (the current suspend code brings the APs out of suspend with an
INIT,
      which doesn't work under TXT).

That's pretty much it for TXT support.


Configuring the System:
======================

This code works with 32bit, 32bit PAE, and 64bit (x86_64) kernels.

In BIOS, the user must enable:  TPM, TXT, VT-x, VT-d.  Not all BIOSes
allow
these to be individually enabled/disabled and the screens in which to
find
them are BIOS-specific.

grub.conf needs to be modified as follows:
        title Linux 2.6.27-rc9 w/ tboot
          root (hd0,0)
                kernel /tboot.gz
                module /vmlinuz-2.6.27-rc9 ro root=LABEL=/ rhgb
console=ttyS0,115200 3
                module /initrd-2.6.27-rc9.img
                module /Q35_SINIT_16.BIN

As mentioned previously, the tboot source can be downloaded from the
Trusted
Boot SourceForge project.

The kernel option for enabling Intel TXT support is found under the
Security
top-level menu and is called "Enable Intel(R) Trusted Execution
Technology (TXT)".
It is marked as EXPERIMENTAL and depends only on the generic x86 support
(to allow
maximum flexibility in kernel build options), since the tboot code will
detect whether
the platform actually supports Intel TXT and thus whether any of the
kernel code is
executed.

The Q35_SINIT_16.BIN file is what Intel TXT refers to as an
Authenticated Code
Module.  It is specific to the chipset in the system and can also be
found on
the Trusted Boot site.  It is an (unencrypted) binary module signed by
Intel
that is used as part of the DRTM process to verify and configure the
system.
It is signed because it operates at a higher privilege level in the
system
than any other macrocode and its correct operation is critical to the
establishment of the DRTM.


We welcome your comments and suggestions and genuinely value your
feedback.

Joseph Cihula
Shane Wang
Gang Wei
Intel Corp.
