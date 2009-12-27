Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbZL0K4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbZL0K4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 05:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZL0K4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 05:56:33 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:37222 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZL0K4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 05:56:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serge@hallyn.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: A basic question about the security_* hooks
In-Reply-To: Your message of "Sun, 27 Dec 2009 13:02:54 +0900."
             <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat> <20091227031631.GA17629@hallyn.com>
            <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1261911374_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 27 Dec 2009 05:56:14 -0500
Message-ID: <22669.1261911374@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B373D4F.00F8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1261911374_3923P
Content-Type: text/plain; charset=us-ascii

On Sun, 27 Dec 2009 13:02:54 +0900, Tetsuo Handa said:
> I believe TOMOYO can safely coexist with other security modules.
> Why TOMOYO must not be used with SELinux or Smack or AppArmor?
> What interference are you worrying when enabling TOMOYO with SELinux or Smack
> or AppArmor?

(It's 5AM and I just got woken up by a thundering herd of cats and can't
get back to sleep, but there's no caffeine to be found.. Yee hah)

Sure, it's *possible* to create a system where you've loaded 2 security systems
and have it work.  But the general consensus is that if you're running one
system and want to run a second, it's easier to ask yourself *why* you want to
run the second, and see if there's some way to get the added functionality
supported in the first system. Presumably your reason is of the form "I'm
running XYZ, but it doesn't stop attack ABC like ZQW does".  Usually, the right
answer is to fix XYZ, not try to load ZQW on top of it.  But if you insist.. ;)

The basic problem is that large complete MAC systems like TOMOYO, SELinux,
Smack, or AppArmor are complicated.  In addition, they are unable to look at
each other's policies to detect potential conflicts. As a result, although
it's probably *possible* to create a system that loads both a TOMOYO and
an SELinux policy, it's hazardous:

First, it's possible to totally screw up your box - consider 2 defective
policies where each prevents a reload of the other's policy.  Now note that it
doesn't even need to be the *policy* - if the Tomoyo policy files get
mislabeled with the wrong SELinux context, then an SELinux component will
probably prevent access to the policy and thus prevent the load.  Your system
is now *at best* running SELinux-only (and now vulnerable to to any attacks you
were depending on Tomoyo to stop). At worst, the wrecked Tomoyo policy will
mean that Tomoyo will then reject the SELinux 'restorecon' command to correct
the labels, leaving you in a situation where you can't recover your box.

Second, it's unclear what a combo of two different MAC systems would *mean*,
and whether it creates corner cases that can be exploited - the "two systems
block each other's reloads" mentioned above is but one example. If a system that
depends on inode labeling is active at the same time as a path-based system,
what happens if you manage to do an 'mv' command that changes the security
context in the path-based system while leaving the inode label the same, or
relabel an inode without rename it to match? The file has just experienced
a security transition for one system, but not the other. Are there any
files and transitions where the mismatch matters?

If the two systems load policies with the same semantics, why are you
bothering?  And if they load different semantics, can the difference be
leveraged by an attacker?

In addition, we've already actually seen composition bugs before - when a
program expecting standard Linux DAC failed when it hit the composition of DAC
plus capabilities. It's helpful to go re-read the story of the Sendmail
capabilities bug, where the Sendmail code wasn't capability-aware, and thus
didn't forsee any way that doing a setuid()/setgid() while running as root
could possibly fail. When it *did* fail, Sendmail thought it was running as a
mortal, but actually still had all privs. Hilarity ensues.

The problem is that for you to *really* be able to safely compose (for instance)
Tomoyo and SELinux, you need to go through *every* Tomoyo-aware program and
verify "this will Do The Right Thing even if an SELinux policy unexpectedly
fails us here" at every point - and then repeat for every SELinux-aware
program regarding a Tomoyo-induced rejection.

And then you get to repeat the process for each Tomoyo and SELinux *policy*
you want to use...

Like I said - it's usually more sane to go back and re-evaluate *why*, and
see if you can fix one system or the other to address your needs.




--==_Exmh_1261911374_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLNz1OcC3lWbTT17ARAvzYAKCnODrcmS8WmGbQbB7ORhQ3vYjpdQCgqCbR
g4qZZdZX5dS+cfontmEBSTU=
=JXiq
-----END PGP SIGNATURE-----

--==_Exmh_1261911374_3923P--

