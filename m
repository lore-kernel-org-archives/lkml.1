Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZEPQJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZEPQJQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 12:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZEPQI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 12:08:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbZEPQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 12:08:57 -0400
Date: Sat, 16 May 2009 09:05:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oliver Neukum <oliver@neukum.org>
cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>, security@kernel.org,
       Linux@hera.kernel.org, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, Arjan@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Alan@hera.kernel.org,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
In-Reply-To: <200905161754.03472.oliver@neukum.org>
Message-ID: <alpine.LFD.2.01.0905160854570.3301@localhost.localdomain>
References: <20090505202219.GL31071@waste.org> <20090516135828.GA25283@1wt.eu> <alpine.LFD.2.01.0905160811550.3301@localhost.localdomain> <200905161754.03472.oliver@neukum.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Oliver Neukum wrote:
> 
> Why can't we implement more than one hash and choose at boot time?
> Or even change the hash on the fly? That's not as good as a secret
> algorithm, but the attacker would have to guess which is used.

There's never really any point in just expanding the search space by some 
small factor. You want to expand the search space _exponentially_, not by 
just making it "three times harder".

Small factors are meaningless, because it's just going to cut down your 
success rate (well, in this case "failure rate" depending on which side 
you're on) by a small constant factor.

So "one of X known functions" does not help - it's a small constant 
factor, and you're likely _much_ better off instead just adding a couple 
of bits of hash space or entropy instead, which also makes things harder. 

Hashing in the TSC, for example, when possible, is a _lot_ more effective: 
even if the attacker can easily get a close estimation of roughly where 
the TSC is, in practice it's going to add a couple of bits of effectively 
random data on each iteration, and as such is much more powerful than 
adding a couple of bits of effectively random data just once at bootup.

What people often do is to use multiple hashes, but not select among them, 
but run them sequentially over the same data - so that if one hash is 
broken, the combination is not. And even if all hashes are broken, it's 
quite likely that the combination is much harder to break (and not by a 
small constant factor, but potentially a multiplicative cost of each 
individual hash breakage - so as long as breaking each hash isn't some 
_trivial_ O(1) thing, doing sequential hashing can add real security).

Of course, doing the sequential hashes isn't exactly good for performance ;)

			Linus
