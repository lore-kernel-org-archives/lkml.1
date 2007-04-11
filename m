Return-Path: <linux-kernel-owner+w=401wt.eu-S965095AbXDKT3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbXDKT3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbXDKT3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:29:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8467 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbXDKT3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:29:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=a4b8dAYlM26LSX/vnUeRhfKvQN4tNNGChvJant5XkGzgYY6W/LIC0wggq0ECXq+QO
	1fzULwFCN7+WmuUEUn+yw==
Message-ID: <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
Date: Wed, 11 Apr 2007 12:28:26 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Zach Brown" <zach.brown@oracle.com>
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Cc: akpm@linux-foundation.org, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070411180038.GN28322@mami.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410235353.325A7346F64@localhost>
	 <20070411180038.GN28322@mami.zabbo.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Zach Brown <zach.brown@oracle.com> wrote:
> First, I'll NAK this and all AIO patches until the patch description
> says that it's been run through the regression tests that we've started
> collecting in autotest.  They're trivial to run, never fear:

OK.  I will run those regression tests.


> > Resurrect an old patch that uses atomic operation to update ring buffer
> > index on AIO event queue.  This work allows futher application/libaio
> > optimization to run fast path io_getevents in user space.
>
> I have mixed feelings.  I think the userspace getevents support was
> poorly designed and the simple fact that we've gone this long without it
> says just how desperately the feature isn't needed.

I kept on getting requests from application developers who want that
feature.  My initial patch was dated back May 2004.


> We're allocating more ring elements
> than userspace asked for and than were accounted for in aio_max_nr.
> That cost, however teeny, will be measured against the benefit.

I noticed that while writing the patch.  We have the same bug right
now that nr_events is enlarged to consume the entire mmap'ed ring
buffer pages.  But yet, we don't account those in aio_max_nr.  I
didn't fix that up in this patch because I was going to do a separate
patch on that.


> > -     /* Compensate for the ring buffer's head/tail overlap entry */
> > -     nr_events += 2; /* 1 is required, 2 for good luck */
> > +     /* round nr_event to next power of 2 */
> > +     nr_events = roundup_pow_of_two(nr_events);
>
> Is that buggy?  How will the code tell if head == tail means a full ring
> or an empty ring?  The old code added that extra event to let it tell
> the ring was full before head == tail and it would think it's empty
> again, I think.  I'm guessing roundup(nr_events + 1) is needed.

I don't think it's a bug.  akpm taught me the trick: we don't wrap the
index around the ring size in this scheme, so the extra space is not
needed.


> The ring page, which is mmaped to userspace at some weird address, was
> just written through a kmap.  Do we need a flush_dcache_page()?  This
> isn't this patch's problem, but it'd need to be addressed if we're using
> the ring from userspace.

I will look into this aside from this patch.

- Ken
