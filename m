Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZCIQVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZCIQVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZCIQUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:20:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62160 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZCIQUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:20:52 -0400
Date: Mon, 9 Mar 2009 12:20:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roel Kluin <roel.kluin@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Observe wrapping variables in while loops
In-Reply-To: <49B3481E.5080108@gmail.com>
Message-ID: <alpine.DEB.2.00.0903091119090.2203@gandalf.stny.rr.com>
References: <49B3481E.5080108@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Sun, 8 Mar 2009, Roel Kluin wrote:

> Inspired by your definition of 'if', I came up with something to test variable
> wrapping in while loops, and was wondering if this was useful for the linux
> kernel:
> 
> The source below is adapted to illustrate how it works. If you run it, this
> will print:
> 
>  8 6 4 2 0 variable wraps at ../test.c:88:main(): -1!
> ...-2
>  9 7 5 3 1 variable wraps at ../test.c:94:main(): -1!
> ...-1
>  8 7 6 5 4 3 2 1 0 ...-1
>  8 7 6 5 4 3 2 1 ...0
>  21 22 23 24 25 26 27 28 29 30 ...31
>  19 18 17 16 15 14 13 12 11 10 ...9
>  4 3 2 1 0 -1 -2 -3 -4 -5 ...-6
>  -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 ...11
>  4 2 0 variable wraps at ../test.c:129:main(): -1!
> ...-2
> 
> In the first two loops and the last, a wrap occurs due to the double decrement.
> Tests like 'while(i++ < 30)' and 'while(j-- > -5)' are boolean.
> 
> However, this may not work for a construction like this:

Interesting variation. Now the question is, how many bugs are we aware of 
that were caused by wraps? If there are a few, then I would say this is 
definitely something to look at. Otherwise, it may not be worth putting 
this in mainline.

-- Steve



> 
> while ((ret = foo())) {
> 	do_stuff();
> }
> ------------------------------>8-------------8<---------------------------------
> #include <stdio.h>
> 
> struct while_data {
>         const char *func;
>         const char *file;
>         unsigned line;
>         unsigned long last;
> };
> 
> int is_while_wrap(struct while_data *w, unsigned long val)
> {
> 	if (w->last < val) {
> 		printf("variable wraps at %s:%u:%s(): %d!\n", w->file, w->line, w->func, val);
> 		return 0;
> 	}
> 	w->last = val;
> 	return val;
> }
> 
> #define __while_check__(x) ({                             \
> 			static struct while_data			\
>                                 ______w = {                             \
>                                 .func = __func__,                       \
>                                 .file = __FILE__,                       \
>                                 .line = __LINE__,                       \
> 				.last = ULONG_MAX,			\
>                         };                                              \
> 			printf(" ");					\
>                         is_while_wrap(&______w, (x)); 	\
>                 })
> 
> #define while(x) 	while(__while_check__(x))
> 
> 
> int main(int argc, char* argv[])
> {
> 	unsigned int i=9;
> 	while(i--) {
> 		printf("%d", i);
> 		--i;
> 	}
> 	printf("...%d\n", i);
> 	i=10;
> 	while(--i) {
> 		printf("%d", i);
> 		--i;
> 	}
> 	printf("...%d\n", i);
> 
> 	i=9;
> 	while(i--)
> 		printf("%d", i);
> 	printf("...%d\n", i);
> 
> 	i=9;
> 	while(--i)
> 		printf("%d", i);
> 	printf("...%d\n", i);
> 
> 	i=20;
> 	while(i++ < 30)
> 		printf("%d", i);
> 	printf("...%d\n", i);
> 
> 	i=20;
> 	while(i-- > 10)
> 		printf("%d", i);
> 	printf("...%d\n", i);
> 
> 	int j=5;
> 	while(j-- > -5)
> 		printf("%d", j);
> 	printf("...%d\n", j);
> 	while(j++ < 10)
> 		printf("%d", j);
> 	printf("...%d\n", j);
> 
> 	j=5;
> 	while(j--) {
> 		printf("%d", j);
> 		j--;
> 	}
> 	printf("...%d\n", j);
> }
> 
