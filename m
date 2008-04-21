Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbYDULnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbYDULnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbYDULnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:43:18 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46338 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755510AbYDULnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:43:17 -0400
Message-Id: <1208778196.9210.1248995009@webmail.messagingengine.com>
X-Sasl-Enc: rKn+ivFsxkjA+O+VNv1apNy0BuKkOi7wxjxosuJ2PA+C 1208778196
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Matti Aarnio" <matti.aarnio@zmailer.org>
Cc: "Joe Perches" <joe@perches.com>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
   <1208563762.10414.19.camel@brick>
   <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
   <1208566724.4891.25.camel@localhost>
   <1208567093.10414.20.camel@brick>
   <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
   <1208573728.11990.14.camel@localhost>
   <20080419222911.GJ3700@mea-ext.zmailer.org>
   <1208660817.12388.40.camel@localhost>
   <1208680941.5276.1248837773@webmail.messagingengine.com>
   <20080420123146.GN3700@mea-ext.zmailer.org>
Subject: Re: Alternative implementation of the generic __ffs
In-Reply-To: <20080420123146.GN3700@mea-ext.zmailer.org>
Date: Mon, 21 Apr 2008 13:43:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 15:31:46 +0300, "Matti Aarnio"
<matti.aarnio@zmailer.org> said:
> On Sun, Apr 20, 2008 at 10:42:21AM +0200, Alexander van Heukelum wrote:
> > On Sat, 19 Apr 2008 20:06:57 -0700, "Joe Perches" <joe@perches.com>
> > said:
> > > On Sun, 2008-04-20 at 01:29 +0300, Matti Aarnio wrote:
> > > > I am curious, why not take the code already in glibc ffs() for ARM ?
> > > > That is, if the ffs() is all that important detail in kernel ?
> > 
> > Hi,
> > 
> > The glibc version is based on a table-lookup. This makes it
> > behave differently in hot and cold cache situations. That's
> > fine if __ffs is used in tight loops, but in the kernel such
> > use of __ffs is avoided because it might be slow. I added it
> > to the benchmark, but it would need testing for the cold
> > cache case too.
> > 
> > As for the importance of __ffs in the kernel: as far as I
> > know the hot-spots in the kernel using __ffs are the
> > schedular (sched_find_first_bit) and the cpu mask walking
> > code (for_each_cpu_mask).
> 
> Perhaps those hot-spots would benefit from more broadly
> accelerable algorithms.

That would be a possibility too ;). The advantages of bitmaps
are that they are so compact and so easy to understand.

>                      ARM architecture v5 introduced
> a CLZ instruction -- Count Leading Zeroes.

Yeah, if such an instruction exist, the arch should provide
optimized versions for the bit functions. The interest here
was to provide a (beter) generic version in pure C for
architectures without such instructions.

Inline assembly versions are indeed provided in
asm-arm/bitops.h for ARM5+.

Greetings,
    Alexander

> Well, gcc's  __builtin_ffs() for ARM Arch5 and up (including
> XScale) does things in a bit more interesting way:
> 
>   http://mail-index.netbsd.org/port-arm/2002/08/20/0001.html
> 
> $ cat try.c
> int foo(int i)
> {
>         return __builtin_ffs(i);
> }
> $ arm-gp2x-linux-gcc -S -O -march=armv5 try.c 
> $ more try.s 
>         .file   "try.c"
>         .text
>         .align  2
>         .global foo
>         .type   foo, %function
> foo:
>         @ args = 0, pretend = 0, frame = 0
>         @ frame_needed = 0, uses_anonymous_args = 0
>         @ link register save eliminated.
>         @ lr needed for prologue
>         rsb     r3, r0, #0
>         and     r3, r3, r0
>         clz     r3, r3
>         rsb     r0, r3, #32
>         bx      lr
>         .size   foo, .-foo
>         .ident  "GCC: (GNU) 4.1.2 (Fedora GP2X 4.1.2-8.fc9)"
> 
> 
> > Greetings,
> >     Alexander
> 
> /Matti Aarnio
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - I mean, what is it about a decent email service?

