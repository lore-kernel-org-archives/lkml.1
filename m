Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbXHXMUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbXHXMUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbXHXMTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:19:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:54167 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbXHXMTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ak+ORfTN37cXT+/XY/TIqCLK3LAPxyflx0VCcmUJSWzlZQ6U2Mi+SXOyfJL9E/TCDs9J/CYAhpS6rExXJzrnN3OClk/ZTCq53qS3Axgi2u33ZQKSBr3P30Zs9ReLwcKSJBGvRgjBnMahPUb12fO8fTBO6UgPonvVScCYkBgQLrk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Fri, 24 Aug 2007 13:19:04 +0100
User-Agent: KMail/1.9.1
Cc: Satyam Sharma <satyam@infradead.org>, Christoph Lameter <clameter@sgi.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Paul Mackerras <paulus@samba.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       heiko.carstens@de.ibm.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, rpjday@mindspring.com, ak@suse.de,
       netdev@vger.kernel.org, cfriesen@nortel.com, akpm@linux-foundation.org,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org, zlynx@acm.org,
       schwidefsky@de.ibm.com, Chris Snook <csnook@redhat.com>,
       davem@davemloft.net, wensong@linux-vs.org, wjiang@resilience.com
References: <20070815234021.GA28775@gondor.apana.org.au> <alpine.LFD.0.999.0708180709060.3666@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0708172110400.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708172110400.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241319.05760.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 August 2007 05:13, Linus Torvalds wrote:
> On Sat, 18 Aug 2007, Satyam Sharma wrote:
> > No code does (or would do, or should do):
> >
> > 	x.counter++;
> >
> > on an "atomic_t x;" anyway.
>
> That's just an example of a general problem.
>
> No, you don't use "x.counter++". But you *do* use
>
> 	if (atomic_read(&x) <= 1)
>
> and loading into a register is stupid and pointless, when you could just
> do it as a regular memory-operand to the cmp instruction.

It doesn't mean that (volatile int*) cast is bad, it means that current gcc
is bad (or "not good enough"). IOW: instead of avoiding volatile cast,
it's better to fix the compiler.

> And as far as the compiler is concerned, the problem is the 100% same:
> combining operations with the volatile memop.
>
> The fact is, a compiler that thinks that
>
> 	movl mem,reg
> 	cmpl $val,reg
>
> is any better than
>
> 	cmpl $val,mem
>
> is just not a very good compiler.

Linus, in all honesty gcc has many more cases of suboptimal code,
case of "volatile" is just one of many.

Off the top of my head:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=28417

unsigned v;
void f(unsigned A) { v = ((unsigned long long)A) * 365384439 >> (27+32); }

gcc-4.1.1 -S -Os -fomit-frame-pointer t.c

f:
        movl    $365384439, %eax
        mull    4(%esp)
        movl    %edx, %eax <===== ?
        shrl    $27, %eax
        movl    %eax, v
        ret

Why is it moving %edx to %eax?

gcc-4.2.1 -S -Os -fomit-frame-pointer t.c

f:
        movl    $365384439, %eax
        mull    4(%esp)
        movl    %edx, %eax <===== ?
        xorl    %edx, %edx <===== ??!
        shrl    $27, %eax
        movl    %eax, v
        ret

Progress... Now we also zero out %edx afterwards for no apparent reason.
--
vda
