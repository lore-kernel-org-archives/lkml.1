Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXE1OG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXE1OG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbXE1OGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:06:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50926 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbXE1OGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:06:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<465A55E7.50904@yahoo.com.au>
	<m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
	<465A6078.6010804@yahoo.com.au> <465A6197.5010402@yahoo.com.au>
Date: Mon, 28 May 2007 08:05:24 -0600
In-Reply-To: <465A6197.5010402@yahoo.com.au> (Nick Piggin's message of "Mon,
	28 May 2007 14:59:03 +1000")
Message-ID: <m1veed82mz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Nick Piggin wrote:
>> Eric W. Biederman wrote:
>
>>> When we initialize the ramdisk by writing to /dev/ram0 usually in
>>> init/do_mounts_rd.c we don't allocate buffer heads but we do set
>>> the dirty bit, and the page is in the page cache.  So when we
>>> later call getblk it reuses the same page and then calls
>>> init_page_buffers.
>>
>>
>> Hmm, so this would be a problem for block_dev.c as well, then?
>> Because it would be possible to have a dirty block dev page
>> have its buffers reclaimed and then reinitialised via
>> init_page_buffers, AFAIKS.
>
> Oh, no, try_to_free_buffers won't drop dirty buffers. However we
> could still set_page_dirty of a block device page without buffers
> via an mmap.

After the page is made dirty via mmap we have:
sys_write -> ... -> block_prepare_write -> ... -> create_empty_buffers.

I suspect that is a pretty rare case but it does indeed seem to exist
as a problem.

Eric
