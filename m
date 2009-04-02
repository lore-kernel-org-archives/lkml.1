Return-Path: <linux-kernel-owner+w=401wt.eu-S1765428AbZDBQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765428AbZDBQff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbZDBQfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:35:23 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:21255 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760902AbZDBQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:35:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JvveS2JaYamUmY3qW36AvoKGtGy+6r1IaWRl3gzCpGYPg854JNwN2uMt65NJl+ba7CG5gj4h1Fm6lKMhTBP4Rw3gr0POg57vvpgKxAgLDMP/SbWjmuSDZmmgm5LTvny1hyA4KlqL6uCAIUd+jJ1ULw5BbiQy2oy/GZ/0WzCfHaA=  ;
X-YMail-OSG: Ku7Q8hUVM1kvjKlSqOndkLifjG1s2RP5Xt.ZZRglFvn3Nfc_UzVGf4zuTCHvlQ9WMLOORi63gMwQLd98qI0TpyVWYa5uwh9v75aCF9LOa8GIvu36D.Y9kIgTcJRWSYXRjMfTjxJuEWt.Bb6C7P1pcwycSp.9TAHf1QLPdbEs2SBd.MpdOB6ciu2NK_Zel6R3PZmlCsleRUzbb9v6AMjtLZQcQ6XS0wKFZlaDW894ZXTFop.eGKlPfBepnBcxx.XH.v5ky2YSBdRCbuZIZdl7g9PEPByxODl1HKUKbeK1tPV8sBNkufY50YHhQum0dvaP.9kqe9wOPqNRy3wQD1IdX0YeJQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 23/43] CacheFiles: Permit the page lock state to be monitored [ver #46]
Date: Fri, 3 Apr 2009 03:35:12 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030237.25893.nickpiggin@yahoo.com.au> <20090401230520.28177.61387.stgit@warthog.procyon.org.uk> <6638.1238688892@redhat.com>
In-Reply-To: <6638.1238688892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030335.13439.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 03:14:52 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > I prefer to nack this because it is exporting details of the page
> > locking mechanism. unlock_page is very heavyweight in large part
> > because of the memory barriers and cacheline required to check the
> > waitqueue. I have patches to avoid all that if the page lock is
> > not contended.
> > 
> > What's wrong with using wait_on_page_locked, like everyone else does?
> 
> When fscache_read_or_alloc_pages() is called from, say, nfs_readpages(), and is
> given a few hundred pages to readahead from the cache, who does the
> wait_on_page_locked() on each of the _backing_ fs's pages?

Presumably: at the point where data is needed.


> The way I've arranged things to work is for the backing fs pages to be copied
> to the netfs pages and released in the order they're read from the disk.
> 
> There's a small pool of threads that processes the pages.  I don't want to have
> to create a thread for each readpages(), and I don't want readpages() to have
> to wait for all the requests it makes.

Or do you actually have numbers showing a problem if you just read the pages
then copy them?


If there is a problem, then why doesn't fscache_read_or_alloc_pages caller do
the work itself, then you get as many threads as you have indivisible work units,
so completing some part of the request before another wouldn't gain you anything
anyway...
