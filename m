Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZGaOBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZGaOBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZGaOBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:01:08 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41756 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZGaOBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=kTcp6aGVve5P/+ZW/mnj2JgYONk+QNOH8mbPOKeSGVe7DKUguGaF6Gdq2ui83MH+hP
         UXPZyHf1LEVsIxk7r+Uhhchdc4vJ9+Zhkys2i8oZbtHdb+0ft8hltnIlyDRtlN1WpkLq
         taUePxCcp0bze8d7aP+CAHYu4+iKRYefig8Qw=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1249029320.6391.72.camel@twins>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com>
	 <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com>
	 <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com>
	 <1249029320.6391.72.camel@twins>
Date: Fri, 31 Jul 2009 16:01:04 +0200
Message-ID: <7c86c4470907310701l463290adibd65b24e94473f3@mail.gmail.com>
Subject: Re: [RFC][PATCH] fcntl: F_[SG]ETOWN_TID
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       roland <roland@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tried this patch in 2.6.30 and perfmon given I already had a
stress test program
for this problem. I can report that the patch seems to work for me.

This is a self-sampling multi-threaded program in which each thread also
uses setitimer(ITIMER_REAL) and thus is getting SIGALRM.

First run with stock F_SETOWN:

$ self_smpl_multi  8 20000000 29 0
program_time = 8, threshold = 20000000, signum = 29 fcntl(F_SETOWN)

launch main: fd: 3, tid: 5836, self: 0x7f75f43206e0
launch side: fd: 4, tid: 5837, self: 0x40b59950
1: fd = 3, count =   30, iter =  651, rate = 46/Kiter
1: fd = 4, count =   29, iter =  623, rate = 46/Kiter
(bad thread) ser = 287, fd = 4, tid = 5836, self = 0x7f75f43206e0
2: fd = 4, count =  119, iter = 2540, rate = 46/Kiter
2: fd = 3, count =  118, iter = 2510, rate = 47/Kiter
(bad thread) ser = 330, fd = 4, tid = 5836, self = 0x7f75f43206e0
(bad thread) ser = 395, fd = 4, tid = 5836, self = 0x7f75f43206e0


The "(bad thread)" message shows up when the signal goes to the wrong
thread.

Second run with F_SETOWN_TID:

$ ./self_smpl_multi  8 20000000 29 1
program_time = 8, threshold = 20000000, signum = 29 fcntl(F_SETOWN_TID)

launch main: fd: 3, tid: 5838, self: 0x7fa1800af6e0
launch side: fd: 4, tid: 5839, self: 0x4253a950
1: fd = 4, count =   52, iter = 1115, rate = 46/Kiter
1: fd = 3, count =   52, iter = 1115, rate = 46/Kiter
2: fd = 4, count =  119, iter = 2541, rate = 46/Kiter
2: fd = 3, count =  117, iter = 2490, rate = 46/Kiter
3: fd = 3, count =  114, iter = 2427, rate = 46/Kiter
3: fd = 4, count =  119, iter = 2541, rate = 46/Kiter
4: fd = 4, count =  119, iter = 2541, rate = 46/Kiter
4: fd = 3, count =  114, iter = 2428, rate = 46/Kiter
5: fd = 4, count =  119, iter = 2541, rate = 46/Kiter

No more error messages.

Thanks.


On Fri, Jul 31, 2009 at 10:35 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> In order to direct the SIGIO signal to a particular thread of a
> multi-threaded application we cannot, like suggested by the manpage, put
> a TID into the regular fcntl(F_SETOWN) call. It will still be send to
> the whole process of which that thread is part.
>
> Since people do want to properly direct SIGIO we introduce F_SETOWN_TID,
> which functions similarly to F_SETOWN, except positive arguments are
> interpreted as TIDs and negative arguments are interpreted as PIDs.
>
> This extension is fully bug compatible with the old F_GETOWN
> implementation in that F_GETOWN_TID will be troubled by the negative
> return value for PIDs similarly to F_GETOWN's trouble with process
> groups.
>
> [ compile tested only so far ]
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/parisc/include/asm/fcntl.h |    2 +
>  fs/fcntl.c                      |   64 +++++++++++++++++++++++++++++++++-----
>  include/asm-generic/fcntl.h     |    4 ++
>  include/linux/fs.h              |   11 +++++-
>  net/socket.c                    |    2 +-
>  5 files changed, 71 insertions(+), 12 deletions(-)
>
> diff --git a/arch/parisc/include/asm/fcntl.h b/arch/parisc/include/asm/fcntl.h
> index 1e1c824..5d5235a 100644
> --- a/arch/parisc/include/asm/fcntl.h
> +++ b/arch/parisc/include/asm/fcntl.h
> @@ -28,6 +28,8 @@
>  #define F_SETOWN       12      /*  for sockets. */
>  #define F_SETSIG       13      /*  for sockets. */
>  #define F_GETSIG       14      /*  for sockets. */
> +#define F_GETOWN_TID   15
> +#define F_SETOWN_TID   16
>
>  /* for posix fcntl() and lockf() */
>  #define F_RDLCK                01
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index ae41308..8d0b7f9 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -197,13 +197,15 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
>  }
>
>  static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
> -                     int force)
> +                     int flags)
>  {
>        write_lock_irq(&filp->f_owner.lock);
> -       if (force || !filp->f_owner.pid) {
> +       if ((flags & FF_SETOWN_FORCE) || !filp->f_owner.pid) {
>                put_pid(filp->f_owner.pid);
>                filp->f_owner.pid = get_pid(pid);
>                filp->f_owner.pid_type = type;
> +               filp->f_owner.task_only =
> +                       (type == PIDTYPE_PID && (flags & FF_SETOWN_TID));
>
>                if (pid) {
>                        const struct cred *cred = current_cred();
> @@ -215,7 +217,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
>  }
>
>  int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
> -               int force)
> +               int flags)
>  {
>        int err;
>
> @@ -223,12 +225,12 @@ int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
>        if (err)
>                return err;
>
> -       f_modown(filp, pid, type, force);
> +       f_modown(filp, pid, type, flags);
>        return 0;
>  }
>  EXPORT_SYMBOL(__f_setown);
>
> -int f_setown(struct file *filp, unsigned long arg, int force)
> +int f_setown(struct file *filp, unsigned long arg, int flags)
>  {
>        enum pid_type type;
>        struct pid *pid;
> @@ -241,7 +243,7 @@ int f_setown(struct file *filp, unsigned long arg, int force)
>        }
>        rcu_read_lock();
>        pid = find_vpid(who);
> -       result = __f_setown(filp, pid, type, force);
> +       result = __f_setown(filp, pid, type, flags);
>        rcu_read_unlock();
>        return result;
>  }
> @@ -263,6 +265,40 @@ pid_t f_getown(struct file *filp)
>        return pid;
>  }
>
> +static int f_setown_tid(struct file *filp, unsigned long arg)
> +{
> +       int flags = FF_SETOWN_FORCE;
> +       struct pid *pid;
> +       int who = arg;
> +       int ret = 0;
> +
> +       if (who < 0)
> +               who = -who;
> +       else
> +               flags |= FF_SETOWN_TID;
> +
> +       rcu_read_lock();
> +       pid = find_vpid(who);
> +       ret = __f_setown(filp, pid, PIDTYPE_PID, flags);
> +       rcu_read_unlock();
> +
> +       return ret;
> +}
> +
> +static pid_t f_getown_tid(struct file *filp)
> +{
> +       pid_t tid;
> +
> +       read_lock(&filp->f_owner.lock);
> +       tid = pid_vnr(filp->f_owner.pid);
> +       if (filp->f_owner.pid_type == PIDTYPE_PGID)
> +               tid = 0;
> +       if (!filp->f_owner.task_only)
> +               tid = -tid;
> +       read_unlock(&filp->f_owner.lock);
> +       return tid;
> +}
> +
>  static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
>                struct file *filp)
>  {
> @@ -311,7 +347,14 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
>                force_successful_syscall_return();
>                break;
>        case F_SETOWN:
> -               err = f_setown(filp, arg, 1);
> +               err = f_setown(filp, arg, FF_SETOWN_FORCE);
> +               break;
> +       case F_GETOWN_TID:
> +               err = f_getown_tid(filp);
> +               force_successful_syscall_return();
> +               break;
> +       case F_SETOWN_TID:
> +               err = f_setown_tid(filp, arg);
>                break;
>        case F_GETSIG:
>                err = filp->f_owner.signum;
> @@ -431,6 +474,7 @@ static void send_sigio_to_task(struct task_struct *p,
>                               int fd,
>                               int reason)
>  {
> +       int (*send_sig)(int, struct siginfo *, struct task_struct *);
>        /*
>         * F_SETSIG can change ->signum lockless in parallel, make
>         * sure we read it once and use the same value throughout.
> @@ -440,6 +484,8 @@ static void send_sigio_to_task(struct task_struct *p,
>        if (!sigio_perm(p, fown, signum))
>                return;
>
> +       send_sig = fown->task_only ? send_sig_info : group_send_sig_info;
> +
>        switch (signum) {
>                siginfo_t si;
>                default:
> @@ -461,11 +507,11 @@ static void send_sigio_to_task(struct task_struct *p,
>                        else
>                                si.si_band = band_table[reason - POLL_IN];
>                        si.si_fd    = fd;
> -                       if (!group_send_sig_info(signum, &si, p))
> +                       if (!send_sig(signum, &si, p))
>                                break;
>                /* fall-through: fall back on the old plain SIGIO signal */
>                case 0:
> -                       group_send_sig_info(SIGIO, SEND_SIG_PRIV, p);
> +                       send_sig(SIGIO, SEND_SIG_PRIV, p);
>        }
>  }
>
> diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
> index 4d3e483..d7906b8 100644
> --- a/include/asm-generic/fcntl.h
> +++ b/include/asm-generic/fcntl.h
> @@ -73,6 +73,10 @@
>  #define F_SETSIG       10      /* for sockets. */
>  #define F_GETSIG       11      /* for sockets. */
>  #endif
> +#ifndef F_SETOWN_TID
> +#define F_SETOWN_TID   12
> +#define F_GETOWN_TID   13
> +#endif
>
>  /* for F_[GET|SET]FL */
>  #define FD_CLOEXEC     1       /* actually anything with low bit set goes */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0872372..42697e7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -872,6 +872,7 @@ struct fown_struct {
>        rwlock_t lock;          /* protects pid, uid, euid fields */
>        struct pid *pid;        /* pid or -pgrp where SIGIO should be sent */
>        enum pid_type pid_type; /* Kind of process group SIGIO should be sent to */
> +       bool task_only;         /* task or group signal */
>        uid_t uid, euid;        /* uid/euid of process setting the owner */
>        int signum;             /* posix.1b rt signal to be delivered on IO */
>  };
> @@ -1291,8 +1292,14 @@ extern void kill_fasync(struct fasync_struct **, int, int);
>  /* only for net: no internal synchronization */
>  extern void __kill_fasync(struct fasync_struct *, int, int);
>
> -extern int __f_setown(struct file *filp, struct pid *, enum pid_type, int force);
> -extern int f_setown(struct file *filp, unsigned long arg, int force);
> +/*
> + * setown flags
> + */
> +#define FF_SETOWN_FORCE                1
> +#define FF_SETOWN_TID          2
> +
> +extern int __f_setown(struct file *filp, struct pid *, enum pid_type, int flags);
> +extern int f_setown(struct file *filp, unsigned long arg, int flags);
>  extern void f_delown(struct file *filp);
>  extern pid_t f_getown(struct file *filp);
>  extern int send_sigurg(struct fown_struct *fown);
> diff --git a/net/socket.c b/net/socket.c
> index 791d71a..ac57f8e 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -916,7 +916,7 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>                        err = -EFAULT;
>                        if (get_user(pid, (int __user *)argp))
>                                break;
> -                       err = f_setown(sock->file, pid, 1);
> +                       err = f_setown(sock->file, pid, FF_SETOWN_FORCE);
>                        break;
>                case FIOGETOWN:
>                case SIOCGPGRP:
>
>
>
