Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZKQSk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZKQSk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZKQSkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:40:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329AbZKQSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:40:55 -0500
Date: Tue, 17 Nov 2009 10:40:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Michael Buesch <mb@bu3sch.de>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
In-Reply-To: <200911171916.41727.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.01.0911171026010.9384@localhost.localdomain>
References: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain> <200911171916.41727.mb@bu3sch.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Nov 2009, Michael Buesch wrote:
> 
> Well, that doesn't actually return the difference at all. Is that allowed?

It's in fact the common implementation. Returning -1/0/1 is kind of 
polite, since it means that the sign now fits in a minimal type (ie you 
can save the end result in a "signed char" and it will _work_, even 
though it's not guaranteed by the standard.

Returning any negative or positive number is certainly _allowed_ by the 
standard, but I just checked, and glibc does the "polite" -1/0/1 thing. I 
suspect many other libraries do too, and it's not like it costs you 
anything more.

In fact, the written-out-with-unsigned-char-variables version is also 
likely to generate better code than the "clever" one that does just one 
subtract, because now the code can do all the comparisons in just 
'unsigned char' and never needs to sign-extend the result to 'int'.

Not that it likely matters.

I double-checked, and the code generated from my patch looks sane.

	strcmp:
	        pushq   %rbp    #
	        movq    %rsp, %rbp      #,
	.L52:
	        movb    (%rdi), %al     #* cs, c1
	        movb    (%rsi), %dl     #* ct, c2
	        incq    %rdi    # cs
	        incq    %rsi    # ct
	        cmpb    %dl, %al        # c2, c1
	        je      .L49    #,
	        sbbl    %eax, %eax      # D.13150
	        orl     $1, %eax        #, D.13150
	        jmp     .L51    #
	.L49:
	        testb   %al, %al        # c1   
	        jne     .L52    #,
	        xorl    %eax, %eax      # D.13150
	.L51:
	        leave
	        ret

which is not horrible (of course, depending on whether you expect to find 
differences early or late you might want to have make the "L49" case be 
the fallthrough etc).

[ Using sbb+or is a standard x86 trick to get -1/1. You'll also find 
  "sbb+and" to get 0/value, or "sbb+add" to get value/value+1 ]

		Linus
