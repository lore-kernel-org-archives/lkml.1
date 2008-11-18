Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYKRACN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYKRACN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYKRABy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:01:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360AbYKRABw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:01:52 -0500
Date: Mon, 17 Nov 2008 16:01:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: eth_type_trans(): Re: [Bug #11308] tbench regression on each
 kernel release from 2.6.22 -&gt; 2.6.28
In-Reply-To: <49220144.2010005@cosmosbay.com>
Message-ID: <alpine.LFD.2.00.0811171557310.18283@nehalem.linux-foundation.org>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com>
 <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117212657.GH12020@elte.hu> <4921E4B0.7010507@cosmosbay.com> <49220144.2010005@cosmosbay.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Nov 2008, Eric Dumazet wrote:
> > *
> > * Compare two ethernet addresses, returns 0 if equal
> > */
> > static inline unsigned compare_ether_addr(const u8 *addr1, const u8 *addr2)
> > {
> >        const u16 *a = (const u16 *) addr1;
> >        const u16 *b = (const u16 *) addr2;
> > 
> >        BUILD_BUG_ON(ETH_ALEN != 6);
> >        return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) != 0;

Btw, at least on some Intel CPU's, it would be faster to do this as a 
32-bit xor and a 16-bit xor. And if we can know that there is always 2 
bytes at the end (because of how the thing was allocated), it's faster 
still to do it as a 64-bit xor and a mask.

And that's true even if the addresses are only 2-byte aligned.

The code that gcc generates for "memcmp()" for a constant-size small data 
thing is sadly crap. It always generates a "rep cmpsb", even if the size 
is something really trivial like 4 bytes, and even if you compare for 
exact equality rather than a smaller/greater-than. Gaah.

		Linus
