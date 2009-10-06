Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZJFAuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZJFAuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZJFAux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:50:53 -0400
Received: from claw.goop.org ([74.207.240.146]:35220 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbZJFAuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:50:52 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Xen-devel <xen-devel@lists.xensource.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH RFC] Extending pvclock down to usermode for vsyscall
Date: Mon,  5 Oct 2009 17:50:06 -0700
Message-Id: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements the vread method for the clocksource, which allows
it to be used directly from usermode via vsyscall.

Most of the work is in the generic pvclock code, with a bit of
hypervisor-specific code to set things up.  Specifically, it sets up a
page which is an array of pvclock_vcpu_time_info structures indexed by
vcpu number.  The usermode code gets the current (v)cpu via vgetcpu,
gets the appropriate time info and computes system time from the tsc.
After doing all that it rechecks the version number to make things
happened consistently.  The kernel also installs a preempt notifier to
bump the version number so that usermode can tell it has had its cpu
context switched under it.

I've included the Xen implementation, but it should be simple to implement
for KVM (especially since it already has the feature I had to add to
Xen to implement this: the ability to place the pvclock_vcpu_time_info
structure at an arbitrary address).

With this in place, I can do a gettimeofday in about 100ns on a 2.4GHz
Q6600.  I'm sure this could be tuned a bit more, but it is already much
better than a syscall.

(There's also a couple of other little generic pvclock fixes I'll send
separately.)

Thanks,
	J

 arch/x86/Kconfig                |    4 +
 arch/x86/include/asm/fixmap.h   |   21 +++++
 arch/x86/include/asm/pvclock.h  |    6 +
 arch/x86/include/asm/vsyscall.h |    3 
 arch/x86/kernel/Makefile        |    2 
 arch/x86/kernel/pvclock.c       |  156 ++++++++++++++++++++++++++++++++++++----
 arch/x86/xen/Kconfig            |    6 +
 arch/x86/xen/mmu.c              |    3 
 arch/x86/xen/smp.c              |    2 
 arch/x86/xen/time.c             |   52 +++++++++++++
 arch/x86/xen/xen-ops.h          |    8 ++
 include/xen/interface/vcpu.h    |   41 ++++++++++
 12 files changed, 291 insertions(+), 13 deletions(-)

