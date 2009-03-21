Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZCUOb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZCUOb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZCUObS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:31:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:59399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZCUObQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:31:16 -0400
Date: Sat, 21 Mar 2009 14:30:39 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237606416-22268-1-git-send-email-fweisbec@gmail.com>
References: <1237606416-22268-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/ring-buffer] tracing/ring-buffer: don't annotate rb_cpu_notify with __cpuinit
Message-ID: <tip-09c9e84d474d917d9de5b9011ed2064b03a19677@git.kernel.org>
Git-Commit-ID: 09c9e84d474d917d9de5b9011ed2064b03a19677
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Mar 2009 14:30:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09c9e84d474d917d9de5b9011ed2064b03a19677
Gitweb:     http://git.kernel.org/tip/09c9e84d474d917d9de5b9011ed2064b03a19677
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 21 Mar 2009 04:33:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Mar 2009 10:54:10 +0100

tracing/ring-buffer: don't annotate rb_cpu_notify with __cpuinit

Impact: remove a section warning

CONFIG_DEBUG_SECTION_MISMATCH raises the following warning on -tip:

  WARNING: kernel/trace/built-in.o(.text+0x5bc5): Section mismatch in
  reference from the function ring_buffer_alloc() to the function
  .cpuinit.text:rb_cpu_notify()
  The function ring_buffer_alloc() references
  the function __cpuinit rb_cpu_notify().

This is actually harmless. The code in the ring buffer don't build
rb_cpu_notify and other cpu hotplug stuffs when !CONFIG_HOTPLUG_CPU
so we have no risk to reference freed memory here (it would even
be harmless if we unconditionally build it because register_cpu_notifier
would do nothing when !CONFIG_HOTPLUG_CPU.

But since ring_buffer_alloc() can be called everytime, we don't want it
to be annotated with __cpuinit so we drop the __cpuinit from
rb_cpu_notify.

This is not a waste of memory because it is only defined and used on
CONFIG_HOTPLUG_CPU.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237606416-22268-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 384ca5d..808b14b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -535,8 +535,8 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 extern int ring_buffer_page_too_big(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static int __cpuinit rb_cpu_notify(struct notifier_block *self,
-				   unsigned long action, void *hcpu);
+static int rb_cpu_notify(struct notifier_block *self,
+			 unsigned long action, void *hcpu);
 #endif
 
 /**
@@ -2784,8 +2784,8 @@ static __init int rb_init_debugfs(void)
 fs_initcall(rb_init_debugfs);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static int __cpuinit rb_cpu_notify(struct notifier_block *self,
-				   unsigned long action, void *hcpu)
+static int rb_cpu_notify(struct notifier_block *self,
+			 unsigned long action, void *hcpu)
 {
 	struct ring_buffer *buffer =
 		container_of(self, struct ring_buffer, cpu_notify);
