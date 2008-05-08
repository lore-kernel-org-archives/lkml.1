Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbYEHXOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbYEHXOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYEHXOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:14:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbYEHXOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:14:44 -0400
Date: Thu, 8 May 2008 16:14:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7
 40% regression with 2.6.26-rc1)
In-Reply-To: <alpine.LFD.1.10.0805081604010.2940@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805081610350.2940@woody.linux-foundation.org>
References: <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu>
 <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org> <20080508201956.GA2547@elte.hu> <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
 <20080508214557.GA13311@elte.hu> <alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org> <alpine.LFD.1.10.0805081604010.2940@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Linus Torvalds wrote:
> 
> Btw, sparse will complain about those, because the source code *looks* 
> really cheap.

Sometimes you can fix it.

For example, this change:

	-       if (pte_present(*pte) && page_to_pfn(page) == pte_pfn(*pte)) {
	+       if (pte_present(*pte) && page == pfn_to_page(pte_pfn(*pte))) {

can simplify things: instead of moving from a 'struct page' to a pfn, it 
moves from a pfn to a 'struct page', and that is generally cheaper 
(multiply rather than divide by size of struct page). It's not always the 
same thing to do, but I think in this case we can. For me, the code 
generation changes:

	-       movabsq $7905747460161236407, %rdx      #, tmp111
	-       movabsq $32985348833280, %rax   #, tmp107
	-       leaq    (%r12,%rax), %rax       #, tmp106
	-       sarq    $3, %rax        #, tmp106
	-       imulq   %rdx, %rax      # tmp111, tmp106
	-       movabsq $70368744177663, %rdx   #, tmp113
	-       andq    %rdx, %rcx      # tmp113, pte$pte
	-       shrq    $12, %rcx       #, pte$pte
	-       cmpq    %rcx, %rax      # pte$pte, tmp106
	+       movabsq $70368744177663, %rax   #, tmp107
	+       andq    %rax, %rdx      # tmp107, pte$pte
	+       shrq    $12, %rdx       #, pte$pte
	+       imulq   $56, %rdx, %rax #, pte$pte, tmp109
	+       movabsq $-32985348833280, %rdx  #, tmp111
	+       addq    %rdx, %rax      # tmp111, tmp110
	+       cmpq    %rax, %r13      # tmp110, page

which isn't a *huge* deal, but it certainly looks better. One less big 
constant, and one less shift.

It's not going to make a huge difference, though. That function is just 
called too much, and it would still be entirely data-dependent all the way 
through.

			Linus
