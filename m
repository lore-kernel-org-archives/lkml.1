Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYBXGvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYBXGvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 01:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYBXGvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 01:51:43 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49614 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYBXGvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 01:51:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Fw: [PATCH 1/1] file capabilities: simplify signal check
References: <20080223000237.518aace0.akpm@linux-foundation.org>
Date: Sat, 23 Feb 2008 23:50:08 -0700
In-Reply-To: <20080223000237.518aace0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 23 Feb 2008 00:02:37 -0800")
Message-ID: <m17igu6e73.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> um, is that code namespace-clean?

Choke, gag.

There are uid namespace issues but since no one has finished the
uid namespace that I am aware of that is minor.

However the code does not appear clean/maintainable.  The normal linux
signal sending policy has already been enforce before we get to this
point.

So unless I am totally mistaken the code should read:

int cap_task_kill(struct task_struct *p, struct siginfo *info,
                                int sig, u32 secid)
{
        if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
                return 0;

        if (!cap_issubset(p->cap_permitted, current->cap_permitted))
                return -EPERM;

	return 0;
}

Although doing it that way violates:
       /*
         * Running a setuid root program raises your capabilities.
         * Killing your own setuid root processes was previously
         * allowed.
         * We must preserve legacy signal behavior in this case.
         */


Which says to me the code should really read:
int cap_task_kill(struct task_struct *p, struct siginfo *info,
                                int sig, u32 secid)
{
	return 0;
}

The entire point of defining cap_task_kill under
CONFIG_SECURITY_FILE_CAPABLITIES appears to be deny killing processes
with more caps.  Killing processes that we could ordinarily kill 
which have more caps appears to be precisely the case we have decided
to allow.  So the patched version of cap_task_kill appears to be an
expensive way of doing nothing, just waiting for someone to complain
about the last couple of cases it denies until it is truly a noop.



> Thanks.
>
> Begin forwarded message:
>
> Date: Wed, 20 Feb 2008 10:15:50 -0600
> From: "Serge E. Hallyn" <serue@us.ibm.com>
> To: lkml <linux-kernel@vger.kernel.org>
> Subject: [PATCH 1/1] file capabilities: simplify signal check
>
>
>>From bd076c7245d02be0cc01b7c09bd7170ec5946492 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Sun, 17 Feb 2008 20:28:07 -0500
> Subject: [PATCH 1/1] file capabilities: simplify signal check
>
> Simplify the uid equivalence check in cap_task_kill().  Anyone
> can kill a process owned by the same uid.
>
> Without this patch wireshark is reported to fail.
>
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
> ---
>  security/commoncap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 5aba826..bb0c095 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -552,7 +552,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo
> *info,
>  	 * allowed.
>  	 * We must preserve legacy signal behavior in this case.
>  	 */
> -	if (p->euid == 0 && p->uid == current->uid)
> +	if (p->uid == current->uid)
>  		return 0;
>  
>  	/* sigcont is permitted within same session */
> -- 
> 1.5.1.1.GIT

So it looks to me like we should just give up trying to deny a few
cases now.

diff --git a/security/commoncap.c b/security/commoncap.c
index 5aba826..c1d1fd7 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -540,41 +540,6 @@ int cap_task_setnice (struct task_struct *p, int nice)
 	return cap_safe_nice(p);
 }
 
-int cap_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
-{
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-
-	/*
-	 * Running a setuid root program raises your capabilities.
-	 * Killing your own setuid root processes was previously
-	 * allowed.
-	 * We must preserve legacy signal behavior in this case.
-	 */
-	if (p->euid == 0 && p->uid == current->uid)
-		return 0;
-
-	/* sigcont is permitted within same session */
-	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
-		return 0;
-
-	if (secid)
-		/*
-		 * Signal sent as a particular user.
-		 * Capabilities are ignored.  May be wrong, but it's the
-		 * only thing we can do at the moment.
-		 * Used only by usb drivers?
-		 */
-		return 0;
-	if (cap_issubset(p->cap_permitted, current->cap_permitted))
-		return 0;
-	if (capable(CAP_KILL))
-		return 0;
-
-	return -EPERM;
-}
-
 /*
  * called from kernel/sys.c for prctl(PR_CABSET_DROP)
  * done without task_capability_lock() because it introduces
@@ -605,13 +570,13 @@ int cap_task_setnice (struct task_struct *p, int nice)
 {
 	return 0;
 }
+#endif
+
 int cap_task_kill(struct task_struct *p, struct siginfo *info,
 				int sig, u32 secid)
 {
 	return 0;
 }
-#endif
-
 void cap_task_reparent_to_init (struct task_struct *p)
 {
 	cap_set_init_eff(p->cap_effective);

