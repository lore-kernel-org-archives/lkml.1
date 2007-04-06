Return-Path: <linux-kernel-owner+w=401wt.eu-S1767422AbXDFC7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767422AbXDFC7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767424AbXDFC7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:59:53 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:48817 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767422AbXDFC7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:59:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=KTGDj/LP7/l4Wg3rOA0cx8bcrebS0CcKSev0R+mibC1O2Pbb+NwseTK5dFNx+xGnDJg+Hih/7RH/aNx3zii1cMvxwUY6/CQhmj7yBEaSQrfMgFjUZ5mycTuggkWug6ze2p5yJ3CG1B4VHlIJ1qAgDh2K1J14CzTK6x4ygma5fbQ=  ;
X-YMail-OSG: qH3p3YkVM1meo5ZvdyQ8Ny5R1WxbkbqqG2ah_dRxVlgXj4jcEZ38l2dphwCkY3zWceLXERmib9uMyjUDGGzsV160nOH.eH_ROX8DPJbn5cNGrBmCbzEWRrWj.Y_47Q--
Message-ID: <4615B79E.9080407@yahoo.com.au>
Date: Fri, 06 Apr 2007 12:59:42 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <4614A5CC.5080508@redhat.com> <46151F73.50602@redhat.com> <4615B043.8060001@yahoo.com.au> <4615B5D9.7060703@redhat.com>
In-Reply-To: <4615B5D9.7060703@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Nick Piggin wrote:
> 
>>Cool. According to my thinking, madvise(MADV_DONTNEED) even in today's
>>kernels using down_write(mmap_sem) for MADV_DONTNEED is better than
>>mmap/mprotect, which have more fundamental locking requirements, more
>>overhead and no benefits (except debugging, I suppose).
> 
> 
> It's a tiny bit faster, see
> 
>   http://people.redhat.com/drepper/dontneed.png
> 
> I just ran it once so the graph is not smooth.  This is on a UP dual
> core machine.  Maybe tomorrow I'll turn on the big 4p machine.

Hmm, I saw an improvement, but that was just on a raw syscall test
with a single page chunk. Real-world use I guess will get progressively
less dramatic as other overheads start being introduced.

Multi-thread performance probably won't get a whole lot better (it does
eliminate 1 down_write(mmap_sem), but one remains) until you use my
madvise patch.


> I would have to see dramatically different results on the big machine to
> make me change the libc code.  The reason is that there is a big drawback.
> 
> So far, when we allocate a new arena, we allocate address space with
> PROT_NONE and only when we need memory the protection is changed to
> PROT_READ|PROT_WRITE.  This is the advantage of catching wild pointer
> accesses.

Sure, yes. And I guess you'd always want to keep that options around as
a debugging aid.

-- 
SUSE Labs, Novell Inc.
