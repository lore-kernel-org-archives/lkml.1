Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXCUGve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXCUGve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932149AbXCUGve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:51:34 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:35558 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932162AbXCUGvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:51:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=PMniIiGgaVCR+CEdvOEP4uBPE7+JLr2YHvoatGzu1Yb0ISgsV2SXBGT2HZA7S2xngGY1AfMtpCLCs4KKXow0QJ8PYXgiBpyoNbbcu+ntvhKbUCSPu5J4WmbBFTM5sp/qKvrWd5+/I1Cv2oYpGPyuDxWqPO8Wt1zvaOH/mbPdoW0=  ;
X-YMail-OSG: xgOZRAoVM1mdIdAiONTp1htZF_o3F9NiwL6Ygzlv7UvN9k5XchHU55NyNqi_qF8QqyaDcy0N9L7rQfeWKejFvfZE39ONhg3HA4u08PdiqwKOxAo.7AbaLUFeDCpU5z6PEgVUJfNzJWajQSQ-
Message-ID: <4600D5EB.90507@yahoo.com.au>
Date: Wed, 21 Mar 2007 17:51:23 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated
 helper macros.
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <20070319200513.17168.52238.stgit@localhost.localdomain> <4600B216.3010505@yahoo.com.au> <20070321045214.GE2986@holomorphy.com> <4600BD9F.8030609@yahoo.com.au> <20070321054102.GF2986@holomorphy.com>
In-Reply-To: <20070321054102.GF2986@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
> 
>>>ISTR potential ppc64 users coming out of the woodwork for something I
>>>didn't recognize the name of, but I may be confusing that with your
>>>patch. I can implement additional users (and useful ones at that)
>>>needing this in particular if desired.
> 
> 
> On Wed, Mar 21, 2007 at 04:07:43PM +1100, Nick Piggin wrote:
> 
>>Yes I would be interested in seeing useful additional users of this
>>that cannot use our regular virtual memory, before making it a general
>>thing.
>>I just don't want to see proliferation of these things, if possible.
> 
> 
> I'm tied up elsewhere so I won't get to it in a timely fashion. Maybe
> in a few weeks I can start up on the first two of the bunch.

Care to give us a hint? :)


> William Lee Irwin III wrote:
> 
>>>Two fault handling methods callbacks raise an eyebrow over here at least.
>>>I was vaguely hoping for unification of the fault handling callbacks.
> 
> 
> On Wed, Mar 21, 2007 at 04:07:43PM +1100, Nick Piggin wrote:
> 
>>I don't know if it would be so clean to do that as they are at different 
>>levels.
>>Adam's fault is before the VM translation (and bypasses it), and mine is 
>>after.
> 
> 
> Not much of a VM translation; it's just a lookup through the software
> mocked-up structures on everything save i386, x86_64, and some m68k where
> they're the same thing only with hardware walkers (ISTR ia64's being
> firmware a la Alpha despite the "HPW" name, though I could be wrong)

Well the vma+pagetables *are* our VM translation data structure. It is
a good data structure. The Gelato/UNSW guys experimenting with changing
this have basically said they haven't yet got anything that beats it.

I would be opposed to anything that bypasses that unless a) it is not
applicable to the VM as a whole, and b) it is really worth it
(hugepages was a reasonable exception).


> reliant on them. The drivers/etc. could just as easily use helper
> functions to carry out the lookup, thereby accomplishing the
> unification. There's nothing particularly fundamental about a pte
> lookup.

Yeah you could, but it looks back to front to me.

The VM tells the filesystem that the machine took a fault at virtual
address X, then the filesystem asks the VM what pgoff that is, then
tells the VM to install the corresponding page to vaddr X.

With my ->fault, the VM asks the filesystem to give the page that
corresponds to vaddr X, then installs it into that vaddr.


> Normal arches that do software TLB refill could just as easily
> consult the radix trees dangled off struct address_space or any old
> data structure floating around the kernel with enough information to
> translate user virtual addresses to the physical addresses they need to
> fill the TLB with, and there are other kernels that literally do things
> like that.

Sure it *could* be done, but it may not be very nice, given Linux's
design. And you definitely need _something_ other than just the
pagecache radix-tree, because the VM needs to know who maps the page.

So if, for your backing store, you use a small hash table and evict old
entries like powerpc, you'll constantly be faulting in and out pages
from the VM's high level view of the address space. That isn't a really
cheap operation. It takes at least:

read_lock_irq(mapping->tree_lock);
radix_tree_lookup()
read_unlock_irq(mapping->tree_lock);
lock_page()
atomic_add(page->_count)
atomic_add(page->_mapcount)
unlock_page()

atomic_add_negative(page->_mapcount)
atomic_dec_and_test(page->_count)

Compared to our current page table walk which is just a single locked
op + barrier for the spinlock + radix tree walk.


If you had a very large hash table (ia64 long mode, maybe?), then you
may have slightly fewer high level faults, but range based operations
are going to take a whole lot of cache misses, aren't they? Especially
for small processes.

Not that I wouldn't be happy to be proven wrong, but I don't think it
should be something that sneaks in under these pagetable operations.
IMO.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
