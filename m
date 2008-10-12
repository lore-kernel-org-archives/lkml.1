Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbYJLNMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbYJLNMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbYJLNMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:12:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:46659 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYJLNMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wD0hVkwTSQJrqAsK1u0rRp1ttaJRX03FvrL1tb1gxdoTzw9KKrMQOJcdK8MAm4ue7F
         IUooUmgi6bRKTnVIgzJn+/dqRZ9i/ET39JLqaPLKZTiXLhngZEI6yXletsmNfge4Gr/7
         JP4AFWtZVZO4l+nJ+RygrkZuL2LyO27VfAE4U=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu, srostedt@redhat.com
Cc: a.p.zijlstra@chello.nl, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 0/4] ftrace: add userspace stacktrace support and semaphore-latency tracer
Date: Sun, 12 Oct 2008 16:12:00 +0300
Message-Id: <1223817124-27239-2-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series is a draft implementation of a semaphore-latency tracer.
I would appreciate feedback on these patches so that they can be merged into
mainline.

The patches apply on top of tip/master (commit aaf9631d60b82182c7e9890b5ffec70f38131a50).

The first two patches add userspace stacktrace support.
Unfortunately if the userspace application (actually libc) is compiled without framepointers
on x86-64, the userspace trace will contain only 1 entry: the return address.
You can either request raw IP addresses in the trace, or ask for them to be
resolved to object file + relative address, then a tool such as addr2line can be
used to get file:line information.
This is currently x86-only, but other architectures could implement it.

TODO: It would be worth investigating if we could avoid code duplication vs. oprofile,
and use a common function for userspace traces, and convert oprofile to it.

The last 2 patches add a new tracer (and is independent of the first 2 patches).
This tracer attempts to help in tracking rwsem latency issues.
Each latency instance gets an ID, and a userspace program can be used to group
the stacktraces by latency ID, thus obtaining a list of all tasks involved
in a latency: the task(s) that was (were) holding the semaphore, and the tasks
that had to wait due to this.

See the patches themselves for more detail on how to use them.

Shortlog below:

Török Edwin (4):
  Add support for userspace stacktraces in tracing/iter_ctrl
  Identify which executable object the userspace address belongs to.
  add tracepoints in rwsem
  Implement semaphore latency tracer

 Documentation/ftrace.txt     |    5 +-
 arch/x86/kernel/stacktrace.c |   57 +++++++++++++
 include/linux/stacktrace.h   |    8 ++
 include/trace/rwsem.h        |   35 ++++++++
 kernel/trace/Kconfig         |   12 +++
 kernel/trace/Makefile        |    1 +
 kernel/trace/trace.c         |  188 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h         |   35 ++++++++
 kernel/trace/trace_semlat.c  |  186 +++++++++++++++++++++++++++++++++++++++++
 lib/rwsem-spinlock.c         |   16 ++--
 lib/rwsem.c                  |   13 +--
 11 files changed, 539 insertions(+), 17 deletions(-)
 create mode 100644 include/trace/rwsem.h
 create mode 100644 kernel/trace/trace_semlat.c

