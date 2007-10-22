Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXJVAgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXJVAgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 20:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXJVAg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 20:36:29 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:44589 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751203AbXJVAg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 20:36:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RPOuEQ++QaSJkQ3khXpsNPe42Cir6mYKKlNMe49qCBWeC5CHKFhauU2Y9GPF0KWJs6K8LoJ54HxTzUTADyenWN9HoMDRrqfrNuQgBzDunj6kKnYbjyRANA8y1t6faApb08+Vbqot5vn2/ePDopYqZ5iFUpHAMzYsQ7FY4ACQzbw=  ;
X-YMail-OSG: biHv0fAVM1nfIDSVTVl.rg0x4rvSD4I3tqYaq0bVitj1WFUFbWplv6ndbFzmK8wySLDAhzN6Pw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] rd: Use a private inode for backing storage
Date: Mon, 22 Oct 2007 10:29:59 +1000
User-Agent: KMail/1.9.5
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <200710211939.04015.nickpiggin@yahoo.com.au> <m1ir50bbd3.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ir50bbd3.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221029.59818.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 03:56, Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > OK, I missed that you set the new inode's aops to the ramdisk_aops
> > rather than the bd_inode. Which doesn't make a lot of sense because
> > you just have a lot of useless aops there now.
>
> Not totally useless as you have mentioned they are accessed by
> the lru so we still need something there just not much.

Well, the ones that are unused are totally useless ;) I would
have expected them to be removed.


> >> Frankly I suspect the whole
> >> issue is to subtle and rare to make any backport make any sense.  My
> >> apologies Christian.
> >
> > It's a data corruption issue. I think it should be fixed.
>
> Of course it should be fixed.  I just don't know if a backport
> makes sense.  The problem once understood is hard to trigger
> and easy to avoid.

I mean backported. That's just me though, I don't know the nuances
of -stable releases. It could be that they rather not risk introducing
something worse which would be fair enough.


> >> Well those pages are only accessed through rd_blkdev_pagecache_IO
> >> and rd_ioctl.
> >
> > Wrong. It will be via the LRU, will get ->writepage() called,
> > block_invalidate_page, etc. And I guess also via sb->s_inodes, where
> > drop_pagecache_sb might do stuff to it (although it probably escapes
> > harm). But you're right that it isn't the obviously correct fix for
> > the problem.
>
> Yes.  We will be accessed via the LRU.  Yes I knew that.

OK it just didn't sound like it, seeing as you said that's the only
way they are accessed.


> The truth is 
> whatever we do we will be visible to the LRU.

No. With my patch, nothing in the ramdisk code is visible to the LRU.
Which is how it should be.


> My preferences run 
> towards having something that is less of a special case then a new
> potentially huge cache that is completely unaccounted for, that we
> have to build and maintain all of the infrastructure for
> independently.

It's not a cache, and it's not unaccounted for. It's specified exactly
with the rd sizing parameters. I don't know why you would say your
patch is better in this regard. Your ramdisk backing store will be
accounted as pagecache, which is completely wrong.


> The ramdisk code doesn't seem interesting enough 
> long term to get people to do independent maintenance.
>
> With my patch we are on the road to being just like the ramdisk
> for maintenance purposes code except having a different GFP mask.

You can be using highmem, BTW. And technically it probably isn't
correct to use GFP_USER.


> > If you think it is a nice way to go, then I think you are
> > blind ;)
>
> Well we each have different tastes.  I think my patch
> is a sane sensible small incremental step that does just what
> is needed to fix the problem.   It doesn't drag a lot of other
> stuff into the problem like a rewrite would so we can easily verify
> it.

The small incremental step that fixes the problem is Christian's
patch.


> > It's horrible. And using truncate_inode_pages / grab_cache_page and
> > new_inode is an incredible argument to save a few lines of code. You
> > obviously didn't realise your so called private pages would get
> > accessed via the LRU, for example.
>
> I did but but that is relatively minor.  Using the pagecache this
> way for this purpose is a well established idiom in the kernel
> so I didn't figure I was introducing anything to hard to maintain.

Where else is this an established idiom?


> > This is making a relatively
> > larger logical change than my patch, because now as well as having
> > a separate buffer cache and backing store, you are also making the
> > backing store pages visible to the VM.
>
> I am continuing to have the backing store pages visible to the VM,
> and from that perspective it is a smaller change then where we are
> today.

It is smaller lines of code. It is a larger change. Because what you
are doing is 2 things. You are firstly discontinuing the use of the
buffer cache for the backing store, and secondly you are introducing
a new backing store which registers an inode with the vfs and pages
with the pagecache.

My patch does the same thing without those two last questionable
steps.

You now have to treat those backing store pages as pagecache pages,
and hope you have set the right flags and registered the right aops.


> Not that we can truly hide pages from the VM. 

Any page you allocate is your private page. The problem is you're
just sending them back to the VM again.
