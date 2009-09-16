Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbZIPMqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbZIPMqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZIPMp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:45:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758931AbZIPMpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:45:45 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] User return notifiers / just-in-time MSR switching for KVM
Date: Wed, 16 Sep 2009 15:45:30 +0300
Message-Id: <1253105134-8862-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various x86 syscall related MSRs (MSR_LSTAR and friends, EFER when SCE
needs to be updated) are fairly expensive to read or write.  Since different
operating systems can set different values for these MSRs, KVM needs to reload
them when switching to a different guest or to the host.

Switching on every guest entry/exit is too expensive, so KVM reloads on
guest preemption, which is a lot rarer.  Even so, preemption based reload
is suboptimal:

- if we're switching to a kernel thread and back, there's no need to reload
  the MSRs.  Examples of kernel threads we're likely to switch to are:

  - the idle task
  - a threaded interrupt handler
  - a kernel-mode virtio server (vhost-net)

- if we're switching to a guest running the same OS, the MSRs will have the
  same values and there's no need to reload them

- if the guest and host run the same OS, again the MSRs need not be reloaded.

This patchset implements just-in-time reloads to defer them to the last
possible instant.  When we do reload, we check whether the values have in
fact changed and reload conditionally.

For the just-in-time reloads the first patch implements "user return
notifiers", a callback invoked just before return to userspace.  This has
been written so that there is no code impact if KVM is not configured, and
no runtime impact if KVM is not running.

The patchset improves guest/idle/guest switches by about 2000 cycles.

Avi Kivity (4):
  core, x86: Add user return notifiers
  KVM: VMX: Move MSR_KERNEL_GS_BASE out of the vmx autoload msr area
  KVM: x86 shared msr infrastructure
  KVM: VMX: Use shared msr infrastructure

 arch/Kconfig                       |   10 +++
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/kvm_host.h    |    3 +
 arch/x86/include/asm/thread_info.h |    7 +-
 arch/x86/kernel/process.c          |    2 +
 arch/x86/kernel/signal.c           |    3 +
 arch/x86/kvm/Kconfig               |    1 +
 arch/x86/kvm/vmx.c                 |  142 +++++++++++++++--------------------
 arch/x86/kvm/x86.c                 |   79 ++++++++++++++++++++
 kernel/Makefile                    |    1 +
 10 files changed, 166 insertions(+), 83 deletions(-)

