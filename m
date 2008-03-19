Return-Path: <linux-kernel-owner+w=401wt.eu-S1761234AbYCSUOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234AbYCSUOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757256AbYCSTi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbYCSTiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:46 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de
Subject: [PATCH 0/79] smpboot integration
Date: Wed, 19 Mar 2008 14:24:55 -0300
Message-Id: <12059475744092-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a complement to my last patch series. In this one, I integrate smpboot.c
The end result is that i386 also uses the new hotplug state machine, and boot cpus
via cpu_up, instead of booting them in the preparation step, and only activating later.

The final diffstat says:
 59 files changed, 1974 insertions(+), 2752 deletions(-)

Leftovers:

smp.h could also be easily integrated. But this series was too big already
setup64.c could also be completely moved to setup.c

Testing and bisectability:

The end result was tested in all my hardware (which includes qemu ;-). 
It does not mean it will boot _your_ hardware, but I did my best ;-)

The tree at least compiles in more than 20 randconfigs (for each of x86_64 and i386)
For i386, each of the subarchitectures was compiled at least once. (By compile, I obviously
mean, every patch, individually)

Full diffstat:

 a/arch/x86/kernel/smpboot_32.c                 |   68 -
 a/arch/x86/kernel/smpboot_64.c                 |   73 -
 a/include/asm-x86/nmi_64.h                     |   89 -
 arch/x86/kernel/Makefile                       |    4 
 arch/x86/kernel/apic_32.c                      |   81 -
 arch/x86/kernel/mpparse_32.c                   |   19 
 arch/x86/kernel/mpparse_64.c                   |   12 
 arch/x86/kernel/nmi_32.c                       |    2 
 arch/x86/kernel/smpboot.c                      | 1071 ++++++++++++++++
 arch/x86/kernel/smpboot_32.c                   | 1617 ++++---------------------
 arch/x86/kernel/smpboot_64.c                   |  949 +-------------
 b/arch/x86/Kconfig                             |    2 
 b/arch/x86/Makefile                            |    2 
 b/arch/x86/kernel/Makefile                     |    2 
 b/arch/x86/kernel/acpi/boot.c                  |    2 
 b/arch/x86/kernel/apic_32.c                    |   23 
 b/arch/x86/kernel/apic_64.c                    |   13 
 b/arch/x86/kernel/bugs_64.c                    |    3 
 b/arch/x86/kernel/mpparse_32.c                 |   12 
 b/arch/x86/kernel/mpparse_64.c                 |    2 
 b/arch/x86/kernel/nmi_32.c                     |    2 
 b/arch/x86/kernel/nmi_64.c                     |    2 
 b/arch/x86/kernel/process_32.c                 |   10 
 b/arch/x86/kernel/setup.c                      |  103 +
 b/arch/x86/kernel/setup64.c                    |   77 -
 b/arch/x86/kernel/setup_32.c                   |   25 
 b/arch/x86/kernel/setup_64.c                   |   15 
 b/arch/x86/kernel/smpboot.c                    |   77 +
 b/arch/x86/kernel/smpboot_32.c                 |    5 
 b/arch/x86/kernel/smpboot_64.c                 |   19 
 b/arch/x86/kernel/traps_64.c                   |    2 
 b/arch/x86/mach-voyager/voyager_smp.c          |    7 
 b/arch/x86/mm/k8topology_64.c                  |    7 
 b/arch/x86/pci/numa.c                          |    8 
 b/arch/x86/vdso/Makefile                       |    2 
 b/include/asm-x86/apic.h                       |    3 
 b/include/asm-x86/apicdef.h                    |    7 
 b/include/asm-x86/mach-bigsmp/mach_apic.h      |    7 
 b/include/asm-x86/mach-default/mach_apic.h     |   11 
 b/include/asm-x86/mach-default/mach_apicdef.h  |    5 
 b/include/asm-x86/mach-default/smpboot_hooks.h |    3 
 b/include/asm-x86/mach-es7000/mach_apic.h      |    8 
 b/include/asm-x86/mach-summit/mach_apic.h      |    4 
 b/include/asm-x86/mach-visws/smpboot_hooks.h   |    5 
 b/include/asm-x86/mmzone_32.h                  |    3 
 b/include/asm-x86/nmi.h                        |   92 +
 b/include/asm-x86/nmi_64.h                     |    3 
 b/include/asm-x86/smp.h                        |    3 
 b/include/asm-x86/smp_32.h                     |    5 
 b/include/asm-x86/smp_64.h                     |   12 
 b/include/asm-x86/topology.h                   |    9 
 include/asm-x86/apic.h                         |    2 
 include/asm-x86/apicdef.h                      |    6 
 include/asm-x86/mach-default/smpboot_hooks.h   |    5 
 include/asm-x86/nmi.h                          |    5 
 include/asm-x86/nmi_32.h                       |   61 
 include/asm-x86/smp.h                          |   29 
 include/asm-x86/smp_32.h                       |   16 
 include/asm-x86/smp_64.h                       |   15 
 59 files changed, 1974 insertions(+), 2752 deletions(-)


