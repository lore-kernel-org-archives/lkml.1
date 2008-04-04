Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYDDOas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYDDOas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbYDDOae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:30:34 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:19272 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759349AbYDDOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:30:33 -0400
Message-ID: <47F63641.4090103@knosof.co.uk>
Date: Fri, 04 Apr 2008 15:08:01 +0100
From: Derek M Jones <derek@knosof.co.uk>
Organization: Knowledge Software, Ltd
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Josh Triplett <josh@freedesktop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org> <20080403024117.GZ9785@ZenIV.linux.org.uk> <47F53E84.8080607@freedesktop.org> <20080404011951.GC9785@ZenIV.linux.org.uk>
In-Reply-To: <20080404011951.GC9785@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

> 	* typedef *can* be variably-modified, but only in block scope.
> Warning: this can get sticky for us - all sizes are evaluated when
> typedef is reached.  IOW,
> 	typedef int a[n];
> 	a x;
> 	if (n++ == 5) {
> 		a y;
> 		int z[n];
> 	}
> will have size of y equal to that of x, but *not* equal to that of z.

An opportunity for Sparse to issue a warning :-)

> Another thing to keep in mind is that sizeof(VLA) is not a constant
> expression *and* that sizeof argument is evaluated.  IOW, not only
> 	sizeof(int [n = f()])
> has side effects, but in
> 	int (*p)[n];
> 	...
> 	sizeof(*(g(), p))
> will have g() evaluated.  Note that if p had been declared as
> 	int (*p)[4];
> the same sizeof() would *NOT* have called anything.  This, BTW, is where
> the rules for what an integer constant expression is are getting bloody
> important:

Any side effect appearing in a sizeof operand ought to be flagged.
There are people out there who think that the side effects occur (even
in C90).

Sentence 1122: http://c0x.coding-guidelines.com/6.5.3.4.html
"If the type of the operand is a variable length array type, the operand 
is evaluated;"

But watch out for sentence 1584: 
http://c0x.coding-guidelines.com/6.7.5.2.html
"Where a size expression is part of the operand of a sizeof operator and
changing the value of the size expression would not affect the result of
the operator, it is unspecified whether or not the size expression is
evaluated."

> int n = 1;
> int f(void)
> {
> 	int (*p)[1 + (0 && n)];
> 	return sizeof(*(g(), p));
> }
> 
> _must_ call g() according to C99, while the same with
> enum {n = 1;} must not, even though n won't be even looked at in either
> case *and* any sane compiler will find return value of f() at compile
> time, turning it to

Any sane compiler that performs the analysis needed to deduce that
the expression inside the parenthesis always evaluated to zero
will turn it into....

> One more thing: use of sizeof(variably-modified type) may or may not
> evaluate size expressions in there if they do not affect the result.
> IOW, it's unspecified whether
> 	sizeof(int (*)[n++])
> increments n; different compilers are broken in different ways and it

This language feature came about because at least one vendor on the
WG14 committee had a compiler that optimized away subexpressions
within a sizeof that did not contribute to the result of the
evaluation.  My attempt to stop the behavior being unspecified
did not succeed :-(

-- 
Derek M. Jones                              tel: +44 (0) 1252 520 667
Knowledge Software Ltd                      mailto:derek@knosof.co.uk
Applications Standards Conformance Testing    http://www.knosof.co.uk

