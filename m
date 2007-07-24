Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbXGXHYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbXGXHYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXGXHYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:24:32 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:36904 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751435AbXGXHYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:24:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Ime5NW7paZ8k09G6WBiEUzuB2Iych86QHHe4EyMpkalXf4Vk5JcnhQnRbyP5tLP8k59owgmzP1ln0MOd/KkqNFsWQQNVUq/Oc5pSraIum5lpJhaJswWDQsfTstOSJKzddG32/XgDSdJOQGLrdSZZhBEvY6vdONlX3rl9NRHbAMc=  ;
X-YMail-OSG: Kljt.q0VM1kypoQ3IcVX8zmjUvcx2X7jF1_ALmQCjOf23DlqBMs1.5p1BMfiv83hk3pyHyT.ZQ--
Message-ID: <46A5A929.4020706@yahoo.com.au>
Date: Tue, 24 Jul 2007 17:24:25 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in> <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On Tue, 24 Jul 2007, Nick Piggin wrote:
> 
> 
>>Satyam Sharma wrote:
>>
>>>From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
>>>
>>>[6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
>>>
>>>The goal is to let gcc generate good, beautiful, optimized code.
>>>
>>>But test_and_set_bit, test_and_clear_bit, __test_and_change_bit,
>>>and test_and_change_bit unnecessarily mark all of memory as clobbered,
>>>thereby preventing gcc from doing perfectly valid optimizations.
>>>
>>>The case of __test_and_change_bit() is particularly surprising, given
>>>that it's a variant where we don't make any guarantees at all.
>>
>>__test_and_change_bit is one that you could remove the memory clobber
>>from.
> 
> 
> Yes, for the atomic versions we don't care if we're asking gcc to
> generate trashy code (even though I'd have wanted to only disallow
> problematic optimizations -- ones involving the passed bit-string
> address -- there, and allow other memory references to be optimized
> as and how the compiler feels like it) because the atomic variants
> are slow anyway and we probably want to be extra-safe there.
> 
> But for the non-atomic variants, it does make sense to remove the
> memory clobber (and the unneeded __asm__ __volatile__ that another
> patch did -- for the non-atomic variants, again).

No. It has nothing to do with atomicity and all to do with ordering.
For example test_bit, clear_bit, set_bit, etc are all atomic but none
place any restrictions on ordering.

__test_and_change_bit has no restriction on ordering, so as long as
the correct operands are clobbered, a "memory" clobber to enforce a
compiler barrier is not needed.


> OTOH, as per Linus' review it seems we can drop the "memory" clobber
> and specify the output operand for the extended asm as "+m". But I
> must admit I didn't quite understand that at all.

Yes, but that is for cases where "memory" is being used to say that
some otherwise unspecified memory is actually being changed, rather
than to provide a compiler barrier as is the case for test_and_set_bit
and co.


> [ I should probably start reading gcc sources, the docs are said to
>   be insufficient/out-of-date, as per the reviews of the patches. ]

You should read Documentation/atomic_ops.txt and memory-barriers.txt,
which are quite useful and should be uptodate.

-- 
SUSE Labs, Novell Inc.
