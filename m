Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZGAVrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZGAVrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZGAVrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:47:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbZGAVrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:47:46 -0400
Date: Wed, 1 Jul 2009 14:47:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: xiyou.wangcong@gmail.com, ebiederm@xmission.com, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com
Subject: Re: [RESEND Patch] kcore: remove its pointless size
Message-Id: <20090701144742.6ce3535b.akpm@linux-foundation.org>
In-Reply-To: <20090630100850.GD5873@cr0.nay.redhat.com>
References: <m11vpqvozl.fsf@fess.ebiederm.org>
	<20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
	<m1tz2ei54r.fsf@fess.ebiederm.org>
	<20090618044055.GB6133@cr0.nay.redhat.com>
	<m1prd2rtdf.fsf@fess.ebiederm.org>
	<20090622085405.GA6499@cr0.nay.redhat.com>
	<20090630100850.GD5873@cr0.nay.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 18:08:50 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> 
> Linus fixes wrong size of /proc/kcore problem in commit 9063c61fd5cbd.
> 
> But its size still looks insane, since it never equals to the size
> of physical memory.

Better changelogs, please!

I think that what you're saying is that the stat.st_size field of the
/proc/kcore inode does not equal the amount of physical memory, and
that you think it should do so?

If that is correct then it would be appropriate to explain what value
the stat.st_size field has before the patch and afterwards.  Just
calling it "insane" isn't optimal.

> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: mtk.manpages@gmail.com
> 
> (Andrew, could you please just cut off the kernel part from below? :)
> 
> ---
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index 59b43a0..eca5201 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -405,9 +405,6 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
>  static int __init proc_kcore_init(void)
>  {
>  	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
> -	if (proc_root_kcore)
> -		proc_root_kcore->size =
> -				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
>  	return 0;
>  }
>  module_init(proc_kcore_init);

AFAICT this means that proc_root_kcore->size will remain uninitialised
until a process opens and reads from /proc/kcore.  So on initial boot
the `ls' output will presumably show a size of zero, and this will
change once /proc/kcore has been read?

If so, should we run get_kcore_size() in proc_kcore_init(), perhaps?

In fact, do we need to run get_kcore_size() more than once per boot? 
AFAICT we only run kclist_add() during bootup, so if proc_kcore_init()
is called at the appropriate time, we can permanently cache its result?

In which case get_kcore_size() and kclist_add() can be marked __init.

Maybe that's all wrong - I didn't look terribly closely.
