Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbYHJJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbYHJJqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYHJJqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 05:46:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYHJJqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 05:46:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1218322518.3268.0.camel@luna.unix.geek.nz>
References: <1218322518.3268.0.camel@luna.unix.geek.nz> <1218287473.3155.13.camel@dhcppc0> <1218281190.3155.5.camel@dhcppc0> <1218214935.3146.5.camel@dhcppc0> <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org> <14476.1218286327@redhat.com> <15386.1218290826@redhat.com>
To: Jasper Bryant-Greene <jasper@amiton.co.nz>
Cc: dhowells@redhat.com, Thomas Meyer <thomas@m3y3r.de>,
       James Morris <jmorris@namei.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Sun, 10 Aug 2008 10:45:39 +0100
Message-ID: <10251.1218361539@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jasper Bryant-Greene <jasper@amiton.co.nz> wrote:

> This occurs on my x86_64 system, config was posted to this thread
> earlier.

Does it happen every time?  I took your config modified it very slightly so
that it'd work on my system:

	-CONFIG_INITRAMFS_SOURCE="/usr/share/v86d/initramfs"
	-CONFIG_INITRAMFS_ROOT_UID=0
	-CONFIG_INITRAMFS_ROOT_GID=0
	+CONFIG_INITRAMFS_SOURCE=""

	-CONFIG_PACKET=m
	+CONFIG_PACKET=y

	-CONFIG_UNIX=m
	+CONFIG_UNIX=y

	-CONFIG_NET_KEY=m
	+CONFIG_NET_KEY=y

	-CONFIG_E1000E=m
	+CONFIG_E1000E=y

	-# CONFIG_SERIAL_8250 is not set
	+CONFIG_SERIAL_8250=y
	+CONFIG_SERIAL_8250_CONSOLE=y
	+CONFIG_SERIAL_8250_PCI=y
	+CONFIG_SERIAL_8250_PNP=y
	+CONFIG_SERIAL_8250_NR_UARTS=4
	+CONFIG_SERIAL_8250_RUNTIME_UARTS=4
	+# CONFIG_SERIAL_8250_EXTENDED is not set

	+CONFIG_SERIAL_CORE=y
	+CONFIG_SERIAL_CORE_CONSOLE=y

	-# CONFIG_EXT3_FS is not set
	+CONFIG_EXT3_FS=y
	+CONFIG_EXT3_FS_XATTR=y
	+CONFIG_EXT3_FS_POSIX_ACL=y
	+CONFIG_EXT3_FS_SECURITY=y
	+CONFIG_JBD=y
	+# CONFIG_JBD_DEBUG is not set

None of which should make a difference, but the kernel works fine and survives
the LTP syscalls testscript:-/

Hmmm... There is a possibility, I suppose.  The only place in the fork path
that I know of that returns EAGAIN is this bit:

	retval = -EAGAIN;
	if (atomic_read(&p->real_cred->user->processes) >=
			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
		    p->real_cred->user != current->nsproxy->user_ns->root_user)
			goto bad_fork_free;
	}

Are you running as an unprivileged user?  If so, this may be the point that's
biting you.  Can you try applying the attached patch to find more information?

David
---
Add printks to find problem

From: David Howells <dhowells@redhat.com>


---

 kernel/fork.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/kernel/fork.c b/kernel/fork.c
index eb7838d..4d52954 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -920,8 +920,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		return ERR_PTR(-EINVAL);
 
 	retval = security_task_create(clone_flags);
-	if (retval)
+	if (retval) {
+		printk(KERN_ERR "security_task_create() returned %d\n", retval);
 		goto fork_out;
+	}
 
 	retval = -ENOMEM;
 	p = dup_task_struct(current);
@@ -938,13 +940,20 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (atomic_read(&p->real_cred->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->real_cred->user != current->nsproxy->user_ns->root_user)
+		    p->real_cred->user != current->nsproxy->user_ns->root_user) {
+			printk(KERN_ERR "Rlimit EAGAIN (%d >= %lu, uid %d)\n",
+			       atomic_read(&p->real_cred->user->processes),
+			       p->signal->rlim[RLIMIT_NPROC].rlim_cur,
+			       p->real_cred->user->uid);
 			goto bad_fork_free;
+		}
 	}
 
 	retval = copy_creds(p, clone_flags);
-	if (retval < 0)
+	if (retval < 0) {
+		printk(KERN_ERR "copy_creds() returned %d\n", retval);
 		goto bad_fork_free;
+	}
 
 	/*
 	 * If multiple threads are within copy_process(), then this check
@@ -1274,6 +1283,7 @@ bad_fork_cleanup_count:
 bad_fork_free:
 	free_task(p);
 fork_out:
+	printk(KERN_ERR "copy_process() = %d\n", retval);
 	return ERR_PTR(retval);
 }
 
