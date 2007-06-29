Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbXF2NYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbXF2NYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763264AbXF2NYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:24:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50638 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763204AbXF2NYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:24:36 -0400
Date: Fri, 29 Jun 2007 08:24:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: casey@schaufler-ca.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
Message-ID: <20070629132431.GC30458@sergelap.austin.ibm.com>
References: <325190.92239.qm@web36610.mail.mud.yahoo.com> <468498F3.5040001@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468498F3.5040001@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Casey Schaufler wrote:
> >> Would there be a difference between that and setting either fI or fP
> >> (depending on your intent) to those caps, and setting fE=1 in Andrew's
> >> scheme?
> > 
> > Arg, you're making me think. The POSIX group went through this,
> > let me see if I can reconstruct the logic.
> > 
> > The main issue is one if there being a possible case where you
> > have a capability ignorant program that you want to exec with
> > a different fP and fE. On first glance it seems that since the
> > program is capability ignorant it can't matter. But what if your
> > capability ignorant program exec's a capability aware program
> > to perform a helper function? You may well want the first program
> > to have a capability that it does not use in fP (but not fE)
> > to pass along to the helper program. True, you could probably
> 
> I'm not sure I've quite flogged this horse to death yet.. :-)
> 
> In my other reply, I quoted the rules. Here they are again:
> 
>     pI' = pI
>     pP' = (X & fP) | (pI & fI)
>     pE' = pP' & fE
>
> If program A exec()utes helper program B, then the only capabilities
> (p*') that B can get from A are a subset of A's pI set.
> 
> If A doesn't know about capabilities, then nothing about the fE value
> associated with the A program file can alter A's pI set and thus affect
> B. That is, nothing about the fE or fP value used to exec()ute A gets
> propagated through a subsequent exec() to B.
> 
> So far as I can see, to achieve the helper program support you are
> describing, the value of pI that program A (and thus program B) inherits
> will have to contain the relevant capabilities, and B will have to have
> a sufficient fI value to pick them up...
> 
> Incidentally, this is also where my request that we require (pP' >= fP)
> be true comes in. If a helper program (which may also be a legacy

That was going to be my next thing to look at, btw.

> program) is used in a way that it is configured (via fP) to have powers
> that are denied to it (via X=cap_bset etc.,) then it should simply not
> be permitted to run (-EPERM). It should not have the opportunity to
> silently confuse itself (as was the case with sendmail when we tried to
> emulate setuid-0 behavior with capabilities a few years back).
> 
> > come up with a way to set the capabilities on the helper program
> > to account for this use, but there may be design and security
> > constraints that make doing so complicated. 
> 
> I've not seen anything yet to make be believe there is a case for a
> non-single bit fE value... Its a little ironic that I read all of the
> rationale I've been espousing in POSIX drafts - so far as I'm aware the
> only detail I'm mixing in there is the (pP' >= fP), -EPERM, thing.
> 
> If you or anyone can cite some counter examples, please do!

Not really.

But, your argument is:

fE can only be used to create a different initial pE' than pP'.

If the binary doesn't know about capabilities, then you would never want
to do that since it won't change it's pE', and therefore it's pP' is
meaningless once pE' is set.

If the binary does know about capabilities, then it can change it's pE'
within the bounds of it's pP' whenever it wants, so we may want to set
pE' to 0 at start, but having pE' be just a subset of pP' has no
advantage since the binary can set pE' to the subset when it wants.

Now, *my* argument :) is that:

While there is no particular advantage (that I can think of) to having
the bitmap pE', there is also no disadvantage, and it produces kernel
code closer to the actual equations usually seen.

In the course of this discussion, the two advantages I've seen which
I'll concede to you are:

	1. the resulting equations may be easier to read/understand,
	   just bc it's one less bitmask operation whose purpose to try
	   to understand.  But I'm not certain.
	2. Improper setting of fE *could* in theory cause another
	   hard to diagnose sendmail-type vulnerability, by having fP
	   set to the right value, but fE to the wrong value.  Though
	   that is stretching things a bit.

The change in xattr format offsets those, which is why I like the idea of
just having the setfcaps program understand 'on=e' and 'off=e' (where on
is of course just an alias for 'all'), but keeping the kernel code the
same.

-serge
