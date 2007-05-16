Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbXEPROf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbXEPROf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761427AbXEPROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:14:20 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:48777 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760071AbXEPROS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:14:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0I3ce5uD+m+Dvtby/gB/iSkPYeiMd39UUm1RgKGjwUV9Ay5zfLRZlPHwrgNkdPhOFPgk6OAh1Vz1YxXhc0BpXqHvgtgWtqMwRha51rp424CyRymoolQbFycc1sH+RUxY86ZAgwXihwVVj2kxN579CDzId+ANZ/MX8yIzFxrbrhY=  ;
X-YMail-OSG: 2EAjLPAVM1n7BEiCGN3PvhauyGUqmIRWgb5RECogELACMKKpNHVJrGKvZRBH.l_dx658gUeh_A--
Message-ID: <464B3BE4.10704@yahoo.com.au>
Date: Thu, 17 May 2007 03:14:12 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com> <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com> <20070515144007.f87d9be5.akpm@linux-foundation.org> <464A533B.8040507@yahoo.com.au> <Pine.LNX.4.64.0705161711090.7914@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705161711090.7914@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 16 May 2007, Nick Piggin wrote:
> 
>>Andrew Morton wrote:
>>
>>>I need to work out what to do with
>>>
>>>mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
>>>mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
>>>mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
>>>mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
>>>mm-merge-nopfn-into-fault.patch
>>>convert-hugetlbfs-to-use-vm_ops-fault.patch
>>>mm-remove-legacy-cruft.patch
>>>mm-debug-check-for-the-fault-vs-invalidate-race.patch
>>>mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
>>>
>>>Probably merge them, I guess.  Hugh had concerns, I think over small
>>>additional overhead from the lock_page()?
> 
> 
> That's right, the overhead of the lock_page()/unlock_page() in the common
> path of faulting, and of the extra call to unmap_mapping_range() when
> truncating (because page lock doesn't satisfactorily replace the old
> sequence count when COWing).
> 
> 
>>Yes he did. It seems to only be noticable in microbenchmarks.
> 
> 
> So far, yes.  I expect it'll surface in some reallife workload
> sometime, but let's not get too depressed about that.  I guess
> your blithe "Scalability is not an issue" comment still irks me.


I say I believe scalability will not be a huge issue, because for
concurrent faulters on the same page, they still have cacheline
contention beginning before we lock the page (tree_lock), and
ending after we unlock it (page->_count), and a few others in the
middle for good mesure. I sure don't think it is going to help,
but I don't think it would be a great impact on an alrady sucky
workload.

We would have contention against other sources of lock_page, but
OTOH, we want to fix up the clear_page_dirty_for_io race window
by doing a wait_for_page_locked here anyway.

We could introduce some contention for some other lockers... but
again I think they are often situations where the page fields are
going to be modified anyway, or where the fault code would be
contending on something anyway (eg. vs !uptodate read, truncate).
The lock hold time in the fault should be smaller than many.

I'm not saying it would never be contended, but it is such a
granular thing and it is so often surrounded by file level locking.


>>Still, I have some lock_page speedup work that eliminates that regression
>>anyway.
> 
> 
> Again, rather too blithely said.  You have a deep well of ingenuity,
> but I doubt it can actually wash away all of the small overhead added.

OK, I haven't proven to eliminate the overhead completely, but we can
see that options exist... And we should be able to at least help the
more heavily impacted powerpc architecture and bring the hit it to a
more reasonable level there.


>>However, Hugh hasn't exactly said yes or no yet...
> 
> 
> Getting a "yes" or "no" out of me is very hard work indeed.
> But I didn't realize that was gating this work: if the world
> had to wait on me, we'd be in trouble.
> 
> I think there are quite a few people eager to see the subsequent
> ->fault changes go in.  And I think I'd just like to minimize the
> difference between -mm and mainline, so maximize comprehensibilty,
> by getting this all in.  I've not heard of any correctness issues
> with it, and we all agree that the page lock there is attractively
> simple.

Well I value your opinion of course, and I don't want to change the
VM in a way that people are not unhappy with :)


> If I ever find a better way of handling it,
> I'm free to send patches in future, after all.

That's definitely what I had in mind -- the page lock is a simple
starting point (that is hopefully correct) that we would always be
able to build on with something more fancy in future.


> Did that sound something like a "yes"?

A little bit :)


-- 
SUSE Labs, Novell Inc.
