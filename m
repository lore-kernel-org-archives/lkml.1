Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYFSOHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYFSOHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYFSOGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:06:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbYFSOGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:06:54 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, zach.brown@oracle.com, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: invalidate async directio writes
References: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com>
	<1213861885.16944.255.camel@twins>
	<x49skv9wn29.fsf@segfault.boston.devel.redhat.com>
	<1213883894.10476.17.camel@twins>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 19 Jun 2008 10:05:38 -0400
In-Reply-To: <1213883894.10476.17.camel@twins> (Peter Zijlstra's message of
	"Thu, 19 Jun 2008 15:58:14 +0200")
Message-ID: <x49y751v7t9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, 2008-06-19 at 09:50 -0400, Jeff Moyer wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> 
>> > On Wed, 2008-06-18 at 14:09 -0400, Jeff Moyer wrote:
>> >> Hi, Andrew,
>> >> 
>> >> This is a follow-up to:
>> >> 
>> >> commit bdb76ef5a4bc8676a81034a443f1eda450b4babb
>> >> Author: Zach Brown <zach.brown@oracle.com>
>> >> Date:   Tue Oct 30 11:45:46 2007 -0700
>> >> 
>> >>     dio: fix cache invalidation after sync writes
>> >>     
>> >>     Commit commit 65b8291c4000e5f38fc94fb2ca0cb7e8683c8a1b ("dio: invalidate
>> >>     clean pages before dio write") introduced a bug which stopped dio from
>> >>     ever invalidating the page cache after writes.  It still invalidated it
>> >>     before writes so most users were fine.
>> >>     
>> >>     Karl Schendel reported ( http://lkml.org/lkml/2007/10/26/481 ) hitting
>> >>     this bug when he had a buffered reader immediately reading file data
>> >>     after an O_DIRECT [writer] had written the data.  The kernel issued
>> >>     read-ahead beyond the position of the reader which overlapped with the
>> >>     O_DIRECT writer.  The failure to invalidate after writes caused the
>> >>     reader to see stale data from the read-ahead.
>> >>     
>> >>     The following patch is originally from Karl.  The following commentary
>> >>     is his:
>> >>     
>> >>         The below 3rd try takes on your suggestion of just invalidating
>> >>         no matter what the retval from the direct_IO call.  I ran it
>> >>         thru the test-case several times and it has worked every time.
>> >>         The post-invalidate is probably still too early for async-directio,
>> >>         but I don't have a testcase for that;  just sync.  And, this
>> >>         won't be any worse in the async case.
>> >>     
>> >>     I added a test to the aio-dio-regress repository which mimics Karl's IO
>> >>     pattern.  It verifed the bad behaviour and that the patch fixed it.  I
>> >>     agree with Karl, this still doesn't help the case where a buffered
>> >>     reader follows an AIO O_DIRECT writer.  That will require a bit more
>> >>     work.
>> >>     
>> >>     This gives up on the idea of returning EIO to indicate to userspace that
>> >>     stale data remains if the invalidation failed.
>> >> 
>> >> Note the second-to-last paragraph, where it mentions that this does not fix
>> >> the AIO case.  I updated the regression test to also perform asynchronous
>> >> I/O and verified that the problem does exist.
>> >> 
>> >> To fix the problem, we need to invalidate the pages that were under write
>> >> I/O after the I/O completes.  Because the I/O completion handler can be called
>> >> in interrupt context (and invalidate_inode_pages2 cannot be called in interrupt
>> >> context), this patch opts to defer the completion to a workqueue.  That
>> >> workqueue is responsible for invalidating the page cache pages and completing
>> >> the I/O.
>> >> 
>> >> I verified that the test case passes with the following patch applied.
>> >
>> > I'm utterly ignorant of all thing [AD]IO, but doesn't deferring the
>> > invalidate open up/widen a race window?
>> 
>> We weren't doing the invalidate at all before this patch.  This patch
>> introduces the invalidation, but we can't do it in interrupt context.
>
> Sure, I understand that, so this patch goes from always wrong, to
> sometimes wrong. I'm just wondering if this non-determinism will hurt
> us.

Actually, it goes from sometimes wrong, to sometimes, but less likely,
wrong.  We already have the non-determinism.  And, as I mentioned, a
test case written to expose this very problem doesn't hit it after this
patch.

I'll see if I can't come up with a more deterministic solution.  Any
ideas on the matter would be welcome.  ;)

Thanks for taking a look, Peter.

Cheers,

Jeff
