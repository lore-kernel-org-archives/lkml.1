Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZKQTNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZKQTNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZKQTNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:13:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbZKQTNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:13:10 -0500
Date: Tue, 17 Nov 2009 11:12:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
In-Reply-To: <alpine.LFD.2.01.0911171102210.9384@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911171105350.9384@localhost.localdomain>
References: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain> <20091117185539.GA23385@pengutronix.de> <alpine.LFD.2.01.0911171102210.9384@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Nov 2009, Linus Torvalds wrote:
> 
> Yeah, I looked at the history too. It's so old that it might well be me.

In fact, it goes back to at least 1.2.13.

And the copyright dates do imply that they could go back way further. 

At least the comment says it all:

	"These are buggy as well.."

so I can at least claim that back in the _original_ 0.01 release, it was 
correct:

	extern inline int strcmp(const char * cs,const char * ct)
	{
	register int __res __asm__("ax");
	__asm__("cld\n"
	        "1:\tlodsb\n\t"
	        "scasb\n\t"
	        "jne 2f\n\t"
	        "testb %%al,%%al\n\t"
	        "jne 1b\n\t"
	        "xorl %%eax,%%eax\n\t"
	        "jmp 3f\n"
	        "2:\tmovl $1,%%eax\n\t"
	        "jl 3f\n\t"
	        "negl %%eax\n"
	        "3:"
	        :"=a" (__res):"D" (cs),"S" (ct):"si","di");
	return __res;
	}

and as far as I can tell, the above is actually correct, even if you have 
to be a bit crazy to write 'strcmp' as gcc inline asm (hey, I wrote _all_ 
the string routines that way, and I made gcc do some of them built-in. 
Because I was a MAN, dammit!).

So the bug was apparently introduced when we went portable.

			Linus
