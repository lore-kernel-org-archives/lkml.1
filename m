Return-Path: <linux-kernel-owner+w=401wt.eu-S1764331AbXLQQa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764331AbXLQQa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbXLQQaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:30:17 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:60956 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXLQQaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:30:15 -0500
Message-ID: <4766A40D.4080804@BitWagon.com>
Date: Mon, 17 Dec 2007 08:30:05 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org>
In-Reply-To: <20071215043208.GF17344@thunk.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Dec 14, 2007 at 04:30:08PM -0800, John Reiser wrote:
> 
>>There is a path that goes from user data into the pool.

Note particularly that the path includes data from other users.
Under the current implementation, anyone who accesses /dev/urandom
is subject to having some bytes from their address space being captured
and mixed into the pool.

>>       This path
>>is subject to manipulation by an attacker, for both reading and
>>writing.  Are you going to guarantee that in five years nobody
>>will discover a way to take advantage of it?

> Yep, I'm confident about making such a guarantee.  Very confident.

A direct attack (determining the specific values or partial values
of some captured bytes) is not the only way to steal secrets.
An indirect attack, such as traffic analysis, also may be effective.

Here is one idea.  Use output from /dev/urandom to generate a random
permutation group.  Analyze the group: determine all its subgroups, etc.
If the structure of those groups has different properties depending
on the captured bytes, even after SHA1 and folding and twisting,
then that may be enough to help steal secrets.

Indirect attacks may be subject to "exponent doubling."  The state
modulo 2**(2n) may correspond to a system of 2**n congruences
in 2**n variables.  So a property modulo 2**n might be hoisted to a
related property modulo 2**(2n).  This might make 2**1024 seem to be
not so big.

Also, "getting lucky" is allowed, both via initial conditions and
via other coincidences.  Running on a newly-booted, newly-installed
system might be especially advantageous.  A completely formal
Goedel-numbering proof often has a formal checker that is logarithmic
in the length of the proof.  If such a logarithmic property applies
every once in a while to /dev/urandom, then that might be enough.


The bottom line:  At a cost of at most three unpredictable branches
(whether to clear the bytes in the last word with indices congruent
to 1, 2, or 3 modulo 4), then the code can reduce the risk from something
small but positive, to zero.  This is very inexpensive insurance.

-- 
John Reiser, jreiser@BitWagon.com
