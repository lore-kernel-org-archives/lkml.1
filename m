Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXKVHmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXKVHmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 02:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXKVHme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 02:42:34 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:35558 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXKVHmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 02:42:33 -0500
Message-ID: <474532E7.6010406@kernel.org>
Date: Wed, 21 Nov 2007 23:42:31 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20071020)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Chris Friedhoff <chris@friedhoff.org>, Serge E Hallyn <sergeh@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Wright <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Posix file capabilities in 2.6.24rc2; now 2.6.24-rc3
References: <20071113230720.22c6a036.chris@friedhoff.org> <20071113235318.GA6477@sergelap.austin.ibm.com> <20071114101251.a1f6214d.chris@friedhoff.org> <20071114180235.GA25344@sergelap.austin.ibm.com> <20071115230227.9dabbb5f.chris@friedhoff.org> <20071119143946.b0664b6c.chris@friedhoff.org> <20071119231644.GA26373@sergelap.austin.ibm.com> <20071120104609.d4f13fa0.chris@friedhoff.org> <20071120145106.GA6641@sergelap.austin.ibm.com>
In-Reply-To: <20071120145106.GA6641@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> The problem is that when you run a setuid binary, its pP and pE are
> fully raised.  The following patch fixes it for me.  Chris, does it fix
> your problem?  Andrew, am I again confusing myself and doing something
> unsafe?

I think this is yet another example of the fragile mess that is UID
emulation with capabilities. Your patch is an example of privilege
escalation - luser can kill a more-capable process. In the kill CONT
case we reached the opposite conclusion to this one. As was the case
then, I didn't disagree then :*). If it meets folk's expectations, then
this is probably a good patch...

> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -543,6 +543,9 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
>  	if (capable(CAP_KILL))
>  		return 0;
>  
> +	if (p->euid==0 && p->uid==current->uid)
> +		return 0;
> +

Its late and I'm obviously tired, but is there any reason not to simply use:

 if (p->uid == current->uid)
	 return 0;

Whatever the case, could you put the new code closer to the sig ==
SIGCONT test? The capability tests are at the end of cap_task_kill() and
this new check breaks that pattern.

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHRTLlQheEq9QabfIRAt/hAKCJgj2kbuyAWI486LOwwDLdkbcpoQCfQdrQ
J+bcvi+9pGTodFn42PsHJHA=
=cXaG
-----END PGP SIGNATURE-----
