Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894Ab0AQVRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0AQVRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200Ab0AQVRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:17:42 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38513 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0AQVRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:17:39 -0500
MIME-Version: 1.0
In-Reply-To: <20100117180728.GA2848@heat>
References: <f73f7ab81001162201v1956351boa9241ce440e62a09@mail.gmail.com> 
	<20100117180728.GA2848@heat>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 17 Jan 2010 16:17:17 -0500
Message-ID: <f73f7ab81001171317y39aec7b2s3f8bce4c689fa82@mail.gmail.com>
Subject: Re: disablenetwork (v5) patches
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>, Andrew Morgan <morgan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 13:07, Michael Stone <michael@laptop.org> wrote:
> Kyle Moffett wrote:
>> I have some time this week to split out my SELinux policy build
>> machinery; I will pull out a standalone set of files to build the
>> policy and do some extra testing on one of my bog-standard Debian
>> boxes and then send it all out again.
>
> Questions:
>
>  1) Your patch seems to rely on a chunk of custom policy. Can this chunk of
>     policy coexist without modification with pre-existing policies like the
>     ones Fedora ships?
>
>     If I understand correctly, the answer is "not as it is written today", for
>     a couple of reasons:

Essentially, yes, the policy that I gave is an extremely limited
system.  If you wanted to constrain your application as installed on a
standard Fedora system, that would involve getting a much more
detailed policy merged in the selinux-refpolicy project.  The plusses
are that such a policy would protect against far more complex attacks
than simple network data exposure, however the policy to protect
against such attacks is far more complex as well.

Basically, I wrote that sample policy as a completely standalone
example of how to use the SELinux machinery to enforce a limited
arbitrary set of restrictions based on your stated requirements.

There has been some partially-stalled work to create a "userspace
policy server" and "hierarchical policy", essentially a mechanism by
which a program (running under a specific type) could sub-divide
itself into additional types bounded by the constraints on the
original type.  Unfortunately I haven't had a chance to look into it
in quite a while, so things may have changed significantly.


>  2) How can an application author test whether or not the contexts defined by
>     this policy are defined in the currently loaded policy?

The standard method for adding SELinux support to an application is
pretty much the same method that you use to enhance security in the
absence of SELinux:  Divide your program into multiple executables
with discrete DAC-enforced privileges (a la postfix).

Then the SELinux policy simply places a different label on each
executable (and via a type_transition rule on the process which is
*started* from that executable).  Each label is then neatly bound by
least-privilege type-based allow rules.


>  3) Your policy relies on defining new roles for objects, regular processes,
>     and network disabled processes. This is definitely a nice reuse of SELinux
>     machinery. Unfortunately, I'm not sure how, as an app author, I'm supposed
>     to use it.
>
> [...code for using dyntransition...]

You can do it that way, although I would certainly suggest an
appropriate config file somewhere to specify what label the software
should attempt to transition to.  The SELinux libraries have some code
for performing dynamic transitions, although as I indicated most
processes don't use them.

Really the preferred way to take advantage of SELinux is simply to
divide the program tasks securely across multiple executables and then
use the SELinux policy to lock them down individually.


>  4) If I understand correctly, the policy you specified actually restricts
>     network access by blacklisting various socket calls by protocol stack.
>     Thus, AF_UNIX socket calls are unrestricted while TCP bind() and connect()
>     and UDP bind(), connect(), and sendto() are restricted.
>
>     I'm uncomfortable with a design based on protocol blacklisting because I
>     think that it is likely to break silently whenever someone adds a new
>     protocol (e.g. SCTP) to the kernel.
>
>     Presumably, though, this is fairly straightforward to fix?

Yes, it's pretty easy to change specifically which access-vectors you
restrict.  If localhost-based accesses are OK, then you could use the
netif and peer-based access controls (possibly with a couple of
optional iptables rules).  That would simply restrict your ability to
send packets out of the computer, regardless of what protocol they
use.

Alternatively there are SELinux mechanisms in recent kernels to
influence whether or not "unknown" access-vectors are allowed (IE:
Those which the kernel understands but the policy does not).

>  5) If I understand correctly, your policy restricts all uses of sendto()
>     including sendto() on previously connected UDP sockets. Unfortunately,
>     this restriction is too strong: the ability to sendto() on previously
>     connected sockets UDP is a design goal.
>     How might we address this problem?

See above, simply restrict with network peer controls.


>  6) Can SELinux be turned on at all on kernels which do not support POSIX
>     extended attributes?

My understanding is that the kernel always supported extended
attributes, but that some filesystems may have support turned off.
You can certainly turn on SELinux on such a system, but you would be
unable to label things on a per-file basis.


>  7) Can you point me toward any measurements on what it costs (specifically in
>     terms of memory and disk usage) to add basic SELinux support plus this
>     policy to an embedded kernel and OS distro which doesn't presently ship
>     any SELinux-related material like, e.g., the distros for the Linksys
>     WRT54G and for the XO?

I don't have such measurements offhand.  If you are shipping a
pre-built policy and do not include any of the tools needed to reload
or modify it then all you really need is an /sbin/init which can mount
/selinux and copy a binary policy file to a virtual file therein.  The
actual dev tools are rather unfortunately large and slow right now,
especially with the full reference policy.

Cheers,
Kyle Moffett
