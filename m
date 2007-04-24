Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbXDXCr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbXDXCr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXDXCr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:47:56 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:38140 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754562AbXDXCrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:47:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=5XXd8DUX7yXyGG2J2Hbiri/tRY8mXxMe2TaINzvGkxxtI2WMAO2EjV8x/eveuTgTn5pB7YWE/bDwBoArfNLDr9FsZuhVVHYX+hu5gKgZM3mynfnm7dDjUM43wfB+6YHy2J7AoeYSc7cHx+zSvX8YjaFhSHJrZDifRsOkr+iVWsI=  ;
X-YMail-OSG: FVtOEOEVM1l0sbHwrn39xYA9SaPK2Gy2y7jkXX28oPQphPw_2ZHNzxeO2pL7hV_ojGT6NDtnSg--
Message-ID: <462D6FD3.2090805@yahoo.com.au>
Date: Tue, 24 Apr 2007 12:47:47 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
CC: Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2> <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com> <6.0.0.20.2.20070423210926.045668d0@172.19.0.2> <Pine.LNX.4.64.0704231438280.3516@blonde.wat.veritas.com> <6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
In-Reply-To: <6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hisashi Hifumi wrote:
> 
> At 22:42 07/04/23, Hugh Dickins wrote:
>  >On Mon, 23 Apr 2007, Hisashi Hifumi wrote:
>  >> >No.  The PG_lru flag bit is just one bit amongst many others:
>  >> >what of concurrent operations changing other bits in that same
>  >> >unsigned long e.g. trying to lock the page by setting PG_locked?
>  >> >There are some places where such micro-optimizations can be made
>  >> >(typically while first allocating the page); but in general, no.
>  >>
>  >> In i386 and x86_64, btsl is used to change page flag. In this case, 
> if btsl
>  >> without lock prefix
>  >> set PG_locked and PG_lru flag concurrently, does only one operation
>  >> succeed ?
>  >
>  >That's right: on an SMP machine, without the lock prefix, the operation
>  >is no longer atomic: what's stored back may be missing the result of
>  >one or the other of the racing operations.
>  >
> 
> In the case that changing the same bit concurrently, lock prefix or other
> spinlock is needed. But, I think that concurrent bit operation on 
> different bits
> is just like OR operation , so lock prefix is not needed.
> 
> AMD instruction manual says about bts that ,
> 
> "Copies a bit, specified by bit index in a register or 8-bit immediate 
> value (second operand), from a bit
> string (first operand), also called the bit base, to the carry flag (CF) 
> of the rFLAGS register, and then
> sets the bit in the bit string to 1."
> 
> BTS instruction is read-modify-write instruction on bit unit. So 
> concurrent bit operation on different
> bits may be possible.


No matter what actual instruction is used, the SetPageLRU operation (ie.
without the double underscore prefix) must be atomic, and the __SetPageLRU
operation *can* be non-atomic if that would be faster.

As Hugh points out, we must have atomic ops here, so changing the generic
code to use the __ version is wrong. However if there is a faster way that
i386 can perform the atomic variant, then doing so will speed up the generic
code without breaking other architectures.

-- 
SUSE Labs, Novell Inc.
