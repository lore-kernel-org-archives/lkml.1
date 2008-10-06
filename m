Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbYJFXNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbYJFXNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYJFXNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:13:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58250 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYJFXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:13:39 -0400
Date: Tue, 7 Oct 2008 01:19:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081006231942.GO3180@one.firstfloor.org>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org> <20081006220101.GK10357@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006220101.GK10357@outflux.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 03:01:01PM -0700, Kees Cook wrote:
> > Since so many systems have poor entropy input /dev/urandom has generally 
> > replaced /dev/random for near all cryptographic software, so it's
> > just the new black.
> 
> If I understand, you're suggesting that ASLR doesn't need to be strong,
> and that there should be something besides get_random* used to produce
> these values?  If that's true, that has nothing to do with the patch
> I've suggested (i.e. we have an immediate need and I'm solving it using
> the current available solutions.)  (Additionally, I think ASLR should be
> as strong as possible.)

Sure in a perfect world we had endless money and endless entropy 
and no world hunger and could make all such RNGs truly random.

But in practice the world is not like that. And entropy on a standard
Linux system is a very precious commodity.

And you won't deny that session keys are more important than mmap
placement, will you?

> 
> If instead, you're saying that the use of urandom has generally caused
> a drain on entropy, and ASLR is suffering, then does it matter that a
> few more bytes are used for the stack guard?  I'm just not clear what

It's eating entropy on every process start, so it's a incredible
drain on the entropy pool. Just calculate how much entropy
a standard "configure" run or kernel build will need.

> direction you're trying to aim my patch.  :)
> 
> I'd really love to see this solved.  My goal is to get a mainline glibc
> patch for a low-cost randomized stack guard value.

Your current implementation is high cost.

> Ulrich has a set of
> requirements, and it sounds like there's a growing new set of requirements
> from the kernel folks.  What's needed to sort this out?

IMHO it needs a new class of random numbers in the kernel that use
some cryptographically strong RNG (there are a couple of candidates
like yarrow) which is very rarely seeded
from the entropy pool[1] and use that for these applications.
A couple of other users in the kernel would benefit that too,
most users of get_random_bytes() probably should be reviewed
for their true requirements.
Ideally expose it to userland too so that dumb users like
tmpfile can use it too. 

An alternative would be also to use existing entropy sources
like the TPMs which are in many boxes now better and automatically,
but that doesn't help on systems without TPM.

-Andi

[1] getting that right is tricky, note that the entropy pool
is useless early at boot because  there's no random input.

-- 
ak@linux.intel.com
