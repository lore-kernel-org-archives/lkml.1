Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZCEEhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZCEEhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 23:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZCEEhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 23:37:37 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40548 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZCEEhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 23:37:36 -0500
Date: Thu, 5 Mar 2009 10:07:26 +0530
From: prasad@linux.vnet.ibm.com
To: mingo@elte.hu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: [patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090305043726.GA17747@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Please find the revised set of patches that implement Hardware
Breakpoint (or watchpoint) registers and an arch-specific implementation
for x86/x86_64.

Changelog
---------
The previous version of these patches were submitted through
http://article.gmane.org/gmane.linux.kernel/794870. The patches now
contain a new ftrace plugin for kernel symbol tracing using hardware
breakpoint registers. The patches are now re-based to -tip tree commit
e40aa382597b30c4d702951348500e812b4cb3d0.

A small usage note on the plugin along with the description of the
breakpoint interfaces is included below.

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

Ftrace plugin
-------------
Usage
------
mount -t debugfs debugfs /debug
cd /debug/tracing/
echo 0 > tracing_enabled
cat available_tracers
echo ksym_tracer > current_tracer
echo "pid_max:rw-" > ksym_trace_filter
echo "jiffies:-w-" > ksym_trace_filter

echo 1 > tracing_enabled

cat trace


Sample Output (snipped)
-------------

[root@mymachine tracing]# cat trace
# tracer: ksym_tracer
#
#       TASK-PID      CPU#      Symbol         Type    Function
#          |           |          |              |         |
atieventsd      3053  1   pid_max               RW alloc_pid+0x6c/0x2fd
authatieventsd. 5394  1   pid_max               RW alloc_pid+0x6c/0x2fd
authatieventsd. 5394  0   pid_max               RW alloc_pid+0x6c/0x2fd
authatieventsd. 5394  0   pid_max               RW alloc_pid+0x6c/0x2fd
bash            4898  1   pid_max               RW alloc_pid+0x6c/0x2fd
atieventsd      3053  1   pid_max               RW alloc_pid+0x6c/0x2fd
authatieventsd. 5401  1   pid_max               RW alloc_pid+0x6c/0x2fd
authatieventsd. 5413  0   pid_max               RW alloc_pid+0x6c/0x2fd
authatieventsd. 5415  0   pid_max               RW alloc_pid+0x6c/0x2fd
authatieventsd. 5415  0   pid_max               RW alloc_pid+0x6c/0x2fd
authatieventsd. 5413  0   pid_max               RW alloc_pid+0x6c/0x2fd
hald-runner     2766  0   pid_max               RW alloc_pid+0x6c/0x2fd
hal-system-kill 5425  1   pid_max               RW alloc_pid+0x6c/0x2fd
hal-system-kill 5425  1   pid_max               RW alloc_pid+0x6c/0x2fd
swapper         0     0   jiffies               W  do_timer+0x16/0xb0
swapper         0     0   jiffies               W  do_timer+0x16/0xb0
gnome-terminal  4521  0   jiffies               W  do_timer+0x16/0xb0
Xorg            3235  0   jiffies               W  do_timer+0x16/0xb0
Xorg            3235  0   jiffies               W  do_timer+0x16/0xb0
[root@mymachine tracing]#

Thanks,
K.Prasad

