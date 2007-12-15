Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbXLOEcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbXLOEcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 23:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXLOEcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 23:32:42 -0500
Received: from thunk.org ([69.25.196.29]:53071 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbXLOEcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 23:32:41 -0500
Date: Fri, 14 Dec 2007 23:32:08 -0500
From: Theodore Tso <tytso@mit.edu>
To: John Reiser <jreiser@BitWagon.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071215043208.GF17344@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47632010.6030709@BitWagon.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 04:30:08PM -0800, John Reiser wrote:
> There is a path that goes from user data into the pool.  This path
> is subject to manipulation by an attacker, for both reading and
> writing.  Are you going to guarantee that in five years nobody
> will discover a way to take advantage of it?  Five years ago
> there were no public attacks against MD5 except brute force;
> now MD5 is on the "weak" list.

Yep, I'm confident about making such a guarantee.  Very confident.

First of all, keep in mind that the attacks on MD5 are about being
able to find hash collisions.  The way the cryptographic hash is being
used in /dev/random, merely being able to find hash collision means
squat.  You need to be able to carry out a preimage attack; which no
one has been able to do yet.  And even if you could figure out how to
do a pre-image attack (which none of the "successful attacks" on MD4,
MD5, SHA-0, HAVAL-128, RIPEMD, et. al have been able to acomplish), we
don't give you the entire hash output; instead, what you get is the
hash folded in half via XOR, so you only get the two halves of the SHA
hash XOR'ed together to form 80 bits.

So given one of these folded 80 bits of hash, you need to figure out a
large number of the possible combinations 1024 bits that were in
secondry entropy pool could have resulted in the folded hash image.
And using the pigeon-hole princple and assuming that SHA approximates
a random function, you need to figure out which one of the 2**944
possible combination of 1024 bits was the correct pool pre-image that
generated those 80 bits.  That's a hard problem.

But secondly, even *that's* not enough.  As I said earlier, the pool
is simply unavailable to the attacker; we never make it available,
except by revealing 80 bit hashes of the pool.  So you can't read the
initial or current state of the pool without first breaking root ---
and after 3 bytes of kernel stack is mixed into the pool, via an XOR
operation, there is no way to read out the pool.  And if you don't
know the initial contents of the pool --- funny thing, but UNKNOWN XOR
KNOWN == UNKNOWN.  So here I'm not even relying on cryptographers of
the future not being able to find preimage attacks.  I'm just relying
on simple logic.

						- Ted
