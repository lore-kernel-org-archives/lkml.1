Return-Path: <linux-kernel-owner+w=401wt.eu-S1765739AbZDBRXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765739AbZDBRXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbZDBRWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:22:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42870 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZDBRWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:22:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090402165505.GA21859@infradead.org>
References: <20090402165505.GA21859@infradead.org> <200904030100.05741.nickpiggin@yahoo.com.au> <200904030232.59355.nickpiggin@yahoo.com.au> <20090402163712.GA25177@infradead.org> <200904030347.21470.nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Thu, 02 Apr 2009 18:22:32 +0100
Message-ID: <7397.1238692952@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> > I don't think "write_one_page" sounds like a particularly good new
> > API addition.
> 
> I also thing it's not a nice one.  I still haven't seen a really good
> explanation of why it can't just use plain ->write

->write requires:

 (1) A struct file.  Refer to the ENFILE problem that my patch to do this
     raised.  The problem is that doing a tar of, say, a kernel tree
     immediately opens ~30000 files internally, and then userspace falls over
     with ENFILE all over the place.  My tests multiply that by 8.

     You (at least I think it was you) refused to countenance allocating file
     structs internally to the kernel that weren't accounted.

 (2) A pointer to a buffer.  That means kmapping a page for the duration of
     the write.

->write is quite heavy.  For something like ext3 it goes down through quite a
few layers, in and out of the fs, VM and VFS.  All this takes both time and
stack space.

I want to write a whole page from the kernel at a page-boundary in the file.
That means it is possible to use an extremely optimised aop to do that.

Really, what I want to do is have the filesystem issue its BIOs directly on
the netfs page, but the Ext3 people I talked to at the time thought that would
be too difficult to track.

David
