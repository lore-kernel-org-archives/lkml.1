Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZLRRl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZLRRl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZLRRl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:41:27 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:18871 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZLRRlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:41:25 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD5NK0urR7Hu/2dsb2JhbAC+SJcnhC4E
X-IronPort-AV: E=Sophos;i="4.47,419,1257120000"; 
   d="scan'208";a="281410069"
From: Roland Dreier <rdreier@cisco.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] anonfd: Make file read-only if fops->write is not set
References: <adaws0k3kd8.fsf@roland-alpha.cisco.com>
	<20091218061049.GI18217@ZenIV.linux.org.uk>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 18 Dec 2009 09:41:24 -0800
In-Reply-To: <20091218061049.GI18217@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 18 Dec 2009 06:10:49 +0000")
Message-ID: <adak4wk2n97.fsf_-_@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Dec 2009 17:41:24.0596 (UTC) FILETIME=[519FAB40:01CA8009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems a couple places such as arch/ia64/kernel/perfmon.c and
drivers/infiniband/core/uverbs_main.c could use anon_inode_getfile()
instead of a private pseudo-fs + alloc_file(), if only there were a way
to get a read-only file.  So provide this by having anon_inode_getfile()
create a read-only file if the fops->write passed in is NULL.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 > Good grief, what for?  We are already passing O_NDELAY in flags argument,
 > why not add O_RDWR/O_RDONLY to it?  It's not as if we had that many
 > callers, after all...

fair enough, I wasn't sure if I really liked changing the meaning of the
flags argument without any indication of that in the function signature,
but definitely the code is nicer.

so would something like this make sense?  if so I'll send follow-ups
converting ia64 / perfmon and infiniband / uverbs to anon_inodes.

 fs/anon_inodes.c    |   12 ++++++++++--
 fs/eventfd.c        |    2 +-
 fs/eventpoll.c      |    2 +-
 fs/signalfd.c       |    2 +-
 fs/timerfd.c        |    2 +-
 kernel/perf_event.c |    2 +-
 virt/kvm/kvm_main.c |    4 ++--
 7 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 2c99459..598237e 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -89,11 +89,19 @@ struct file *anon_inode_getfile(const char *name,
 	struct qstr this;
 	struct path path;
 	struct file *file;
+	fmode_t mode;
 	int error;
 
 	if (IS_ERR(anon_inode_inode))
 		return ERR_PTR(-ENODEV);
 
+	switch (flags & O_ACCMODE) {
+	case O_RDONLY: mode = FMODE_READ;		break;
+	case O_WRONLY: mode = FMODE_WRITE;		break;
+	case O_RDWR:   mode = FMODE_READ | FMODE_WRITE;	break;
+	default:       return ERR_PTR(-EINVAL);
+	}
+
 	if (fops->owner && !try_module_get(fops->owner))
 		return ERR_PTR(-ENOENT);
 
@@ -121,13 +129,13 @@ struct file *anon_inode_getfile(const char *name,
 	d_instantiate(path.dentry, anon_inode_inode);
 
 	error = -ENFILE;
-	file = alloc_file(&path, FMODE_READ | FMODE_WRITE, fops);
+	file = alloc_file(&path, mode, fops);
 	if (!file)
 		goto err_dput;
 	file->f_mapping = anon_inode_inode->i_mapping;
 
 	file->f_pos = 0;
-	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
+	file->f_flags = flags & (O_ACCMODE | O_NONBLOCK);
 	file->f_version = 0;
 	file->private_data = priv;
 
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 8b47e42..d26402f 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -339,7 +339,7 @@ struct file *eventfd_file_create(unsigned int count, int flags)
 	ctx->flags = flags;
 
 	file = anon_inode_getfile("[eventfd]", &eventfd_fops, ctx,
-				  flags & EFD_SHARED_FCNTL_FLAGS);
+				  O_RDWR | (flags & EFD_SHARED_FCNTL_FLAGS));
 	if (IS_ERR(file))
 		eventfd_free_ctx(ctx);
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 366c503..bd056a5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1206,7 +1206,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 	 * a file structure and a free file descriptor.
 	 */
 	error = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
-				 flags & O_CLOEXEC);
+				 O_RDWR | (flags & O_CLOEXEC));
 	if (error < 0)
 		ep_free(ep);
 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index b07565c..1dabe4e 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -236,7 +236,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		 * anon_inode_getfd() will install the fd.
 		 */
 		ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx,
-				       flags & (O_CLOEXEC | O_NONBLOCK));
+				       O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
 		if (ufd < 0)
 			kfree(ctx);
 	} else {
diff --git a/fs/timerfd.c b/fs/timerfd.c
index b042bd7..1bfc95a 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -200,7 +200,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
-			       flags & TFD_SHARED_FCNTL_FLAGS);
+			       O_RDWR | (flags & TFD_SHARED_FCNTL_FLAGS));
 	if (ufd < 0)
 		kfree(ctx);
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 97d1a3d..67eed80 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4720,7 +4720,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (IS_ERR(event))
 		goto err_put_context;
 
-	err = anon_inode_getfd("[perf_event]", &perf_fops, event, 0);
+	err = anon_inode_getfd("[perf_event]", &perf_fops, event, O_RDWR);
 	if (err < 0)
 		goto err_free_put_context;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e1f2bf8..b5af881 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1177,7 +1177,7 @@ static struct file_operations kvm_vcpu_fops = {
  */
 static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 {
-	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, 0);
+	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, O_RDWR);
 }
 
 /*
@@ -1638,7 +1638,7 @@ static int kvm_dev_ioctl_create_vm(void)
 	kvm = kvm_create_vm();
 	if (IS_ERR(kvm))
 		return PTR_ERR(kvm);
-	fd = anon_inode_getfd("kvm-vm", &kvm_vm_fops, kvm, 0);
+	fd = anon_inode_getfd("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (fd < 0)
 		kvm_put_kvm(kvm);
 
