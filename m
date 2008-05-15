Return-Path: <linux-kernel-owner+w=401wt.eu-S1762592AbYEORmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbYEORmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYEORmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:42:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYEORml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:42:41 -0400
Date: Thu, 15 May 2008 10:41:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
In-Reply-To: <20080514174955.GA515@elte.hu>
Message-ID: <alpine.LFD.1.10.0805151020460.3019@woody.linux-foundation.org>
References: <20080514174955.GA515@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So looking a bit more at your trivial fixups, I'd suggest strongly that 
they be re-organized a bit.

I cherry-picked your tty layer thing, because it was a real fix.

On Wed, 14 May 2008, Ingo Molnar wrote:
>
> diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
> index 6eab9bf..e12e571 100644
> --- a/net/sunrpc/sched.c
> +++ b/net/sunrpc/sched.c
> @@ -224,9 +224,15 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
>  
>  static int rpc_wait_bit_killable(void *word)
>  {
> +	int bkl = kernel_locked();
> +
>  	if (fatal_signal_pending(current))
>  		return -ERESTARTSYS;
> +	if (bkl)
> +		unlock_kernel();
>  	schedule();
> +	if (bkl)
> +		lock_kernel();
>  	return 0;
>  }

The above doesn't even work in general. It depends on having just a single 
level of locking, and is ugly to boot. So wow about we just expose some 
version of

	depth = release_kernel_lock()
	..
	reacquire_kernel_lock(depth);

to existing BKL users as a way to safely release and re-aquire it 
regardless of depth. That makes the code more generic, but it *also* makes 
it more readable than that "if (bkl) [un]lock_kernel()" sequence.

> commit 89c25297465376321cf54438d86441a5947bbd11
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed May 14 15:10:37 2008 +0200
> 
>     remove the BKL: do not take the BKL in init code

I think this one should be changed - that comment says "do not take", but 
in fact you still do take it, you just release it earlier. So we should 
just not start out with the kernel locked in the first place. The BKL 
doesn't do anything for the init sequence anyway, since all of this is for 
code that runs before there even are any other threads (not counting the 
idle thread).

I don't see anything in there that could *possibly* depend on the kernel 
lock, and if there is anything, it would need to be fixed anyway.

> commit 5fff2843de609b77d4590e87de5c976b8ac1aacd
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed May 14 14:30:33 2008 +0200
> 
>     remove the BKL: procfs debug helper and BKL elimination

ACK. Code that relies on this is broken anyway. 

We used to have lots of "proc_create()" followed by setup code that could 
race with "proc_lookup()", but they were fundamentally racy anyway, so 
this should happen regardless of any other BKL removal.

> commit b07e615cf0f731d53a3ab431f44b1fe6ef4576e6
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed May 14 14:19:52 2008 +0200
> 
>     remove the BKL: request_module() debug helper

See the above comment about "release/reaquire_kernel_lock()".

> commit d31eec64e76a4b0795b5a6b57f2925d57aeefda5
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed May 14 13:47:58 2008 +0200
> 
>     remove the BKL: tty updates

Same thing.

> commit 3a0bf25bb160233b902962457ce917df27550850
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed May 14 11:34:13 2008 +0200
> 
>     remove the BKL: reduce misc_open() BKL dependency

Same thing.

> commit 79b2b296c31fa07e8868a6c622d766bb567f6655
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed May 14 11:30:35 2008 +0200
> 
>     remove the BKL: change get_fs_type() BKL dependency

Same thing.

> commit fc6f051a95c8774abb950f287b4b5e7f710f6977
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed May 14 09:51:42 2008 +0200
> 
>     revert ("BKL: revert back to the old spinlock implementation")

And obviously this one I'd never take. It would need to work with a 
working BKL implementation.

			Linus
