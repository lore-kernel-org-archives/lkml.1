Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbZDBRFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbZDBRFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760294AbZDBRFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:05:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35880 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbZDBRFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:05:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030335.13439.nickpiggin@yahoo.com.au>
References: <200904030335.13439.nickpiggin@yahoo.com.au> <200904030237.25893.nickpiggin@yahoo.com.au> <20090401230520.28177.61387.stgit@warthog.procyon.org.uk> <6638.1238688892@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 23/43] CacheFiles: Permit the page lock state to be monitored [ver #46]
Date: Thu, 02 Apr 2009 18:05:07 +0100
Message-ID: <7156.1238691907@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Presumably: at the point where data is needed.

But the point where the data is needed is where filemap.c is waiting on a
netfs page.  Maybe the sync_page() aop can deal with it

There's also the problem of recording and pinning the backing page I'm waiting
for.  Currently I can do that by hooking the monitor block into the page
unlock watching list.  If I don't do that, I have to use up yet more memory to
track those some other way.  It's not impossible, but I'd like to keep memory
usage down.

> Or do you actually have numbers showing a problem if you just read the pages
> then copy them?

I did, years ago.  It wasn't particularly good, but
fscache_read_or_alloc_pages() was completely synchronous.

> If there is a problem, then why doesn't fscache_read_or_alloc_pages caller
> do the work itself, then you get as many threads as you have indivisible
> work units, so completing some part of the request before another wouldn't
> gain you anything anyway...

(1) Trond stipulated FS-Cache had to be asynchronous, and it is, as far as I
    can make it.  I still have to invoke bmap() synchronously, though, to find
    out whether I have a page in the cache to read:-/

(2) You lose the advantage of being able to process what you've got whilst the
    disk is fetching stuff in the background.

David
