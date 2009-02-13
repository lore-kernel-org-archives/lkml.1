Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbZBMQ01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbZBMQ01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZBMQ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:26:19 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41391 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZBMQ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:26:18 -0500
Date: Fri, 13 Feb 2009 20:23:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, richardj_moore@uk.ibm.com,
       jason.wessel@windriver.com
Subject: [Patch 00/10] Hardware Breakpoint interfaces
Message-ID: <20090213145301.GA31546@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Please find the patches that introduce interfaces to access
Hardware Breakpoint (or watchpoint) registers and an arch-specific
implementation for x86/x86_64 architecture. The patches have been
re-based to -tip tree (commit 4e3bae758b552d6bd094fb36e78a4d738cb42257)

A short description of the framework and interfaces is provided
below. Some of the details will be specific to x86/x86_64 architecture
and may vary depending upon the support provided by the target
processor.

Kindly accept these patches to become a part of -tip tree.

Description
-------------
The Hardware Breakpoint registers can be used for tracing changes to a
variable or data location (even I/O ports in x86/x86_64) and will be
extremely helpful in debugging problems such as memory corruption. While
these registers have been used by user-space debuggers for long (through
'ptrace' syscalls), Kgdb exploited them for kernel-space addresses.

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

There is pending integration with 'KGDB' without which mutual exclusion
between them (KGDB and HW breakpoint use through above interfaces) needs
to be observed.

Thanks,
K.Prasad

