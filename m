Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZICVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZICVYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbZICVYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:24:33 -0400
Received: from dsl.zenzebra.mv.com ([207.22.49.29]:1056 "EHLO cmarib.ramside"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756334AbZICVYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:24:32 -0400
X-Greylist: delayed 2067 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 17:24:31 EDT
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel reboot before Decompressing Linux, after setting video mode
From: VirginSnow@vfemail.net
Date: 03 Sep 2009 20:49:48 +0000
Message-ID: <86tyzjg3df.fsf@cmarib.ramside>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:    

     Linux kernel 2.6.30.5 reboots after setting video mode, but
     before issuing the "Decompressing Linux" message.

[2.] Full description of the problem/report:

     I just compiled a kernel from the official 2.6.30.5 sources using
     gcc 3.4.4.  "make xconfig" was used to configure the kernel, and
     the .config was NOT edited by hand.  EARLY_PRINTK=y in .config.

     Initial builds failed due to unresolved ".L1234" symbols.  Using
     "make xconfig" to disable uncompilable code resulted in a
     successful kernel build.

     Booting the resulting kernel outputs the message "Probing EDD"
     and then reboots.  Passing "edd=on" or "edd=off" on the kernel
     command line does not help; the kernel always reboots.

     Passing "vga=ask" allows me to select a video mode, which appears
     to take effect properly.  Immediately after setting the video
     mode, however, the machine reboots.

     The problem behavior is repeatable and consistent.

[3.] Keywords (i.e., modules, networking, kernel):

     boot reboot query_edd set_video go_to_protected_mode
     mask_all_interrupts setup_idt setup_gdt protected_mode_jump
     decompress_kernel

[4.] Kernel version (from /proc/version):

     Attempting to boot a kernel compiled from stock 2.6.30.5 sources.

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)

     No error message is displayed.  The machine simply reboots.

[6.] A small shell script or example program which triggers the
     problem (if possible)

     N/A.  This is a problem with the early boot process.  However,
     see diagnostic C code below.

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

     Gnu C                  3.4.4
     Gnu make               3.80
     binutils               2.16.1

     grub                   0.96

[7.2.] Processor information (from /proc/cpuinfo):

     vendor_id       : GenuineIntel
     cpu family      : 6
     model           : 8
     model name      : Pentium III (Coppermine)
     flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse

[7.3.] Module information (from /proc/modules):

     N/A.  This is a problem with the early boot process.

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

     HP Pavilion.  Additional specs available as needed.

[7.5.] PCI information ('lspci -vvv' as root)
[7.6.] SCSI information (from /proc/scsi/scsi)

     N/A.  This is a problem with the early boot process.

[7.7.] Other information that might be relevant to the problem:

     I'm assuming that this bug has something to do with relocation of
     the x86 setup code from assembly to C.  The reboot appears to
     occur just after the call to mask_all_interrupts(), but before
     decompressing the kernel.  Kernel version 2.6.15 boots without
     any problem, on the same machine, with the same bootloader, and
     with the same boot arguments.  Note that set_video() is called
     AFTER query_edd() in arc/x86/boot/main.c, so this does not appear
     to be related to EDD.

     In order to track down the problem, I added some puts()s to pm.c:

void pmbusywaitloop()
{
  int i = 0;
  int j = 1 << 27;
  for(i=0; i < j; i++) {
    /* just to make sure this loop isn't optimized out of the code */
    j--;
    j++;
  }
}

/*
 * Actual invocation sequence
 */
void go_to_protected_mode(void)
{
  puts("Entering go_to_protected_mode\n");
  pmbusywaitloop();
	/* Hook before leaving real mode, also disables interrupts */
	realmode_switch_hook();
  puts("About to enable A20 gate\n");
  pmbusywaitloop();

	/* Enable the A20 gate */
	if (enable_a20()) {
		puts("A20 gate not responding, unable to boot...\n");
		die();
	}

  puts("About to reset coprocessor\n");
  pmbusywaitloop();
	/* Reset coprocessor (IGNNE#) */
	reset_coprocessor();

	/* Mask all interrupts in the PIC */
  puts("About to mask interrupts\n");
  pmbusywaitloop();
	mask_all_interrupts();

	/* Actual transition to protected mode... */
  puts("About to setup IDT\n");
  pmbusywaitloop();
	setup_idt();
  puts("About to setup GDT\n");
  pmbusywaitloop();
	setup_gdt();
  puts("About to jump to protected mode\n");
  pmbusywaitloop();
	protected_mode_jump(boot_params.hdr.code32_start,
			    (u32)&boot_params + (ds() << 4));
}

When booting, the kernel outputs:

Entering go_to_protected_mode
(pause)
About to enable A20 gate
(pause)
About to reset coprocessor
(pause)
About to mask interrupts
(pause)
About to setup IDT
(pause)
(*reboot*)

Since "About to setup GDT" is never printed, I assumed that the
problem was in setup_idt().  However, looking at setup_idt(), it
appears that setup_idt() consists of more or less a single assembly
instruction.  Since I don't know if puts() requires the old IDT, I'm
not able to narrow down the problem any further than this:

The reboot occurs *after* mask_all_interrupts(), but *before* the
putstr("\nDecompressing Linux... ") in decompress_kernel().
