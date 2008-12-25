Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbYLYPAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbYLYPAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 10:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYLYO7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:59:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54391 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYLYO7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:59:53 -0500
Message-ID: <49539FD0.7070103@redhat.com>
Date: Thu, 25 Dec 2008 16:59:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Serebrin <benjamin.serebrin@amd.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: kvm vmload/vmsave vs tss.ist
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm performance is largely dependent on the frequency and cost of 
switches between guest and host mode.  The cost of a switch is greatly 
influenced by the amount of state we have to load and save.

One of the optimizations that kvm makes in order to reduce the cost is 
to partition the guest state into two; let's call the two parts kernel 
state and user state.  The kernel state consists of registers that are 
used for general kernel execution, for example the general purpose 
registers.  User state consists of registers that are only used in user 
mode (or in the transition to user mode).  When switching from guest to 
host, we only save and reload the kernel state, delaying reloading of 
user state until we actually need to switch to user mode.  Since many 
exits are satisfied entirely in the kernel, we can avoid switching user 
state entirely.  In effect the host kernel runs with some of the cpu 
registers containing guest values.  The mechanism used for deferring 
state switch is PREEMPT_NOTIFIERS, introduced in 2.6.23 IIRC.

Now, AMD SVM instructions also partition register state into two.  The 
VMRUN instruction, which is used to switch to guest mode, loads and 
saves registers corresponding to kernel state.  The VMLOAD and VMSAVE 
instructions load and save user state registers.

The exact registers managed by VMLOAD and VMSAVE are:

  FS GS TR LDTR
  KernelGSBase
  STAR LSTAR CSTAR SFMASK
  SYSENTER_CS SYSENTER_ESP SYSENTER_EIP

None of these registers are ever touched in 64-bit kernel mode, except 
gs.base (which we can save/restore manually), and TR.  The only part of 
the TSS (pointed to by the TR) used in 64-bit mode are the seven 
Interrupt Stack Table (IST) entries.  These are used to provide 
known-good stacks for critical exceptions.

These critical exceptions are: debug, nmi, double fault, stack fault, 
and machine check.

Because of this one detail, kvm must execute vmload/vmsave on every 
guest/host switch. Hardware architects, give yourself a pat on the back.

The impact is even greater when using nested virtualization, since we 
must trap on two additional instructions on every switch.

I would like to remove this limitation.  I see several ways to go about it:

1. Drop the use of IST

This would reduce the (perceived) reliability of the kernel and would 
probably not be welcomed.

2. Introduce a config item for dropping IST, and have kvm defer 
vmload/vmsave depending on the configuration

This would pose a dilemma for kitchen sink distro kernels: kvm 
performance or maximum reliability?

3. Switch off IST when the first VM is created, switch it back on when 
the last VM is destroyed

Most likely no additional code would need to be modified.  It could be 
made conditional if someone wants to retain IST even while kvm is 
active.  We already have hooks in place and know where the host IST is.  
I favor this option. 

4. Some other brilliant idea?

Might be even better than option 3.

hpa/Ingo, any opinions?


-- 
error compiling committee.c: too many arguments to function

