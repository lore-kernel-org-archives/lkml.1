Return-Path: <linux-kernel-owner+w=401wt.eu-S1764510AbYDCTqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764510AbYDCTqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbYDCToV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:44:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35118 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762670AbYDCToU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:44:20 -0400
Date: Thu, 3 Apr 2008 14:44:18 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Manfred Spraul <manfred@colorfullife.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
Message-ID: <20080403194418.GA11105@sergelap.austin.ibm.com>
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <m1od8tiom7.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1od8tiom7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Pavel Emelyanov <xemul@openvz.org> writes:
> >>> I agree, that we should probably destroy this one when the task calls 
> >>> unshare, but trying to keep this list relevant is useless.
> >>>   
> >> A very tricky question: Let's assume we have a process with two threads.
> >> The undo structure is shared, as per opengroup standard.
> >> Now one thread calls unshare(CLONE_NEWIPC). What should happen? We 
> >> cannot destroy the undo structure, the other thread might be still 
> >> interested in it.
> >> If we allow sys_unshare() for multithreaded processes with CLONE_NEWIPC 
> >> and without CLONE_SYSVSEM, then we must handle this case.
> >
> > Hm... I'd simply disable creating any new namespaces for threads.
> > I think other namespaces developers agree with me. Serge, Suka, Eric
> > what do you think?
> 
> I almost agree.  sys_unshare() in a multithreaded process breaks
> all kinds of user space libs.  So you can only reasonably look at
> the problem as what we do with linux tasks that share some things
> and not others.  The posix/opengroup notion of processes and threads
> are a distraction.
> 
> In this case requiring it appears that to require unsharing both
> CLONE_SYSVSEM and CLONE_NEWIPC at the same time.  (i.e. unshare
> of CLONE_SYSVSEM should fail if CLONE_NEWIPC is not also specified).
> 
> Then to make it work we make unshare of SYSVSEM succeed when it is
> not shared.
> 
> This looks like about a 5 line patch or two.
> 
> The effect is because we don't support unsharing of SYSVSEM currently
> we don't support a threaded process unsharing the ipc namespace.
> 
> Eric

Eric, does the following patch correctly interpret your recommendation?

Pavel does it make sense to you?

thanks,
-serge

>From 9c85fb3cb80cea1d888c3c253a9fb6e9bc173649 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Thu, 3 Apr 2008 12:43:23 -0700
Subject: [PATCH 1/1] ipc namespaces: fix svsem unsharing issue

Refuse to unshare an ipcns if the semundo is shared and we
are not requesting a new SYSVSEM

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 ipc/namespace.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 9171d94..9044505 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -48,6 +48,16 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
 	if (!(flags & CLONE_NEWIPC))
 		return ns;
 
+	if (!(flags & CLONE_SYSVSEM)) {
+		if (!current->sysvsem.undo_list)
+			goto ok;
+		if (atomic_read(&current->sysvsem.undo_list->refcnt) == 1)
+			goto ok;
+		put_ipc_ns(ns);
+		return ERR_PTR(-EINVAL);
+	}
+
+ok:
 	new_ns = clone_ipc_ns(ns);
 
 	put_ipc_ns(ns);
-- 
1.5.3.6

