Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbYANOR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbYANOR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYANORt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:17:49 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:28362 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYANORs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:17:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RYGdPa3Yur9rOCXVmMSbMvqClm7L215o+tJYttRWaMbwmCJ2+Lk7ywek31C1DI3AiiRTpmzBhqr37hSQrGlznuaZ2iwY+02G4iZIXfsHcmNbwgLQQb6gTiAtaxNId3pZn/3/3+5ItuBUWKYDoBenmzHtEQMHtBRTdoMtp+M9Zu8=
Message-ID: <4df4ef0c0801140617t6ca81e84w1cdfcce290ce68fe@mail.gmail.com>
Date: Mon, 14 Jan 2008 17:17:46 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] updating ctime and mtime at syncing
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com
In-Reply-To: <1200317737.15103.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12001991991217-git-send-email-salikhmetov@gmail.com>
	 <12001992023392-git-send-email-salikhmetov@gmail.com>
	 <E1JENAv-0007CM-T9@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801140422l1980d507v1884ad8d8e8bf6d3@mail.gmail.com>
	 <E1JEP9P-0007RD-PP@pomaz-ex.szeredi.hu>
	 <1200317737.15103.8.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/14, Peter Zijlstra <a.p.zijlstra@chello.nl>:
>
> On Mon, 2008-01-14 at 14:14 +0100, Miklos Szeredi wrote:
> > > 2008/1/14, Miklos Szeredi <miklos@szeredi.hu>:
> > > > > http://bugzilla.kernel.org/show_bug.cgi?id=2645
> > > > >
> > > > > Changes for updating the ctime and mtime fields for memory-mapped files:
> > > > >
> > > > > 1) new flag triggering update of the inode data;
> > > > > 2) new function to update ctime and mtime for block device files;
> > > > > 3) new helper function to update ctime and mtime when needed;
> > > > > 4) updating time stamps for mapped files in sys_msync() and do_fsync();
> > > > > 5) implementing the feature of auto-updating ctime and mtime.
> > > >
> > > > How exactly is this done?
> > > >
> > > > Is this catering for this case:
> > > >
> > > >  1 page is dirtied through mapping
> > > >  2 app calls msync(MS_ASYNC)
> > > >  3 page is written again through mapping
> > > >  4 app calls msync(MS_ASYNC)
> > > >  5 ...
> > > >  6 page is written back
> > > >
> > > > What happens at 4?  Do we care about this one at all?
> > >
> > > The POSIX standard requires updating the file times every time when msync()
> > > is called with MS_ASYNC. I.e. the time stamps should be updated even
> > > when no physical synchronization is being done immediately.
> >
> > Yes.  However, on linux MS_ASYNC is basically a no-op, and without
> > doing _something_ with the dirty pages (which afaics your patch
> > doesn't do), it's impossible to observe later writes to the same page.
> >
> > I don't advocate full POSIX conformance anymore, because it's probably
> > too expensive to do (I've tried).  Rather than that, we should
> > probably find some sane compromise, that just fixes the real life
> > issue.  Here's a pointer to the thread about this:
> >
> > http://lkml.org/lkml/2007/3/27/55
> >
> > Your patch may be a good soultion, but you should describe in detail
> > what it does when pages are dirtied, and when msync/fsync are called,
> > and what happens with multiple msync calls that I've asked about.
> >
> > I suspect your patch is ignoring writes after the first msync, but
> > then why care about msync at all?  What's so special about the _first_
> > msync?  Is it just that most test programs only check this, and not
> > what happens if msync is called more than once?  That would be a bug
> > in the test cases.
>
> I must agree, doing the mmap dirty, MS_ASYNC, mmap retouch, MS_ASYNC
> case correctly would need a lot more code which I doubt is worth the
> effort.
>
> It would require scanning the PTEs and marking them read-only again on
> MS_ASYNC, and some more logic in set_page_dirty() because that currently
> bails out early if the page in question is already dirty.

Thanks for your review, Peter and Miklos!

I overlooked this case when AS_MCTIME flag has been turned off and the
page is still dirty.

On the other hand, the words "shall be marked for update" may be
considered as just setting the AS_MCTIME flag, not updating the time
stamps.

What do you think about calling mapping_update_time() inside of "if
(MS_SYNC & flags)"? I suggest such change because the code for
analysis of the case you've mentioned above seems impossible to me.

>
>
>
>
