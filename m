Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbXK0EPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbXK0EPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbXK0EO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:14:59 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:37406 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXK0EO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:14:58 -0500
Message-ID: <474B99C1.6040208@kernel.org>
Date: Mon, 26 Nov 2007 20:14:57 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20071020)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Wright <chrisw@sous-sol.org>, chris@friedhoff.org
Subject: Re: [PATCH] file capabilities: don't prevent signaling setuid root
 programs.
References: <20071126180028.GA9106@sergelap.austin.ibm.com>
In-Reply-To: <20071126180028.GA9106@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge,

I still feel a bit uneasy about this. Looking ahead, with filesystem
capabilities, one can simulate this same situation with a setuid
'non-root' program as follows:

[morgan@computer ~]$ cat > test.c
main()
{
    printf("sleeping (%u)\n", getpid());
    sleep(100);
    printf("woke up\n");
}
[morgan@computer ~]$ cc -o test test.c
[morgan@computer ~]$ chmod u+s ./test
[morgan@computer ~]$ ls -ltr test
- -rwsrwxr-x  1 morgan morgan 7090 Nov 26 20:01 test
[morgan@computer ~]$ setcap cap_net_raw+ep ~/test
[morgan@computer ~]$ getcap ~/test
/home/morgan/test = cap_net_raw+ep
[morgan@computer ~]$ su luser
Password:
[luser@computer morgan]$ ./test
sleeping (5935)

<In another shell run by luser>
[luser@computer morgan]$ kill 5935
bash: kill: (5935) - Operation not permitted

Because of the euid=0 test, the piece of code you are adding will behave
differently in this situation. Is the root-behavior deserving of less
protection than this one? To my eye they seem equivalent.

Is there a compelling reason to include the euid==0 check?

Thanks

Andrew

Serge E. Hallyn wrote:
> This patch is needed to preserve legacy behavior when
> CONFIG_SECURITY_FILE_CAPABILITIES=y.  Without this patch, xinit can't
> kill X, so manually starting X in runlevel 3 then exiting your window
> manager will not cause X to exit. 
> 
> thanks,
> -serge
> 
>>From 81a6d780ad570f9a326fc27912ec0e373f5fa14f Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Tue, 20 Nov 2007 08:47:35 +0000
> Subject: [PATCH] file capabilities: don't prevent signaling setuid root programs.
> 
> An unprivileged process must be able to kill a setuid root
> program started by the same user.  This is legacy behavior
> needed for instance for xinit to kill X when the window manager
> exits.
> 
> When an unprivileged user runs a setuid root program in !SECURE_NOROOT
> mode, fP, fI, and fE are set full on, so pP' and pE' are full on.
> Then cap_task_kill() prevents the user from signaling the setuid root
> task.  This is a change in behavior compared to when
> !CONFIG_SECURITY_FILE_CAPABILITIES.
> 
> This patch introduces a special check into cap_task_kill() just
> to check whether a non-root user is signaling a setuid root
> program started by the same user.  If so, then signal is allowed.
> 
> Changelog:
> 	Nov 26: move test up above CAP_KILL test as per Andrew
> 		Morgan's suggestion.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  security/commoncap.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 302e8d0..5bc1895 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -526,6 +526,15 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
>  	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
>  		return 0;
>  
> +	/*
> +	 * Running a setuid root program raises your capabilities.
> +	 * Killing your own setuid root processes was previously
> +	 * allowed.
> +	 * We must preserve legacy signal behavior in this case.
> +	 */
> +	if (p->euid == 0 && p->uid == current->uid)
> +		return 0;
> +
>  	/* sigcont is permitted within same session */
>  	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
>  		return 0;
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHS5m/QheEq9QabfIRAmouAJkBBB0kXH57s9mvlgdG3XZhC0pZMwCfZUW3
L4vJUkR4tgAh33GTqEquIqw=
=sKCy
-----END PGP SIGNATURE-----
