Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZCUDdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZCUDdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 23:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZCUDdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 23:33:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58310 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZCUDdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 23:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vx1w49G3lyLFCbdNd3lieQW4/z1Zn2jzwj0mkdDpbbQO7OUiIph5wya9gkQwgzJqf1
         K8RcFgK7PGUrhYjwA50s0Iz9f0FUQcdvnST6IP2YhkCASGUarmossTWHC/2GMZ73W6ub
         UrAqcO5DAoK7uqfORnqoADr1L7PzrgBTgK3c0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing/ring-buffer: don't annotate rb_cpu_notify with __cpuinit
Date: Sat, 21 Mar 2009 04:33:36 +0100
Message-Id: <1237606416-22268-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bc74f00..7e05e2c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -536,8 +536,8 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 extern int ring_buffer_page_too_big(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static int __cpuinit rb_cpu_notify(struct notifier_block *self,
-				   unsigned long action, void *hcpu);
+static int rb_cpu_notify(struct notifier_block *self,
+			 unsigned long action, void *hcpu);
 #endif
 
 /**
@@ -2787,8 +2787,8 @@ static __init int rb_init_debugfs(void)
 fs_initcall(rb_init_debugfs);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static int __cpuinit rb_cpu_notify(struct notifier_block *self,
-				   unsigned long action, void *hcpu)
+static int rb_cpu_notify(struct notifier_block *self,
+			 unsigned long action, void *hcpu)
 {
 	struct ring_buffer *buffer =
 		container_of(self, struct ring_buffer, cpu_notify);
-- 
1.6.1

