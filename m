Return-Path: <linux-kernel-owner+w=401wt.eu-S964996AbXIJOiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964996AbXIJOiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbXIJOii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:38:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:9619 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759105AbXIJOig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=X+R+35tMrQAYr+Y+zCSJ+QywvRuCk4gEa6IXZx9/cTkAEkhYkkn200fy6wFCnRR/hPHsWP4PPEMTDq7wunP24S41MUgtLRi8f9e7jg0E3W6zH4wFkYInxgz7nWeHWFjKoe9Ckyo++EVPX0YWQD8IT13MxfXfQHtbjI4XJGN5Qi4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Mon, 10 Sep 2007 15:38:23 +0100
User-Agent: KMail/1.9.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <200709101156.30010.vda.linux@googlemail.com> <20070910155156.2c1453fc@laptopd505.fenrus.org>
In-Reply-To: <20070910155156.2c1453fc@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709101538.25132.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2007 15:51, Arjan van de Ven wrote:
> On Mon, 10 Sep 2007 11:56:29 +0100
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
> 
> > 
> > Well, if you insist on having it again:
> > 
> > Waiting for atomic value to be zero:
> > 
> >         while (atomic_read(&x))
> >                 continue;
> > 
> 
> and this I would say is buggy code all the way.
>
> Not from a pure C level semantics, but from a "busy waiting is buggy"
> semantics level and a "I'm inventing my own locking" semantics level.

After inspecting arch/*, I cannot agree with you.
Otherwise almost all major architectures use
"conceptually buggy busy-waiting":

arch/alpha
arch/i386
arch/ia64
arch/m32r
arch/mips
arch/parisc
arch/powerpc
arch/sh
arch/sparc64
arch/um
arch/x86_64

All of the above contain busy-waiting on atomic_read.

Including these loops without barriers:

arch/mips/kernel/smtc.c
			while (atomic_read(&idle_hook_initialized) < 1000)
				;
arch/mips/sgi-ip27/ip27-nmi.c
	while (atomic_read(&nmied_cpus) != num_online_cpus());

[Well maybe num_online_cpus() is a barrier, I didn't check]

arch/sh/kernel/smp.c
	if (wait)
		while (atomic_read(&smp_fn_call.finished) != (nr_cpus - 1));

Bugs?
--
vda
