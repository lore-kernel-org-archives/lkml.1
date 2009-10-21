Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZJUJiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZJUJiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 05:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZJUJiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 05:38:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:59529 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZJUJiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 05:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Nuq9P4fn3VzG/jj4VFv+OPiVt525P9JvYuiFM9lHBgx6UQDVa0/r1wlUX6RX4003QX
         tbyu/34bnEeOUjQwe8KchUVgNYJnkhpxIsmbFelaQeSWNcTU6zAuqL1hJHvPZTbTE8x4
         vXZ6c/Uf8IAQ6U8gion2B9R632stAjZfJ8lok=
MIME-Version: 1.0
In-Reply-To: <4ADCEE6D.6050008@agilent.com>
References: <4AD8852E.2090302@agilent.com> <4ADCAC33.4070908@agilent.com>
	 <4ADCDB9A.7050701@agilent.com> <4ADCEE6D.6050008@agilent.com>
Date: Wed, 21 Oct 2009 17:38:22 +0800
Message-ID: <2375c9f90910210238i744fec42gb4d9a1c5229696f0@mail.gmail.com>
Subject: Re: [PATCH v4 1/1]: fs: pipe.c null pointer dereference + really sign 
	off + unmangled diffs
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Earl Chew <earl_chew@agilent.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 6:55 AM, Earl Chew <earl_chew@agilent.com> wrote:
> [ Exactly as before, but really sign off and tabs preserved ]
>
>
> This patch fixes a null pointer exception in pipe_rdwr_open() which
> generates the stack trace:
>
>
>> Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
>>  [<ffffffff802899a5>] pipe_rdwr_open+0x35/0x70
>>  [<ffffffff8028125c>] __dentry_open+0x13c/0x230
>>  [<ffffffff8028143d>] do_filp_open+0x2d/0x40
>>  [<ffffffff802814aa>] do_sys_open+0x5a/0x100
>>  [<ffffffff8021faf3>] sysenter_do_call+0x1b/0x67
>
>
> The failure mode is triggered by an attempt to open an anonymous
> pipe via /proc/pid/fd/* as exemplified by this script:
>
> =============================================================
> #!/bin/sh
> while : ; do
>   { echo y ; sleep 1 ; } | { while read ; do echo z$REPLY; done ; } &
>   PID=$!
>   OUT=$(ps -efl | grep 'sleep 1' | grep -v grep |
>        { read PID REST ; echo $PID; } )
>   OUT="${OUT%% *}"


Well, you can use 'pgrep', it will save you a lot here.
Try: pgrep -f 'sleep 1' -n

>   DELAY=$((RANDOM * 1000 / 32768))
>   usleep $((DELAY * 1000 + RANDOM % 1000 ))
>   echo n > /proc/$OUT/fd/1                 # Trigger defect
> done
> =============================================================
>

This still has very little chance to trigger it, I am afraid.
I tried on my machine, didn't get any oops.

Trying to use C to write it may be better.


> Note that the failure window is quite small and I could only
> reliably reproduce the defect by inserting a small delay
> in pipe_rdwr_open(). For example:
>
>  static int
>  pipe_rdwr_open(struct inode *inode, struct file *filp)
>  {
>       msleep(100);
>       mutex_lock(&inode->i_mutex);
>
>
> Although the defect was observed in pipe_rdwr_open(), I think it
> makes sense to replicate the change through all the pipe_*_open()
> functions.
>
> The core of the change is to verify that inode->i_pipe has not
> been released before attempting to manipulate it. If inode->i_pipe
> is no longer present, return ENOENT to indicate so.
>
> The comment about potentially using atomic_t for i_pipe->readers
> and i_pipe->writers has also been removed because it is no longer
> relevant in this context. The inode->i_mutex lock must be used so
> that inode->i_pipe can be dealt with correctly.


So, if I understand you correctly, you mean we have a small window
between calling sys_open() and fifo_open(), during this little period,
we don't have i_mutex held, thun another process have a chance
to release that pipe and make i_pipe NULL. Right?

Hmm, sounds reasonable. :-/

I'd like you to put the explanations into the code, as comments.

>
>
> Signed-off-by: Earl Chew <earl_chew@agilent.com>


Add some Cc, fs-devel and Al.


>
>
> --- linux-2.6.21_mvlcge500/fs/pipe.c.orig       2009-10-15 20:33:53.000000000 -0700
> +++ linux-2.6.21_mvlcge500/fs/pipe.c    2009-10-15 21:21:25.000000000 -0700
> @@ -712,36 +712,55 @@ pipe_rdwr_release(struct inode *inode, s
>  static int
>  pipe_read_open(struct inode *inode, struct file *filp)
>  {
> -       /* We could have perhaps used atomic_t, but this and friends
> -          below are the only places.  So it doesn't seem worthwhile.  */
> +       int ret = -ENOENT;
> +
>        mutex_lock(&inode->i_mutex);
> -       inode->i_pipe->readers++;
> +
> +       if (inode->i_pipe) {
> +               ret = 0;
> +               inode->i_pipe->readers++;
> +       }
> +
>        mutex_unlock(&inode->i_mutex);
>
> -       return 0;
> +       return ret;
>  }
>
>  static int
>  pipe_write_open(struct inode *inode, struct file *filp)
>  {
> +       int ret = -ENOENT;
> +
>        mutex_lock(&inode->i_mutex);
> -       inode->i_pipe->writers++;
> +
> +       if (inode->i_pipe) {
> +               ret = 0;
> +               inode->i_pipe->writers++;
> +       }
> +
>        mutex_unlock(&inode->i_mutex);
>
> -       return 0;
> +       return ret;
>  }
>
>  static int
>  pipe_rdwr_open(struct inode *inode, struct file *filp)
>  {
> +       int ret = -ENOENT;
> +
>        mutex_lock(&inode->i_mutex);
> -       if (filp->f_mode & FMODE_READ)
> -               inode->i_pipe->readers++;
> -       if (filp->f_mode & FMODE_WRITE)
> -               inode->i_pipe->writers++;
> +
> +       if (inode->i_pipe) {
> +               ret = 0;
> +               if (filp->f_mode & FMODE_READ)
> +                       inode->i_pipe->readers++;
> +               if (filp->f_mode & FMODE_WRITE)
> +                       inode->i_pipe->writers++;
> +       }
> +
>        mutex_unlock(&inode->i_mutex);
>
> -       return 0;
> +       return ret;
>  }
>
>  /*
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
