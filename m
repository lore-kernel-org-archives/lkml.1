Return-Path: <linux-kernel-owner+w=401wt.eu-S1763688AbYARUXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763688AbYARUXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbYARUXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:23:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759565AbYARUXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:23:40 -0500
Date: Fri, 18 Jan 2008 12:22:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Salikhmetov <salikhmetov@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, peterz@infradead.org,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
In-Reply-To: <4df4ef0c0801181158s3f783beaqead3d7049d4d3fa7@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0801181214440.2957@woody.linux-foundation.org>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>  <1200651337.5920.9.camel@twins> <1200651958.5920.12.camel@twins>  <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org>  <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu> 
 <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org>  <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu>  <alpine.LFD.1.00.0801181106340.2957@woody.linux-foundation.org>  <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>  <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
 <4df4ef0c0801181158s3f783beaqead3d7049d4d3fa7@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jan 2008, Anton Salikhmetov wrote:
> 
> The current solution doesn't hit the performance at all when compared to
> the competitor POSIX-compliant systems. It is faster and does even more
> than the POSIX standard requires.

Your current patches have two problems:
 - they are simply unnecessarily invasive for a relatively simple issue
 - all versions I've looked at closer are buggy too

Example:

	+               if (pte_dirty(*pte) && pte_write(*pte))
	+                       *pte = pte_wrprotect(*pte);

Uhhuh. Looks simple enough. Except it does a non-atomic pte access while 
other CPU's may be accessing it and updating it from their hw page table 
walkers. What will happen? Who knows? I can see lost access bits at a 
minimum.

IOW, this isn't simple code. It's code that it is simple to screw up. In 
this case, you really need to use ptep_set_wrprotect(), for example.

So why not do it in many fewer lines with that simpler vma->dirty flag?

		Linus
