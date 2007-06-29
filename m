Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXF2Fak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXF2Fak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXF2Fab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:30:31 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:60964 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbXF2Fa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:30:29 -0400
Message-ID: <468498F3.5040001@kernel.org>
Date: Thu, 28 Jun 2007 22:30:27 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070531)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: "Serge E. Hallyn" <serue@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
References: <325190.92239.qm@web36610.mail.mud.yahoo.com>
In-Reply-To: <325190.92239.qm@web36610.mail.mud.yahoo.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Casey Schaufler wrote:
>> Would there be a difference between that and setting either fI or fP
>> (depending on your intent) to those caps, and setting fE=1 in Andrew's
>> scheme?
> 
> Arg, you're making me think. The POSIX group went through this,
> let me see if I can reconstruct the logic.
> 
> The main issue is one if there being a possible case where you
> have a capability ignorant program that you want to exec with
> a different fP and fE. On first glance it seems that since the
> program is capability ignorant it can't matter. But what if your
> capability ignorant program exec's a capability aware program
> to perform a helper function? You may well want the first program
> to have a capability that it does not use in fP (but not fE)
> to pass along to the helper program. True, you could probably

I'm not sure I've quite flogged this horse to death yet.. :-)

In my other reply, I quoted the rules. Here they are again:

    pI' = pI
    pP' = (X & fP) | (pI & fI)
    pE' = pP' & fE

If program A exec()utes helper program B, then the only capabilities
(p*') that B can get from A are a subset of A's pI set.

If A doesn't know about capabilities, then nothing about the fE value
associated with the A program file can alter A's pI set and thus affect
B. That is, nothing about the fE or fP value used to exec()ute A gets
propagated through a subsequent exec() to B.

So far as I can see, to achieve the helper program support you are
describing, the value of pI that program A (and thus program B) inherits
will have to contain the relevant capabilities, and B will have to have
a sufficient fI value to pick them up...

Incidentally, this is also where my request that we require (pP' >= fP)
be true comes in. If a helper program (which may also be a legacy
program) is used in a way that it is configured (via fP) to have powers
that are denied to it (via X=cap_bset etc.,) then it should simply not
be permitted to run (-EPERM). It should not have the opportunity to
silently confuse itself (as was the case with sendmail when we tried to
emulate setuid-0 behavior with capabilities a few years back).

> come up with a way to set the capabilities on the helper program
> to account for this use, but there may be design and security
> constraints that make doing so complicated. 

I've not seen anything yet to make be believe there is a case for a
non-single bit fE value... Its a little ironic that I read all of the
rationale I've been espousing in POSIX drafts - so far as I'm aware the
only detail I'm mixing in there is the (pP' >= fP), -EPERM, thing.

If you or anyone can cite some counter examples, please do!

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFGhJjxQheEq9QabfIRAmyLAKCUxirmAuS4VM0U+9HloeOF6cKt2gCgi/fh
ElhM1CISM4a+e0umBjK9GV0=
=Vrqj
-----END PGP SIGNATURE-----
