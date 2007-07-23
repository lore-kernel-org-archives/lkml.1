Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbXGWJOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbXGWJOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbXGWJOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:14:04 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:20760 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026AbXGWJOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ICErPE8EMdQOtK2MUMrmF07ufSOHvFEjZVGYbMxkp+oCUdVThsZd90qGQDOvGit/UPxmkn39Pk3ZzO+gFZZNNNu28Ri/oEi/uv/88Z1HdaKwyOBf3OOn5q9jSkBaYskfbwFW8oncRxqA4QJYEZhJhLuHCrlxNA7AwfYD6Yx0hYo=
Message-ID: <a781481a0707230213n7672223duf8008926d53012bc@mail.gmail.com>
Date: Mon, 23 Jul 2007 14:43:58 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] AFS: Fix file locking
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0707230150u21ba14bfme7bbff92d4705d20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>
	 <20070717175017.8b8a8976.akpm@linux-foundation.org>
	 <469DABA5.9070706@yahoo.com.au>
	 <20070719204102.7b82692d.akpm@linux-foundation.org>
	 <46A04129.1020900@yahoo.com.au>
	 <alpine.LFD.0.999.0707201835070.27249@woody.linux-foundation.org>
	 <46A4539D.9060100@yahoo.com.au>
	 <a781481a0707230150u21ba14bfme7bbff92d4705d20@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Restricting discussion to the i386 bitops implementation. ]

Hi Nick,

On 7/23/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi,
>
> On 7/23/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Linus Torvalds wrote:
> > >
> > > On Fri, 20 Jul 2007, Nick Piggin wrote:
> > >
> > >>So you did. Then to answer that, yes it could be faster because there are
> > >>stupid volatiles sprinkled all over the bitops code so you could easily
> > >>end up having to do more loads. Does it make a real difference? Unlikely,
> > >>but David loves counting cycles :)
> > >
> > >
> > > I thought we long long since removed the volatiles. They are buggy and
> > > horrible, and we really want to let the compiler combine multiple
> > > test-bits, and if they matter that implies locking is buggy or something
> > > worse..
> > >
> > > Ie we'd *want*
> > >
> > >       if (test_bit(x, y) || test_bit(z,y))
> > >
> > > to be rewritten by the compiler as testing bits x/z at the same time.
> >
> > Yep. We'd also want __set_bit(x, y); __set_bit(z, y); and such to be
> > combined.

BTW I'm also running some tests writing test code, compiling and verifying
the code gcc generates ... curiously, volatile-access-casting of the passed
bit-string address is not the only thing that'll prevent gcc's optimizer from
combining the operations such as ones you listed above. Then there are
-O2 vs -Os (and constant_test_bit() vs variable_test_bit()) differences I am
observing ... and sometimes just the inadequacy of gcc's optimizer -- note
that constant_test_bit() seems to go through extra hoops unnecessarily to
avoid honouring @nr >= 32, whereas none of the other primitives in that file
does that. So the i386 kernel's stock constant_test_bit implementation
ends up differing from David's open-coded versions quite drastically in
subtle ways, and again makes it difficult to combine the kind of operations
you guys are discussing here ...

It's a given, of course, that the code that gcc generates when combining
such operations would clearly be more optimal than the simple btl-sbbl pair
with test-and-conditional-jumps that would otherwise get generated ...

> > > But now I'm too scared to look.
> >
> > Not a chance :) Even the asm-generic "reference" implementation ratifies
> > the volatile crapiness. Would you take a patch?
>
> Coincidentally, I'm working on a cleanup of the bitops code just now --
> I stumbled upon a lot of varied bogosity in there :-)

Such as bogus/invalid asm constraints being passed in the inline assembly.
Probably gcc knows everybody gets its complicated extended asm wrong,
so doesn't barf when parsing such stuff ... :-)

> Intend to send it
> out in a couple of hours, probably.

Satyam
