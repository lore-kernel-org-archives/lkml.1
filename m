Return-Path: <linux-kernel-owner+w=401wt.eu-S933945AbYEHXIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbYEHXIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762570AbYEHXHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:07:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760746AbYEHXHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:07:53 -0400
Date: Thu, 8 May 2008 16:07:14 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805081604010.2940@woody.linux-foundation.org>
References: <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu>
 <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org> <20080508201956.GA2547@elte.hu> <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
 <20080508214557.GA13311@elte.hu> <alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Linus Torvalds wrote:
> 
> Some of it is that "page_to_pfn(page)", which involves a nasty division 
> (divide by sizeof(struct page)). It gets turned into that shift and 
> multiply, but it's still quite expensive with big constants etc.

Btw, sparse will complain about those, because the source code *looks* 
really cheap.

The normal "page_to_pfn()" looks trivial:

	((unsigned long)((page) - mem_map) + ARCH_PFN_OFFSET)

which looks like a trivial subtraction and addition of a constant, but the 
subtraction is on C pointers, and basically turns into

	((unsigned long)page - (unsigned long)mem_map) / sizeof(struct page)

and because "struct page" is not some nice power-of-two in size, that 
division is rather nasty even though it's a constant size.

		Linus
