Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXAZOPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXAZOPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965696AbXAZOPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:15:54 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46724 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965690AbXAZOPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:15:53 -0500
Message-ID: <45BA0D16.8040909@hitachi.com>
Date: Fri, 26 Jan 2007 23:15:50 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: akpm@osdl.org, pavel@suse.cz, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 4/4] coredump: documentation for proc and sysctl
References: <45BA0A93.30004@hitachi.com>
In-Reply-To: <45BA0A93.30004@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation for the following parameters:
  /proc/<pid>/core_flags
  /proc/sys/kernel/core_flags_enable

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 Documentation/filesystems/proc.txt |   42 +++++++++++++++++++++++++++
 Documentation/sysctl/kernel.txt    |   11 +++++++
 2 files changed, 53 insertions(+)

Index: linux-2.6.20-rc4-mm1/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.20-rc4-mm1.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.20-rc4-mm1/Documentation/filesystems/proc.txt
@@ -41,6 +41,7 @@ Table of Contents
   2.11	/proc/sys/fs/mqueue - POSIX message queues filesystem
   2.12	/proc/<pid>/oom_adj - Adjust the oom-killer score
   2.13	/proc/<pid>/oom_score - Display current oom-killer score
+  2.14	/proc/<pid>/core_flags - Core dump control flags
 
 ------------------------------------------------------------------------------
 Preface
@@ -1981,6 +1982,47 @@ This file can be used to check the curre
 any given <pid>. Use it together with /proc/<pid>/oom_adj to tune which
 process should be killed in an out-of-memory situation.
 
+2.14 /proc/<pid>/core_flags - Core dump control flags
+---------------------------------------------------------------------
+When a process is dumped, all anonymous memory is written to a core file as
+long as the size of the core file isn't limited. But sometimes we don't want
+to dump some memory segments, for example, huge shared memory.
+
+The /proc/<pid>/core_flags file enables you to omit some anonymous memory from
+a core file when it is generated. The content of the proc file is bitmask of
+memory segment types you don't want to dump. When the <pid> process is dumped,
+the core dump routine decides whether a given memory segment should be dumped
+into a core file or not, based on the type of the memory segment and bitmask.
+
+Currently, only valid bit is bit 0. If bit 0 is set, anonymous `shared' memory
+segments are not dumped. There are three types of anonymous shared memory:
+
+  - IPC shared memory
+  - the memory segments created by mmap(2) with MAP_ANONYMOUS and MAP_SHARED
+    flags
+  - the memory segments created by mmap(2) with MAP_SHARED flag, and the
+    mapped file has already been unlinked
+
+Because current core dump routine doesn't distinguish these segments, you can
+only choose either dumping all anonymous shared memory segments or not.
+
+If you don't want to dump all shared memory segments attached to pid 1234, set
+the bit 0 of the process's core_flags to 1:
+
+  $ echo 1 > /proc/1234/core_flags
+
+Additionally, you can check its hexadecimal value by reading the file:
+
+  $ cat /proc/1234/core_flags
+  00000001
+
+When a new process is created, the process inherits the core_flags setting
+from its parent. It is useful to set the core_flags before the program runs.
+For example:
+
+  $ echo 1 > /proc/self/core_flags
+  $ ./some_program
+
 ------------------------------------------------------------------------------
 Summary
 ------------------------------------------------------------------------------
Index: linux-2.6.20-rc4-mm1/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.20-rc4-mm1.orig/Documentation/sysctl/kernel.txt
+++ linux-2.6.20-rc4-mm1/Documentation/sysctl/kernel.txt
@@ -20,6 +20,7 @@ show up in /proc/sys/kernel:
 - acct
 - core_pattern
 - core_uses_pid
+- core_flags_enable
 - ctrl-alt-del
 - dentry-state
 - domainname
@@ -122,6 +123,16 @@ the filename.
 
 ==============================================================
 
+core_flags_enable:
+
+This file enables/disables each flag in /proc/<pid>/core_flags
+(please see Documentation/filesystems/proc.txt). If a bit in
+core_flags_enable is set, the corresponding flag in
+/proc/<pid>/core_flags is effective, otherwise the flag is
+discarded.
+
+==============================================================
+
 ctrl-alt-del:
 
 When the value in this file is 0, ctrl-alt-del is trapped and



