Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZCEXV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZCEXV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZCEXVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:21:46 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37381 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZCEXVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:21:45 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 18:21:45 EST
Message-Id: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: [RFC patch 00/41] LTTng 0.105 core for Linux 2.6.27-rc9
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I spent the last 4-5 months working with the Fujitsu team at implementing the
tracer elements identified as goals at Kernel Summit 2008 and at the following
Plumber Conference. My idea was to incremententally adapt the LTTng tracer,
currently used in the industry and well tested, to those requirements.

I spent the last days rearranging/folding/inspecting the LTTng patchset
to prepare it for an LKML post. The version 0.105 in the LTTng git tree
corresponds to the patchset I am posting here. The said patchset will
only include the core features of LTTng, excluding the timestamping
infrastructure (trace clock) and excluding the instrumentation.

The corresponding git tree contains also the trace clock patches and the lttng
instrumentation. The trace clock is required to use the tracer, but it can be
used without the instrumentation : there is already a kprobes and userspace
event support included in this patchset.

This tracer exports binary data through buffers using splice(). The resulting
binary files can be parsed from userspace because the format string metadata is
exported in the files. The event set can be enhanced by adding tracepoints to
the kernel code and by creating probe modules, which connects callbacks to the
tracepoints and contain the format string metainformation. Those callbacks are
responsible for writing the data in the trace buffers. This separation between
the trace buffer format string and the tracepoints is done on purpose so the
core kernel instrumentation (tracepoints) is not exported to userspace, which
will make maintainance much easier.

The tree including the trace clock patches is available at :

git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git
branch : 2.6.29-rc7-lttng-0.105

Project website : http://www.lttng.org/

Information about how to install and use the tracer is available at :

http://ltt.polymtl.ca/svn/trunk/lttv/LTTngManual.html

The size of the LTTng core patchset is 41 patches. The diffstat details
as follow :

 include/linux/ltt-core.h                                  |   35 
 include/linux/ltt-relay.h                                 |  161 +
 include/linux/ltt-tracer.h                                |   43 
 include/linux/marker.h                                    |  121 
 kernel/marker.c                                           |  353 ++
 kernel/module.c                                           |   31 
 linux-2.6-lttng/Documentation/markers.txt                 |   17 
 linux-2.6-lttng/MAINTAINERS                               |    7 
 linux-2.6-lttng/Makefile                                  |    2 
 linux-2.6-lttng/arch/powerpc/kernel/traps.c               |    5 
 linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/spufs.h |    6 
 linux-2.6-lttng/arch/sparc/Makefile                       |    2 
 linux-2.6-lttng/arch/x86/kernel/dumpstack.c               |    5 
 linux-2.6-lttng/arch/x86/mm/fault.c                       |    1 
 linux-2.6-lttng/fs/ext4/fsync.c                           |    8 
 linux-2.6-lttng/fs/ext4/ialloc.c                          |   17 
 linux-2.6-lttng/fs/ext4/inode.c                           |   79 
 linux-2.6-lttng/fs/ext4/mballoc.c                         |   71 
 linux-2.6-lttng/fs/ext4/mballoc.h                         |    2 
 linux-2.6-lttng/fs/ext4/super.c                           |    6 
 linux-2.6-lttng/fs/jbd2/checkpoint.c                      |    7 
 linux-2.6-lttng/fs/jbd2/commit.c                          |   12 
 linux-2.6-lttng/fs/pipe.c                                 |    5 
 linux-2.6-lttng/fs/select.c                               |   41 
 linux-2.6-lttng/fs/seq_file.c                             |   45 
 linux-2.6-lttng/fs/splice.c                               |    1 
 linux-2.6-lttng/include/linux/immediate.h                 |   94 
 linux-2.6-lttng/include/linux/kvm_host.h                  |   12 
 linux-2.6-lttng/include/linux/ltt-channels.h              |   94 
 linux-2.6-lttng/include/linux/ltt-core.h                  |   47 
 linux-2.6-lttng/include/linux/ltt-relay.h                 |  186 +
 linux-2.6-lttng/include/linux/ltt-tracer.h                |  731 ++++++
 linux-2.6-lttng/include/linux/ltt-type-serializer.h       |  107 
 linux-2.6-lttng/include/linux/marker.h                    |   16 
 linux-2.6-lttng/include/linux/module.h                    |    6 
 linux-2.6-lttng/include/linux/poll.h                      |    2 
 linux-2.6-lttng/include/linux/seq_file.h                  |   20 
 linux-2.6-lttng/include/trace/ext4.h                      |  129 +
 linux-2.6-lttng/include/trace/jbd2.h                      |   19 
 linux-2.6-lttng/init/Kconfig                              |    2 
 linux-2.6-lttng/kernel/kallsyms.c                         |    1 
 linux-2.6-lttng/kernel/marker.c                           |   12 
 linux-2.6-lttng/kernel/module.c                           |   32 
 linux-2.6-lttng/ltt/Kconfig                               |  130 +
 linux-2.6-lttng/ltt/Makefile                              |   15 
 linux-2.6-lttng/ltt/ltt-channels.c                        |  338 ++
 linux-2.6-lttng/ltt/ltt-core.c                            |  101 
 linux-2.6-lttng/ltt/ltt-filter.c                          |   66 
 linux-2.6-lttng/ltt/ltt-kprobes.c                         |  479 +++
 linux-2.6-lttng/ltt/ltt-marker-control.c                  |  265 ++
 linux-2.6-lttng/ltt/ltt-relay-alloc.c                     |  715 +++++
 linux-2.6-lttng/ltt/ltt-relay-locked.c                    | 1704 ++++++++++++++
 linux-2.6-lttng/ltt/ltt-serialize.c                       |  685 +++++
 linux-2.6-lttng/ltt/ltt-trace-control.c                   | 1061 ++++++++
 linux-2.6-lttng/ltt/ltt-tracer.c                          | 1210 +++++++++
 linux-2.6-lttng/ltt/ltt-type-serializer.c                 |   96 
 linux-2.6-lttng/ltt/ltt-userspace-event.c                 |  131 +
 linux-2.6-lttng/samples/markers/Makefile                  |    2 
 linux-2.6-lttng/samples/markers/marker-example.c          |    4 
 linux-2.6-lttng/samples/markers/probe-example.c           |   10 
 linux-2.6-lttng/samples/markers/test-multi.c              |  120 
 linux-2.6-lttng/virt/kvm/kvm_trace.c                      |   12 
 ltt/Kconfig                                               |   24 
 ltt/Makefile                                              |    2 
 ltt/ltt-relay-alloc.c                                     |   80 
 65 files changed, 9445 insertions(+), 398 deletions(-)


Comments are welcome.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
