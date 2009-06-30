Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbZF3AJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbZF3AJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZF3AJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:09:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46365 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbZF3AJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:09:33 -0400
Date: Tue, 30 Jun 2009 02:06:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090630000618.GA18342@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090629003514.GC2479@localhost.localdomain> <20090628222455.GA21475@redhat.com> <20090629023621.GA4289@localhost.localdomain> <20090628233200.GA26669@redhat.com> <20090629102152.GA7993@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629102152.GA7993@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Neil Horman wrote:
>
> On Mon, Jun 29, 2009 at 01:32:00AM +0200, Oleg Nesterov wrote:
> > On 06/28, Neil Horman wrote:
> > >
> > > On Mon, Jun 29, 2009 at 12:24:55AM +0200, Oleg Nesterov wrote:
> > > >
> > > > Perhaps this sysctl should be added in a separate patch? This patch mixes
> > > > differents things imho.
> > > >
> > > No, I disagree. If we're going to have a sysctl, It should be added in this
> > > patch.  I agree that since these processes run as root, we can have all sort of
> > > bad things happen.  But I think theres an advantage to being able to limit the
> > > damage that a core_pattern process can do if it never exits.
> >
> > Yes, but why it should be added in this patch?
> >
> I agree with what you said earlier, in that the sysctl is orthogonal to the
> wait_for_complete functionality, from an implementation standpoint.  But I don't
> feel as though they are independent from a behavioral standpoint.

I think they are ;)

> Given that
> the sysctl defines a default value of zero in which unlimited parallel core
> dumps are allowed, but none are waited for, separating the patches creates a
> behavioral split in which the the core_pattern behavior changes for the span of
> one commit, and in such a way that the system can deadlock if the core_pattern
> process does bad things.  To illustrate, say we applied the wait_for_core patch
> separately from sysctl patch.  If someone built with both patches, their
> core_pattern behavior would appear unchanged, but if they built with only the
> first patch, and their core_pattern app had a bug in which the process never
> exited properly, they would get an unbounded backlog of unreaped processes.

Just send the sysctl first. If this limit makes sense (I think yes), then
it makes sense even without wait_for_core patch, because the buggy core_pattern
app can make problems even without wait_for_core.

This looks so obvious to me, but of course please do what you think right.

(from another message)
>
> So, I'd like to solicit your opinion on something here.  I've run into an
> interesting chicken and egg problem in attempting to implement this.  I found
> that while implementing this, that the user space component might be reliying on
> an feof condition on stdin to determine when to stop reading from the pipe.

I see.

> I see
> two options:
>
> 1) Require user space to parse the core file during its read, to know how much
> data to extract from the pipe, and call it a user space problem if they read
> more than that and wind up blocking indefinately?

I don't think we should break user-space.

> 2) Develop another way to detect that userspace is done and has exited.

Yes, as I said we can implement UMH_WAIT_CUSTOM_COMPLETION, but this needs
changes in kmod.c

> I personally like option 2, and I think I can do it using the inotify

Well, not good to depend on CONFIG_INOTIFY, and this looks like an overkill
to me.

How about (completely untested) patch below?

Oleg.


--- WAIT/fs/exec.c~CD_3_CLOSE_WAIT	2009-06-30 01:26:38.000000000 +0200
+++ WAIT/fs/exec.c	2009-06-30 01:47:18.000000000 +0200
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/pipe_fs_i.h>
 #include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
@@ -1710,6 +1711,23 @@ int get_dumpable(struct mm_struct *mm)
 	return (ret >= 2) ? 2 : ret;
 }
 
+static void xxx(struct file *file)
+{
+	struct pipe_inode_info *pipe = file->f_path.dentry->d_inode->i_pipe;
+
+	pipe_lock(pipe);
+	while (pipe->readers) {
+		pipe->readers++;
+		pipe->writers--;
+		wake_up_interruptible_sync(&pipe->wait);
+		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+		pipe_wait(pipe);
+		pipe->writers++;
+		pipe->readers--;
+	}
+	pipe_unlock(pipe);
+}
+
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
@@ -1853,11 +1871,12 @@ void do_coredump(long signr, int exit_co
 		current->signal->group_exit_code |= 0x80;
 
 close_fail:
+	if (ispipe)
+		xxx(file);
 	filp_close(file, NULL);
 fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
-
 	coredump_finish(mm);
 	revert_creds(old_cred);
 fail_creds:

