Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbZBKAyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbZBKAyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757794AbZBKApk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:45:40 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:38471 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758934AbZBKApi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:45:38 -0500
Subject: Re: [BUGFIX/x86] Fix initialization of wakeup_cpu.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49921C4F.9050601@kernel.org>
References: <1234297715.24155.29.camel@alok-dev1>
	 <86802c440902101303u2fe671b0xe811543d40e0cd9@mail.gmail.com>
	 <1234303240.24155.36.camel@alok-dev1>  <49921C4F.9050601@kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 10 Feb 2009 16:45:37 -0800
Message-Id: <1234313137.30391.13.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 16:31 -0800, Yinghai Lu wrote:
> > 
> >> 2. also will break 64 bit....
> > isn't the default_x86_quirks defined for 64 bit too ? 
> > 
> 64 bit doesn't have genapic_apic_probe()
> 
> need to change that to 
> #ifdef CONFIG_X86_32
> 	genapic_apic_probe();
> #endif
> 

Ok here it is. 
--

With refactoring of wake_cpu macros the 32bit code in tip doesn't 
execute generic_apic_probe if CONFIG_X86_32_NON_STANDARD is not set.

Even on a x86 STANDARD cpu we need to execute the generic_apic_probe
function, as we rely on this function to execute the update_genapic
quirk which initilizes apic->wakeup_cpu. 

Failing to do so results in we making a call to a null function in do_boot_cpu.

The stack trace without the patch goes like this.

Booting processor 1 APIC 0x1 ip 0x6000
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
*pdpt = 0000000000839001 *pde = 0000000000c97067 *pte = 0000000000000163 
Oops: 0000 [#1] SMP 
last sysfs file: 
Modules linked in:

Pid: 1, comm: swapper Not tainted (2.6.29-rc4-tip #18) VMware Virtual Platform
EIP: 0062:[<00000000>] EFLAGS: 00010293 CPU: 0
EIP is at 0x0
EAX: 00000001 EBX: 00006000 ECX: c077ed00 EDX: 00006000
ESI: 00000001 EDI: 00000001 EBP: ef04cf40 ESP: ef04cf1c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 006a
Process swapper (pid: 1, ti=ef04c000 task=ef050000 task.ti=ef04c000)
Stack:
 c0644e52 00000000 ef04cf24 ef04cf24 c064468d c0886dc0 00000000 c0702aea
 ef055480 00000001 00000101 dead4ead ffffffff ffffffff c08af530 00000000
 c0709715 ef04cf60 ef04cf60 00000001 00000000 00000000 dead4ead ffffffff
Call Trace:
 [<c0644e52>] ? native_cpu_up+0x2de/0x45b
 [<c064468d>] ? do_fork_idle+0x0/0x19
 [<c0645c5e>] ? _cpu_up+0x88/0xe8
 [<c0645d20>] ? cpu_up+0x42/0x4e
 [<c07e7462>] ? kernel_init+0x99/0x14b
 [<c07e73c9>] ? kernel_init+0x0/0x14b
 [<c040375f>] ? kernel_thread_helper+0x7/0x10
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 006a:ef04cf1c

I think we should call generic_apic_probe unconditionally for 32 bit now.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Yinghai Lu <yinghai@kernel.org>

Index: linux-tip-master/arch/x86/kernel/setup.c
===================================================================
--- linux-tip-master.orig/arch/x86/kernel/setup.c	2009-02-10 12:05:18.000000000 -0800
+++ linux-tip-master/arch/x86/kernel/setup.c	2009-02-10 16:37:59.000000000 -0800
@@ -936,7 +936,7 @@
 	map_vsyscall();
 #endif
 
-#if defined(CONFIG_X86_32_NON_STANDARD) || defined(CONFIG_X86_BIGSMP)
+#ifdef CONFIG_X86_32
 	generic_apic_probe();
 #endif
 


