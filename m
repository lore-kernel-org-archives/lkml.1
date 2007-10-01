Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbXJAQMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbXJAQMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXJAQMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:12:33 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55120 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbXJAQMc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:12:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2
In-Reply-To: Your message of "Sun, 30 Sep 2007 01:50:14 PDT."
             <20070930015014.78bb88d3.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <18268.1191119181@turing-police.cc.vt.edu>
            <20070930015014.78bb88d3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191255147_2870P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Oct 2007 12:12:27 -0400
Message-ID: <773.1191255147@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191255147_2870P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <760.1191255138.1@turing-police.cc.vt.edu>

On Sun, 30 Sep 2007 01:50:14 PDT, Andrew Morton said:
> On Sat, 29 Sep 2007 22:26:21 -0400 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Thu, 27 Sep 2007 02:22:20 PDT, Andrew Morton said:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> > 
> > Locks up hard at very early boot on my Dell Latitude - grub says loading
> > kernel, the screen clears, and we lock up before we get penguins.
> > 
> > -rc8-mm1 was OK. I'm off to go bisect, figured I'd drop a heads-up.
> > 
> 
> It doesn't ring a bell, sorry.  hpet-force-enable-on-ich34.patch is known
> to be bad, but it causes failure later in the boot than that.

OK, now I'm confoozled.  I built -rc8-mm2, and it bricked.  Usually my first
test is then using quilt to push just origin.patch, so I know if I'm needing
to bisect Linus git or Andrew -mm.

Starting with a clean 23-rc8, and using 'quilt push origin.patch' to just add
the Linus changes *also* gets me a brick.  So I did a git bisect between 23-rc8 and
the first commit listed in origin.patch, and got down to this:

f7f847b01571e86044dc77e03d92f43699652f8d is first bad commit
commit f7f847b01571e86044dc77e03d92f43699652f8d
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Wed Sep 26 15:21:33 2007 -0700

(Here's the 'git bisect log':
git-bisect start
# good: [4942de4a0e914f205d351a81873f4f63986bcc3c] Linux 2.6.23-rc8
git-bisect good 4942de4a0e914f205d351a81873f4f63986bcc3c
# bad: [f7f847b01571e86044dc77e03d92f43699652f8d] Revert "x86-64: Disable local APIC timer use on AMD systems with C1E"
git-bisect bad f7f847b01571e86044dc77e03d92f43699652f8d
# good: [4d3fac08718b49fc256bdb447a479d089ca97b78] Merge branch 'upstream-linus' of master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev
git-bisect good 4d3fac08718b49fc256bdb447a479d089ca97b78
# good: [d85f57938ad1d674dff8077a2e6a36a45dbe0e22] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect good d85f57938ad1d674dff8077a2e6a36a45dbe0e22
# good: [d8c4a2f9d9e7827362fd7ab0b5d9637c6af5ac5b] mv643xx_eth: duplicate methods in initializer
git-bisect good d8c4a2f9d9e7827362fd7ab0b5d9637c6af5ac5b
# good: [255129d1e9ca0ed3d69d5517fae3e03d7ab4b806] NLM: Fix a circular lock dependency in lockd
git-bisect good 255129d1e9ca0ed3d69d5517fae3e03d7ab4b806
# good: [e66485d747505e9d960b864fc6c37f8b2afafaf0] x86-64: Disable local APIC timer use on AMD systems with C1E
git-bisect good e66485d747505e9d960b864fc6c37f8b2afafaf0
# good: [df912ea4ae7233d1504fbd861ee127bd7ee5781d] xen: execve's error paths don't pin the mm before unpinning
git-bisect good df912ea4ae7233d1504fbd861ee127bd7ee5781d

And diffing the 2 trees (linus -git and my "origin.patch" tree shows only
the following 2 differences:

commit f7f847b01571e86044dc77e03d92f43699652f8d
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Wed Sep 26 15:21:33 2007 -0700

    Revert "x86-64: Disable local APIC timer use on AMD systems with C1E"

commit 2efa33f81ef56e7700c09a3d8a881c96692149e5
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Sep 26 14:11:43 2007 -0700

    [x86 setup] Handle case of improperly terminated E820 chain

So I'm having a pretty good case of WTF? going at the moment...



--==_Exmh_1191255147_2870P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHARxrcC3lWbTT17ARAga2AJ923UDhLjtVC3M4JXMmHVwyI4VthgCgxyUm
GZN+5jrxQ/Nxhpg4F3SnkKQ=
=6oEN
-----END PGP SIGNATURE-----

--==_Exmh_1191255147_2870P--
