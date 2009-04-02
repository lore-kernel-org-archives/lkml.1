Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbZDBQPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbZDBQPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764273AbZDBQPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:15:13 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:21277 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764267AbZDBQPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:15:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=aFpTDVprL7tasW5BEwMMcX2mEaEzBMd6fxbJflVTuVCp2gFEN28pj15w73at1ccNFrIA7A/tja3NjUQF0GmvMV/mocAtFZ/KvnFtAoQofedtxUZMXSoh87nZ95RA2iqQyJUvmGwC5hmyW0wEOQ6aYZvO6Cte/SQbriMOp3MUYXw=  ;
X-YMail-OSG: IK324pwVM1k0TLEgstBgoM8ee.MIaiL25pUpDDj54of_eoj03TykoAXxgdA95gqGAAdz2d2RcACRnQd5ksEdU5rFCiQL.fh3TZLOhqZtW8fdJbe7XkTWSbyvWJWVFT9yA_dje1s_HHXm_PT1XHqkr1x8r25lmQZbZWREzUGZziDnkrX0w_gXJTjM7tTzaf7AzerdigAOBGPcpFiSfvJvTdblwgwI2uapxiaLUwDJZmx.mhTpx8T0wzv_LX4b2gdwIcvQE1PAsGBmughjTtwatrXXZcIZhWJO0a5ltqw2Gnk5zg4L7K4BgSkZvub8DWphsACypY4qqbfcROS.TuZPHbrdsA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Fri, 3 Apr 2009 03:15:02 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030225.16372.nickpiggin@yahoo.com.au> <5198.1238682972@redhat.com> <6362.1238687462@redhat.com>
In-Reply-To: <6362.1238687462@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904030315.03606.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 02:51:02 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > Haven't looked closely at how fscache works.
> 
> It's fairly simple.  FS-Cache sets PG_private_2 (PageFsCache) on pages that the
> netfs tells it about, if it retains an interest in the page.  This causes
> invalidatepage() and suchlike to be invoked on that page when the page is
> discarded.
> 
> The netfs can check for the page being in use by calling PageFsCache() and then
> uncache the page if it is in use:
> 
> 	#ifdef CONFIG_AFS_FSCACHE
> 		if (PageFsCache(page)) {
> 			struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
> 			wait_on_page_fscache_write(page);
> 			fscache_uncache_page(vnode->cache, page);
> 		}
> 	#endif
> 
> which clears the bit.

OK, then you just use PG_private for that, and have the netfs
use a PG_owner_private or some such bit to tell that it is an
fscache page.


> Furthermore, when FS-Cache is asked to store a page to the cache, it
> immediately marks it with PG_owner_priv_2 (PageFsCacheWrite).  This is cleared
> when FS-Cache no longer needs the data in the page for writing to the cache.
> 
> This allows (1) invalidatepage() to wait until the page is written before it is
> returned to the memory allocator, and (2) releasepage() to indicate that the
> page is busy if __GFP_WAIT is not given.

So it isn't written synchronously at invalidatepage-time? OK.

 
> > Possibly you can't reuse mappedtodisk....
> 
> PG_mappedtodisk has a very specific meaning to fs/buffer.c and fs/mpage.c.  I
> can't also easily make it mean that a page is backed by the cache.  A page can
> be cached and not mapped to disk.

You have 2 types of pagecache pages you are dealing with here, right? The
netfs and the backingfs pages. From what you write above, am I to take it
that you need to know whether a backingfs page is "backed by the cache"?
WTF for? And what cache is it backed by if it is the backing store?


> > > We still need a way of triggering the page invalidation callbacks for in-use
> > > pages, however.  PG_private, as I've said, is not currently a viable option.
> > 
> > Can you say exactly why not?
> 
> fs/buffer.c owns PG_private in filesystems that use standard buffering.  It
> sets it, clears it and tests it at its own behest without recourse to the
> filesystem using it.

One of us is confused about how this works. Firstly, from your description
above, you're needing the invalidatepage call from the *netfs* page. This is
not using fs/buffer.c presumably, that is the backing store fs.

Secondly, I repeat again, PG_private is only to tell the VM to call the fs aop,
so if you just think you can override this without changing the aop then you
are mistaken: buffer.c will blow up in serveral places if its page aops are
called without buffers being attached to the page (try_to_release_page being one
of them).

Thirdly, buffer layer is just a library for the filesystem to use. Of course it
has recourse to override things just by giving different aops (which could then
call into buffer.c if PG_fscache is not set or whatever you require).


> Also NFS uses PG_private for its own nefarious purposes.  Making PG_private be
> the conjunction of both purposes entailed some fairly messy patching.

This is basically an NFS mess, so that's where it belongs. But anyway I don't
see how it could be less messy to add this in the VM because NFS aops *still*
need to distinguish between cases anyway.
