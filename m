Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYFIOTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYFIOTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbYFIOSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbYFIOSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:30 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 0/15] Improve x86 smpboot integration
Date: Mon,  9 Jun 2008 11:16:43 -0300
Message-Id: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

First of all, sorry for being away for so long ;-)

Here it goes a series of improvements for the x86 smpboot integration.
The final goal is the same: To reduce the difference between architectures,
just this time I do a little bit more ;-)

Basically, this one reduces greatly the ifdef count:

[root@t60 linux-2.6-x86]# git-show 674ce:arch/x86/kernel/smpboot.c \
			  | grep -e "^#ifdef \+CONFIG_X86_\(32\|64\)" | wc -l
18
[root@t60 linux-2.6-x86]# git-show HEAD:arch/x86/kernel/smpboot.c \
			  | grep -e "^#ifdef \+CONFIG_X86_\(32\|64\)" | wc -l
8

The remaining ones are _mainly_ (not all) due to the fact that x86_64 uses the pda,
while i386 goes with normal per-cpu data. They are things like:

per_cpu(current_task, cpu) = c_idle.idle; vs cpu_pda(cpu)->pcurrent = c_idle.idle;

Also, there is the low mappings piece of code Hugh detected. To that, I intend
to also find a common base between them. Just I'm not doing it in this series, because
it deserves special attention.

As usual, this series was compiled tested in a whole bunch of different configs ( ~ 10
for each architecture), including all i386 variants. Boot tested in all my hardware.

The final diffstat is:

 arch/x86/kernel/head_32.S             |    2 
 arch/x86/kernel/head_64.S             |   48 +---------------
 arch/x86/kernel/io_apic_32.c          |    2 
 arch/x86/kernel/setup64.c             |    1 
 arch/x86/kernel/smpboot.c             |   97 ++++------------------------------
 b/arch/x86/kernel/acpi/sleep.c        |    2 
 b/arch/x86/kernel/apic_32.c           |    6 --
 b/arch/x86/kernel/apic_64.c           |   10 +++
 b/arch/x86/kernel/head_32.S           |    6 +-
 b/arch/x86/kernel/head_64.S           |    5 +
 b/arch/x86/kernel/io_apic_32.c        |    5 +
 b/arch/x86/kernel/io_apic_64.c        |    9 ++-
 b/arch/x86/kernel/process_32.c        |   16 +++++
 b/arch/x86/kernel/setup64.c           |    5 -
 b/arch/x86/kernel/setup_64.c          |   27 +++++++++
 b/arch/x86/kernel/smpboot.c           |    8 --
 b/arch/x86/kernel/traps_32.c          |    3 -
 b/arch/x86/kernel/x8664_ksyms_64.c    |    5 -
 b/arch/x86/mach-voyager/voyager_smp.c |    2 
 b/include/asm-x86/desc.h              |   24 +++-----
 b/include/asm-x86/hw_irq.h            |    3 -
 b/include/asm-x86/numa_32.h           |    1 
 b/include/asm-x86/segment.h           |   24 ++++----
 b/include/asm-x86/smp.h               |    2 
 include/asm-x86/hw_irq.h              |    4 -
 25 files changed, 122 insertions(+), 195 deletions(-)


