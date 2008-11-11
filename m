Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbYKKTFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbYKKTFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYKKTFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:05:34 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41150 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYKKTFd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:05:33 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rc4-mmotm1110 - Another build error
In-Reply-To: Your message of "Mon, 10 Nov 2008 19:43:53 PST."
             <20081110194353.1a1f616e.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <38231.1226373633@turing-police.cc.vt.edu>
            <20081110194353.1a1f616e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1226430296_3887P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Nov 2008 14:04:57 -0500
Message-ID: <7421.1226430297@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1226430296_3887P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <7415.1226430296.1@turing-police.cc.vt.edu>

On Mon, 10 Nov 2008 19:43:53 PST, Andrew Morton said:
> On Mon, 10 Nov 2008 22:20:33 -0500 Valdis.Kletnieks@vt.edu wrote:
> 
> > gcc --version says:
> > gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
> > 
> > ka-blam number 2:
> > 
> >   CC      kernel/audit.o
> > In file included from include/net/dst.h:15,
> >                  from include/net/sock.h:57,
> >                  from kernel/audit.c:54:
> > include/net/neighbour.h:114: error: braced-group within expression allowed 
only inside a function
> > make[1]: *** [kernel/audit.o] Error 1
> > 
> > I'm placing bets on patches/align-avoid-evaluating-its-argument-twice.patch
> > 
> > Yep, revert that patch, and audit.o compiles again.
> > 
> 
> I hadn't got around to testing that one yet.
> 
> So ug.  ALIGN() is used in array sizing and hence has to be a
> compile-time thing.  But ALIGN(foo, bar()) will call bar() twice.
> 
> Now how do we fix that?

Can we abuse __builtin_constant_p somehow?  Maybe we can make a definition
something like:

#define __align_mask(x,mask) (
	__builtin_constant_p(mask) ? {
		(((x)+(mask))&~(mask)) :
		{              \
		      typeof(mask) __mask = mask;             \
		       (((x) + __mask) & ~__mask);             \
		}
	})

If it's a compile-time constant, it's safe to evaluate mask twice.
And if it's *not* a constant, it shouldn't be used for sizing arrays
in open code.  And if it's an array local to a procedure, it probably
should be kmalloc()'ed instead.


--==_Exmh_1226430296_3887P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJGddYcC3lWbTT17ARAjgTAJ42nAx4sXWiwL9Id3ENE7NqTr4H9gCguyjz
4EKe4JYMNbiZ54R606HHnIs=
=WGSc
-----END PGP SIGNATURE-----

--==_Exmh_1226430296_3887P--
