Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbXLWVQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbXLWVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 16:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXLWVQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 16:16:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbXLWVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 16:16:19 -0500
Date: Sun, 23 Dec 2007 13:15:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: tlb_finish_mmu() bogisity
In-Reply-To: <20071223093241.GR8181@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.9999.0712231311530.21557@woody.linux-foundation.org>
References: <20071223093241.GR8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Dec 2007, Al Viro wrote:
>
>         tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
> makes no sense whatsoever.  How the hell can you ever get the address of
> __get_cpu_var(quicklist)[0].nr_pages to be NULL?  Postfix operators have
> higher precedence than prefix ones, so that's
> 	&(((__get_cpu_var(quicklist))[0]).nr_pages)
> 
> What did you intend here?  s/&//, perhaps?

I think that thing is bogus in other ways. It plays games with 
"needs_flush", just because it seems to want the generic code to then call 
"check_pgt_cache()", not because it actually wants any flushing to take 
place.

But we already call "check_pgt_cache()" there in tlb_finish_mmu() 
unconditionally, so I think the whole patch was utter crap.

Or is there any other reason going on here? That quicklist stuff has been 
totally broken, it's done too many totally invalid things to really be 
worth even keeping. We should get rid of that unmaintainable hack, and if 
it has a real performance upside, we should make it part of the *native* 
mmu-gather infrastructure, instead of maintaining it as some separate and 
buggy/unmaintainable piece-of-sh*t code.

		Linus
