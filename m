Return-Path: <linux-kernel-owner+w=401wt.eu-S1765577AbZDBHY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765577AbZDBHY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbZDBHYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:24:16 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:36849 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbZDBHYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:24:15 -0400
Date: Thu, 2 Apr 2009 11:24:18 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
	percpu allocator
Message-ID: <20090402072418.GA14071@jurassic.park.msu.ru>
References: <20090325142525.2d31c522@skybase> <49CA32F6.2030408@kernel.org> <20090331185431.72ff1707@skybase> <49D2B04D.4070604@kernel.org> <20090401101054.0a4b187d@skybase> <49D3231D.2040403@kernel.org> <20090401103257.12c2517e@skybase> <49D32B96.3060102@kernel.org> <20090401130731.785714c5@skybase> <49D41B79.60708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D41B79.60708@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 10:57:13AM +0900, Tejun Heo wrote:
> Martin Schwidefsky wrote:
> >> Maybe we can build indirection pointer manually by twiddling with
> >> DEFINE_PER_CPU() in such a way that it doesn't have to distinguish
> >> symbols and variables?
> > 
> > Hmm, a provocative idea: can we ban the use of static per-cpu variables
> > for modules in common code? There are not many common code modules
> > doing this, with a visibility hack I found the following relevant
> > locations:
> >
> > ....
> > 
> > That would "fix" the problem as well..
> 
> Eh... I don't know.  I'd really like remove such API limitations as
> most of the necessary pieces are already there anyway, so I'd much
> prefer the re-mapping thing if it can be made to work.

On alpha, the main kernel lives in the unmapped area (superpage)
and modules get loaded into vmalloc area. Changing this means total
rewrite of the alpha code, so the remapping thing is not affordable...

On the other hand, some tricks with DEFINE_PER_CPU() are indeed possible -
for instance, using weak references we could force the compiler to
generate proper addressing mode. So DEFINE_PER_CPU(int, foo) in module
would expand to something like this:

	extern int per_cpu__foo;
	asm(".weakref per_cpu__foo, per_cpu_mod__foo");
	__attribute__((__section__(".data.percpu"))) int per_cpu_mod__foo

The main problem is that our DEFINE_PER_CPU() macro consists of more
than one definition, so it won't be possible to specify both storage class
and initializer with it.

If it's acceptable to change the semantics from

static DEFINE_PER_CPU(int, foo) = 1

to

DEFINE_PER_CPU(static, int, foo) = 1

then we're ok.

Or maybe just add STATIC_DEFINE_PER_CPU_xx() variants?

Ivan.
