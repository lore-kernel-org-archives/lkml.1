Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbYJGBOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbYJGBOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYJGBOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:14:04 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:44100 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYJGBOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:14:03 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Date: Mon, 6 Oct 2008 22:16:10 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <gce2na$2or$1@taverner.cs.berkeley.edu>
References: <20081001201116.GD12527@outflux.net> <20081006175038.GF10357@outflux.net> <gcdl7a$en4$1@taverner.cs.berkeley.edu> <873aj9o4lq.fsf@basil.nowhere.org>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1223331370 2843 128.32.168.222 (6 Oct 2008 22:16:10 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 6 Oct 2008 22:16:10 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen  wrote:
>Nobody really is using blocking /dev/random anymore,

Good.  /dev/random was a poor choice for most applications.
I've always lamented the naming scheme (which for a long time
caused many applications to use /dev/random when /dev/urandom would
have been more appropriate).

>> (Andi Kleen's criticisms would be relevant if get_random_bytes() acted
>> like reading from /dev/random.)
>
>It does. It processes your real entropy from the pool and then
>afterwards it's not unique anymore because it has been reused. Yes it
>runs through a few hashes and what not, so it's not trivially
>predictable, and it won't block on depletion, but it still
>affects the entropy pool and degenerates it into a psuedo
>random RNG.

?  You say get_random_bytes() acts like reading from /dev/random,
but then your subsequent sentences are consistent with it acting like
reading from /dev/urandom, so I'm lost.

/dev/urandom also runs its inputs through cryptographic hash functions
to ensure that it acts as a cryptographic-quality pseudorandom number
generator.  /dev/urandom also won't block on depletion.  /dev/urandom
also affects the entropy pool.  /dev/urandom is a pseudorandom number
generator.

"not trivially predictable" seems overly dismissive.  /dev/urandom is
a lot better than "not trivially predictable"; it is intended as a
cryptographic-quality PRNG.  It's not just "run through a few hashes
and what not": it uses cryptographic hash functions in an appropriately
chosen way to ensure that its output will be cryptographically strong
(assuming it has been properly seeded, and assuming that the
cryptographic hash functions have no relevant security holes).

>The only chance to have some for the applications
>that really need it is to conserve the little entropy
>that is there anyways as best as possible. And giving out 
>16 bytes of it (or rather dilluting it by giving out
>parts of it) for each programs isn't the way to do.

I'm not sure what you mean by "conserving entropy".  Are you
referring to the impact on other applications that use /dev/random?
If the impact of get_random_bytes() on /dev/random-users is the
same as the impact of /dev/urandom on /dev/random-users, then I
don't understand the objection.

>It depends on how you define crypto strength pseudorandom:

This term has a standard well-defined meaning in the cryptographic
literature.  That's how I define it.

"pseudorandom" implies that it is not true, information-theoretic
randomness; rather, it refers to bits that are computationally
indistinguishable from true randomness.

>If you refer to some crytographic pseudo RNG: that is what
>urandom does, except that it still uses up previous real
>entropy so that the next user who needs real entropy for their
>session keys won't get as much (or rather it will get low quality entropy
>instead which is dangerous)

This statement looks confused to me.  You really have to separate users
of /dev/random from users of /dev/urandom if you want to make these kinds
of statements, and you need to separate information-theoretic security
("entropy") from computational security (where, confusingly, sometimes
people also use the word "entropy" to refer to computational
indistinguishability from true entropy; let's try to avoid that here,
since there seems to be some confusion about information-theoretic
vs computational security).

Once /dev/urandom is properly seeded, it doesn't matter how much output
you grab from /dev/urandom; all subsequent users of /dev/urandom will
continue to get cryptographic-quality pseudorandom bits (bits that cannot
be distinguished from true randomness by any computationally feasible
computation, so far as we know).

Perhaps you are referring to the effect that reading from /dev/urandom
has on user of /dev/random.  I'm not sure I fully understand the issue.
Are you saying that if /dev/random is relatively starved for entropy,
and if Alice reads lots of bits from /dev/urandom, and then Bob reads
from /dev/random, then Bob might block waiting for /dev/random's pool
to be replenished?

If that's the issue, then the solution seems to be to fix /dev/urandom
and /dev/random, as this is a general issue for all users of /dev/random,
not specific to get_random_bytes() or to this particular use of random
bits for glibc.  (Keep in mind your earlier claim that no one uses
/dev/random.)

Note that /dev/random will block if it thinks there is not sufficient
entropy availbale; it doesn't return low quality entropy.  I'm not clear
on the scenario under which you expect some user to get low quality
entropy.

>The better way would be to use a crypto strength RNG that is only
>seeded very seldom from the true pool, as to not affect the precious
>real entropy pool for applications that really need it much.

Seems to me cleaner fix /dev/urandom to work that way, if this is
the concern, rather than narrowing in on glibc's use of /dev/urandom.

>The problem in your reasoning is that you assume the entropy
>pool is a infinite resource that there is enough for everybody.

I never made that assumption.  Once /dev/urandom is seeded with
128 bits of high-quality entropy, all of its subsequent outputs
will be fantastic (computationally indistinguishable from true
randomness).
