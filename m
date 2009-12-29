Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZL2VPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZL2VPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZL2VPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:15:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43846 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZL2VPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:15:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fDrkibZwTAOmlZAksqDuyEfNqOsLc9YXNiQ9/a21gsykXFKv9HmdBH+CuipFlSkQIa
         32X9MjaOJOuxtfE8rcuXFkXRFkceBzQZb/Dj9+kOqRS3/NL6568+k4eJwl7pQiT5Tmj7
         CJWirWNWl4FzCtHyLCBJOfniriGJ2ZoVNedl0=
MIME-Version: 1.0
In-Reply-To: <20091229211139.0732a0c1@lxorguk.ukuu.org.uk>
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org> 
	<20091229151146.GA32153@us.ibm.com> <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com> 
	<m3oclhzgm4.fsf@ursa.amorsen.dk> <m17hs5y0mg.fsf@fess.ebiederm.org> 
	<20091229211139.0732a0c1@lxorguk.ukuu.org.uk>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 29 Dec 2009 16:14:46 -0500
Message-ID: <3e8340490912291314m5e1b72e6s6e394d0a8cf95d00@mail.gmail.com>
Subject: Re: RFC: disablenetwork facility. (v4)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
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
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/29 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> > Execute != read. The executable file may contain secrets which must not
>> > be available to the user running the setuid program. If you fail the
>> > setuid, the user will be able to ptrace() and then the secret is
>> > revealed.
>> >
>> > It's amazing how many security holes appear from what seems like a very
>> > simple request.
>>
>> Do we have a security hole in nosuid mount option?
>> Can someone write a patch to fix it?
>
> If a setuid app can read a key when its erroneously not set setuid then
> the user can read it too.
>
> Anything you can do with ptrace you can do yourself !

The security hole is that secrets in a setuid application with
other-exec but no other-read permission can be read when the
filesystem is mounted nosuid. Normally the user would be unable to
ptrace the program, and unable to read the executable, so the secret
would not be divulged; when nosuid is set, the user is now able to
ptrace the program - ie, they gain abilities from nosuid.

Whether this is a severe issue is debatable, of course; it's unlikely
that the administrator will create a setuid program with weird
permissions and then go and mount the fs it's on with nosuid. However
with the proposed 'drop suiding abilities' API, this becomes a bigger
issue, since if we reuse the nosuid semantics, any user can trigger
it, without needing to get root to mount things nosuid.

That said, I do tend to agree that relying on the _presence_ of a suid
mode to protect your secrets is probably a bad idea...
