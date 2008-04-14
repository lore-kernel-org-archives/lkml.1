Return-Path: <linux-kernel-owner+w=401wt.eu-S1761842AbYDNVo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761842AbYDNVo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYDNVoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:44:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35093 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbYDNVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:44:18 -0400
Date: Mon, 14 Apr 2008 16:44:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Pierre PEIFFER <pierre.peiffer@bull.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH 1/2] fix sys_unshare()+SEM_UNDO: add support for
	CLONE_SYSVSEM
Message-ID: <20080414214417.GA1761@sergelap.austin.ibm.com>
References: <200804130848.m3D8mU7D007104@mail.q-ag.de> <20080413015936.580bf7fe.akpm@linux-foundation.org> <4801F038.8020003@colorfullife.com> <20080414145840.GA15667@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414145840.GA15667@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Manfred Spraul (manfred@colorfullife.com):
> > Andrew Morton wrote:
> >> On Sun, 13 Apr 2008 10:04:17 +0200 Manfred Spraul 
> >> <manfred@colorfullife.com> wrote:
> >>
> >>   
> >>> sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this 
> >>> can
> >>> cause a kernel memory corruption. CLONE_NEWIPC must detach from the 
> >>> existing
> >>> undo lists.
> >>> Fix, part 1: add support for sys_unshare(CLONE_SYSVSEM)
> >>>
> >>>     
> >>
> >> Is this a non-back-compatible change?
> >>
> >>   
> > It adds a new feature - previously sys_unshare(CLONE_SYSVSEM) returned 
> > -EINVAL.
> >
> >>> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> >>> ---
> >>>  ipc/sem.c     |    1 +
> >>>  kernel/fork.c |   18 ++++++++++++++----
> >>>  2 files changed, 15 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/ipc/sem.c b/ipc/sem.c
> >>> index 0b45a4d..35841bd 100644
> >>> --- a/ipc/sem.c
> >>> +++ b/ipc/sem.c
> >>> @@ -1298,6 +1298,7 @@ void exit_sem(struct task_struct *tsk)
> >>>  	undo_list = tsk->sysvsem.undo_list;
> >>>  	if (!undo_list)
> >>>  		return;
> >>> +	tsk->sysvsem.undo_list = NULL;
> >>>   	if (!atomic_dec_and_test(&undo_list->refcnt))
> >>>  		return;
> >>> diff --git a/kernel/fork.c b/kernel/fork.c
> >>> index 9c042f9..7f242b0 100644
> >>> --- a/kernel/fork.c
> >>> +++ b/kernel/fork.c
> >>> @@ -1675,13 +1675,17 @@ static int unshare_fd(unsigned long 
> >>> unshare_flags, struct files_struct **new_fdp
> >>>  }
> >>>   /*
> >>> - * Unsharing of semundo for tasks created with CLONE_SYSVSEM is not
> >>> - * supported yet
> >>> + * Unsharing of semundo for tasks created with CLONE_SYSVSEM doesn't 
> >>> require
> >>> + * any allocations: it means that the task leaves the existing undo 
> >>> lists,
> >>> + * just like sys_exit(). The new undo lists are allocated on demand in 
> >>> the
> >>> + * ipc syscalls.
> >>> + * new_ulistp is set to a non-NULL value, the caller expects that on 
> >>> success.
> >>>   */
> >>>  static int unshare_semundo(unsigned long unshare_flags, struct 
> >>> sem_undo_list **new_ulistp)
> >>>  {
> >>> -	if (unshare_flags & CLONE_SYSVSEM)
> >>> -		return -EINVAL;
> >>> +	if (unshare_flags & CLONE_SYSVSEM) {
> >>> +		*new_ulistp = (void*)1;
> >>> +	}
> >>>     
> >>
> >> And can we do anything nicer than this?
> >>
> >>   
> > Attached is an alternative. If you prefer it, I'll send another patch set.
> 
> FWIW I definately far far prefer this version  :)
> 
> As for 'maintainers', in the end wrt this code I'd defer to any two of
> Pavel, Nadia, and Pierre, each of who I've seen do a great deal of
> digging around this code.
> 
> (I think I saw some set of these go into -mm so I guess I'll just grab
> mmotm and test with that a bit later today)
> 
> thanks,
> -serge

Of course if we do go this route, then the unshare(2) manpage will need
an update (so Michael Kerrisk cc:d).

thanks,
-serge
