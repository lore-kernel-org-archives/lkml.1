Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYKRUSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYKRUSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYKRUSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:18:32 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:11049 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYKRUSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:18:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=Bv7jovBDanh5TEfygzcwxI+MQEJilQVAhwlWMAP8PLQP+3WgFnc4jIHcxPe69+vH0L
         0GHpuQV5GDTFq+ghDxbI53XN0Cl43mBLhORFlLbjB0qXvw5w+i7mwiIIpUFsA2iKrUG7
         D7JWDaw5Rnp7oMgWtdKs4ogOVBsANZQd4Swz0=
Message-ID: <4923230D.8090301@gmail.com>
Date: Tue, 18 Nov 2008 15:18:21 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [patch] Fix type errors in inotify interfaces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Vegard reminded me of an issue with the inotify interface
that I raised quite a while ago, offlist, with Robert; Robert
acknowledged that things should be fixed, but then neither of
us actually did anything :-{.

The problems lie in the types used for some inotify interfaces, both
at the kernel level and at the glibc level.  This mail addresses the
kernel problem.  I will follow up with some suggestions for glibc
changes.

For the sys_inotify_rm_watch() interface, the type of the 'wd' argument
is currently 'u32', it should be '__s32' .  That is Robert's suggestion,
and is consistent with the other declarations of watch descriptors in
the kernel source, in particular, the inotify_event structure in
include/linux/inotify.h:

struct inotify_event {
        __s32           wd;             /* watch descriptor */
        __u32           mask;           /* watch mask */
        __u32           cookie;         /* cookie to synchronize two events */
        __u32           len;            /* length (including nulls) of name */
        char            name[0];        /* stub for possible name */
};

The patch below makes the changes needed for inotify_rm_watch().

Thanks

Michael


diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index d367e9b..a71f764 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -704,7 +704,7 @@ fput_and_out:
 	return ret;
 }
 
-asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
+asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd)
 {
 	struct file *filp;
 	struct inotify_device *dev;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d6ff145..36983a5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -550,7 +550,7 @@ asmlinkage long sys_inotify_init(void);
 asmlinkage long sys_inotify_init1(int flags);
 asmlinkage long sys_inotify_add_watch(int fd, const char __user *path,
 					u32 mask);
-asmlinkage long sys_inotify_rm_watch(int fd, u32 wd);
+asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd);
 
 asmlinkage long sys_spu_run(int fd, __u32 __user *unpc,
 				 __u32 __user *ustatus);
