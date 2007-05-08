Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXEHGMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXEHGMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXEHGMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:12:10 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:31493 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755018AbXEHGMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:12:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=4O9x5tGOmx6CNDz/2soYPSjkKYmtmPvxY7/tBvQI9PdLqqDdlLWvUIImXJMHxc9X9ZA//MKr+ehql2iYC3BGfQ4fdYE+ReiidNTu2s/+d3v2bIMk/eXSXrMJyg65KP+MNeYCfAE4/rWvqOz/VaHpGb+n04dC6FrbMJY5nv+DUWk=  ;
X-YMail-OSG: YV4CDnMVM1n_TnNlTAcxhNRNvelkI1HeO_2jVBuwB45LDkO1Qweaj5QuSYbgHjn.Hj._8QyPsg--
Message-ID: <464014B0.7060308@yahoo.com.au>
Date: Tue, 08 May 2007 16:12:00 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au> <463E5A00.6070708@redhat.com>
In-Reply-To: <463E5A00.6070708@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Nick Piggin wrote:
> 
>> OK, sure. I think we need more numbers though.
> 
> 
> Thinking about the issue some more, I think I know just the
> number we might want to know.
> 
> It is pretty obvious that the kernel needs to do less work
> with the MADV_FREE code present.  However, it is possible
> that userspace needs to do more work, by accessing pages
> that are not in the CPU cache, or in another CPU's cache.
> 
> In the test cases where you see similar performance on the
> workload with and without the MADV_FREE code, are you by any
> chance seeing lower system time and higher user time?

I didn't actually check system and user times for the mysql
benchmark, but that's exactly what I had in mind when I
mentioned the poor cache behaviour this patch could cause. I
definitely did see user times go up in benchmarks where I
measured.

We have percpu and cache affine page allocators, so when
userspace just frees a page, it is likely to be cache hot, so
we want to free it up so it can be reused by this CPU ASAP.
Likewise, when we newly allocate a page, we want it to be one
that is cache hot on this CPU.


> I think that maybe for 2.6.22 we should just alias MADV_FREE
> to run with the MADV_DONTNEED functionality, so that the glibc
> people can make the change on their side while we figure out
> what will be the best thing to do on the kernel side.
> 
> I'll send in a patch that does that once Linus has committed
> your most recent flood of patches.  What do you think?

I'll let you and Ulrich decide on that. Keep in mind that older
kernels (without the mmap_sem patch for MADV_DONTNEED) still
seem to get a pretty decent improvement from using MADV_DONTNEED,
so it is possible glibc will want to start using that anyway.

-- 
SUSE Labs, Novell Inc.
