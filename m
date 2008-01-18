Return-Path: <linux-kernel-owner+w=401wt.eu-S1765988AbYARTOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765988AbYARTOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765684AbYARTOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:14:37 -0500
Received: from mail.impinj.com ([206.169.229.170]:54334 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765133AbYARTOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:14:35 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Andy Lutomirski <luto@myrealbox.com>
Subject: Re: Why is the kfree() argument const?
Date: Fri, 18 Jan 2008 11:14:33 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>, clameter@sgi.com,
       penberg@cs.helsinki.fi
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com> <47906133.6010301@cateee.net> <4790AF84.2020000@myrealbox.com>
In-Reply-To: <4790AF84.2020000@myrealbox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181114.33513.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 18 Jan 2008 19:14:34.0743 (UTC) FILETIME=[5C736870:01C85A06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 05:54:12 am Andy Lutomirski wrote:
> It almost sounds like the compiler is free to change:
>
> void foo(const int *x);
> foo(x);
> printf("%d", x);
>
> to:
>
> void foo(const int *x);
> printf("%d", x);
> foo(x);
>
> especially if it can prove that the pointer to x doesn't otherwise
> escape or that foo doesn't call anything that could see the pointer (and
> given that gcc has special magical markings for malloc, one way this
> could be "proven" is to have x be some freshly malloced object.

That's absolutely not true.

Let's unravel the code, by fixing usage of 'x' (which seems to vary at will 
between value and pointer in the above example), and by replacing printf with 
another opaque function. Our decls:
	void foo(const int *ptr);
	void bar(int val);
You're saying that this:
	foo(&x);
	bar(x);
can be reordered into this:
	bar(x);
	foo(&x);

No way. First, the way that const is currently defined, the compiler cannot 
assume that the value of x did not change while foo was executing. So, it 
will not only be forced to leave the two functions in that order, it will 
even reload the value of x before passing it into bar. Go figure.

Second, even if const did have stronger semantics that forbade the value of x 
from being modified during execution of foo, the compiler still could not 
reorder the two function calls, before it cannot assume that the two 
functions (in their internal implementations) do not touch some other, 
unknown to this code, global variable.

-- Vadim Lobanov
