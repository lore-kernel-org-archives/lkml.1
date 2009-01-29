Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZA2HtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZA2HtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZA2Hs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:48:57 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41247 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZA2Hs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:48:56 -0500
Date: Thu, 29 Jan 2009 13:18:45 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       mingo@elte.hu, richardj_moore@uk.ibm.com, jason.wessel@windriver.com,
       prasad@linux.vnet.ibm.com, naren@linux.vnet.ibm.com
Subject: [Patch 0/10] Hardware Breakpoint interfaces
Message-ID: <20090129074845.GA5078@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and all,
	Please find the patches that introduce interfaces to access
Hardware Breakpoint (or watchpoint) registers and an arch-specific
implementation for x86/x86_64 architecture. Can you consider them for
inclusion in -mm tree?

A short description of the framework and interfaces is provided
below. Some of the details will be specific to x86/x86_64 architecture
and may vary depending upon the support provided by the target
processor.

Description
------------

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
arch-specific). More information about the role of each field, the handler
functions and their return values can be found in the descriptive comments
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

Several enhancements including support for more architectures and types
of breakpoints are contemplated in the revisions to come.

Let me know your thoughts on this.

Thanks,
K.Prasad

