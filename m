Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZBJMj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZBJMj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZBJMjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:39:16 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38448 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZBJMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:39:15 -0500
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479
X-Spam-TokenSummary: Bayes not run.
X-Spam-Relay-Country: 
Date: Tue, 10 Feb 2009 18:05:14 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       mingo@elte.hu, richardj_moore@uk.ibm.com, jason.wessel@windriver.com,
       prasad@linux.vnet.ibm.com, naren@linux.vnet.ibm.com
Subject: [Patch 0/10] Hardware Breakpoint interfaces - v2
Message-ID: <20090210123514.GA4199@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Xagent-From: prasad@linux.vnet.ibm.com
X-Xagent-To: prasad@linux.vnet.ibm.com
X-Xagent-Gateway: sydvm9.vnet.ibm.com (XAGENTU at SYDVM9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and all,

	Please find the patches that introduce interfaces to access
Hardware Breakpoint (or watchpoint) registers and an arch-specific
implementation for x86/x86_64 architecture. The earlier patchset (sent to
you here: http://lkml.org/lkml/2009/1/29/36) generated some discussion
over the employment of RCU synchronisation in the patchset. They're now
resolved. The other changes over the previous patchset include:

- Modified kernel/hw_breakpoint.c and arch/x86/kernel/hw_breakpoint.c
into independently compilable units. Made necessary declarations in
header files.

- One pair of read-side RCU locks were introduced in
load_debug_registers() following discussions about RCU synchronisation
in the patchset. 

A short description of the framework and interfaces is provided
below. Some of the details will be specific to x86/x86_64 architecture
and may vary depending upon the support provided by the target
processor.

The patches are based of -mm tree (commit
6a522c468fe6d01679224edfe78586c95b6d9872) and have been tested on x86
architecture over 2.6.29-rc2. Kindly accept these patches to be a part
of -mm tree.

Description
-------------
The Hardware Breakpoint registers can be used for tracing changes to a
variable or data location (even I/O ports in x86/x86_64) and will be
extremely helpful in debugging problems such as memory corruption. While
these registers have been used by user-space debuggers for long (through
'ptrace' syscalls), KGDB exploited them for kernel-space addresses.

The proposed framework, introduces interfaces to use them directly on
both  user- and kernel-space addresses apart from arbitrating requests
from various such users for the limited number of registers.

The interfaces are:

int register_kernel_hw_breakpoint(struct hw_breakpoint *);
void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);

int register_user_hw_breakpoint(struct task_struct *tsk,
                                 struct hw_breakpoint *bp);
void unregister_user_hw_breakpoint(struct task_struct *tsk,
                struct hw_breakpoint *bp);

The 'struct hw_breakpoint' will be the anchor data-structure containing
all the necessary information such as name or address, type, length,
priority and pointers to handler functions (some of which are
arch-specific). More information about the role of each field, the
handler
functions and their return values can be found in the descriptive
comments
preceding these functions and in "include/asm-generic/hw_breakpoint.h".

While (un)register_user_hw_breakpoint() isn't exported yet, its
worker-routine __register_user-hw_breakpoint() is used by ptrace syscall
for all breakpoint register requirements. For the kernel-space, a simple
use case to trace 'write' operations on a kernel variable can be found
in samples/hw_breakpoint/data_breakpoint.c.

In the current patchset, support is provided only for read and
read-write breakpoints on data locations, which can be later expand to
include instruction and I/O breakpoints for x86/x86_64.

The patches are based on 2.6.29-rc2 and have been tested on an x86
machine along with concurrent sessions of a kprobe-module and a GDB
session using HW breakpoints on the target program.

There is pending integration with 'KGDB' without which mutual exclusion
between them (KGDB and HW breakpoint use through above interfaces) needs
to be observed.

Thanks,
K.Prasad

