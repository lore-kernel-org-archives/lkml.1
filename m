Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbXHONac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbXHONac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXHONaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:30:22 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:32876 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754499AbXHONaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:30:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=wAj3ah5xi+o6yehAQV1FaRpesJw7QLx13X6X3U3BwNJ+mdQHKhm+0RAakTnLVioD0ZUm9co/4GueRoQcf8MWIQAqRi3yLzDKiGNIwTp1FtH+fRlfkkippPz7kSjzqw+vjNTbYll4xhmGDTojJez3OdwpOTyf37LIoGpul5zWCLg=  ;
X-YMail-OSG: wjiJ_SsVM1lTXmm6_gGd.KkE0P9YR64tfsPU4qLgEsz1XK4XFI93hr9ccsAuwQyalIuJRlOVmFcdD.bArBrV51mSAwNjL9rV0Md3IuV0GDtEW05etec-
Message-ID: <46C2FFDD.5000600@yahoo.com.au>
Date: Wed, 15 Aug 2007 23:30:05 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Herbert Xu <herbert@gondor.apana.org.au>, csnook@redhat.com,
       dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
References: <20070811042943.GA13410@linux.vnet.ibm.com> <E1IKSHQ-0007hg-00@gondolin.me.apana.org.au> <20070813060302.GF13410@linux.vnet.ibm.com> <46C13EE1.1000707@yahoo.com.au> <20070814170128.GA8243@linux.vnet.ibm.com>
In-Reply-To: <20070814170128.GA8243@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Tue, Aug 14, 2007 at 03:34:25PM +1000, Nick Piggin wrote:

>>Maybe it is the safe way to go, but it does obscure cases where there
>>is a real need for barriers.
> 
> 
> I prefer burying barriers into other primitives.

When they should naturally be there, eg. locking or the RCU primitives,
I agree.

I don't like having them scattered in various "just in case" places,
because it makes both the users and the APIs hard to understand and
change.

Especially since several big architectures don't have volatile in their
atomic_get and _set, I think it would be a step backwards to add them in
as a "just in case" thin now (unless there is a better reason).


>>Many atomic operations are allowed to be reordered between CPUs, so
>>I don't have a good idea for the rationale to order them within the
>>CPU (also loads and stores to long and ptr types are not ordered like
>>this, although we do consider those to be atomic operations too).
>>
>>barrier() in a way is like enforcing sequential memory ordering
>>between process and interrupt context, wheras volatile is just
>>enforcing coherency of a single memory location (and as such is
>>cheaper).
> 
> 
> barrier() is useful, but it has the very painful side-effect of forcing
> the compiler to dump temporaries.  So we do need something that is
> not quite so global in effect.

Yep.


>>What do you think of this crazy idea?
>>
>>/* Enforce a compiler barrier for only operations to location X.
>> * Call multiple times to provide an ordering between multiple
>> * memory locations. Other memory operations can be assumed by
>> * the compiler to remain unchanged and may be reordered
>> */
>>#define order(x) asm volatile("" : "+m" (x))
> 
> 
> There was something very similar discussed earlier in this thread,
> with quite a bit of debate as to exactly what the "m" flag should
> look like.  I suggested something similar named ACCESS_ONCE in the
> context of RCU (http://lkml.org/lkml/2007/7/11/664):

Oh, I missed that earlier debate. Will go have a look.


> 	#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> 
> The nice thing about this is that it works for both loads and stores.
> Not clear that order() above does this -- I get compiler errors when
> I try something like "b = order(a)" or "order(a) = 1" using gcc 4.1.2.

As Arnd ponted out, order() is not supposed to be an lvalue, but a
statement like the rest of our memory ordering API.

As to your followup question of why to use it over ACCESS_ONCE. I
guess, aside from consistency with the rest of the barrier APIs, you
can use it in other primitives when you don't actually know what the
caller is going to do or if it even will make an access. You could
also use it between calls to _other_ primitives, etc... it just
seems more flexible to me, but I haven't actually used such a thing
in real code...

ACCESS_ONCE doesn't seem as descriptive. What it results in is the
memory location being loaded or stored (presumably once exactly),
but I think the more general underlying idea is a barrier point.

-- 
SUSE Labs, Novell Inc.
