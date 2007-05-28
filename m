Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbXE1N73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbXE1N73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXE1N7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:59:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48898 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXE1N7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:59:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<465A55E7.50904@yahoo.com.au>
	<m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
	<465A7894.5090101@yahoo.com.au>
Date: Mon, 28 May 2007 07:58:36 -0600
In-Reply-To: <465A7894.5090101@yahoo.com.au> (Nick Piggin's message of "Mon,
	28 May 2007 16:37:08 +1000")
Message-ID: <m1zm3p82yb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

>> Definitely, and it was a royal pain to trace the bug that this
>> caused.  An initial ramdisk having pieces disappear after mkfs
>> is called can look like the entire machine is dying.
>>
>> When we initialize the ramdisk by writing to /dev/ram0 usually in
>> init/do_mounts_rd.c we don't allocate buffer heads but we do set
>> the dirty bit, and the page is in the page cache.  So when we
>> later call getblk it reuses the same page and then calls
>> init_page_buffers.
>
> Hmm, the comment above grow_dev_buffers indicates this should
> not happen. But contrary to the comment, it doesn't go BUG
> unless you're attaching dirty buffers to a page with dirty
> buffers.
>
> I suspect this happens more frequently with rd.c, because unlike
> block_dev.c, it does not create dirty buffers in prepare_write.
> However it could still happen in block_dev.c via mmaped memory,
> as I said earlier.
>
> I'm not saying this patch 1/3 is wrong, but we would at least
> need to revise some comments. The grow_dev_buffers comment looks
> like one of Andrew's. Maybe he can shed some more light on this?

Good question.  It sounds like you are correct.

Either we need to fix those comments or find the root
cause for the need to call cancel_dirty_page in try_to_free_buffers
and fix that.

Eric
