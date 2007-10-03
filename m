Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbXJCPsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbXJCPsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXJCPsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:48:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbXJCPsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:48:07 -0400
Date: Wed, 3 Oct 2007 08:47:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux 2.6.23-rc9
 and a heads-up for the 2.6.24 series..)
In-Reply-To: <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710030835070.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <20071003084607.GC32218@elte.hu>
 <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Linus Torvalds wrote:
> 
>  - the bug happens on this:
> 
> 	char c = *p++;
> 
>  - which has been compiled into
> 
> 	8b 3a		mov    (%edx),%edi

Btw, this definitely doesn't happen for me, either on x86-64 or plain x86. 
The x86 thing I tested was Fedora 8 testing (ie not even some stable 
setup), so I wonder what experimental compiler you have.

Your compiler generates

	movl    -16(%ebp),%edx
	movl    (%edx),%edi		/* this is _totally_ bogus! */
	incl    %edx
	movl    %edx,-16(%ebp)
	movl    %edi,%ecx
	testb   %cl,%cl
	je      ...

while I get (gcc version 4.1.2 20070925 (Red Hat 4.1.2-28)):

        movl    -16(%ebp), %eax # p,
        movzbl  (%eax), %edi    #, c	/* not bogus! */
        movl    %edi, %edx      # c,
        testb   %dl, %dl        #
        je      .L64    #,
        incl    %eax    #
        movsbl  %dl,%ebx        #, D.12414
        movl    %eax, -16(%ebp) #, p

where the difference (apart from doing the increment differently and 
different register allocation) is that I have a "movzbl" (correct), while 
you have a "movl" (pure and utter crap).

I *suspect* that the compiler bug is along the lines of:
 (a) start off with movzbl
 (b) notice that the higher bits don't matter, because nobody subsequently 
     uses them
 (c) turn the thing into just a byte move. 
 (d) make the totally incorrect optimization of using a full 32-bit move 
     in order to avoid a partial register access stall

and the thing is, that final optimization can actually speed things up 
(although it can also slow things down for any access that crosses a cache 
sector boundary - 8/16 bytes), but it's seriously bogus, exactly because 
it can cause an invalid access to the three next bytes that may not even 
exist.

			Linus
