Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZJSTnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZJSTnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbZJSTnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:43:06 -0400
Received: from fifo99.com ([67.223.236.141]:51866 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZJSTnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:43:05 -0400
Subject: Re: [PATCH v2 1/1]: fs: pipe.c null pointer dereference + sign off
From: Daniel Walker <dwalker@fifo99.com>
To: Earl Chew <earl_chew@agilent.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4ADCAC33.4070908@agilent.com>
References: <4AD8852E.2090302@agilent.com>  <4ADCAC33.4070908@agilent.com>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 12:43:15 -0700
Message-Id: <1255981395.23353.46.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 11:13 -0700, Earl Chew wrote:
> [ Exactly as before, but with sign off ]
> 

You've got a few more submission related issues, see below.

> This patch fixes a null pointer exception in pipe_rdwr_open() which
> generates the stack trace:
> 
> 
>  > Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
>  >  [<ffffffff802899a5>] pipe_rdwr_open+0x35/0x70
>  >  [<ffffffff8028125c>] __dentry_open+0x13c/0x230
>  >  [<ffffffff8028143d>] do_filp_open+0x2d/0x40
>  >  [<ffffffff802814aa>] do_sys_open+0x5a/0x100
>  >  [<ffffffff8021faf3>] sysenter_do_call+0x1b/0x67
> 
> This defect is also described in:
>    http://lkml.org/lkml/2009/10/14/184
>    http://bugzilla.kernel.org/show_bug.cgi?id=14416
> 
> 
> The failure mode is triggered by an attempt to open an anonymous
> pipe via /proc/pid/fd/* as exemplified by this script:
> 
> =============================================================
> #!/bin/sh
> while : ; do
>     { echo y ; sleep 1 ; } | { while read ; do echo z$REPLY; done ; } &
>     PID=$!
>     OUT=$(ps -efl | grep 'sleep 1' | grep -v grep |
>          { read PID REST ; echo $PID; } )
>     OUT="${OUT%% *}"
>     DELAY=$((RANDOM * 1000 / 32768))
>     usleep $((DELAY * 1000 + RANDOM % 1000 ))
>     echo n > /proc/$OUT/fd/1                 # Trigger defect
> done
> =============================================================
> 
> Note that the failure window is quite small and I could only
> reliably reproduce the defect by inserting a small delay
> in pipe_rdwr_open(). For example:
> 
>   static int
>   pipe_rdwr_open(struct inode *inode, struct file *filp)
>   {
>         msleep(100);
>         mutex_lock(&inode->i_mutex);
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
> 
> 
> Signed-off-by: Earl Chew <earl_chew@agilent.com>
> 
> 
> --- linux-2.6.21_mvlcge500/fs/pipe.c.orig    2009-10-15 
> 20:33:53.000000000 -0700
> +++ linux-2.6.21_mvlcge500/fs/pipe.c    2009-10-15 21:21:25.000000000 -0700
> @@ -712,36 +712,55 @@ pipe_rdwr_release(struct inode *inode, s
>   static int

You patch looks like it might be line wrapped .. Sometimes mailers will
do that if you don't tell them the content is already formatted.

Also I see your using a MontaVista kernel, which is older than current
mainline .. I would assume you tested this on a recent kernel also?

>   pipe_read_open(struct inode *inode, struct file *filp)
>   {
> -    /* We could have perhaps used atomic_t, but this and friends
> -       below are the only places.  So it doesn't seem worthwhile.  */
> +    int ret = -ENOENT;

>From checkpatch,

ERROR: code indent should use tabs where possible
#125: FILE: fs/pipe.c:720:
+        ret = 0;$

It looks like maybe your mailer (or copy and paste) may have stripped
all the tabs off your patch. This makes is very difficult to apply.


Daniel

