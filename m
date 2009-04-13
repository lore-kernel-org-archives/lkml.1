Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZDMVEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZDMVEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZDMVE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:04:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZDMVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:04:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hZud/J7v75z4k2Fl1iv/7MfOXPlOKS5Z04Vz/bFNqbKePIInqaxFzRF0OrqPNRxcL
	pMAwNnr5tz7irXT5WQPEg==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904131254480.26713@localhost.localdomain>
References: <604427e00904131244y68fa7e62x85d599f588776eee@mail.gmail.com>
	 <alpine.LFD.2.00.0904131254480.26713@localhost.localdomain>
Date: Mon, 13 Apr 2009 14:04:23 -0700
Message-ID: <604427e00904131404g5284478cw126e21b368b35dfc@mail.gmail.com>
Subject: Re: [V4][PATCH 0/4]page fault retry with NOPAGE_RETRY
From: Ying Han <yinghan@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Waychison <mikew@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 12:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 13 Apr 2009, Ying Han wrote:
>>
>> Benchmarks:
>> case 1. one application has a high count of threads each faulting in
>> different pages of a hugefile. Benchmark indicate that this double data
>> structure walking in case of major fault results in << 1% performance hit.
>>
>> case 2. add another thread in the above application which in a tight loop
>> of mmap()/munmap(). Here we measure loop count in the new thread while other
>> threads doing the same amount of work as case one. we got << 3% performance
>> hit on the Complete Time(benchmark value for case one) and 10% performance
>> improvement on the mmap()/munmap() counter.
>>
>> This patch helps a lot in cases we have writer which is waitting behind all
>> readers, so it could execute much faster.
>
> Hmm. I normally think of "<<" as "much smaller than", but the way you use
> it makes me wonder. In particular, "<< 3%" sounds very odd. If it's much
> smaller than 3%, I'd have expected "<< 1%" again. So it probably isn't.

Yes, it should be "< 3%", i will make the change.

>> benchmarks from Wufengguang:
>> Just tested the sparse-random-read-on-sparse-file case, and found the
>> performance impact to be 0.4% (8.706s vs 8.744s) in the worst case.
>> Kind of acceptable.
>
> Well, have you tried the obvious optimization of _not_ doing the RETRY
> path when atomic_read(&mm->counter) == 1?
>
> After all, if it's not a threaded app, and it doesn't have a possibility
> of concurrent mmap/fault, then why release the lock?
>
>                Linus
>
