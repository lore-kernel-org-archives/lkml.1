Return-Path: <linux-kernel-owner+w=401wt.eu-S933764AbXBZEaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbXBZEaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 23:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933766AbXBZEaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 23:30:52 -0500
Received: from smtp109.plus.mail.mud.yahoo.com ([68.142.206.242]:28329 "HELO
	smtp109.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933762AbXBZEav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 23:30:51 -0500
X-Greylist: delayed 697 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Feb 2007 23:30:51 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=BH3Dbk5GgJvUHioyaFEFP9LM3HGRnPjhrPbmgZFkS/JEYJLo7Eq2pVSi/4lyTqhIh5HGJEwsutytXoC/3/O5T3O/AS/MHts+swiGiA54SwCk8d0G9um+xpgDHmCsTwiU6PhvzvqoEuDAzgSCinfZ0FbnO0Rs93vb+ScWX6JzljM=  ;
X-YMail-OSG: Hj2LTH0VM1kSXLvLq9cLzLVgoxNjQk_OFgy_irB.VJl_u8NFWEKu4ra.txQ4_y8FiyTX5aCbeTqyL0kPGv3zmR2ATGBphemMxsdKGtW52uygPCPbc773Udsz4k5X4IMXZ3yEFsqnSbzkX3c-
Message-ID: <45E25FB7.9020306@yahoo.com.au>
Date: Mon, 26 Feb 2007 15:19:03 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: paulmck@linux.vnet.ibm.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: BUG in 2.6.20-rt8
References: <20070225062747.GA13432@elte.hu>	<20070224.223744.59470086.davem@davemloft.net>	<20070226015230.GN5049@linux.vnet.ibm.com> <20070225.180927.112620704.davem@davemloft.net>
In-Reply-To: <20070225.180927.112620704.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Sun, 25 Feb 2007 17:52:30 -0800
> 
> 
>>Why doesn't the traditional hash table of locks work here?  Use the
>>cache-line address as input to the hash function, take the corresponding
>>lock, do the compare-and-exchange by hand, and then release the lock.
>>What am I missing here?  Address aliasing do to memory being mapped into
>>multiple locations or something?  (In that case, use only the portion
>>of the address within the page, right?)
> 
> 
> It doesn't protect against pure stores.

Use atomic_cmpxchg (or atomic_long_cmpxchg). The atomic_t type ensures
that unprotected stores don't happen (unless you try to do something
stupid, but you can break all other atomic_ ops like that anyway).

> Even ignoring that you'll also need to disable interrupts, always,
> which therefore will always perform very poorly compared to an
> open-coded spinlock variant.

But on those architectures, the same argument could also be said about
a lot of atomic_ operations in the generic kernel code (ie. just use
spinlocks).

> There are zero gains to cmpxchg(), in my opinion, you dirty and
> grab exclusive access to a cacheline with cmpxchg() just the
> same as a spinlock, so the real cost is the same.
> 
> There is zero justification for using this primitive in generic
> code.

IMO it is useful for when you are memory constrained (and bit locks
are no good because they require an atomic unlock). For example we
could actually cut down on a reasonable number of atomic ops by adding
a spinlock to struct page. However I suspect this wouldn't go down too
well.

With that said, our use of atomic operations in the kernel is probably
not an optimal balance for SMP sparc32 and parisc (ie. those platforms
might be a little faster with more spinlocks and less atomics). Does
it really matter, though?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
