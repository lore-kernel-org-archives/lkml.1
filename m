Return-Path: <linux-kernel-owner+w=401wt.eu-S934244AbZLMBsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbZLMBsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934211AbZLMBse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:48:34 -0500
Received: from www.tglx.de ([62.245.132.106]:34360 "HELO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934156AbZLMBsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:48:32 -0500
Date: Sat, 12 Dec 2009 23:34:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <20091212110240.194760cc@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0912122333260.3089@localhost.localdomain>
References: <20091211232805.GA10652@kroah.com> <20091212084611.GA28266@elte.hu> <20091212013927.58d386d1.akpm@linux-foundation.org> <20091212110240.194760cc@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Dec 2009, Alan Cox wrote:

> > The do_tty_hangup()->tty_fasync() path takes the locks in the
> > file_list_lock()->lock_kernel() direction whereas most other code takes
> > them in the other direction, which cannot be good.  But I'm not sure
> 
> Thats a bug - the BKL does want to be taken first (and will
> sleep/yield/drop)
> 
> > Have a trace.  I'm actually wondering if perhaps there's a missing
> > unlock_kernel() somewhere else, and the tty code is just the victim of
> > that.
> 
> It's introduced by the BKL shuffle. Try the following
> 
> 
> commit 1f61f07a985c7e8cfc20ad8fcced2f3d226bd0dc
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Sat Dec 12 10:32:36 2009 +0000
> 
>     tty: Fix the AB-BA locking bug introduced in the BKL split
>     
>     The fasync path takes the BKL (it probably doesn't need to in fact) but
>     this causes lock inversions and deadlocks so we can't do that. Leave the
>     BKL over that bit for the moment.
>     
>     Identified by AKPM.
>     
>     Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-and-Tested-by: Thomas Gleixner <tglx@linutronix.de>

 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index 684f0e0..f15df40 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -516,7 +516,6 @@ static void do_tty_hangup(struct work_struct *work)
>  	/* inuse_filps is protected by the single kernel lock */
>  	lock_kernel();
>  	check_tty_count(tty, "do_tty_hangup");
> -	unlock_kernel();
>  
>  	file_list_lock();
>  	/* This breaks for file handles being sent over AF_UNIX sockets ? */
> @@ -531,7 +530,6 @@ static void do_tty_hangup(struct work_struct *work)
>  	}
>  	file_list_unlock();
>  
> -	lock_kernel();
>  	tty_ldisc_hangup(tty);
>  
>  	read_lock(&tasklist_lock);
> 
