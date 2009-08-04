Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZHDMYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZHDMYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZHDMYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:24:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58850 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311AbZHDMYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:24:50 -0400
Date: Tue, 4 Aug 2009 14:24:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Patch 1/2] ia32: use generic sys_pipe()
Message-ID: <20090804122432.GB4367@elte.hu>
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722091051.6621.15184.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Amerigo Wang <amwang@redhat.com> wrote:

> As suggested by Al, it's better to use the generic sys_pipe() for 
> ia32.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> CC: Linus Torvalds <torvalds@linux-foundation.org>

> --- a/arch/x86/ia32/sys_ia32.c
> +++ b/arch/x86/ia32/sys_ia32.c
> @@ -189,20 +189,6 @@ asmlinkage long sys32_mprotect(unsigned long start, size_t len,
>  	return sys_mprotect(start, len, prot);
>  }
>  
> -asmlinkage long sys32_pipe(int __user *fd)
> -{
> -	int retval;
> -	int fds[2];
> -
> -	retval = do_pipe_flags(fds, 0);
> -	if (retval)
> -		goto out;
> -	if (copy_to_user(fd, fds, sizeof(fds)))
> -		retval = -EFAULT;
> -out:
> -	return retval;
> -}

Please _ALWAYS_ mention the change in behavior in the changelog, 
just in case someone ends up bisecting it. I only found out when i 
reviewed the two syscalls out of caution.

The syscall you remove kept stale fd's around in case of -EFAULT 
from copy_to_user(). The generic version does an explicit close of 
those files:

                        sys_close(fd[0]);
                        sys_close(fd[1]);
                        error = -EFAULT;

The generic version looks like the better choice to me but this 
difference should be mentioned in the changelog nevertheless, just 
in case some buggy app runs into this issue.

	Ingo
