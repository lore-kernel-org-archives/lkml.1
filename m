Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbYFREEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbYFREEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 00:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYFREEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 00:04:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769AbYFREET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 00:04:19 -0400
Date: Tue, 17 Jun 2008 21:03:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <20080618031406.GA4326@brong.net>
Message-ID: <alpine.LFD.1.10.0806172057450.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
 <20080618031406.GA4326@brong.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jun 2008, Bron Gondwana wrote:
> 
> For my sins, I appear to be becoming the world expert on 
> that particular file.

Heh. Congrats ;)

> I've debugged skiplist bugs many times over, and completely rewritten 
> the locking code.  It really does some pretty evil things - the memory 
> accesses look something like this:
> 
> [file...................]
> [mmap^....^.^........^^..................................]
> [file...................++++++++++++]
> [mmap^....^.^........^^.^^ ^      ^^.....................]
> 
> Where (^) is the bits that get accessed.  All reads are via
> the mmap, all writes are done with retry_write or 
> retry_writev (Cyrus library functions that keep hammering
> until all the bytes are written)

Is there any reason it doesn't use mmap(MAP_SHARED) and make the 
modifications that way too?

Because quite frankly, the mixture of doing mmap() and write() system 
calls is quite fragile - and I'm not saying that just because of this 
particular bug, but because there are all kinds of nasty cache aliasing 
issues with virtually indexed caches etc that just fundamentally mean that 
it's often a mistake to mix mmap with read/write at the same time.

(For the same reason it's not a good idea to mix writing through an mmap() 
and then using read() to read it - again, you can have some nasty aliasing 
going on there).

So this particular issue was definitely a kernel bug (and big thanks for 
making such a good test-case), but in general, it does sound like Cyrus is 
actively trying to dig itself into a nasty hole there.

			Linus
