Return-Path: <linux-kernel-owner+w=401wt.eu-S1751664AbXJUFLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbXJUFLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 01:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbXJUFLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 01:11:03 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60206 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXJUFLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 01:11:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH] rd: Use a private inode for backing storage
References: <200710151028.34407.borntraeger@de.ibm.com>
	<200710181126.10559.borntraeger@de.ibm.com>
	<m1lk9yen0h.fsf_-_@ebiederm.dsl.xmission.com>
	<200710211428.55611.nickpiggin@yahoo.com.au>
Date: Sat, 20 Oct 2007 23:10:15 -0600
In-Reply-To: <200710211428.55611.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Sun, 21 Oct 2007 14:28:55 +1000")
Message-ID: <m1wsthcatk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Saturday 20 October 2007 08:51, Eric W. Biederman wrote:
>> Currently the ramdisk tries to keep the block device page cache pages
>> from being marked clean and dropped from memory.  That fails for
>> filesystems that use the buffer cache because the buffer cache is not
>> an ordinary buffer cache user and depends on the generic block device
>> address space operations being used.
>>
>> To fix all of those associated problems this patch allocates a private
>> inode to store the ramdisk pages in.
>>
>> The result is slightly more memory used for metadata, an extra copying
>> when reading or writing directly to the block device, and changing the
>> software block size does not loose the contents of the ramdisk.  Most
>> of all this ensures we don't loose data during normal use of the
>> ramdisk.
>>
>> I deliberately avoid the cleanup that is now possible because this
>> patch is intended to be a bug fix.
>
> This just breaks coherency again like the last patch. That's a
> really bad idea especially for stable (even if nothing actually
> was to break, we'd likely never know about it anyway).

Not a chance.  The only way we make it to that inode is through block
device I/O so it lives at exactly the same level in the hierarchy as
a real block device.  My patch is the considered rewrite boiled down
to it's essentials and made a trivial patch.

It fundamentally fixes the problem, and doesn't attempt to reconcile
the incompatible expectations of the ramdisk code and the buffer cache.

> Christian's patch should go upstream and into stable. For 2.6.25-6,
> my rewrite should just replace what's there. Using address spaces
> to hold the ramdisk pages just confuses the issue even if they
> *aren't* actually wired up to the vfs at all. Saving 20 lines is
> not a good reason to use them.

Well is more like saving 100 lines.  Not having to reexamine complicated
infrastructure code and doing things the same way ramfs is.  I think
that combination is a good reason.  Especially since I can do with a
16 line patch as I just demonstrated.  It is a solid and simple
incremental change.

Eric
