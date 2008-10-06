Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYJFXZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYJFXZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbYJFXWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48504 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbYJFXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:07 -0400
Date: Tue, 7 Oct 2008 01:28:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081006232810.GP3180@one.firstfloor.org>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org> <20081006220759.GM10357@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006220759.GM10357@outflux.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 03:07:59PM -0700, Kees Cook wrote:
> On Mon, Oct 06, 2008 at 09:26:41PM +0200, Andi Kleen wrote:
> > > We're already using get_random* for stack, heap, and brk.  Also,
> > > get_random* uses the nonblocking pool, so this is the same as if userspace
> > > had tried to pull bytes out of /dev/urandom, which (as I understand it)
> > 
> > Yes exactly that's the problem. Think about it: do you really 
> > need the same cryptographic strength for your mmap placement
> > as you need for your SSL session keys?
> > 
> > And if you need true entropy for your session keys do you
> > still get it when it was all used for low security 
> > purposes first?
> 
> Off-list I was just shown random32().  If AT_RANDOM used that instead,
> would that be acceptable?

random32() is not a cryptographically strong RNG. I suspect it would
be pretty easy to reverse engineer its seed given some state. It hasn't
been designed to be protected against that.

While I suspect this wouldn't be a serious threat to the security
model for mmap (to break the mmap placement you would still need quite a lot of
addresses before you can predict some and I presume most apps do not leak
addresses) it would seem unnecessarily 
weak to me because using a better algorithm is not very costly.
Also it might be a problem for some of the other potential users.

cryptographically strong RNGs are especially designed to make this
reverse engineering of the state hard. 

Simple ones can be just a cryptographic hash + counter + secret or
the same with a encryption algorithm like AES, but there are 
also algorithms who are especially designed for this like yarrow/fortuna

See
http://en.wikipedia.org/wiki/Cryptographically_secure_pseudo-random_number_generator

-Andi

-- 
ak@linux.intel.com
