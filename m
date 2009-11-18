Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbZKRSKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbZKRSKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbZKRSKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:10:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932170AbZKRSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:10:07 -0500
Date: Wed, 18 Nov 2009 10:09:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: jslaby@novell.com, jirislaby@gmail.com, mingo@elte.hu,
       nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, jmorris@namei.org, heiko.carstens@de.ibm.com,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 06/16] SPARC: use ACCESS_ONCE for rlimits
In-Reply-To: <20091118.095526.43570583.davem@davemloft.net>
Message-ID: <alpine.LFD.2.01.0911181000020.4644@localhost.localdomain>
References: <4B040A03.2020508@gmail.com> <1258555922-2064-6-git-send-email-jslaby@novell.com> <20091118.095526.43570583.davem@davemloft.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Nov 2009, David Miller wrote:
> 
> But I wonder have we really seen the compiler create this
> kind of situation?  Or is this patch series based upon the
> fact that it "could happen"?

We have seen things like that in practice - where the compiler re-loads a 
value twice, rather than use a copy like the source code did.

That said, it's rare, to the point of being _almost_ unheard of. It's much 
more common that gcc generates bad code by doing the reverse (trying to 
keep things in registers and spilling, instead of just re-generating the 
value). There are very very few cases where ACCESS_ONCE() actually matters 
for correctness.

Because in practice, the value is either modified some way (and spilling 
it is cheaper than re-computing the modification), or there's just some 
operation that might act as a memory barrier and alias the original memory 
location so gcc wouldn't dare re-load anyway.

However, one of the nice things about ACCESS_ONCE() is that it's also a 
big flag for "this value is loaded without locking, on purpose".

So even if it doesn't then actually change code generation significantly 
(most common end result especially on x86 that has most ALU instructions 
taking memory operations: gcc generates slightly worse code due to getting 
nervous about 'volatile' and not combining instructions), it's a big 
honking piece of programmer documentation: look out!

It's basically a heads-up for lockless programming like RCU. As such, it 
can be something scary, but when it's done right, it's a good thing. And I 
think that for rlimits, we do have a good reason to say "sure, somebody 
else may change the limit values concurrently, but we don't really care: 
we just want _one_ value, whether it's the old or the new one".

That said, the patch you Ack'ed is in the series of patches that I hated, 
and Nak'ed for other reasons (namely "-EEXPRESSIONTOOCOMPLICATEDTOLIVE").

			Linus
