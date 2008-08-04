Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYHDKoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYHDKoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHDKnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:43:55 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:27422 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752666AbYHDKny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:43:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kCVkZCimFXUx91AaRTQY/6loMXgzvcv9e79NgOJold85wTWLadn9f9Ez01DOIKLHoH6GAdysFbgT9EVVtwRoCE7mBRaJQokdAWH6zhN65uYePHqTZhWVh9H3USTm0w2vTjCVMAwxGFosY3a6OItLbD26I00lnnhM35j4yoKQVYQ=  ;
X-YMail-OSG: PXlbcXIVM1n8HVEASJeNEO8rkSzhRB0FglZi9yf3LOG.M0R_YWpJ9KWGQh3Sfogqyn2Hsk71moDMx5fJxwShWkasbrMj4GJ.yKwFeXZ72kWSKkZGcorRbw7hVoD0X1gg2e8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Date: Mon, 4 Aug 2008 20:43:46 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <200808041902.23970.nickpiggin@yahoo.com.au> <1217845590.24714.45.camel@koto.keithp.com>
In-Reply-To: <1217845590.24714.45.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808042043.46710.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 20:26, Keith Packard wrote:
> On Mon, 2008-08-04 at 19:02 +1000, Nick Piggin wrote:
> > This is how I'd suggested it work as well. I think a little bit
> > more effort should be spent looking at making this work.
>
> What I may be able to do is create a file, then hand it to my driver and
> close the fd. That would avoid any ulimit or low-fd issues.

Sure.


> > Mapping the file into an address space might be a way to make it
> > work (using get_user_pages to get the struct page). splice might
> > also work. read_mapping_page or similar could also be something to
> > look at. But using shmem_getpage seems wrong because it circumvents
> > the vfs API.
>
> It seems fairly ugly to map the object to user space just to get page
> pointers; the expense of constructing that mapping will be entirely
> wasted most of the time.

True. It would make it possible for the userspace program to pass in
anonymous pages, but maybe not a big deal if you're using files and
shmem based management.


> Would it be imprudent to use pagecache_write_begin/pagecache_write_end
> here? For shmem, that appears to point at functions which will do what I
> need. Of course, it will cause extra page-outs as each page will be
> marked dirty, even if the GPU never writes them.
>
> While shmem offers good semantics for graphics objects, it doesn't seem
> like it is unique in any way, and it seems like it should be possible to
> do this operation on any file system.

pagecache_write_begin/pagecache_write_end should be reasonable, but you
have to be careful of the semantics of it. For example, you can't really
read anything from the page inside the calls because the filesystem may
not bring it up to date.

read_mapping_page might help there.


> > If you genuinely have problems that can't be fit into existing
> > APIs without significant modification, and that is specific just to
> > your app, then we could always look at making special cases for you.
> > But it would be nice if we generically solve problems you have with
> > processes manipulating thousands of files.
>
> There are some unique aspects to this operation which don't really have
> parallels in other environments.
>
> I'm doing memory management for a co-processor which uses the same pages
> as the CPU. So, I need to allocate many pages that are just handed to
> the GPU and never used by the CPU at all. Most rendering buffers are of
> this form -- if you ever need to access them from the CPU, you've done
> something terribly wrong.
>
> Then there are textures which are constructed by the CPU (usually) and
> handed over to the GPU for the entire lifetime of the application. These
> are numerous enough that we need to be able to page them to disk; the
> kernel driver will fault them back in when the GPU needs them again.
>
> On the other hand, there are command and vertex buffers which are
> constructed in user space and passed to the GPU for execution. These
> operate just like any bulk-data transfer, and, in fact, I'm using the
> pwrite API to transmit this data. For these buffers, the entire key is
> to make sure you respect the various caches to keep them from getting
> trashed.

Right, that's your specific implementation, but for some cases the
memory management can map or be implemented using generic primitives.
Using pagecache for your memory for example should work nicely. Making
it shmem specific and using internal APIs seems like a negative step
until you really have a good reason to.
