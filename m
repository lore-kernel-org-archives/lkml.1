Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXH1Xvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXH1Xvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbXH1Xvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:51:31 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:46591 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756084AbXH1Xva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:51:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=5lTSMWCnxBaq0/35lFE1g78GLNTkbpnm59TPO/IlcURqB8bhEIYNnwUFfEUyvaQKbe2h5nF90UqcxXLzMj/rYMz49WqdDU2qh6MZ8+2mqTP6Rz9n4P9CeNhlxEilb0FlrCgbC21Yk8G3AV9sIOxH/JFjgPgtzL7DgJ0jwXMt6pI=  ;
X-YMail-OSG: ebsIMdkVM1lAycPeomjfdxfi_hox0CABRVNE_fKG0osBaMaj7MGqcY3KjcCGRwwQVRu4FZ5aww--
Message-ID: <46D4B4FB.8000001@yahoo.com.au>
Date: Wed, 29 Aug 2007 09:51:23 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, clameter@sgi.com,
       mingo@redhat.com
Subject: Re: [patch 01/28] Fall back on interrupt disable in cmpxchg8b on
 80386 and 80486
References: <20070827155234.062715780@polymtl.ca> <20070827155523.916345864@polymtl.ca> <46D37D0A.905@yahoo.com.au> <20070828113122.GA12241@Krystal>
In-Reply-To: <20070828113122.GA12241@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Nick Piggin (nickpiggin@yahoo.com.au) wrote:
> 
>>Mathieu Desnoyers wrote:
>>
>>
>>>Q:
>>>What's the reason to have cmpxchg64_local on 32 bit architectures?
>>>Without that need all this would just be a few simple defines.
>>>
>>>A:
>>>cmpxchg64_local on 32 bits architectures takes unsigned long long
>>>parameters, but cmpxchg_local only takes longs. Since we have cmpxchg8b
>>>to execute a 8 byte cmpxchg atomically on pentium and +, it makes sense
>>>to provide a flavor of cmpxchg and cmpxchg_local using this instruction.
>>>
>>>Also, for 32 bits architectures lacking the 64 bits atomic cmpxchg, it
>>>makes sense _not_ to define cmpxchg64 while cmpxchg could still be
>>>available.
>>>
>>>Moreover, the fallback for cmpxchg8b on i386 for 386 and 486 is a
>>>different case than cmpxchg (which is only required for 386). Using
>>>different code makes this easier.
>>>
>>>However, cmpxchg64_local will be emulated by disabling interrupts on all
>>>architectures where it is not supported atomically.
>>>
>>>Therefore, we *could* turn cmpxchg64_local into a cmpxchg_local, but it
>>>would make the 386/486 fallbacks ugly, make its design different from
>>>cmpxchg/cmpxchg64 (which really depends on atomic operations and cannot
>>>be emulated) and require the __cmpxchg_local to be expressed as a macro
>>>rather than an inline function so the parameters would not be fixed to
>>>unsigned long long in every case.
>>>
>>>So I think cmpxchg64_local makes sense there, but I am open to
>>>suggestions.
>>
>>Every new thing like this (especially 64 bit operation on 32 bit
>>architectures) adds a tiny bit more burden for maintainers. Are
>>there any callers? If not, don't add it. It's simple to add if we
>>do get a good reason.
>>
> 
> 
> I am actually using it in LTTng in my timestamping code. I use it to
> work around CPUs with asynchronous TSCs. I need to update 64 bits
> values atomically on this 32 bits architecture.
> 
> I plan to submit this timestamping code soon.

OK fair enough. So long as there is a user (and you are sure said
user is going to get upstream -- sometimes it is easier to put
this patchset in with the one that is going to call it, but OTOH
that can turn people off reviewing).

-- 
SUSE Labs, Novell Inc.
