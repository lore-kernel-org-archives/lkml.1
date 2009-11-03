Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZKCOy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZKCOy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZKCOy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:54:26 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:43729 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZKCOyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:54:25 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: Your message of "Mon, 02 Nov 2009 10:14:15 EST."
             <alpine.OSX.1.10.0911020012500.56087@caridad.local>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <yw1xhbte0wx0.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011623070.55174@caridad.local> <63587.1257137919@turing-police.cc.vt.edu>
            <alpine.OSX.1.10.0911020012500.56087@caridad.local>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257260057_10149P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Nov 2009 09:54:17 -0500
Message-ID: <151663.1257260057@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4AF04421.028C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257260057_10149P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Nov 2009 10:14:15 EST, "Ryan C. Gordon" said:

> I probably wasn't clear when I said "distribution-wide policy" followed by 
> a "then again." I meant there would be backlash if the distribution glued 
> the whole system together, instead of just binaries that made sense to do 
> it to.

OK.. I'll bite - which binaries does it make sense to do so?  Remember in
your answer to address the very valid point that any binaries you *don't*
do this for will still need equivalent hand-holding by the package manager.
So if you're not doing all of them, you need to address the additional
maintenance overhead of "which way is this package supposed to be built?"
and all the derivative headaches.

It might be instructive to not do a merge of *everything* in Ubuntu as you
did, but only select a random 20% or so of the packages and convert them
to FatELF, and see what breaks. (If our experience with 'make randconfig'
in the kernel is any indication, you'll hit a *lot* of corner cases and
pre-reqs you didn't know about...)

> > Actually, they can't nuke the /lib{32,64} directories unless *all* binaries
> > are using FatELF - as long as there's any binaries doing things The Old Way,
> > you need to keep the supporting binaries around.
> 
> Binaries don't refer directly to /libXX, they count on ld.so to tapdance 
> on their behalf. My virtual machine example left the dirs there as 
> symlinks to /lib, but they could probably just go away directly.

Only if all your shared libs (which are binaries too) have migrated to FatELF.

On my box, I have:

% ls -l /usr/lib{,64}/libX11.so.6.3.0
-rwxr-xr-x 1 root root 1274156 2009-10-06 13:49 /usr/lib/libX11.so.6.3.0
-rwxr-xr-x 1 root root 1308600 2009-10-06 13:49 /usr/lib64/libX11.so.6.3.0

You can't dump them both into /usr/lib without making it a FatElf or doing
some name mangling. You probably didn't notice because you merged *all* of
an ubuntu distro into FatELF.

> > Don't forget you take that hit once for each shared library involved.  Plus
> 
> That happens in user space in ld.so, so it's not a kernel problem in any 
> case, but still...we're talking about, what? Twenty more branch 
> instructions per-process?

No, a lot more than that - you already identified an extra 128-byte read
as needing to happen.  Plus syscall overhead.

> > Or will a FatELF glibc.so screw up somebody's refcounts if it's mapped
> > in both 32 and 64 bit modes?
> 
> Whose refcounts would this screw up? If there's a possible bug, I'd like 
> to make sure it gets resolved, of course.

That's the point - nobody's done an audit for such things.  Does the kernel
DTRT when counting mapped pages (probably close-to-right, if you got it to boot)?
Where are the corresponding patches, if any, for tools like perf and oprofile?
Does lsof DTRT? /proc/<pid>/pagemap?  Any other tools that may break because
the make an assumption that executable files are mapped as 32-bit or 64-bit,
but not both (most likely choking if they see a 64-bit address someplace
after they've decided the binary is a 32-bit)?

--==_Exmh_1257260057_10149P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8EQZcC3lWbTT17ARAutiAKCskTpN5o7QWrG5PRCWHxk71oDdJgCbBBT7
reHrpL/pmDbci1YP3jkSag0=
=cmI6
-----END PGP SIGNATURE-----

--==_Exmh_1257260057_10149P--

