Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbZJNNxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbZJNNxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761796AbZJNNxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:53:51 -0400
Received: from aglcosbs01.cos.agilent.com ([192.25.218.35]:47015 "EHLO
	aglcosbs01.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761788AbZJNNxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:53:50 -0400
X-Greylist: delayed 801 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2009 09:53:50 EDT
Message-ID: <4AD5D476.6010103@agilent.com>
Date: Wed, 14 Oct 2009 06:39:02 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: fs/pipe.c null pointer dereference
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2009 13:39:05.0843 (UTC) FILETIME=[B3004430:01CA4CD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on a 2.6.21 based kernel and received the following
oops last tonight:

> stopped custom tracer.
> Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
>  [<ffffffff802899a5>] pipe_rdwr_open+0x35/0x70
> PGD 17d198067 PUD 17c672067 PMD 0
> Oops: 0002 [1] PREEMPT SMP
> CPU 0
> Modules linked in: jffs2 cfi_cmdset_0001 cfi_util cfi_probe gen_probe physmap_lo e1000e fakephp amp_uio uio coretemp lm90 hwmon w83627ehf ipmi_watchdog ipmi_devintf ipmi_si ipmi_msghandler ppdev physmap mtdpart chipreg map_funcs mtdblock mtd_blkdevs mtdchar mtdcore
> Pid: 6928, comm: poll Not tainted 2.6.21-amp64c-10X-n2x-10X #1
> RIP: 0010:[<ffffffff802899a5>]  [<ffffffff802899a5>] pipe_rdwr_open+0x35/0x70
> RSP: 0018:ffff81017c583e48  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff81017c9bc490 RCX: ffffffff80e48c00
> RDX: ffff81017c583fd8 RSI: ffff81017c603040 RDI: ffff81000642bf40
> RBP: ffff81017cf2dec0 R08: ffff81017c582000 R09: 0000000000000082
> R10: ffff81017d1b6000 R11: ffffffff802985f0 R12: ffff81017c9bc550
> R13: ffffffff80289970 R14: ffff81017cea1e90 R15: ffff81017fc2c980
> FS:  0000000000000000(0000) GS:ffffffff806b30c0(0063) knlGS:00000000f7dc16c0
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 00000000f7dfb040 CR3: 000000017c5bc000 CR4: 00000000000006e0
> Process poll (pid: 6928, threadinfo ffff81017c582000, task ffff81017c603040)
> Stack:  ffff81017cf2dec0 ffff81017c9bc490 0000000000008000 ffffffff8028125c
>  ffff81017c603040 0000000000008000 ffff81017f68e000 0000000000008000
>  0000000000000004 00000000ffffff9c 0000000000000000 ffffffff8028143d
> Call Trace:
>  [<ffffffff8028125c>] __dentry_open+0x13c/0x230
>  [<ffffffff8028143d>] do_filp_open+0x2d/0x40
>  [<ffffffff802814aa>] do_sys_open+0x5a/0x100
>  [<ffffffff8021faf3>] sysenter_do_call+0x1b/0x67
> 
> 
> Code: 83 40 28 01 8b 45 38 a8 02 74 0b 48 8b 83 d8 01 00 00 83 40
> RIP  [<ffffffff802899a5>] pipe_rdwr_open+0x35/0x70
>  RSP <ffff81017c583e48>
> CR2: 0000000000000028

The null dereference is happening at the ++ operator in:

 > static int
 > pipe_rdwr_open(struct inode *inode, struct file *filp)
 > {
 >         mutex_lock(&inode->i_mutex);
 >         if (filp->f_mode & FMODE_READ)
 >                 inode->i_pipe->readers++;

The corresponding assembler is:

> 0000000000000190 <pipe_rdwr_open>:
>      190:       48 83 ec 18             sub    $0x18,%rsp
>      194:       4c 89 64 24 10          mov    %r12,0x10(%rsp)
>      199:       4c 8d a7 c0 00 00 00    lea    0xc0(%rdi),%r12
>      1a0:       48 89 1c 24             mov    %rbx,(%rsp)
>      1a4:       48 89 6c 24 08          mov    %rbp,0x8(%rsp)
>      1a9:       48 89 fb                mov    %rdi,%rbx
>      1ac:       48 89 f5                mov    %rsi,%rbp
>      1af:       4c 89 e7                mov    %r12,%rdi
>      1b2:       e8 00 00 00 00          callq  1b7 <pipe_rdwr_open+0x27>
>                         1b3: R_X86_64_PC32      mutex_lock+0xfffffffffffffffc
>      1b7:       8b 45 38                mov    0x38(%rbp),%eax
>      1ba:       a8 01                   test   $0x1,%al
>      1bc:       74 0e                   je     1cc <pipe_rdwr_open+0x3c>
>      1be:       48 8b 83 d8 01 00 00    mov    0x1d8(%rbx),%rax
>      1c5:       83 40 28 01             addl   $0x1,0x28(%rax)    <--------**** FAULT HERE ****

IOW i_pipe is NULL, apparently set by free_pipe_info()

I went trawling through the code to see if I could figure out
how this might have happened. The are mutexes of the form:

        mutex_lock(&inode->i_mutex);
          ...
        mutex_unlock(&inode->i_mutex);

throughout fs/pipe.c and fs/fifo.c so the above seems to be
an impossibility ;-)


Perhaps there is a potential window for failure in fs/fifo.c.

pipe_rdwr_open() is only accessible via rdwr_pipefifo_fops and
that is obtained via fs/fifo.c.

Looking at fs/fifo.c I see:

        mutex_lock(&inode->i_mutex);
          ...
        switch (filp->f_mode) {
        case FMODE_READ:
                ...
                 if (!pipe->writers) {
                       wait_for_partner(inode, filp, &pipe->w_counter);
                ...
        case FMODE_WRITE:
                ...
                 if (!pipe->readers) {
                         wait_for_partner(inode, filp, &pipe->r_counter);
                ...

        case FMODE_READ | FMODE_WRITE:
                 filp->f_op = &rdwr_pipefifo_fops;
                   ...
                 if (pipe->readers == 1 || pipe->writers == 1)
                         wake_up_partner(inode);
                 break;

        }
          ...
        mutex_unlock(&inode->i_mutex);

So it turns out that FMODE_READ|FMODE_WRITE does not block.

However, FMODE_READ alone or FMODE_WRITE alone may call
wait_for_partner(), which in turn calls pipe_wait(), which
in turn drops the mutex, then reacquires it:

> void pipe_wait(struct pipe_inode_info *pipe)
> {
 >          ...
>         if (pipe->inode)
>                 mutex_unlock(&pipe->inode->i_mutex);
 >          ...
>         if (pipe->inode)
>                 mutex_lock(&pipe->inode->i_mutex);
> }

So perhaps:

1. Process A calls fifo_open(FMODE_READ), then relinquishes
    the mutex at pipe_wait() (readers == 1, writers == 0)

2. Process B calls fifo_open(FMODE_WRITE|FMODE_READ) and completes
    (readers == 2, writers == 1)

3. Process A wakes, but finds signal pending, so goes to err_rd
    and drops readers to 1

  ... but I couldn't figure out a way for this to fail ...

Any other ideas?

Earl


