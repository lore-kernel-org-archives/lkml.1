Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZB1RnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZB1RnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZB1Rmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:42:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbZB1Rmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:42:54 -0500
Date: Sat, 28 Feb 2009 09:42:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to
 __copy_from_user_*nocache()
In-Reply-To: <20090228092450.3ded2db5@infradead.org>
Message-ID: <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
References: <20090224020304.GA4496@google.com> <200902272305.01867.nickpiggin@yahoo.com.au> <20090228082922.GB11425@elte.hu> <200902282249.57479.nickpiggin@yahoo.com.au> <20090228125816.GA14917@elte.hu> <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
 <20090228092450.3ded2db5@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Feb 2009, Arjan van de Ven wrote:
> 
> it invalidates all caches in the hierarchy

Yeah, now that I look at the intel pdf's, I see that.

> afaik this is what Intel cpus do; but I also thought this behavior was
> quite architectural as well...

Ok, I really think we should definitely not use non-temporal stores for 
anything smaller than one full page in that case. In fact, I wonder if 
even any of the old streaming benchmarks are even true. I thought it would 
still stay in the L3, but yes, it literally seems to make the access 
totally noncached and WC.

That's almost unacceptable in the long run. With a 8MB L3 cache - and a 
compile sequence, do we really want to go out to memory to write the .S 
file, and then have the assembler go out to memory to read it back? For a 
compile, that _probably_ is all fine (the compiler in particular will have 
enough data structures around that it's not going to fit in the cache 
anyway), but I'm seeing leaner compilers and other cases where forcing 
things out all the way on the bus is simply the wrong thing.

			Linus
