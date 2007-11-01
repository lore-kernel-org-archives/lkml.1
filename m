Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbXKAMpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbXKAMpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbXKAMpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:45:07 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:34037 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753541AbXKAMpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:45:05 -0400
X-Greylist: delayed 1876 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 08:45:04 EDT
Subject: Re: [PATCH] file capabilities: allow sigcont within session (v2)
From: Stephen Smalley <sds@epoch.ncsc.mil>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Andrew Morgan <morgan@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, "Theodore Ts'o" <tytso@mit.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <20071031234945.GA16455@sergelap.austin.ibm.com>
References: <20071031234945.GA16455@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 01 Nov 2007 08:07:24 -0400
Message-Id: <1193918844.12018.6.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-31 at 18:49 -0500, Serge E. Hallyn wrote:
> >From 5bff8967f45a35f858b96ca673d9bf98eac53d49 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Wed, 31 Oct 2007 11:22:04 -0500
> Subject: [PATCH 1/1] file capabilities: allow sigcont within session (v2)
> 
> (This is a proposed fix to http://bugzilla.kernel.org/show_bug.cgi?id=9247)
> 
> Allow sigcont to be sent to a process with greater capabilities
> if it is in the same session.  Otherwise, a shell from which
> I've started a root shell and done 'suspend' can't be restarted
> by the parent shell.
> 
> Also don't do file-capabilities signaling checks when uids for
> the processes don't match, since the standard check_kill_permission
> will have done those checks.

Description doesn't match the code.  And in the non-matching uid case,
check_kill_permission typically returns an error before it reaches
cap_task_kill (modulo the special cases).

> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  security/commoncap.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index bf67871..4de6857 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -526,6 +526,15 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
>  	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
>  		return 0;
>  
> +	/* if tasks have same uid, then check_kill_permission did check */
> +	if (current->uid == p->uid || current->euid == p->uid ||
> +		current->uid == p->suid || current->euid == p->suid)
> +		return 0;

I'm confused - if you are allowing all signals within the same uid, then
what was the point of having a cap_task_kill at all?  cap_task_kill was
supposed to prevent a process with lesser capabilities from killing a
process with more capabilities, even if they have the same uid, so that
when you have a program marked with file capabilities instead of a
setuid-0 program, that program can't be sent arbitrary signals by the
caller.

> +
> +	/* sigcont is permitted within same session */
> +	if (sig == SIGCONT && (task_session_nr(current)==task_session_nr(p)))
> +		return 0;
> +
>  	if (secid)
>  		/*
>  		 * Signal sent as a particular user.
-- 
Stephen Smalley
National Security Agency

