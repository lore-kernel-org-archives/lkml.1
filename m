Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbXLRBR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbXLRBR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXLRBRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:17:49 -0500
Received: from THAUM.MIT.EDU ([18.95.3.27]:48826 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751862AbXLRBRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:17:48 -0500
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 20:17:48 EST
Message-ID: <476719E5.1010505@myrealbox.com>
Date: Mon, 17 Dec 2007 19:52:53 -0500
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, John Reiser <jreiser@BitWagon.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org>
In-Reply-To: <20071217173623.GC7070@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, Dec 17, 2007 at 08:30:05AM -0800, John Reiser wrote:
>>>> [You have yet to show that...]
>>>> There is a path that goes from user data into the pool.
>> Note particularly that the path includes data from other users.
>> Under the current implementation, anyone who accesses /dev/urandom
>> is subject to having some bytes from their address space being captured
>> and mixed into the pool.
> 
> Again, you haven't *proven* this yet.

Has anyone *proven* that using uninitialized data this way is safe?  As 
a *user* of this stuff, I'm *very* hesitant to trust Linux's RNG when I 
hear things like this.  (Hint: most protocols are considered insecure 
until proven otherwise, not the other way around.)

Consider:  add_entropy_words is reversible [1], presumably in the sense 
that words could be removed, so, if there added words are independent of 
the state, there is no loss of entropy.  But it also appears reversible 
in the sense that if the pool has a known state and entropy words are 
added, most of which are known, the unknown ones can be found (if 
nothing else, if there are only a few bits of entropy there, you can try 
all possibilities).

Now imagine a security program.  It runs some forward secret protocol 
and it's very safe not to leak data that would break forward secrecy 
(mlockall, memset when done with stuff, etc).  It runs on a freshly 
booted machine (no DSA involved, so we're not automatically hosed), so 
an attacker knows the initial pool state.  Conveniently, some *secret* 
(say an ephemeral key, or, worse, a password) gets mixed in to the pool. 
  There are apparently at most three bytes of extra data mixed in, but 
suppose the attacker knows add the words that were supposed to get mixed 
in.  Now the program clears all its state to "ensure" forward secrecy, 
and *then* the machine gets hacked.  Now the attacker can learn (with at 
most 2^24 guesses worth of computation) 24 bits worth of a secret, which 
could quite easily reduce the work involved in breaking whatever forward 
secret protocol was involved from intractable to somewhat easy.  Or it 
could leak three bytes of password.  Or whatever.

Sorry for the somewhat inflammatory email, but this is absurd.

--Andy


[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg238406.html
