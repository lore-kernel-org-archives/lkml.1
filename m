Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbZH1OE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbZH1OE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZH1OE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:04:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZH1OE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:04:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090827145359.87367779.akpm@linux-foundation.org>
References: <20090827145359.87367779.akpm@linux-foundation.org> <20090827122231.14557.79687.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
       anton@samba.org, stable@kernel.org
Subject: Re: [PATCH] AFS: Stop readlink() on AFS crashing because file not passed to afs_readpage()
Date: Fri, 28 Aug 2009 15:01:18 +0100
Message-ID: <1302.1251468078@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> That seems like a rather large bug.

Indeed.

I've not seen this happen because when a symlink inode is filled in,
afs_mntpt_check_symlink() is called to see whether it's actually a mountpoint,
and *that* calls read_mapping_page() correctly to read the contents of the
symlink.

The contents of the symlink then hang around in the pagecache, preventing
further calls to afs_readpage() by page_getlink().

However, if you wait long enough, as presumably Anton has, the contents of the
symlink get ejected from the pagecache, but the inode is retained, and thus
the next readlink will oops.

> To which kernel version(s) should we apply this?

kAFS isn't that widely used yet, so only the latest, I think.

David
