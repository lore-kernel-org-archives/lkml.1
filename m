Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbYAVO7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbYAVO7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYAVO72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:59:28 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:57234 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbYAVO70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:59:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAIOTlUdMROHU/2dsb2JhbACBV6sK
Date: Tue, 22 Jan 2008 09:59:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>, ltt-dev@shafik.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       Robert Wisniewski <bobww@us.ibm.com>
Subject: [RFC] LTTng Userspace Tracing, vDSO
Message-ID: <20080122145919.GA17620@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:30:21 up 79 days, 19:35,  4 users,  load average: 0.25, 0.28,
	0.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am poking in the userspace tracing problem again. I had two different
implementations in LTTng, but I left them out so I could come back with
a more satisfying solution.

Here are the ideas I would like to use in my forthcoming implementation.
I submit them for comments, especially about limitations of vDSO I
might not be aware of (code size... ?, max data size ?).

The idea is to fast-path tracing so a system call is not required. I
have to determine if I put the tracing code in a normal shared object or
if it belongs to a vDSO.

Basic ideas :

* Buffers
Per CPU buffers mapped by both userspace and the kernel
menuconfig options for buffers
- per process (safe, a process cannot overwrite other processes'data)
  - 4k default size, menuconfig configurable
    - Total of 12.5MB for 200 traced processes * 4 CPUs.. not bad.
- system-wide (unsafe, low memory consumption)
  - 1MB default size, menuconfig configurable

Depending on the system type, one could wish for efficiency (single-user
server) or protection (multi-user system)

Since threads can be stopped by the OS when the buffers are filled, we
can afford to have smaller buffers than the kernel buffers (4k vs 1MB).

Atomic space reservation to protect against traced signal handlers. Note
that a full cmpxchg (synchronized wrt other CPUs) is required because
the vgetcpu only returns a statistically correct cpu ID (might be
migrated).

* Synchronization
 - Use seqlock to synchronize vsyscall with kernel if required.

* time source
  - vsyscall to get the raw cycle count
  - fallback on kernel syscall

One could ask : why don't you stay in the kernel when you have to use a
syscall to get the timestamps anyway ? Well, because passing a format
string and var args from userspace to the kernel would not be "polite".
;) If userspace passes wrong format strings to the tracing code, I would
rather prefer the segfault to happen in userspace and not involve the
kernel at all.

* marker registration

System call to register markers in library init.
Markers in special section, modify the linker script.
Keep a per-process data structure (in kernel) to keep track of the
registered markers. When the last process using a marker set exits,
remove those markers. (refcount)

* buffer switch

buffer switch performed by a system call.
Use inotify to tell lttd (trace reading daemon) that new debugfs files
are created upon first buffer switch of a userspace process.

* Filtering

Export filter data and code to user-space. (eventually)

* Multiple traces

LTTng supports writing to multiple traces at the same time. Each of them
can have different filtering expressions or be in different mode
(extract the data to disk when the trace is running or flight recorder
mode where the data is only kept in circular buffers and always
overwritten). Can be useful for multiuser systems too.

Therefore, we would have to reserve enough virtual address space in the
vDSO region to put roughly 16 per-cpu buffers (?). Then, upon buffer
allocation for a new trace, we would have to iterate over each process
in the system; if it is being traced, we would allocate extra buffers
within the tracing vDSO data region.

Any thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
