Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396Ab0ATUwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0ATUwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735Ab0ATUwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:52:07 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42052 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab0ATUwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:52:06 -0500
Date: Wed, 20 Jan 2010 14:51:09 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
In-Reply-To: <4B57641E.5060303@zytor.com>
Message-ID: <alpine.DEB.2.00.1001201443340.17915@router.home>
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com> <alpine.DEB.2.00.1001201333430.15175@router.home> <4B57641E.5060303@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, H. Peter Anvin wrote:

> > No I just saw it. Linus first patch increases the 64/32 bit separation by
> > creating yet another 64 bit specific file. Can we avoid that and have
> > code that is shared as much as possible between 32 and 64 bit?
>
> The ABI is completely different between 32 and 64 bits.  The stubs avoid
> keeping track of *those* differences in each and every inline.  It might
> be possible with macros, but there is something that really is very
> different: for x86-32, there are only three function-clobbered
> registers, which we pretty much need to use anyway.  For x86-64, there
> are a lot more -- which means that each callsite would end up having gcc
> generate save/restore code that would be in the fast path.  Linus' patch
> pushes that into the slow path, which seems significantly better to me.

That does not seem to be such a problematic thing to solve.

> > Why have a rwsem_count_t when a simple long would do in both cases? Just
> > make sure that long is consistently used.
>
> The motivation for rwsem_count_t seemed to be making it easier to switch
> over.  I leave it up to Linus to motivate the typedef... I have to say,
> though, that using a typedef also tells you want the number is for.

I thought we discourage such typedefs?

> > __downgrade_write:  Why use the inc trick instead of the add
> > like in 32 bit? There is not much difference and it results in much
> > stabler code.
>
> Because you can't do an add with a 64-bit immediate!  Yes, we could have
> loaded it into a register, but that would have required an additional
> 10-byte(!) instruction for no good reason.

Well 2^32 readers is a bit large anyways. If we are satisifed with 2^30
(only a billion) then it works with the same code.

