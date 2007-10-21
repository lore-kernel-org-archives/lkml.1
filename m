Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbXJUGtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbXJUGtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 02:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXJUGtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 02:49:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59541 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbXJUGtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 02:49:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH] rd: Use a private inode for backing storage
References: <200710151028.34407.borntraeger@de.ibm.com>
	<200710211428.55611.nickpiggin@yahoo.com.au>
	<m1wsthcatk.fsf@ebiederm.dsl.xmission.com>
	<200710211524.52595.nickpiggin@yahoo.com.au>
Date: Sun, 21 Oct 2007 00:48:59 -0600
In-Reply-To: <200710211524.52595.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Sun, 21 Oct 2007 15:24:52 +1000")
Message-ID: <m1d4v9c690.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Yes it does. It is exactly breaking the coherency between block
> device and filesystem metadata coherency that Andrew cared about.
> Whether or not that matters, that is a much bigger conceptual
> change than simply using slightly more (reclaimable) memory in
> some situations that my patch does.
>
> If you want to try convincing people to break that coherency,
> fine, but it has to be done consistently and everywhere rather than
> for a special case in rd.c.

Nick.  Reread the patch.  The only thing your arguments have
established for me is that this patch is not obviously correct.  Which
makes it ineligible for a back port.  Frankly I suspect the whole
issue is to subtle and rare to make any backport make any sense.  My
apologies Christian.

>> The only way we make it to that inode is through block 
>> device I/O so it lives at exactly the same level in the hierarchy as
>> a real block device.
>
> No, it doesn't. A real block device driver does have its own
> buffer cache as it's backing store. It doesn't know about
> readpage or writepage or set_page_dirty or buffers or pagecache.

Well those pages are only accessed through rd_blkdev_pagecache_IO
and rd_ioctl.

The address space operations can (after my patch) be deleted or
be replaced by their generic versions.  I just didn't take that
step because it was an unnecessary change and I wanted the minimal
change for a backport.

>> My patch is the considered rewrite boiled down 
>> to it's essentials and made a trivial patch.
>
> What's the considered rewrite here? The rewrite I posted is the
> only one so far that's come up that I would consider [worthy],
> while these patches are just more of the same wrongness.

Well it looks like you were blind when you read the patch.

Because the semantics between the two are almost identical,
except I managed to implement BLKFLSBUF in a backwards compatible
way by flushing both the buffer cache and my private cache.  You
failed to flush the buffer cache in your implementation.

Yes. I use an inode 99% for it's mapping and the mapping 99% for it's
radix_tree.  But having truncate_inode_pages and grab_cache_page
continue to work sure is convenient.  I certainly think it makes it a
lot simpler to audit the code to change just one thing at a time (the
backing store) then to rip out and replace everything and then try and
prove that the two patches are equivalent.

Eric
