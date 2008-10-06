Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYJFUXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYJFUXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYJFUXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:23:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41157 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYJFUXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:23:16 -0400
To: daw-news@cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
From: Andi Kleen <andi@firstfloor.org>
References: <20081001201116.GD12527@outflux.net>
	<20081003001616.GN10632@outflux.net>
	<87ej2untze.fsf@basil.nowhere.org>
	<20081006175038.GF10357@outflux.net>
	<gcdl7a$en4$1@taverner.cs.berkeley.edu>
Date: Mon, 06 Oct 2008 22:23:13 +0200
In-Reply-To: <gcdl7a$en4$1@taverner.cs.berkeley.edu> (David Wagner's message of "Mon, 6 Oct 2008 18:25:46 +0000 (UTC)")
Message-ID: <873aj9o4lq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

daw@cs.berkeley.edu (David Wagner) writes:

> Kees Cook  wrote:
>>On Mon, Oct 06, 2008 at 08:00:21AM +0200, Andi Kleen wrote:
>>> While the basic idea is good using get_random_bytes() is not.
>>> 
>>> That eats precious cryptography strength entropy from the entropy
>>> pool, which on many systems is not adequately fed. In those cases you
>>> really only want to use it for real keys, not for lower grade
>>> applications. The applications glibc wants to use this for do not
>>> really require crypto strength entropy, just relatively unpredictable
>>> randomness.
>>
>>We're already using get_random* for stack, heap, and brk.  Also,
>>get_random* uses the nonblocking pool, so this is the same as if userspace
>>had tried to pull bytes out of /dev/urandom, which (as I understand it)
>>is the very thing we're trying to duplicate without the VFS overhead.
>
> Using /dev/urandom does seem like exactly the right thing to do.

Nobody really is using blocking /dev/random anymore, unless you like seeing
"Please bang the keyboard randomly until the pool is full" messages.
Good luck doing that on a rackmounted system in some data center.

Unfortunately most systems have very little real entropy
input, so every application what doesn't want itself constantly
dos'ed has to use /dev/unradom.

> (Andi Kleen's criticisms would be relevant if get_random_bytes() acted
> like reading from /dev/random.)

It does. It processes your real entropy from the pool and then
afterwards it's not unique anymore because it has been reused. Yes it
runs through a few hashes and what not, so it's not trivially
predictable, and it won't block on depletion, but it still
affects the entropy pool and degenerates it into a psuedo
random RNG.

The only chance to have some for the applications
that really need it is to conserve the little entropy
that is there anyways as best as possible. And giving out 
16 bytes of it (or rather dilluting it by giving out
parts of it) for each programs isn't the way to do.

> I don't think it would be wise to use less than crypto strength
> pseudorandom numbers for glibc 

It depends on how you define crypto strength pseudorandom:
if you refer to a true environmental entropy pool then you're clearly wrong.
If you refer to some crytographic pseudo RNG: that is what
urandom does, except that it still uses up previous real
entropy so that the next user who needs real entropy for their
session keys won't get as much (or rather it will get low quality entropy
instead which is dangerous)
The better way would be to use a crypto strength RNG that is only
seeded very seldom from the true pool, as to not affect the precious
real entropy pool for applications that really need it much.

> -- at least, not without very thorough
> analysis.  glibc is using this for security, so it has to be right.
> When people say "oh, we don't need crypto-strength randomness", in
> my experience it's too common to end up with something insecure.

The problem in your reasoning is that you assume the entropy
pool is a infinite resource that there is enough for everybody.
While that's a nice theory it does not match real systems unfortunately.

So in your quest for "same strength for everyone" you end up
with "poor strength for everyone". Bad tradeoff. 

-Andi
