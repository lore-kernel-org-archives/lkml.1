Return-Path: <linux-kernel-owner+w=401wt.eu-S934420AbXGXIbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbXGXIbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764492AbXGXIbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:31:40 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:46151 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761058AbXGXIbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:31:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=sX0nRVMokb2PYJSS44H+uh3jWo5LKeoPYpb3v+LP6Pl6i1FKPTbnvMD0SWrAS8kTpJtV7sLKaQ6E2nCzBVI/FzJR8DIQqS0TVyY2ButrNiQguGj5UZnPiRmZGgct9VYziYf9vyqqg9sWkbQMUwf9dpsAHx6DPx7GvVs68lz6KiY=  ;
X-YMail-OSG: EtmMsoYVM1n7kuOMQAYr.O42PMvU_8plkRfPrGPKBtxsYLADrzgpONrorb1mKQ2fmCgP6B50hQ--
Message-ID: <46A5B8E4.1050503@yahoo.com.au>
Date: Tue, 24 Jul 2007 18:31:32 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160608.22137.14790.sendpatchset@cselinux1.cse.iitk.ac.in> <46A577AA.4020804@yahoo.com.au> <Pine.LNX.4.64.0707241208440.1433@cselinux1.cse.iitk.ac.in> <46A5AECB.3060208@goop.org>
In-Reply-To: <46A5AECB.3060208@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Satyam Sharma wrote:
> 
>>Consider this (the above two functions exist only for clear_bit(),
>>the atomic variant, as you already know), the _only_ memory reference
>>we care about is that of the address of the passed bit-string:
>>
>>(1) The compiler must not optimize / elid it (i.e. we need to disallow
>>    compiler optimization for that reference) -- but we've already taken
>>    care of that with the __asm__ __volatile__ and the constraints on
>>    the memory "addr" operand there, and,
>>(2) For the i386, it also includes an implicit memory (CPU) barrier
>>    already.
>>
>>So I /think/ it makes sense to let the compiler optimize _other_ memory
>>references across the call to clear_bit(). There's a difference. I think
>>we'd be safe even if we do this, because the synchronization in callers
>>must be based upon the _passed bit-string_, otherwise _they_ are the
>>ones who're buggy.
>>
>>[ However, elsewhere Jeremy Fitzhardinge mentioned the case of
>>  some callers, for instance, doing a memset() on an alias of
>>  the same bit-string. But again, I think that is dodgy/buggy/
>>  extremely border-line usage on the caller's side itself ...
>>  *unless* the caller is doing that inside a higher-level lock
>>  anyway, in which case he wouldn't be needing to use the
>>  locked variants either ... ]
>>  
> 
> 
> You miss my point.  If you have:
> 
> 	memset(&my_bitmask, 0, sizeof(my_bitmask));
> 	set_bit(my_bitmask, 44);
> 
> Then unless the set_bit has a constraint argument which covers the whole
> of the (multiword) bitmask, the compiler may see fit to interleave the
> memset writes with the set_bit in bad ways.  In other words, plain "+m"
> (*(long *)ptr) won't cut it.  You'd need "+m" (my_bitmask), I think.

That's a valid point, and looks like it is a bug in the existing i386
macros, doesn't it? We should be clobbering addr + BITOP_WORD(nr).

-- 
SUSE Labs, Novell Inc.
