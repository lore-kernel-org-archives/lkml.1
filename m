Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbXKANr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbXKANr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXKANrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:47:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52658 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbXKANrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:47:19 -0400
Date: Thu, 1 Nov 2007 08:47:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@epoch.ncsc.mil>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       "Theodore Ts'o" <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH] file capabilities: allow sigcont within session (v2)
Message-ID: <20071101134701.GA21131@sergelap.austin.ibm.com>
References: <20071031234945.GA16455@sergelap.austin.ibm.com> <1193918844.12018.6.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193918844.12018.6.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@epoch.ncsc.mil):
> On Wed, 2007-10-31 at 18:49 -0500, Serge E. Hallyn wrote:
> > >From 5bff8967f45a35f858b96ca673d9bf98eac53d49 Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Wed, 31 Oct 2007 11:22:04 -0500
> > Subject: [PATCH 1/1] file capabilities: allow sigcont within session (v2)
> > 
> > (This is a proposed fix to http://bugzilla.kernel.org/show_bug.cgi?id=9247)
> > 
> > Allow sigcont to be sent to a process with greater capabilities
> > if it is in the same session.  Otherwise, a shell from which
> > I've started a root shell and done 'suspend' can't be restarted
> > by the parent shell.
> > 
> > Also don't do file-capabilities signaling checks when uids for
> > the processes don't match, since the standard check_kill_permission
> > will have done those checks.
> 
> Description doesn't match the code.

Egads.  I knew I should've just kept that part out of it for the first
patch...

New patch on top of previous one is appended.

Thanks.

> And in the non-matching uid case,
> check_kill_permission typically returns an error before it reaches
> cap_task_kill (modulo the special cases).

Typically, but when it doesn't, then the file capabilities shouldn't get
in the way of check_kill_permission() granting permission.  The file
capabilities 

> 
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  security/commoncap.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index bf67871..4de6857 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -526,6 +526,15 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
> >  	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
> >  		return 0;
> >  
> > +	/* if tasks have same uid, then check_kill_permission did check */
> > +	if (current->uid == p->uid || current->euid == p->uid ||
> > +		current->uid == p->suid || current->euid == p->suid)
> > +		return 0;
> 
> I'm confused - if you are allowing all signals within the same uid, then

No I was confused.  I wanted to allow for tasks with different uids.

But in fact that's not safe anyway.  A binary can be setuid and owned by
a non-root user user1, have file capabilities, and be executed by user2.

(Anyway given how grossly my code missed my erroneous intentions, I need
to add some signal tests to my file capabilities tests - and get those
tests into LTP)

> what was the point of having a cap_task_kill at all?  cap_task_kill was
> supposed to prevent a process with lesser capabilities from killing a
> process with more capabilities, even if they have the same uid, so that
> when you have a program marked with file capabilities instead of a
> setuid-0 program, that program can't be sent arbitrary signals by the
> caller.
> 
> > +
> > +	/* sigcont is permitted within same session */
> > +	if (sig == SIGCONT && (task_session_nr(current)==task_session_nr(p)))
> > +		return 0;
> > +
> >  	if (secid)
> >  		/*
> >  		 * Signal sent as a particular user.
> -- 
> Stephen Smalley
> National Security Agency

Thanks, Stephen.

>From 98741f07ab1bc4a1fc2de7fedfb9023ea30bf988 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Thu, 1 Nov 2007 08:20:12 -0500
Subject: [PATCH 1/1] file capabilities: remove the non-matching uid special case for kill

There I went again having one patch do two (related) things.

Remove the special check I had added to cap_task_kill() for
non-matching uids.  In fact it turns out the check wouldn't be
safe even if I'd coded it correctly.  A binary can be setuid
and owned by a non-root user user1, have file capabilities, and
be executed by user2.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index f04784a..302e8d0 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -526,11 +526,6 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
 		return 0;
 
-	/* if tasks have same uid, then check_kill_permission did check */
-	if (current->uid == p->uid || current->euid == p->uid ||
-		current->uid == p->suid || current->euid == p->suid)
-		return 0;
-
 	/* sigcont is permitted within same session */
 	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
 		return 0;
-- 
1.5.1.1.GIT

