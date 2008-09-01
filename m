Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbYIAL6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbYIAL6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYIAL6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:58:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37883 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbYIAL6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:58:30 -0400
To: ebiederm@xmission.com
CC: tj@kernel.org, miklos@szeredi.hu, serue@us.ibm.com, greg@kroah.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <m163pjr5qf.fsf@frodo.ebiederm.org>
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
	<1219945263-21074-6-git-send-email-tj@kernel.org>
	<20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org>
	<48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>
	<48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>
	<48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>
	<48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>
	<48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>
	<48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>
	<48B7BB4C.4060907@kernel.org> <m163pjr5qf.fsf@frodo.ebiederm.org>
Message-Id: <E1Ka82g-0003NU-4D@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 01 Sep 2008 13:57:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, ebiederm@xmission.com (Eric W. Biederman)
> Tejun Heo <tj@kernel.org> writes:
> > The FUSE server gets task->pid.  IIUC, if the FUSE server is not in a
> > container, task->pid should work fine whether the caller is in
> > container or not, right?  And if the FUSE server is in a container,
> > it's hell lot more complex and FUSE may have to map task->pid to what
> > FUSE server would know if possible?
> 
> Implementation wise it is not too bad.
> 
>            FUSE ----------------
> pid = get_pid(task_tid(current))
>             ^                   |
>             |                   |        kernel
>                           pid_vnr(pid)

Ahh, thanks.  I'll need to fix this up then, regardless of any ioctl
issues, so that the tid supplied to the userspace filesystem actually
makes sense in a containerized environment.

> However it is a largely an insane idea.
> - Write is not implemented for /proc/PID/task/TID/mem

Mmm,  that does pose a bit of a problem :)

> - It would be better if the kernel handed you back a file descriptor
> to the other process memory rather than you having to generate one.

Yep, that could be done...

> - To access /proc/PID/task/TID/mem you need to have CAP_PTRACE.

Yes, but access to the other process's address space requires some
sort of privilege anyway.  It would not do to have an unprivileged
process peek at arbitrary addresses in the other process's memory, and
that is exactly what generic ioctl support requires.

> - This seems to allow for random ioctls.  With the compat_ioctl
> thing we have largely stomped on that idea.  So you should only need
> to deal with well defined ioctls.  At which point why do you need to
> directly access the memory of another process.
> 
> So why not just only support well defined ioctls and serialize them
> in the kernel and allow the receiving process to deserialize them?

I'd like the idea of limiting to well behaved ioctls, but Tejun
doesn't...

> That would allow all of this to happen with a non-privileged server
> which makes the functionality much more useful.

There's still a security issue, because we cannot verify *if* a
particular ioctl is indeed well behaved: only the application and the
driver knows that, and the application cannot tell us (ioctl interface
is broken, broken, broken), and we don't trust the server.

Thanks,
Miklos
