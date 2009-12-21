Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZLUIxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZLUIxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 03:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZLUIxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 03:53:49 -0500
Received: from sh.osrg.net ([192.16.179.4]:33761 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbZLUIxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 03:53:48 -0500
Date: Mon, 21 Dec 2009 17:53:00 +0900
To: tytso@mit.edu
Cc: fujita.tomonori@lab.ntt.co.jp, torvalds@linux-foundation.org,
       kyle@mcmartin.ca, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
       hch@infradead.org, linux-arch@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091218141731.GH2123@thunk.org>
References: <20091217173957.GG2123@thunk.org>
	<20091218091901J.fujita.tomonori@lab.ntt.co.jp>
	<20091218141731.GH2123@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091221175137I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 21 Dec 2009 17:53:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 09:17:32 -0500
tytso@mit.edu wrote:

> On Fri, Dec 18, 2009 at 09:21:30AM +0900, FUJITA Tomonori wrote:
> > 
> > iSCSI initiator driver should work with kmalloc'ed memory.
> > 
> > The reason why iSCSI didn't work with kmalloc'ed memory is that it
> > uses sendpage (which needs refcountable pages). We added a workaround
> > to not use sendpage with kmalloc'ed memory (it would be great if we
> > remove the workaround though).
> 
> Well, with a patch that I plan to be pushing that we have general
> agreement that it is a block device driver BUG not to accept
> kmalloc'ed/SLAB allocated memory, is one where ext4 will use
> kmalloc'ed/slab allocated memory on occasion when it needs to make
> shadow copy of buffers for journalling purposes AND when the fs block
> size is smaller than the page size.  (i.e., no more allocating a 16k
> page when the fs block size is 4k).  So this won't happen all the
> time; even if the case of a 16k Itanium system with 4k blocks, the
> bulk of the data won't be sent via kmalloc'ed memory --- just some
> critical metadata block and some data blocks that need to be escaped
> when being written into the journal.

Actually, ext3 (jbd) sent kmalloc'ed buffer to the block layer for
frozen data. xfs also used kmalloc'ed buffer. Neither do now (so, as
you said above, jbd wastes some memory when the block size is not
equal to page size, I think).


> I do think we need to document that block device drivers are
> _expected_ to be able to handle kmalloc'ed memory,

Agreed.

Note that network block drivers (iSCSI, drbd, something else?) doesn't
play with page ref-counting. They want to use sendpage. The network
layer (sendpage) can't handle non-ref-counted pages. The best solution
for fs and network block drivers might be modifying sendpage to handle
such pages.
