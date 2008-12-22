Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYLVXPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYLVXPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYLVXOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:14:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167AbYLVXOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:14:51 -0500
Date: Mon, 22 Dec 2008 15:13:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@elte.hu, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       kenchen@google.com, paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] powerpc: change u64/s64 to a long long integer type
Message-Id: <20081222151338.3b6ef997.akpm@linux-foundation.org>
In-Reply-To: <20081222230035.GB4074@uranus.ravnborg.org>
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au>
	<b040c32a0812212249p45aba306tbb68a960b79cd0ee@mail.gmail.com>
	<20081222070426.GD29160@elte.hu>
	<20081222181932.5dd9514e.sfr@canb.auug.org.au>
	<20081222080341.GA18897@elte.hu>
	<20081222144319.1bfc0061.akpm@linux-foundation.org>
	<20081222230035.GB4074@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008 00:00:35 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Dec 22, 2008 at 02:43:19PM -0800, Andrew Morton wrote:
> > On Mon, 22 Dec 2008 09:03:41 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Subject: powerpc: change u64/s64 to a long long integer type
> > 
> > <applause>
> > 
> > There are lots of other architctures that need doing though.
> 
> I have missed the introduction.
> Can you explain why?

People keep on doing

	printk("%llu", some_u64);

testing it only on x86_64 and this generates a warning storm on
powerpc, sparc64, etc.  Because they use `long', not `long long'.

And not just a little bit - this bug gets repeated maybe ten times per
week - it's insane.

If we make all architectures use `long long' then the above code
becomes correct and warning-free on all architectures.

And we then get to remove all the open-coded (unsigned long long) casts
which we added all over the tree (hundreds of them).

> I have done a bit of sparc hacking lately and was wondering if
> sparc needs something similar.
> 
> cd arch/sparc
> git grep u64 | grep -v __u64 | wc -l
> 448
> 
> [On the unified tree]

Yes, quite a few 64-bit architectures are using `long' for their
s64/u64 types.  We should convert them all to `long long'.

That's quite trivial to do, but it causes a lot of warnings due to code
in arch-speciic files which does

	printk("%lu", some_u64);

which will then generate a warning.  Or an error if the archtiecture
uses -Werror, which several do.  So we need to simultaneously convert
all those to %llu.  (Or %Lu, which saves a byte :))


	
