Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbZAOWNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbZAOWNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZAOWCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:14 -0500
Received: from kroah.org ([198.145.64.141]:38255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933563AbZAOWCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:09 -0500
Date: Thu, 15 Jan 2009 13:59:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michael Kerrisk <mtk.manpages@googlemail.com>,
       Robert Love <rlove@google.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 20/85] inotify: fix type errors in interfaces
Message-ID: <20090115215934.GU17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="inotify-fix-type-errors-in-interfaces.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Kerrisk <mtk.manpages@googlemail.com>

commit 4ae8978cf92a96257cd8998a49e781be83571d64 upstream.

The problems lie in the types used for some inotify interfaces, both at the kernel level and at the glibc level. This mail addresses the kernel problem. I will follow up with some suggestions for glibc changes.

For the sys_inotify_rm_watch() interface, the type of the 'wd' argument is
currently 'u32', it should be '__s32' .  That is Robert's suggestion, and
is consistent with the other declarations of watch descriptors in the
kernel source, in particular, the inotify_event structure in
include/linux/inotify.h:

struct inotify_event {
        __s32           wd;             /* watch descriptor */
        __u32           mask;           /* watch mask */
        __u32           cookie;         /* cookie to synchronize two events */
        __u32           len;            /* length (including nulls) of name */
        char            name[0];        /* stub for possible name */
};

The patch makes the changes needed for inotify_rm_watch().

Signed-off-by: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Robert Love <rlove@google.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/inotify_user.c        |    2 +-
 include/linux/syscalls.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -707,7 +707,7 @@ fput_and_out:
 	return ret;
 }
 
-asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
+asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd)
 {
 	struct file *filp;
 	struct inotify_device *dev;
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

