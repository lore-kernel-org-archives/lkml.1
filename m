Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbXH1Bkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbXH1Bkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbXH1Bkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:40:33 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:35512 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752302AbXH1Bkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:40:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=uMHGn9FkT8V3LWYrMmld0Ypc7K8odYRBqyoBYbqmCVpeZso8z59ccRiC6PV7CtAGhFkmz8S/s2s0JBSBmorVp+jZeW3LMJluypcB5YIPeaGElya2kdW7Bx01KyPOq0ExfCVhmgLmRzyTeKEBSVvYVwb9aIDnHI48kv/KACA72Fo=  ;
X-YMail-OSG: hY7KqI4VM1lQ_4nvbawTOd.Fhs1hlon0NTrNe1hZDo7grOlGfHXf2MnNkTOPo7YyhCjAMChsDA--
Message-ID: <46D37D0A.905@yahoo.com.au>
Date: Tue, 28 Aug 2007 11:40:26 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, clameter@sgi.com,
       mingo@redhat.com
Subject: Re: [patch 01/28] Fall back on interrupt disable in cmpxchg8b on
 80386 and 80486
References: <20070827155234.062715780@polymtl.ca> <20070827155523.916345864@polymtl.ca>
In-Reply-To: <20070827155523.916345864@polymtl.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:

> Q:
> What's the reason to have cmpxchg64_local on 32 bit architectures?
> Without that need all this would just be a few simple defines.
> 
> A:
> cmpxchg64_local on 32 bits architectures takes unsigned long long
> parameters, but cmpxchg_local only takes longs. Since we have cmpxchg8b
> to execute a 8 byte cmpxchg atomically on pentium and +, it makes sense
> to provide a flavor of cmpxchg and cmpxchg_local using this instruction.
> 
> Also, for 32 bits architectures lacking the 64 bits atomic cmpxchg, it
> makes sense _not_ to define cmpxchg64 while cmpxchg could still be
> available.
> 
> Moreover, the fallback for cmpxchg8b on i386 for 386 and 486 is a
> different case than cmpxchg (which is only required for 386). Using
> different code makes this easier.
> 
> However, cmpxchg64_local will be emulated by disabling interrupts on all
> architectures where it is not supported atomically.
> 
> Therefore, we *could* turn cmpxchg64_local into a cmpxchg_local, but it
> would make the 386/486 fallbacks ugly, make its design different from
> cmpxchg/cmpxchg64 (which really depends on atomic operations and cannot
> be emulated) and require the __cmpxchg_local to be expressed as a macro
> rather than an inline function so the parameters would not be fixed to
> unsigned long long in every case.
> 
> So I think cmpxchg64_local makes sense there, but I am open to
> suggestions.

Every new thing like this (especially 64 bit operation on 32 bit
architectures) adds a tiny bit more burden for maintainers. Are
there any callers? If not, don't add it. It's simple to add if we
do get a good reason.

-- 
SUSE Labs, Novell Inc.
