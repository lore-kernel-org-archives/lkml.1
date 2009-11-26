Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZKZJzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZKZJzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZKZJzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:55:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:59856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZKZJzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:55:13 -0500
Date: Thu, 26 Nov 2009 09:54:48 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4AEFC37C.5080609@cn.fujitsu.com>
References: <4AEFC37C.5080609@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Separate raw syscall from syscall tracer
Message-ID: <tip-b8007ef7422270864eae523cb38d7522a53a94d3@git.kernel.org>
Git-Commit-ID: b8007ef7422270864eae523cb38d7522a53a94d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8007ef7422270864eae523cb38d7522a53a94d3
Gitweb:     http://git.kernel.org/tip/b8007ef7422270864eae523cb38d7522a53a94d3
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 3 Nov 2009 13:45:32 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 25 Nov 2009 14:20:06 -0500

tracing: Separate raw syscall from syscall tracer

The current syscall tracer mixes raw syscalls and real syscalls.

echo 1 > events/syscalls/enable
And we get these from the output:

(XXXX insteads "            grep-20914 [001] 588211.446347" .. etc)

XXXX: sys_read(fd: 3, buf: 80609a8, count: 7000)
XXXX: sys_enter: NR 3 (3, 80609a8, 7000, a, 1000, bfce8ef8)
XXXX: sys_read -> 0x138
XXXX: sys_exit: NR 3 = 312
XXXX: sys_read(fd: 3, buf: 8060ae0, count: 7000)
XXXX: sys_enter: NR 3 (3, 8060ae0, 7000, a, 1000, bfce8ef8)
XXXX: sys_read -> 0x138
XXXX: sys_exit: NR 3 = 312

There are 2 drawbacks here.
A) two almost identical records are saved in ringbuffer
   when a syscall enters or exits. (4 records for every syscall)
   This wastes precious space in the ring buffer.
B) the lines including "sys_enter/sys_exit" produces
   hardly any useful information for the output (no labels).

The user can use this method to prevent these drawbacks:
echo 1 > events/syscalls/enable
echo 0 > events/syscalls/sys_enter/enable
echo 0 > events/syscalls/sys_exit/enable

But this is not user friendly. So we separate raw syscall
from syscall tracer.

After this fix applied:
syscall tracer's output (echo 1 > events/syscalls/enable):

XXXX: sys_read(fd: 3, buf: bfe87d88, count: 200)
XXXX: sys_read -> 0x200
XXXX: sys_fstat64(fd: 3, statbuf: bfe87c98)
XXXX: sys_fstat64 -> 0x0
XXXX: sys_close(fd: 3)

raw syscall tracer's output (echo 1 > events/raw_syscalls/enable):

XXXX: sys_enter: NR 175 (0, bf92bf18, bf92bf98, 8, b748cff4, bf92bef8)
XXXX: sys_exit: NR 175 = 0
XXXX: sys_enter: NR 175 (2, bf92bf98, 0, 8, b748cff4, bf92bef8)
XXXX: sys_exit: NR 175 = 0
XXXX: sys_enter: NR 3 (9, bf927f9c, 4000, b77e2518, b77dce60, bf92bff8)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4AEFC37C.5080609@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/syscalls.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index 397dff2..fb726ac 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -1,5 +1,6 @@
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM syscalls
+#define TRACE_SYSTEM raw_syscalls
+#define TRACE_INCLUDE_FILE syscalls
 
 #if !defined(_TRACE_EVENTS_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_EVENTS_SYSCALLS_H
