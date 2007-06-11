Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXFKTqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXFKTqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXFKTpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:45:53 -0400
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:53531 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbXFKTpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:45:52 -0400
Message-ID: <466DA660.4090102@cs.cmu.edu>
Date: Mon, 11 Jun 2007 15:45:36 -0400
From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
User-Agent: Icedove 1.5.0.8 (X11/20061208)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@linux-foundation.org, herbert@gondor.apana.org.au,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux@horizon.com
Subject: Re: [PATCH 3/3] [CRYPTO] Add optimized SHA-1 implementation for x86_64
References: <20070608214242.23949.30350.stgit@dev>	<20070608214258.23949.67358.stgit@dev> <p73lkeqvgwb.fsf@bingen.suse.de>
In-Reply-To: <p73lkeqvgwb.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Benjamin Gilbert <bgilbert@cs.cmu.edu> writes:
>> +#define EXPAND(i)						\
>> +	movl	OFFSET(i % 16)(DATA), TMP;			\
>> +	xorl	OFFSET((i + 2) % 16)(DATA), TMP;		\
> 
> Such overlapping memory accesses are somewhat dangerous as they tend
> to stall some CPUs.  Better probably to do a quad load and then extract.

OFFSET(i) is defined as 4*(i), so they don't actually overlap. 
(Arguably that macro should go away.)

> I haven't checked in detail if it's possible but it's suspicious you
> never use quad operations for anything. You keep at least half
> the CPU's bits idle all the time.

SHA-1 fundamentally wants to work with 32-bit quantities.  It might be 
possible to use quad operations for some things, with sufficient 
cleverness, but I doubt it'd be worth the effort.

> Gut feeling is that the unroll factor is far too large.
> Have you tried a smaller one? That would save icache
> which is very important in the kernel.

That seems to be the consensus.  I'll see if I can find some time to try 
linux@horizon.com's suggestion and report back.

I don't think, though, that cache footprint is the *only* thing that 
matters.  Leaving aside /dev/urandom, there are cases where throughput 
matters a lot.  This patch set came out of some work on a hashing block 
device driver in which SHA is, by far, the biggest CPU user.  One could 
imagine content-addressable filesystems, or even IPsec under the right 
workloads, being in a similar situation.

Would it be more palatable to roll the patch as an optimized CryptoAPI 
module rather than as a lib/sha1.c replacement?  That wouldn't help 
/dev/urandom, of course, but for other cases it would allow the user to 
ask for the optimized version if needed, and not pay the footprint costs 
otherwise.

--Benjamin Gilbert

