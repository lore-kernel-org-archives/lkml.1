Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828Ab0AFMlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0AFMlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 07:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819Ab0AFMlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 07:41:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50527 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab0AFMlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 07:41:35 -0500
Message-ID: <4B448499.6080609@cn.fujitsu.com>
Date: Wed, 06 Jan 2010 20:39:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace_syscalls: cleanup for syscalls_metadata
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


NR_syscalls is compile-time constant.
so we allocates memory for syscalls_metadata at compile-time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f694f66..c7db995 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -17,7 +17,7 @@ static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 extern unsigned long __start_syscalls_metadata[];
 extern unsigned long __stop_syscalls_metadata[];
 
-static struct syscall_metadata **syscalls_metadata;
+static struct syscall_metadata *syscalls_metadata[NR_syscalls];
 
 static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 {
@@ -45,7 +45,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 
 static struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
-	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
+	if (nr >= NR_syscalls || nr < 0)
 		return NULL;
 
 	return syscalls_metadata[nr];
@@ -400,13 +400,6 @@ int __init init_ftrace_syscalls(void)
 	unsigned long addr;
 	int i;
 
-	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
-					NR_syscalls, GFP_KERNEL);
-	if (!syscalls_metadata) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
-
 	for (i = 0; i < NR_syscalls; i++) {
 		addr = arch_syscall_addr(i);
 		meta = find_syscall_meta(addr);

