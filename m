Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbYDNPBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbYDNPBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbYDNPBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:01:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:32805 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710AbYDNPA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:00:59 -0400
Date: Mon, 14 Apr 2008 10:00:57 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 2/2] fix sys_unshare()+SEM_UNDO: perform an implicit
	CLONE_SYSVSEM in CLONE_NEWIPC
Message-ID: <20080414150057.GB15667@sergelap.austin.ibm.com>
References: <200804130848.m3D8mdo2007124@mail.q-ag.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804130848.m3D8mdo2007124@mail.q-ag.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Manfred Spraul (manfred@colorfullife.com):
> sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
> cause a kernel memory corruption. CLONE_NEWIPC must detach from the existing
> undo lists.
> Fix, part 2: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC.
> CLONE_NEWIPC creates a new IPC namespace, the task cannot access the
> existing semaphore arrays after the unshare syscall. Thus the task
> can/must detach from the existing undo list entries, too.
> 
> This fixes the kernel corruption, because it makes it impossible that
> undo records from two different namespaces are in sysvsem.undo_list.

So this was never an issue with clone(CLONE_NEWIPC|CLONE_SYSVSEM), which
should have had the same result as unshare(CLONE_NEWIPC&~CLONE_SYSVSEM)?

> I'm not sure who's the right maintainer, Andrew, could you merge it?
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  kernel/fork.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 7f242b0..6f956a7 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1735,9 +1735,13 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
>  		goto bad_unshare_cleanup_semundo;
> 
>  	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
> -		if (unshare_flags & CLONE_SYSVSEM) {
> +		if (unshare_flags & (CLONE_NEWIPC|CLONE_SYSVSEM)) {
>  			/*
>  			 * CLONE_SYSVSEM is equivalent to sys_exit().
> +			 *
> +			 * CLONE_NEWIPC must also detach from the undolist: after switching
> +			 * to a new ipc namespace, the semaphore arrays from the old
> +			 * namespace are unreachable.
>  			 */
>  			exit_sem(current);
>  		}
> -- 
> 1.5.4.1
