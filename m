Return-Path: <linux-kernel-owner+w=401wt.eu-S934716AbYCSUnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716AbYCSUnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYCSToE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:44:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26271 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256AbYCSToA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:44:00 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, paulus@samba.org, tglx@linutronix.de, mingo@redhat.com,
       tony.luck@intel.com
Subject: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Date: Wed, 19 Mar 2008 12:56:07 +0100
Message-Id: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While working on the IO CPU affinity bits, I had to convert some more
archs to support smp_call_function_single(). Nicks original patch
for x86-64 also included improvements for smp_call_function(), so
it isn't serialized by call_lock anymore (but still hits call_lock
on every call). I've made further improvements and changes upon that
while converting x86, going further and updating IA64 and PPC made me
realize that we have a lot of shared code for the same functionality.

So I came up with kernel/smp.c that basically just holds the new
and abstracted code for issuing smp_call_function() and
smp_call_function_single() along with the helpers and interrupt
handlers associated. Perhaps a better place would be lib/smp.c, I'm
open to suggestions.

Even with half of this being new functionality, the diffstat still looks
pretty nice:

 arch/ia64/kernel/smp.c                     |  171 ++---------
 arch/powerpc/kernel/smp.c                  |  223 +-------------
 arch/powerpc/platforms/cell/interrupt.c    |    1 
 arch/powerpc/platforms/ps3/smp.c           |    7 
 arch/powerpc/platforms/pseries/xics.c      |    6 
 arch/powerpc/sysdev/mpic.c                 |    2 
 arch/x86/kernel/entry_64.S                 |    3 
 arch/x86/kernel/i8259_64.c                 |    1 
 arch/x86/kernel/smp_32.c                   |  165 +++-------
 arch/x86/kernel/smp_64.c                   |  175 ++---------
 arch/x86/kernel/smpboot_32.c               |    4 
 arch/x86/kernel/smpcommon_32.c             |   34 --
 include/asm-powerpc/smp.h                  |    5 
 include/asm-x86/hw_irq_32.h                |    1 
 include/asm-x86/hw_irq_64.h                |    4 
 include/asm-x86/mach-default/entry_arch.h  |    1 
 include/asm-x86/mach-default/irq_vectors.h |    1 
 include/linux/smp.h                        |   30 +
 kernel/Makefile                            |    2 
 kernel/smp.c                               |  316 +++++++++++++++++++++
 20 files changed, 533 insertions(+), 619 deletions(-)

When/if more archs are converted, it'll of course look even better.
Comments? I've verified that this builts and boots on x86, x86-64
and powerpc. IA64 may still need a one-liner change, I don't have
access to that platform anymore so I can't verify that myself. It
does build, however :-)

The patch series is also available in the 'generic-ipi' branch from

git://git.kernel.dk/linux-2.6-block.git

and the 'io-cpu-affinity' branch is directly based on this.

-- 
Jens Axboe


