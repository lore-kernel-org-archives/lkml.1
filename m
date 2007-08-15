Return-Path: <linux-kernel-owner+w=401wt.eu-S934773AbXHOSkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773AbXHOSkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbXHOSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:39:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:37367 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbXHOSj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:39:56 -0400
In-Reply-To: <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
References: <20070809131423.GA9927@shell.boston.redhat.com> <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in> <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <9350e9fab505c92af8d5e1f3441d6ad2@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Christoph Lameter <clameter@sgi.com>, heiko.carstens@de.ibm.com,
       horms@verge.net.au, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       ak@suse.de, cfriesen@nortel.com, rpjday@mindspring.com,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, zlynx@acm.org,
       schwidefsky@de.ibm.com, Chris Snook <csnook@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Wed, 15 Aug 2007 20:31:31 +0200
To: Satyam Sharma <satyam@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> "Volatile behaviour" itself isn't consistently defined (at least
> definitely not consistently implemented in various gcc versions across
> platforms),

It should be consistent across platforms; if not, file a bug please.

> but it is /expected/ to mean something like: "ensure that
> every such access actually goes all the way to memory, and is not
> re-ordered w.r.t. to other accesses, as far as the compiler can take
> care of these". The last "as far as compiler can take care" disclaimer
> comes about due to CPUs doing their own re-ordering nowadays.

You can *expect* whatever you want, but this isn't in line with
reality at all.

volatile _does not_ make accesses go all the way to memory.
volatile _does not_ prevent reordering wrt other accesses.

What volatile does are a) never optimise away a read (or write)
to the object, since the data can change in ways the compiler
cannot see; and b) never move stores to the object across a
sequence point.  This does not mean other accesses cannot be
reordered wrt the volatile access.

If the abstract machine would do an access to a volatile-
qualified object, the generated machine code will do that
access too.  But, for example, it can still be optimised
away by the compiler, if it can prove it is allowed to.

If you want stuff to go all the way to memory, you need some
architecture-specific flush sequence; to make a store globally
visible before another store, you need mb(); before some following
read, you need mb(); to prevent reordering you need a barrier.


Segher

