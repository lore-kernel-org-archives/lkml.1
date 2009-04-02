Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZDBQPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZDBQPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbZDBQO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:14:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51109 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZDBQO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:14:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030237.25893.nickpiggin@yahoo.com.au>
References: <200904030237.25893.nickpiggin@yahoo.com.au> <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230520.28177.61387.stgit@warthog.procyon.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 23/43] CacheFiles: Permit the page lock state to be monitored [ver #46]
Date: Thu, 02 Apr 2009 17:14:52 +0100
Message-ID: <6638.1238688892@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> I prefer to nack this because it is exporting details of the page
> locking mechanism. unlock_page is very heavyweight in large part
> because of the memory barriers and cacheline required to check the
> waitqueue. I have patches to avoid all that if the page lock is
> not contended.
> 
> What's wrong with using wait_on_page_locked, like everyone else does?

When fscache_read_or_alloc_pages() is called from, say, nfs_readpages(), and is
given a few hundred pages to readahead from the cache, who does the
wait_on_page_locked() on each of the _backing_ fs's pages?

The way I've arranged things to work is for the backing fs pages to be copied
to the netfs pages and released in the order they're read from the disk.

There's a small pool of threads that processes the pages.  I don't want to have
to create a thread for each readpages(), and I don't want readpages() to have
to wait for all the requests it makes.

Ideally, I'd like to ask the backing fs to read directly into netfs pages, but
that's not particularly feasible at the moment.

David
