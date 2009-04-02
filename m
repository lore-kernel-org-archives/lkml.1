Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbZDBWoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbZDBWoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760935AbZDBWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:44:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58728 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbZDBWod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:44:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29524.1238696291@redhat.com>
References: <29524.1238696291@redhat.com> <20090402165505.GA21859@infradead.org> <200904030100.05741.nickpiggin@yahoo.com.au> <200904030232.59355.nickpiggin@yahoo.com.au> <20090402163712.GA25177@infradead.org> <200904030347.21470.nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, viro@zeniv.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Thu, 02 Apr 2009 23:44:19 +0100
Message-ID: <7093.1238712259@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> So, I can apply the attached patch.  It opens a file each time it wants to
> write a page and then closes it again, but it's the best way to avoid the
> ENFILE problem.  I'm benchmarking it at the moment.

Okay.  I'm not sure why, but using ->write() in that patch appears to be _much_
better than using ->write_one_page(), despite the latter doing much less work.

The benchmark was:

	mke2fs -j -O dir_index -b 4096 /dev/sda6
	tune2fs -o user_xattr /dev/sda6
	setenforce 0
	mount /dev/sda6 /var/fscache/ -o user_xattr
	insmod /tmp/sunrpc.ko
	insmod /tmp/lockd.ko
	insmod /tmp/nfs_acl.ko 
	insmod /tmp/auth_rpcgss.ko
	insmod /tmp/fscache.ko
	insmod /tmp/nfs.ko
	insmod /tmp/cachefiles.ko
	sync
	service cachefilesd start
	sync
	mount warthog:/warthog /warthog -o fsc -t nfs4
	date;
		tar cf - /warthog/aaa >/dev/zero &
		tar cf - /warthog/aaa2 >/dev/zero &
		tar cf - /warthog/aaa3 >/dev/zero &
		tar cf - /warthog/aaa >/dev/zero &
		tar cf - /warthog/aaa2 >/dev/zero &
		tar cf - /warthog/aaa3 >/dev/zero &
		tar cf - /warthog/aaa >/dev/zero &
		tar cf - /warthog/aaa2 >/dev/zero;
		wait;
		date
	sync
	echo b >/proc/sysrq-trigger

Where each of /warthog/aaa{,2,3} is about 340MB of kernel tree.  The test box
only has 1GB of RAM.  The server has the whole data set in RAM and is
connected by GigE with more or less no other traffic on the line.


Runs without and with the patch were alternated, and the following results
were produced:

Using write_one_page():

	Thu Apr  2 22:56:45 BST 2009
	Thu Apr  2 23:01:03 BST 2009	4m 18s

	Thu Apr  2 23:11:12 BST 2009
	Thu Apr  2 23:15:12 BST 2009	4m 0s

	Thu Apr  2 23:28:39 BST 2009
	Thu Apr  2 23:32:01 BST 2009	3m 22s

Using write():

	Thu Apr  2 23:05:19 BST 2009
	Thu Apr  2 23:07:31 BST 2009	2m 12s

	Thu Apr  2 23:18:28 BST 2009
	Thu Apr  2 23:20:18 BST 2009	1m 50s

	Thu Apr  2 23:22:52 BST 2009
	Thu Apr  2 23:25:24 BST 2009	2m 32s	

So the patch improves performance by about 2x, it would appear.  The disk
holding the backing fs was much more continually on with the patch, so I think
write() must be promoting some disk I/O.

Or maybe, fput() calling release() is the difference.  Any thoughts?

David
