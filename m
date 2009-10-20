Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZJTEzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZJTEzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZJTEzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:55:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:63521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZJTEzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:55:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,589,1249282800"; 
   d="scan'208";a="505288191"
Date: Tue, 20 Oct 2009 12:54:02 +0800
From: Feng Tang <feng.tang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [REGRESSION] EFI boot on x86 fails in .32
Message-ID: <20091020125402.028d66d5@feng-desktop>
In-Reply-To: <20091020030656.GA30139@srcf.ucam.org>
References: <20091020003400.GA27997@srcf.ucam.org>
	<20091020030656.GA30139@srcf.ucam.org>
Organization: intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Could you try the following patch? I guess the bug is related to
x86_32/64.

Thanks,
Feng

----------------------------------------------------------------
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index ad5bd98..cdcfb12 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -454,8 +454,10 @@ void __init efi_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+#ifdef CONFIG_X86_32
 	x86_platform.get_wallclock = efi_get_time;
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
+#endif
 
 	/* Setup for EFI runtime service */
 	reboot_type = BOOT_EFI;


On Tue, 20 Oct 2009 11:06:57 +0800
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> This seems to be caused by 7bd867dfb4e0357e06a3211ab2bd0e714110def3 -
> reverting that results in a booting kernel. Can't say I understand how
> or why, but...
> 
> On Tue, Oct 20, 2009 at 01:34:00AM +0100, Matthew Garrett wrote:
> > 2.6.32-rc5 (and some earlier git checkout I had) fail to boot on my
> > HP 2530p when using EFI - they boot fine with the BIOS emulation
> > instead. I get an early exception when print_efi_memmap() is
> > called, which implies that the memory map is broken somehow. Here's
> > the dmesg for a working boot:
> >
> > Initializing cgroup subsys cpuset
> > Initializing cgroup subsys cpu
> > Linux version 2.6.30.8-64.fc11.x86_64
> > (mockbuild@x86-5.fedora.phx.redhat.com) (gcc version 4.4.1 20090725
> > (Red Hat 4.4.1-2) (GCC) ) #1 SMP Fri Sep 25 04:43:32 EDT 2009
> > Command line: ro root=UUID=fd334e23-080a-449d-8993-07758e5cd581
> > rhgb quiet KERNEL supported cpus: Intel GenuineIntel AMD
> > AuthenticAMD Centaur CentaurHauls
> > BIOS-provided physical RAM map:
> >  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
> >  BIOS-e820: 0000000000100000 - 0000000075a4c000 (usable)
> >  BIOS-e820: 0000000075a4c000 - 0000000075a4e000 (reserved)
> >  BIOS-e820: 0000000075a4e000 - 0000000076870000 (usable)
> >  BIOS-e820: 0000000076870000 - 0000000076880000 (ACPI NVS)
> >  BIOS-e820: 0000000076880000 - 0000000078fb1000 (usable)
> >  BIOS-e820: 0000000078fb1000 - 00000000791b1000 (ACPI NVS)
> >  BIOS-e820: 00000000791b1000 - 000000007a88f000 (usable)
> >  BIOS-e820: 000000007a88f000 - 000000007a9cf000 (reserved)
> >  BIOS-e820: 000000007a9cf000 - 000000007aacf000 (ACPI NVS)
> >  BIOS-e820: 000000007aacf000 - 000000007aaff000 (ACPI data)
> >  BIOS-e820: 000000007aaff000 - 000000007ab00000 (usable)
> >  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> >  BIOS-e820: 00000000fffa0000 - 00000000fffa7000 (reserved)
> > EFI v2.00 by INTEL
> >  ACPI=0x7aafe000  ACPI 2.0=0x7aafe014  SMBIOS=0x7a99f718
> > Kernel-defined memdesc doesn't match the one from EFI!
