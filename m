Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbXJKKUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbXJKKUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXJKKUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:20:30 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53903 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXJKKU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:20:29 -0400
Date: Thu, 11 Oct 2007 14:25:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core dump: remain dumpable
Message-ID: <20071011102507.GA101@tv-sign.ru>
References: <20071011062730.19F774D026B@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011062730.19F774D026B@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10, Roland McGrath wrote:
> 
> As far as I know, set_dumpable was only used in do_coredump for
> synchronization and not intended for any security purpose.

I don't understand why do_coredump() clears DUMPABLE too.

> This changes do_coredump to use a separate bit for its
> synchronization, so the "dumpable" bits remain the same.
> ...
>
> @@ -1727,7 +1727,8 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
>  	if (!binfmt || !binfmt->core_dump)
>  		goto fail;
>  	down_write(&mm->mmap_sem);
> -	if (!get_dumpable(mm)) {
> +	if (!get_dumpable(mm) ||
> +	    test_and_set_bit(MMF_DUMP_STARTED, &mm->flags)) {
>  		up_write(&mm->mmap_sem);
>  		goto fail;

Do we really need the new MMF_DUMP_STARTED flag? We are holding ->mmap_sem,
can't we check "mm->core_waiters != 0" instead?

Hmm. Actually, do we need any check? If another thread (or CLONE_VM task)
already started do_coredump(), we must see SIGNAL_GROUP_EXIT when we take
->mmap_sem. In that case coredump_wait() does nothing but returns -EAGAIN.

> -	set_dumpable(mm, 0);

Looks like this change is all we need, no? The only problem is that we
return -EAGAIN if we race with another thread (the current code returns 0),
but nobody checks the returned value.

What do you think?

Oleg.

