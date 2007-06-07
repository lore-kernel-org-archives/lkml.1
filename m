Return-Path: <linux-kernel-owner+w=401wt.eu-S934223AbXFGRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223AbXFGRZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759932AbXFGRZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:25:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761195AbXFGRZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:25:32 -0400
Message-ID: <4668155B.4020705@redhat.com>
Date: Thu, 07 Jun 2007 07:25:31 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>	<20070606235906.72439d16@the-village.bc.nu>	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>	<20070607001932.35c9591c@the-village.bc.nu>	<466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
In-Reply-To: <20070607110432.73be7960@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
>> continuous allocation are part of the API.  It's required by POSIX and
>> provided by Unix since the early days.  There are entire code bases out
>> there which depend on this assumption.  Linking with code like this,
>> before or after the new version controlled symbol is introduced, will
>> break it. 
> 
> If your linker is doing its job then you won't be able to link them
> together because they have incompatible assumptions. Not exactly rocket
> science even if it is done a little differently to the usual symbol
> compatibility tests. 

No.  You still don't appreciate the problem.

Assume I would change code so that newly compiled programs which use
open, socket, etc generate different references which cannot be
satisfied by old runtimes.  That and only that is something linkers can
see, linkers deal with symbols and references.

If I would do that and people would recompile their existing code this
*still* does not change the fact that the program behavior would be
changed and the code might break.  It can be something as simple as

   int fd = open(...);
   ...
   close(fd);
   ...
   close(STDIN_FILENO);
   open(...);

The last open is supposed to open a new file with descriptor 0 (i.e.,
STDIN_FILENO).  By using non-sequential descriptors this is not guaranteed.

This is nothing you can change with linker magic.  It is embedded in the
code.  It's behavior *guaranteed* by POSIX and Unix before it for
decades.  This isn't anything you can change.


> And the stuff you are trying to put into the kernel is better ? No, its a
> bunch of ugly hacks caused by trying to solve the problem in the wrong
> way and in the wrong place.

Go back 30 years and convince people to not guarantee first-match
allocation of descriptors.  Then you can stand up and demand purity.
But just as in many other cases, legacy demands its price.  We sometimes
have to pay the price for compatibility and if it isn't high it's worth
it.  I don't say the current proposed code is the answer but iff
Davide's unified code does not perform worse than the current code I
don't see the harm since, for instance, extending socket() is in any
case necessary.  I mentioned that close_on_exit must be set on open,
else leaks are risked.  This will come naturally with a flags parameter
which already takes O_NONSEQFD.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaBVb2ijCOnn/RHQRAnzGAJwLY3dDc9nl69yFPZfYUr8qbIeXygCfTqMd
u5Jofy3gFB5bWEHdnPtUhJY=
=Jz/g
-----END PGP SIGNATURE-----
