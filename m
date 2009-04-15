Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZDOCqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZDOCqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZDOCqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:46:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbZDOCp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:45:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-api@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v3 4/6] aio: Don't inherit aio ring memory at fork
References: <20090414151924.C653.A69D9226@jp.fujitsu.com>
	<x49iql7z0k1.fsf@segfault.boston.devel.redhat.com>
	<20090415091534.AC18.A69D9226@jp.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 14 Apr 2009 22:44:03 -0400
In-Reply-To: <20090415091534.AC18.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Wed, 15 Apr 2009 09:56:34 +0900 (JST)")
Message-ID: <x49tz4qiqks.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> Hi!
>
>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
>> 
>> > AIO folks, Am I missing anything?
>> >
>> > ===============
>> > Subject: [RFC][PATCH] aio: Don't inherit aio ring memory at fork
>> >
>> > Currently, mm_struct::ioctx_list member isn't copyed at fork. IOW aio context don't inherit at fork.
>> > but only ring memory inherited. that's strange.
>> >
>> > This patch mark DONTFORK to ring-memory too.
>> 
>> Well, given that clearly nobody relies on io contexts being copied to
>> the child, I think it's okay to make this change.  I think the current
>> behaviour violates the principal of least surprise, but I'm having a
>> hard time getting upset about that.  ;)
>
> ok.
> So, Can I get your Acked-by?

I have more comments below.

>> > In addition, This patch has good side effect. it also fix
>> > "get_user_pages() vs fork" problem.
>> 
>> Hmm, I don't follow you, here.  As I understand it, the get_user_pages
>> vs. fork problem has to do with the pages used for the actual I/O, not
>> the pages used to store the completion data.  So, could you elaborate a
>> bit on what you mean by the above statement?
>
> No.
>
> The problem is, get_user_pages() increment page_count only.
> but VM page-fault logic don't care page_count. (it only care page::_mapcount)
> Then, fork and pagefault can change virtual-physical relationship although
> get_user_pages() is called.
>
> drawback worst aio scenario here
> -----------------------------------------------------------------------
> io_setup() and gup			inc page_count
>
> fork					inc mapcount
> 					and make write-protect to pte
>
> write ring from userland(*)		page fault and
> 					COW break.
> 					parent process get copyed page and
> 					child get original page owner-ship.
>
> kmap and memcpy from kernel		change child page. (it mean data lost)
>
> (*) Is this happend?

I guess it's possible, but I don't know of any programs that do this.

> MADV_DONTFORK or down_read(mmap_sem) or down_read(mm_pinned_sem) 
> or copy-at-fork mecanism(=Nick/Andrea patch) solve it.

OK, thanks for the explanation.

+	/*
+	 * aio context doesn't inherit while fork. (see mm_init())
+	 * Then, aio ring also mark DONTFORK.
+	 */

Would you mind if I did some word-smithing on that comment?  Something
like:
	/*
	 * The io_context is not inherited by the child after fork()
         * (see mm_init).  Therefore, it makes little sense for the
         * completion ring to be inherited.
         */

+	ret = sys_madvise(info->mmap_base, info->mmap_size, MADV_DONTFORK);
+	BUG_ON(ret);
+

It appears there's no other way to set the VM_DONTCOPY flag, so I guess
calling sys_madvise is fine.  I'm not sure I agree with the BUG_ON(ret),
however, as EAGAIN may be feasible.

So, fix that up and you can add my reviewed-by.  I think you should push
this patch independent of the other patches in this series.

>> > I think "man fork" also sould be changed. it only say
>> >
>> >        *  The child does not inherit outstanding asynchronous I/O operations from
>> >           its parent (aio_read(3), aio_write(3)).
>> > but aio_context_t (return value of io_setup(2)) also don't inherit in current implementaion.
>> 
>> I can certainly make that change, as I have other changes I need to push
>> to Michael, anyway.
>
> thanks.

No problem.  As you know, I've already sent a patch for this.

Cheers,
Jeff
