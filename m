Return-Path: <linux-kernel-owner+w=401wt.eu-S1766857AbXDSQfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766857AbXDSQfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766855AbXDSQfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:35:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48133 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766857AbXDSQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:09 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Message-Id: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 0/8] Variable Order Page Cache
Date: Thu, 19 Apr 2007 09:35:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache Patchset

This patchset modifies the core VM so that higher order page cache pages
become possible. The higher order page cache pages are compound pages
and can be handled in the same way as regular pages.

The order of the pages is determined by the order set up in the mapping
(struct address_space). By default the order is set to zero.
This means that higher order pages are optional. There is no attempt here
to generally change the page order of the page cache. 4K pages are effective
for small files.

However, it would be good if the VM would support I/O to higher order pages
to enable efficient support for large scale I/O. If one wants to write a
long file of a few gigabytes then the filesystem should have a choice of
selecting a larger page size for that file and handle larger chunks of
memory at once.

The support here is only for buffered I/O and only for one filesystem (ramfs).
Modification of other filesystems to support higher order pages may require
extensive work of other components of the kernel. But I hope this shows that
there is a relatively easy way to that goal that could be taken in steps..

Note that the higher order pages are subject to reclaim. This works in general
since we are always operating on a single page struct. Reclaim is fooled to
think that it is touching page sized objects (there are likely issues to be
fixed there if we want to go down this road).

What is currently not supported:
- Buffer heads for higher order pages (possible with the compound pages in mm
  that do not use page->private requires upgrade of the buffer cache layers).
- Higher order pages in the block layer etc.
- Mmapping higher order pages

Note that this is proof-of-concept. Lots of functionality is missing and
various issues have not been dealt with. Use of higher order pages may cause
memory fragmentation. Mel Gorman's anti-fragmentation work is probably
essential if we want to do this. We likely need actual defragmentation
support.

The main point of this patchset is to demonstrates that it is basically
possible to have higher order support with straightforward changes to the
VM.

The ramfs driver can be used to test higher order page cache functionality
(and may help troubleshoot the VM support until we get some real filesystem
and real devices supporting higher order pages).

If you apply this patch and then you can f.e. try this:

mount -tramfs -o10 none /media

	Mounts a ramfs filesystem with order 10 pages (4 MB)

cp linux-2.6.21-rc7.tar.gz /media

	Populate the ramfs. Note that we allocate 14 pages of 4M each
	instead of 13508..

umount /media

	Gets rid of the large pages again

Comments appreciated.

