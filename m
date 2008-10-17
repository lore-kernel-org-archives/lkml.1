Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYJQWsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYJQWsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYJQWrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:47:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:33479 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYJQWrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OAyRN6RlMMvgxrahmCT64wNch9lLCW2pzAIZxPhLDiY2qKJpdsf1TSsYSyx/w08xab
         2yR4UXGw/nZ134NlfLaEKpZ9MhegC/aSvdUtPEzS6MI52ElHEU2GToygtlnRnwnWDxEs
         NM8FUozrdHTQqI/Dn1Yd4VtVnGB6utaYiVqyE=
Message-ID: <48F91612.5020901@gmail.com>
Date: Sat, 18 Oct 2008 00:47:46 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Slightly off topic] A question about R/B trees.
References: <48F904FA.6090102@gmail.com> <48F90E96.3060800@redhat.com>
In-Reply-To: <48F90E96.3060800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Maxim Levitsky wrote:
>> I am working on my small project, and I need a fast container to hold 
>> a large sparse array.
>> Balanced trees seem to fit perfectly.
> 
> Balanced trees take O(log n) to perform a great many operations, and 
> traversing a binary tree is a particularly bad case for branch 
> prediction.  Hash tables will perform much better, unless you get them 
> horribly wrong.
Let me explain.

I am writing a userspace packet writing application.

One of things I need is to have a cache of the disk.

I need an 'array' that will hold cache of written blocks in ascending order,
I need to be able to insert a block anywhere in the array, and be able to read it
from lowest block to highest.

Hash tables can't be read this way, right?

I could use a linked list, but insertion will be slower.


> 
>> I decided to implement a red/black tree, and took a look at kernel rb 
>> tree for reference,
>> and I noticed that tree item has no parent pointer, while it seems 
>> that it should have it.
>>
>> I know now that it has parent pointer, but it is mixed with current 
>> and parent node colour.
>> Thus it is assumed that last two bits of this pointer are zero.
> 
> Not quite.  Read this:
> 
> http://lwn.net/Articles/184495/

What do you mean?

I have read this article, I haven't yet spotted anything suspicious about parent pointer there yet.
> 
>> I can see anywhere that this restriction is applied.
>> I see that structure is "aligned" but that I think only ensures that 
>> compiler places it
>> aligned in static data, does the alignment ensures that it will always 
>> place it on aligned address in a structure?
>> But then, the whole container structure can be misaligned, can't it?
> 
> GCC will only misalign the contents of a struct if you explicitly tell 
> it to pack the struct.  That's one of those things you only do if you're 
> 100% certain it's the right thing, and you're prepared to accept the 
> consequences if you screw it up.

Why gcc?

Say you allocate a piece of memory using kmalloc, and write there, a structure that contains a r/b tree item.
I agree that gcc will ensure that offset from start of that structure to first byte of the tree item will be aligned.

But what if malloc returned a misaligned pointer?
This will ensure that virtual address of the tree item won't be aligned.
(I know it doesn't, but this isn't a assumption about gcc anymore)



> 
>> Besides a comment there states that alignment is only for CRIS
> 
> I'm not sure this check is still necessary, but CRIS is a rather niche 
> architecture.  On most architectures, word-aligning structures boosts 
> performance at negligible memory cost, so compilers do it automatically.
> 
>> How about a check for misalignment?
> 
> The kernel is written in a dialect of C that makes several assumptions 
> about the compiler, among them that the compiler won't screw this up 
> unless you tell it to.  Any compiler that has alignment problems with 
> the rbtree code is going to have similar problems in lots of other 
> places too.  We don't support those compilers.
> 

Best regards,
	Maxim Levitsky
