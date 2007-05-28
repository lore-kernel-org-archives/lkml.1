Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbXE1Ebu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbXE1Ebu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXE1Ebn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:31:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50465 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXE1Ebm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:31:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<465A55E7.50904@yahoo.com.au>
Date: Sun, 27 May 2007 22:30:53 -0600
In-Reply-To: <465A55E7.50904@yahoo.com.au> (Nick Piggin's message of "Mon, 28
	May 2007 14:09:11 +1000")
Message-ID: <m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Eric W. Biederman wrote:
>> The problem:  When we are trying to free buffers try_to_free_buffers
>> will look at ramdisk pages with clean buffer heads and remove the
>> dirty bit from the page.  Resulting in ramdisk pages with data that
>> get removed from the page cache.  Ouch!
>>
>> Buffer heads appear on ramdisk pages when a filesystem calls getblk,
>> which through a series of function calls eventually calls
>> init_page_buffers.
>>
>> So to fix the mismatch between buffer head state and page state this
>> patch modifies init_page_buffers to transfer the dirty bit from the
>> page to the buffer heads like we currently do for the uptodate bit.
>
> Ouch indeed!
>
> But can we ever have a dirty page at init_page_buffers-time?

Definitely, and it was a royal pain to trace the bug that this
caused.  An initial ramdisk having pieces disappear after mkfs
is called can look like the entire machine is dying.

When we initialize the ramdisk by writing to /dev/ram0 usually in
init/do_mounts_rd.c we don't allocate buffer heads but we do set
the dirty bit, and the page is in the page cache.  So when we
later call getblk it reuses the same page and then calls
init_page_buffers.

> I would have thought we can fix this simply by removing the
> broken ramdisk_set_page_dirty (as far as the comment goes, we
> set CAP_NO_ACCT_DIRTY anyway, so the normal set_page_dirty
> should handle everything properly, no?).

No.  I don't know where accounting comes into play.  I didn't
trace that path.  But if we have a non-dirty ramdisk page with
buffers (basically a hole in the middle or at the end of the ramdisk).
We need to set the buffer dirty bits when we write to it.

So I don't see how it would make sense to reuse the generic
set_page_dirty, and handling all of the logic in set_page_dirty
to dirty the buffer heads seemed to have made the most sense.

Eric
