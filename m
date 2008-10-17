Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYJQWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYJQWP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYJQWPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:15:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYJQWPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:15:15 -0400
Message-ID: <48F90E96.3060800@redhat.com>
Date: Fri, 17 Oct 2008 18:15:50 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Slightly off topic] A question about R/B trees.
References: <48F904FA.6090102@gmail.com>
In-Reply-To: <48F904FA.6090102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> I am working on my small project, and I need a fast container to hold a 
> large sparse array.
> Balanced trees seem to fit perfectly.

Balanced trees take O(log n) to perform a great many operations, and traversing 
a binary tree is a particularly bad case for branch prediction.  Hash tables 
will perform much better, unless you get them horribly wrong.

> I decided to implement a red/black tree, and took a look at kernel rb 
> tree for reference,
> and I noticed that tree item has no parent pointer, while it seems that 
> it should have it.
> 
> I know now that it has parent pointer, but it is mixed with current and 
> parent node colour.
> Thus it is assumed that last two bits of this pointer are zero.

Not quite.  Read this:

http://lwn.net/Articles/184495/

> I can see anywhere that this restriction is applied.
> I see that structure is "aligned" but that I think only ensures that 
> compiler places it
> aligned in static data, does the alignment ensures that it will always 
> place it on aligned address in a structure?
> But then, the whole container structure can be misaligned, can't it?

GCC will only misalign the contents of a struct if you explicitly tell it to 
pack the struct.  That's one of those things you only do if you're 100% certain 
it's the right thing, and you're prepared to accept the consequences if you 
screw it up.

> Besides a comment there states that alignment is only for CRIS

I'm not sure this check is still necessary, but CRIS is a rather niche 
architecture.  On most architectures, word-aligning structures boosts 
performance at negligible memory cost, so compilers do it automatically.

> How about a check for misalignment?

The kernel is written in a dialect of C that makes several assumptions about the 
compiler, among them that the compiler won't screw this up unless you tell it 
to.  Any compiler that has alignment problems with the rbtree code is going to 
have similar problems in lots of other places too.  We don't support those 
compilers.

-- Chris
