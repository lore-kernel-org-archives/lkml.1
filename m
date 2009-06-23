Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZFWRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZFWRVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZFWRVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:21:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbZFWRVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:21:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090623173340.66f71915@lxorguk.ukuu.org.uk>
References: <20090623173340.66f71915@lxorguk.ukuu.org.uk> <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk> <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org> <16370.1245772337@redhat.com> <16755.1245773452@redhat.com> 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Date: Tue, 23 Jun 2009 18:20:48 +0100
Message-ID: <17391.1245777648@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Which means the device could be unloaded, something else loaded and your
> handle wouldn't be invalidated but would be stale ?

It would not be stale.  The O_NOACC handle would effectively be a route to the
inode on the underlying fs, and so shouldn't affect normal opens that do get
routed to the device driver.

However, Miklos's O_FILESYSTEM suggestion would work as a differentiation to
O_NOACC, if you want the latter to go to the device driver.

> Perhaps it would make more sense to me if I knew why you needed to do this ?

How about I give you an example:

There's a pioctl to kick a file out of the local cache and reload it.  AFS
symlinks are stored in the local cache, and so you might conceivably want to
eject one from the local cache on your machine.  This is an operation on the
symlink object itself, _not_ on the target of the symlink.

However, unless I can open a symlink without it giving me an error or trying
to open the target, I cannot issue an ioctl() upon it.

Also, this is a command, not an attribute, and so using lsetxattr() is a bit
of a violation of semantics, and, furthermore, it's not an attribute of the
file.


Now, consider that I may, at some point in the future, or in some other netfs,
need to deal with device files.  I may want to eject a dev file from the
cache; I might want to lock one into the cache.  I need to affect the
filesystem object underlying the device file, not the device driver's opinion
of the device file.  The device driver knows nothing about the filesystem's
local caching, and shouldn't have to deal with it.  I need a way to operate on
a device file without (a) incurring ->open() side effects of a dev file, (b)
pestering the device driver, (c) incurring a failure because the dev file
doesn't have a corresponding driver, or (d) requiring permission to open that
dev file.


It is probably worth adding an fscachectl() syscall to handle caching commands,
since these are fairly simple and need to be applied to NFS as well as AFS, but
there are other file commands too (not just things that get attributes).  See:

	http://www.openafs.org/cgi-bin/cvsweb.cgi/openafs/doc/pdf/fscm-ispec.pdf?rev=1.1&content-type=text/x-cvsweb-markup

for more information.

David
