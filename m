Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYEDNsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYEDNsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYEDNsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:48:42 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:62187 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244AbYEDNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:48:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8EAKpbHUhMROPA/2dsb2JhbACBU6gB
Date: Sun, 4 May 2008 09:48:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: System call instrumentation
Message-ID: <20080504134838.GA21487@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:26:49 up 65 days,  9:37,  3 users,  load average: 1.10, 0.55,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I looked at the system call instrumentation present in LTTng lately. I
tried different solutions, e.g. hooking a kernel-wide syscall trace in
do_syscall_trace, but it appears that I ended up re-doing another
syscall table, which consists of specialized functions which extracts
the string and data structure parameters from user-space. Since code
duplication is not exactly wanted, I think that the original approach
taken in my patchset, which is to instrument the kernel code at the
sys_* level (e.g. sys_open), which is the earliest level where the
parameter information is made available to the kernel, is still the best
way to go.

I would still identify the execution mode changes in the same way I do
currently, which is by instrumenting do_syscall_trace, just to know as
soon as possible when the mode has changed from user-space to
kernel-space so we can do time accounting more accurately. I already
have the patchset which adds the KERNEL_TRACE thread flag to every
architectures. It's tested in assembly in the same way SYSCALL_TRACE is
tested, but is activated globally by iterating on all the threads.

So, the currently proposed scheme for a system call would be (for the
open() example)

shown as : 
kernel stack
  trace: event name (parameters)


do_syscall_trace()
  trace: kernel_arch_syscall_entry (syscall id, instruction pointer)

do_sys_open()
  trace: fs_open (fd, filename)

do_syscall_trace()
  kernel_arch_syscall_exit (return value)

If we take this open() example, filename is ready only in do_sys_open,
which is called by sys_open and sys_openat. So the logical
instrumentation site for this would really be do_sys_open(). The
information about which system call has been done is made available in
the kernel_arch_syscall_entry event. It is not present anymore at the
do_sys_open level because this execution path can be called from more
than one syscall.

What do you think of this approach ?


Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
