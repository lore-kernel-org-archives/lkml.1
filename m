Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036Ab0AAVRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0AAVRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 16:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398Ab0AAVRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 16:17:37 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63381 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0AAVRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 16:17:36 -0500
MIME-Version: 1.0
In-Reply-To: <m1oclfkmuz.fsf@fess.ebiederm.org>
References: <551280e50912300652r1007dee0j8de750bf33af9b3c@mail.gmail.com>
	 <m1hbr8tb8q.fsf_-_@fess.ebiederm.org>
	 <20091230212931.233003b9@lxorguk.ukuu.org.uk>
	 <m1skasrvnq.fsf@fess.ebiederm.org>
	 <20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
	 <3e8340490912301844p4fddaf57ke58ceeba9582e0fa@mail.gmail.com>
	 <20091231173334.5e3d7557@lxorguk.ukuu.org.uk>
	 <20091231175257.GA7210@us.ibm.com>
	 <551280e50912311020x2bdc5b1o699a601f67b91662@mail.gmail.com>
	 <m1oclfkmuz.fsf@fess.ebiederm.org>
Date: Fri, 1 Jan 2010 13:17:33 -0800
X-Google-Sender-Auth: 304d4507511b0296
Message-ID: <551280e51001011317u44347082r4bd288f10475be18@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
From: "Andrew G. Morgan" <morgan@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bryan Donlan <bdonlan@gmail.com>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/31 Eric W. Biederman <ebiederm@xmission.com>:
> "Andrew G. Morgan" <morgan@kernel.org> writes:
>
>> Since there is already independent support for disabling file
>> capabilities (the privilege escalation part), I see these two
>> mechanisms as separable.
>
> I guess there is something that resembles support for disabling
> privilege escalation.  The problem is that it requires privilege to
> use it.

Just to be clear, this does not prevent luser1 -> luser2 transitions
(even though it does strip root of its privilege), but here is a
concrete worked example of what support is in the current kernel.

That is, here is a program that cripples privilege in a process tree.
Other than setting it up one time, you don't need to become root (or
visit a *uid=0) to execute it, and because capabilities are not
naively inherited nothing about the privilege of the limiter
executable can leak through the execve().

Setup (see below for source code, and
http://ols.fedoraproject.org/OLS/Reprints-2008/hallyn-reprint.pdf for
an explanation of how it all works):

luser> cc -o limiter limiter.c -lcap
luser> sudo /usr/sbin/setcap cap_setpcap=p ./limiter

Use:

luser> ./limiter /bin/bash
[feeling powerless]
luser> ...try something privileged... or look at /proc/self/status etc.
luser> exit
luser> back in parent shell

//---- cut here 8< ----- [this is limiter.c]
/* Quick demo of blocking privilege */
#include <stdio.h>
#include <sys/capability.h>
#include <sys/prctl.h>
#include <stdlib.h>

int main(int argc, char *argv[], char *envp[])
{
     if (argc < 2) {
	  fprintf(stderr, "usage: %s <execv args>\n", argv[0]);
	  exit(1);
     }
     cap_t needed = cap_from_text("cap_setpcap=ep");
     if (cap_set_proc(needed) != 0) {
	  perror("cap_set_proc failed");
	  exit(1);
     }
     int cap = 0;
     int set;
     while ((set = prctl(PR_CAPBSET_READ, cap)) >= 0) {
	  if (set && prctl(PR_CAPBSET_DROP, cap)) {
	       fprintf(stderr, "failed to drop bset capability: %s\n",
		       cap_to_name(cap));
	       exit(1);
	  }
	  cap++;
     }
     if (prctl(PR_SET_SECUREBITS, 0x2e /* magic combination */)) {
	  perror("unable lock secure-bits");
	  exit(1);
     }
     fprintf(stderr, "[feeling powerless]\n");
     execve(argv[1], argv + 1, envp);
     fprintf(stderr, "[execve(\"%s\",...) failed - try something else.]\n",
	     argv[1]);
     exit(1);
}
//---- cut here 8< -----

> I have no problem with expressing this in a fine grained manner internally
> to the kernel but the user space interface needs to be atomic so that
> we can enable this all without privilege.

I'm not clear on the need for this specific detail.

> Further I may be off but I think the implementation would be more
> challenging than what I have already posted.  That doesn't mean it
> won't be more useful long term.

[Not sure I followed this bit.]

I can see a desire to block luser -> luser transitions being a good
thing, but not because it has anything to do with privilege.

Cheers [and happy New Year!]

Andrew

>
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
