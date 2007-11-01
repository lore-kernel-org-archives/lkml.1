Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXKAB2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXKAB2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbXKAB2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:28:02 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:55567 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXKAB2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:28:00 -0400
Message-ID: <47292B92.3030200@kernel.org>
Date: Wed, 31 Oct 2007 18:27:46 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Stephen Smalley <sds@epoch.ncsc.mil>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH] file capabilities: allow sigcont within session (v2)
References: <20071031234945.GA16455@sergelap.austin.ibm.com>
In-Reply-To: <20071031234945.GA16455@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ackd.

Cheers

Andrew

Serge E. Hallyn wrote:
>>From 5bff8967f45a35f858b96ca673d9bf98eac53d49 Mon Sep 17 00:00:00 2001
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
> +
> +	/* sigcont is permitted within same session */
> +	if (sig == SIGCONT && (task_session_nr(current)==task_session_nr(p)))
> +		return 0;
> +
>  	if (secid)
>  		/*
>  		 * Signal sent as a particular user.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHKSuSmwytjiwfWMwRAkHXAJ4lr07yW936ychUGNxqQSOanZTecwCePYVc
d8uP0I3AEDjTpG8s7Nojo7Y=
=8777
-----END PGP SIGNATURE-----
