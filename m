Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096Ab0AJWTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0AJWTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894Ab0AJWTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:19:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52101 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab0AJWTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:19:12 -0500
MIME-Version: 1.0
In-Reply-To: <20100110215409.GA3705@heat>
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> 
	<20100110215409.GA3705@heat>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 10 Jan 2010 17:18:49 -0500
Message-ID: <f73f7ab81001101418x3b3f8652j256f6311ad6244c5@mail.gmail.com>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
To: Michael Stone <michael@laptop.org>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 16:54, Michael Stone <michael@laptop.org> wrote:
> On Fri, 1 Jan 2010, Pavel Machek wrote:
>> > > For the record: NAK, as it introduces security holes.
>>
>> Please elaborate.
>
> Pavel's position is that disablenetwork is likely to permit some attacker
> somewhere to deny network access to some setuid app some day in a way that
> violates some security policy.
>
> He has mentioned specific concern over scenarios like:
>
>  Alice configures PAM auth to 'fail open' by checking login credentials
>  against a restrictive LDAP server and, if the server is unavailable,
> against
>  a very permissive files database.
>
>  Alice updates her kernel to a version with disablenetwork.
>
>  Mallory calls disablenetwork, calls su -, and vanquishes all.

No, there is a *MUCH* bigger security issue here.  There are existing
PAM modules which lazily fork background processes to handle
authentication, authorization, logging, etc.  Now assume that one of
those PAM modules is hooked from /etc/pam.d/su.

(1) Mallory runs "disablenetwork su -"
(2) The PAM module lazily starts its background daemon with a
10-minute idle timeout.
(3) The daemon has network disabled, and so it is completely nonfunctional.
(4) The daemon automatically denies all logins because it cannot
communicate with the login server
(5) Alice tries to run "su -" from her regular terminal.
(6) Alice's "su" process communicates with the running daemon and
fails because "the network is down".

All of that software is perfectly reasonably designed... the daemon is
even fail-secure in the event that the network really is inaccessible.
 Unfortunately it lets Mallory easily DoS every superuser login on the
system without generating a single audit log.  The only process that
knows what he did is the one that cannot communicate with the remote
audit daemon.

Moreover, that DoS would continue until the 10-minute idle timeout
actually expired.  As Alice keeps trying to log in, it will keep
automatically extending the daemon's lifetime.

Now, you can try to claim "Nobody has it configured like that" or
"None of the standard Linux PAM modules do that"... but that does not
resolve the problem.  A sysadmin and part-time programmer (not knowing
about a little-documented "disablenetwork" feature) could very easily
write software like that and assume that it is secure.

The #1 rule for setuid binaries is that you DO NOT INHERIT ANYTHING.
Any kernel feature or setuid program which violates that rule is just
going to cause big security holes.  Security models must be either
obviously correct or mathematically provable (or both)... and this is
neither.

Cheers,
Kyle Moffett
