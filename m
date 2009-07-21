Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZGUL6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZGUL6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZGUL6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:58:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40069 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZGUL6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:58:19 -0400
To: peterz@infradead.org
CC: eric.sesterhenn@lsexperts.de, linux-kernel@vger.kernel.org,
       mingo@redhat.com, miklos@szeredi.hu
In-reply-to: <1248163763.15751.11098.camel@twins> (message from Peter Zijlstra
	on Tue, 21 Jul 2009 10:09:23 +0200)
Subject: Re: Lockdep warning for sys_tee system call
References: <1248159597.3794.9.camel@queen> <1248163763.15751.11098.camel@twins>
Message-Id: <E1MTDyo-0002rz-FR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 21 Jul 2009 13:57:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Peter Zijlstra wrote:
> void pipe_double_lock(struct pipe_inode_info *pipe1,
> 		      struct pipe_inode_info *pipe2)
> {
> 	BUG_ON(pipe1 == pipe2);
> 
> 	if (pipe1 < pipe2) {
> 		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
> 		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
> 	} else {
> 		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
> 		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
> 	}
> }
> 
> That's an obvious FAIL right there.
> 
> Miklos?

Right, copy-paste bug.  At least I got the locking right ;)

Acked-by: Miklos Szeredi <mszeredi@suse.cz>

Thanks,
Miklos

> 
> ---
> Subject: fs/pipe: rectify a lockdep annotation
> 
> The presumed use of the pipe_double_lock() routine is to lock 2 locks in
> a deadlock free way by ordering the locks by their address. However it
> fails to keep the specified lock classes in order and explicitly
> annotates a deadlock.
> 
> Rectify this.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  fs/pipe.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index f7dd21a..52c4151 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -68,8 +68,8 @@ void pipe_double_lock(struct pipe_inode_info *pipe1,
>  		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
>  		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
>  	} else {
> -		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
> -		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
> +		pipe_lock_nested(pipe2, I_MUTEX_PARENT);
> +		pipe_lock_nested(pipe1, I_MUTEX_CHILD);
>  	}
>  }
>  
> 
> 
