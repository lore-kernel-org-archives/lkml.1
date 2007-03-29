Return-Path: <linux-kernel-owner+w=401wt.eu-S1750936AbXC2V2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbXC2V2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXC2V2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:28:21 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39859 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXC2V2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:28:21 -0400
Date: Thu, 29 Mar 2007 14:28:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Hafting <helgehaf@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.21-rc5-mm2 - compile error on x86-64
Message-Id: <20070329142816.5d18d89f.akpm@linux-foundation.org>
In-Reply-To: <20070329182020.GA9223@aitel.hist.no>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<20070329182020.GA9223@aitel.hist.no>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 20:20:20 +0200
Helge Hafting <helgehaf@aitel.hist.no> wrote:

> I tried compiling this on x86-64, and got this compile error:
>   CC      init/version.o
>   CC      init/missing_syscalls.o
> In file included from init/missing_syscalls.c:97:
> init/missing_syscalls.h:279:2: warning: #warning syscall ssetmask not
> implemented
> init/missing_syscalls.h:1263:2: warning: #warning syscall getcpu not
> implemented
> init/missing_syscalls.h:1267:2: warning: #warning syscall epoll_pwait not
> implemented
> init/missing_syscalls.h:1271:2: warning: #warning syscall lutimesat not
> implemented
> init/missing_syscalls.h:1275:2: warning: #warning syscall revokeat not
> implemented
> init/missing_syscalls.h:1279:2: warning: #warning syscall frevoke not
> implemented

yup, people will presumably work on fixing these things up after the
feature hits mainline.

>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> fs/built-in.o: In function `proc_root_init':
> /usr/src/linux/fs/proc/root.c:83: undefined reference to `proc_sys_init'

Ah.  I assume you have CONFIG_SYSCTL=y, CONFIG_PROC_SYSCTL=n?




From: Andrew Morton <akpm@linux-foundation.org>

We're using #ifdef CONFIG_SYSCTL, but we should be using CONFIG_PROC_SYSCTL,
so we get

 fs/built-in.o: In function `proc_root_init':
 /usr/src/linux/fs/proc/root.c:83: undefined reference to `proc_sys_init'

Fix that up and remove an ifdef-in-C.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Helge Hafting <helgehaf@aitel.hist.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    4 ++++
 fs/proc/root.c     |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/root.c~proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n fs/proc/root.c
--- a/fs/proc/root.c~proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n
+++ a/fs/proc/root.c
@@ -79,9 +79,7 @@ void __init proc_root_init(void)
 	proc_device_tree_init();
 #endif
 	proc_bus = proc_mkdir("bus", NULL);
-#ifdef CONFIG_SYSCTL
 	proc_sys_init();
-#endif
 }
 
 static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat
diff -puN fs/proc/internal.h~proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n fs/proc/internal.h
--- a/fs/proc/internal.h~proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n
+++ a/fs/proc/internal.h
@@ -11,7 +11,11 @@
 
 #include <linux/proc_fs.h>
 
+#ifdef CONFIG_PROC_SYSCTL
 extern int proc_sys_init(void);
+#else
+static inline void proc_sys_init(void) { }
+#endif
 
 struct vmalloc_info {
 	unsigned long	used;
_

