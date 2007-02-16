Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbXBPNmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbXBPNmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964845AbXBPNmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:42:32 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44505 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843AbXBPNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:42:30 -0500
Message-ID: <45D5B4C1.7050306@hitachi.com>
Date: Fri, 16 Feb 2007 22:42:25 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: [PATCH 4/4] coredump: documentation for proc entry
References: <45D5B2E3.3030607@hitachi.com>
In-Reply-To: <45D5B2E3.3030607@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation for
/proc/<pid>/coredump_omit_anonymous_shared.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 Documentation/filesystems/proc.txt |   38 +++++++++++++++++++++++++++
 1 files changed, 38 insertions(+)

Index: linux-2.6.20-mm1/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.20-mm1.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.20-mm1/Documentation/filesystems/proc.txt
@@ -41,6 +41,7 @@ Table of Contents
   2.11	/proc/sys/fs/mqueue - POSIX message queues filesystem
   2.12	/proc/<pid>/oom_adj - Adjust the oom-killer score
   2.13	/proc/<pid>/oom_score - Display current oom-killer score
+  2.14	/proc/<pid>/coredump_omit_anonymous_shared - Core dump coordinator
 
 ------------------------------------------------------------------------------
 Preface
@@ -1982,6 +1983,43 @@ This file can be used to check the curre
 any given <pid>. Use it together with /proc/<pid>/oom_adj to tune which
 process should be killed in an out-of-memory situation.
 
+2.14 /proc/<pid>/coredump_omit_anonymous_shared - Core dump coordinator
+---------------------------------------------------------------------
+When a process is dumped, all anonymous memory is written to a core file as
+long as the size of the core file isn't limited. But sometimes we don't want
+to dump some memory segments, for example, huge shared memory.
+
+The /proc/<pid>/coredump_omit_anonymous_shared is a flag which enables you to
+omit anonymous shared memory segments from a core file when it is generated.
+When the <pid> process is dumped, the core dump routine decides whether a
+given memory segment should be dumped into a core file or not based on the
+type of the memory segment and the flag.
+
+If you have written a non-zero value to this proc file, anonymous shared
+memory segments are not dumped. There are three types of anonymous shared
+memory:
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
+If you don't want to dump all shared memory segments attached to pid 1234,
+write 0 to the process's proc file.
+
+  $ echo 1 > /proc/1234/coredump_omit_anonymous_shared
+
+When a new process is created, the process inherits the flag status from its
+parent. It is useful to set the flag before the program runs.
+For example:
+
+  $ echo 1 > /proc/self/coredump_omit_anonymous_shared
+  $ ./some_program
+
 ------------------------------------------------------------------------------
 Summary
 ------------------------------------------------------------------------------


