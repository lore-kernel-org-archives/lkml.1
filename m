Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZHSHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZHSHxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZHSHxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:53:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61908 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbZHSHxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:53:17 -0400
Message-ID: <4A8BAF16.8040504@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 15:51:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] tracing/syscalls: Add filtering support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds filtering support for syscall events

For syscall enter events, we can do filtering on syscall
parameters, and for exit events, filter on syscall return
value.

For example, we set 'mode == 0666' (0666 == 0x1b6) to
sys_enter_open, and set 'ret == 0' to sys_exit_open,
and here's the output:

 # echo 'mode == 0666' > events/syscalls/sys_enter_open
 # echo 'ret == 0' > events/syscalls/sys_exit_open
 # echo 1 > events/syscalls/sys_enter_open
 # echo 1 > events/syscalls/sys_exit_open
 # cat trace
 ...
   modprobe-3084 [001] 117.463140: sys_open(filename: 917d3e8, flags: 0, mode: 1b6) 
   modprobe-3084 [001] 117.463176: sys_open -> 0x0
       less-3086 [001] 117.510455: sys_open(filename: 9c6bdb8, flags: 8000, mode: 1b6) 
   sendmail-2574 [001] 122.145840: sys_open(filename: b807a365, flags: 0, mode: 1b6) 
 ...

[PATCH 1/5] tracing/syscalls: Fix fields format for enter events
[PATCH 2/5] tracing/syscalls: Add fields format for exit events
[PATCH 3/5] tracing/events: Add ftrace_event_call param to define_fields()
[PATCH 4/5] tracing/events: Add trace_define_common_fields()
[PATCH 5/5] tracing/syscalls: Add filtering support
---
 include/linux/ftrace_event.h  |   15 ++----
 include/linux/syscalls.h      |   19 +++++--
 include/trace/ftrace.h        |   11 ++---
 include/trace/syscall.h       |   13 ++++-
 kernel/trace/trace_events.c   |   29 +++++++++-
 kernel/trace/trace_export.c   |   13 ++---
 kernel/trace/trace_syscalls.c |  120 +++++++++++++++++++++++++++++++----------
 7 files changed, 156 insertions(+), 64 deletions(-)
