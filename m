Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbZDODAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbZDODAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZDODAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:00:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43741 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZDODAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:00:20 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC][PATCH v3 4/6] aio: Don't inherit aio ring memory at fork
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-api@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <x49tz4qiqks.fsf@segfault.boston.devel.redhat.com>
References: <20090415091534.AC18.A69D9226@jp.fujitsu.com> <x49tz4qiqks.fsf@segfault.boston.devel.redhat.com>
Message-Id: <20090415115858.AC31.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 12:00:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > drawback worst aio scenario here
> > -----------------------------------------------------------------------
> > io_setup() and gup			inc page_count
> >
> > fork					inc mapcount
> > 					and make write-protect to pte
> >
> > write ring from userland(*)		page fault and
> > 					COW break.
> > 					parent process get copyed page and
> > 					child get original page owner-ship.
> >
> > kmap and memcpy from kernel		change child page. (it mean data lost)
> >
> > (*) Is this happend?
> 
> I guess it's possible, but I don't know of any programs that do this.

Yup, I also think this isn't happen in real world.

> 
> > MADV_DONTFORK or down_read(mmap_sem) or down_read(mm_pinned_sem) 
> > or copy-at-fork mecanism(=Nick/Andrea patch) solve it.
> 
> OK, thanks for the explanation.
> 
> +	/*
> +	 * aio context doesn't inherit while fork. (see mm_init())
> +	 * Then, aio ring also mark DONTFORK.
> +	 */
> 
> Would you mind if I did some word-smithing on that comment?  Something
> like:
> 	/*
> 	 * The io_context is not inherited by the child after fork()
>          * (see mm_init).  Therefore, it makes little sense for the
>          * completion ring to be inherited.
>          */
> 
> +	ret = sys_madvise(info->mmap_base, info->mmap_size, MADV_DONTFORK);
> +	BUG_ON(ret);
> +
> 
> It appears there's no other way to set the VM_DONTCOPY flag, so I guess
> calling sys_madvise is fine.  I'm not sure I agree with the BUG_ON(ret),
> however, as EAGAIN may be feasible.
> 
> So, fix that up and you can add my reviewed-by.  I think you should push
> this patch independent of the other patches in this series.

Done :)




