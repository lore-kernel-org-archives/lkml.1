Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab0BDP3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:29:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932221Ab0BDP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:29:29 -0500
Date: Thu, 4 Feb 2010 07:29:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
In-Reply-To: <20100203024931.GA6307@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1002040715570.3707@localhost.localdomain>
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202065341.GF6292@linux.vnet.ibm.com> <20100203024931.GA6307@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Feb 2010, Paul E. McKenney wrote:
> 
> One stupid question: why are the hash and length ints rather than shorts?
> Doesn't the maximum filename length fit into a 16-bit short?  In fact,
> doesn't the maximum length of a full pathname fit into a 16-bit short?

Yes, the name length could easily be just 16 bits. 

The hash, though, is a different matter. We actually want lots of bits to 
spread out the dentries and 16 bits for hashing would be too small (on my 
machine, the dentry cache hash table has half a million entries and takes 
4MB of space - space I'll happily give it to keep the hash chains short).

So we need at least 20 bits (and probably more on big machines).

Now, we could decide that having just 16 bits for the name hash is enough, 
because we do mix in the address of the 'parent' dentry, and we might 
decide that that is worth a few bits (taking the number of total bits up 
to enough to look up half a million entries)

We could also use bitfields, and give the name length say 10 bits, and 22 
bits to the hash, which togethr with the extra bits from the parent 
pointer might well work out fine.

It might be worth trying. But is playing that kind of game worth four 
extra characters in the inline name? If it were to make the difference 
between "core dentry fields fit in a cacheline" vs "needs two cachelines", 
then maybe it would be worth it. But I don't think that's the case.

		Linus
