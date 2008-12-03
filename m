Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYLCCzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYLCCzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYLCCzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:55:43 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47995 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYLCCzm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:55:42 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Geoffrey McRae <geoff@rabidhost.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
In-Reply-To: Your message of "Wed, 03 Dec 2008 12:44:17 +1100."
             <1228268657.6679.4.camel@lappy.spacevs.com>
From: Valdis.Kletnieks@vt.edu
References: <1228260494.24232.21.camel@compy.ivent.com.au> <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
            <1228268657.6679.4.camel@lappy.spacevs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228272932_28627P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Dec 2008 21:55:32 -0500
Message-ID: <73639.1228272932@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1228272932_28627P
Content-Type: text/plain; charset=us-ascii

On Wed, 03 Dec 2008 12:44:17 +1100, Geoffrey McRae said:

> I would welcome more information as to how this can break applications
> as I am very new to kernel hacking and would like to solve this
> performance vs security problem once and for all.

A *lot* of software has implicit assumptions - for instance, that your process
UID remains constant unless you intentionally did a setuid() call.

Read Henry Spencer's (now ancient but still educational) write-up on *some* of
the things that can happen to set-UID programs:

http://www.daemon-systems.org/man/setuid.7.html

Now consider that *any* program that gets its UID suddenly changed on it
just became vulnerable to all that stuff that Henry writes about.

News flash - most programmers who wrote code thinking it would run as the
same userid the whole time don't do checks for all the sort of stuff that
Henry warns about when programs suddenly get invoked with more privilege
than they were designed to handle.

Then there's the opposite case - somebody manages to trick you into nuking the
permissions on the right process-ID but wrong executable. Hilarity ensues when
the process is running with *less* privilege than it expected. Go and read up
on how Sendmail failed back around 2000, and understand *why* it failed. Just
google for 'sendmail CAP_SETUID' and start reading. Then think what happens if
somebody manages to get PHP to exec() some other binary (a set-UID one) and
it's busy running when you whack its UID.

That's just off the top of my head.

Then go look at kernel/sys.c and read the comments just before the functions
sys_setpgid(), sys_setregid(), and sys_setuid(), and figure out how the
saved uid enters into things....

There be serious and nasty dragons in there...


--==_Exmh_1228272932_28627P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJNfUkcC3lWbTT17ARAgA1AJ98wDlxFD9f733OCV87Zf+wROGLSACg6u+d
qQFNpQxWKFb6X0/VfVJV+6c=
=2YFL
-----END PGP SIGNATURE-----

--==_Exmh_1228272932_28627P--
