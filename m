Return-Path: <linux-kernel-owner+w=401wt.eu-S1767033AbXCJOG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767033AbXCJOG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 09:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767834AbXCJOG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 09:06:27 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:52561 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767033AbXCJOGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 09:06:25 -0500
Date: Sat, 10 Mar 2007 15:01:32 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Valdis.Kletnieks@vt.edu, Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
In-Reply-To: <1173503968.3104.65.camel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.61.0703101452240.8799@yvahk01.tjqt.qr>
References: <1173419792.32234.131.camel@localhost.localdomain> 
 <1173481052.32234.137.camel@localhost.localdomain> 
 <200703100403.l2A4355v008616@turing-police.cc.vt.edu>
 <1173503968.3104.65.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10 2007 16:19, Nigel Cunningham wrote:
>On Fri, 2007-03-09 at 23:03 -0500, Valdis.Kletnieks@vt.edu wrote:
>> On Sat, 10 Mar 2007 09:57:32 +1100, Rusty Russell said:
>> 
>> > +/* GCC is awesome. */
>> >  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
>> >  	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
>> >  		 typeof(&arr[0]))]))*0)
>> 
>> -/* GCC is awesome. */
>> +/* GCC leaves me speechless. */
>
>A speechless Rusty would be horrible. That said, it would be nice if the
>comment was something more like the normal Rusty pearl of wisdom. I
>understand the first part, but have no idea was + sizeof(typeof(int[....
>does...

IOCCC entry candidate.

Simple. !!__builtin_types_compatible_p, as it sounds, will return 1 if
both types are compatible. If they are, then '1-2*!!_builtin..' will
produce -1, then - surprisingly - sizeof(typeof(int[-1])) seems strange to
me and should throw the error.

If the types are not compatible, compat_p returns 0. !! will turn it into
0. 2* will turn it into 0. 1-0 is 1. sizeof(typeof(int[1])) is valid, and
*0 will compile it away.

So in case they _ARE_ compatible, we get the compile error, as far as I
can see it. There's a ! too much in the !!_builtin line. Now we know why
such patches are dangerous.

What's more, a test program does not even fail when the types are
incompatible. (Or it's also wrong):

#include <stdio.h>
struct foo {
        int x, y, z;
};
struct bar {
        const char *fol;
};
#define c(x, y)  \
        sizeof(typeof(int[1 - \
         2*!!__builtin_types_compatible_p(typeof(x), typeof(y))]))
int main(void)
{
        printf("%d\n", c(struct foo *, struct bar *));
	printf("%d\n", c(int*, int*));
}

Both printf()s throw a compile time error.


Jan
-- 
