Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYJFXiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYJFXiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYJFXil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:38:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41791 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYJFXil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:38:41 -0400
Date: Tue, 7 Oct 2008 01:44:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081006234444.GA20740@one.firstfloor.org>
References: <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org> <20081006220101.GK10357@outflux.net> <20081006231942.GO3180@one.firstfloor.org> <20081006232936.GR10357@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006232936.GR10357@outflux.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 04:29:36PM -0700, Kees Cook wrote:
> > > I'd really love to see this solved.  My goal is to get a mainline glibc
> > > patch for a low-cost randomized stack guard value.
> > 
> > Your current implementation is high cost.
> >...
> > random32() is not a cryptographically strong RNG. I suspect it would
> > be pretty easy to reverse engineer its seed given some state. It hasn't
> > been designed to be protected against that.
> 
> It's being used for randomness in the networking code, so it's at least
> mildly random "enough".

Only for applications there which are not considered security sensitive.
I think. A general review of all the rngs in the kernel would be 
probably a good idea. 

Note that there are also several degrees of random
requirements in the networking code.
e.g. IPsec clearly needs stronger randomness than pktgen.

A lot of users are somewhere inbetween. e.g. I suspect the regular
routing cache rehashing would also be a excellent client of a 
a new medium quality rng facility.

> 
> > IMHO it needs a new class of random numbers in the kernel that use
> > some cryptographically strong RNG (there are a couple of candidates
> > like yarrow) which is very rarely seeded
> > from the entropy pool[1] and use that for these applications.
> > A couple of other users in the kernel would benefit that too,
> > most users of get_random_bytes() probably should be reviewed
> > for their true requirements.
> 
> Sure, but this is a larger (and pre-existing) problem.

Yes it is, but since you propose to extend the problematic 
usage much further (and also eating incredible amounts of entropy
on many workloads) you end up with the task of solving 
this problem first, sorry.

> 
> > Ideally expose it to userland too so that dumb users like
> > tmpfile can use it too. 
> 
> Would you propose that it get hooked to /dev/urandom?

It would need to be a new device.

The problem is that since noone in their right mind really still
uses /dev/random (except perhaps for gpg secret keygen) a lot
of real cryptographic applications also use /dev/urandom. And silently
changing the semantics under those wouldn't be nice.

The abusers like tmpfile etc. would just need to be fixed to 
use a different interface.

-Andi

-- 
ak@linux.intel.com
