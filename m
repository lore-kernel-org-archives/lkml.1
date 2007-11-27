Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbXK0QxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbXK0QxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbXK0QxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:53:14 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55979 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212AbXK0QxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:53:12 -0500
Date: Tue, 27 Nov 2007 10:53:05 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Wright <chrisw@sous-sol.org>, chris@friedhoff.org
Subject: Re: [PATCH] file capabilities: don't prevent signaling setuid root
	programs.
Message-ID: <20071127165305.GF32362@sergelap.austin.ibm.com>
References: <20071126180028.GA9106@sergelap.austin.ibm.com> <474B99C1.6040208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474B99C1.6040208@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge,
> 
> I still feel a bit uneasy about this. Looking ahead, with filesystem
> capabilities, one can simulate this same situation with a setuid
> 'non-root' program as follows:
> 
> [morgan@computer ~]$ cat > test.c
> main()
> {
>     printf("sleeping (%u)\n", getpid());
>     sleep(100);
>     printf("woke up\n");
> }
> [morgan@computer ~]$ cc -o test test.c
> [morgan@computer ~]$ chmod u+s ./test
> [morgan@computer ~]$ ls -ltr test
> - -rwsrwxr-x  1 morgan morgan 7090 Nov 26 20:01 test
> [morgan@computer ~]$ setcap cap_net_raw+ep ~/test
> [morgan@computer ~]$ getcap ~/test
> /home/morgan/test = cap_net_raw+ep
> [morgan@computer ~]$ su luser
> Password:
> [luser@computer morgan]$ ./test
> sleeping (5935)
> 
> <In another shell run by luser>
> [luser@computer morgan]$ kill 5935
> bash: kill: (5935) - Operation not permitted
> 
> Because of the euid=0 test, the piece of code you are adding will behave
> differently in this situation. Is the root-behavior deserving of less
> protection than this one?

I don't believe in entitlement  :)

> To my eye they seem equivalent.

Not to mine.  The one case is classic setuid root,  the other exploits
the new file capabilities - even if they don't actually add any
privilege.

> Is there a compelling reason to include the euid==0 check?

Yes, because only setuid root fills your capability sets.

In fact I was wondering whether the check should be under a check
for !SECURE_NOROOT.  I think it should, but it only matters after your
per-process securebits patch is reposted.

Would you prefer if the check were under a sysctl, so that those really
using file caps could tutn off the setuid root exception?  It also
provies a more graceful path toward eventually getting rid of this
legacy support.

thanks,
-serge

> 
> Thanks
> 
> Andrew
> 
> Serge E. Hallyn wrote:
> > This patch is needed to preserve legacy behavior when
> > CONFIG_SECURITY_FILE_CAPABILITIES=y.  Without this patch, xinit can't
> > kill X, so manually starting X in runlevel 3 then exiting your window
> > manager will not cause X to exit. 
> > 
> > thanks,
> > -serge
> > 
> >>From 81a6d780ad570f9a326fc27912ec0e373f5fa14f Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Tue, 20 Nov 2007 08:47:35 +0000
> > Subject: [PATCH] file capabilities: don't prevent signaling setuid root programs.
> > 
> > An unprivileged process must be able to kill a setuid root
> > program started by the same user.  This is legacy behavior
> > needed for instance for xinit to kill X when the window manager
> > exits.
> > 
> > When an unprivileged user runs a setuid root program in !SECURE_NOROOT
> > mode, fP, fI, and fE are set full on, so pP' and pE' are full on.
> > Then cap_task_kill() prevents the user from signaling the setuid root
> > task.  This is a change in behavior compared to when
> > !CONFIG_SECURITY_FILE_CAPABILITIES.
> > 
> > This patch introduces a special check into cap_task_kill() just
> > to check whether a non-root user is signaling a setuid root
> > program started by the same user.  If so, then signal is allowed.
> > 
> > Changelog:
> > 	Nov 26: move test up above CAP_KILL test as per Andrew
> > 		Morgan's suggestion.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  security/commoncap.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index 302e8d0..5bc1895 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -526,6 +526,15 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
> >  	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
> >  		return 0;
> >  
> > +	/*
> > +	 * Running a setuid root program raises your capabilities.
> > +	 * Killing your own setuid root processes was previously
> > +	 * allowed.
> > +	 * We must preserve legacy signal behavior in this case.
> > +	 */
> > +	if (p->euid == 0 && p->uid == current->uid)
> > +		return 0;
> > +
> >  	/* sigcont is permitted within same session */
> >  	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
> >  		return 0;
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
> 
> iD8DBQFHS5m/QheEq9QabfIRAmouAJkBBB0kXH57s9mvlgdG3XZhC0pZMwCfZUW3
> L4vJUkR4tgAh33GTqEquIqw=
> =sKCy
> -----END PGP SIGNATURE-----
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
