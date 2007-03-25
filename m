Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXCYSTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXCYSTE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 14:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbXCYSTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 14:19:04 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266AbXCYSTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 14:19:02 -0400
Date: Sun, 25 Mar 2007 11:14:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Stable Kernel Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [BUG] __copy_to_user_inatomic broken on non Pentium machines
In-Reply-To: <1174810024.10840.477.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org>
References: <1174810024.10840.477.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Mar 2007, Thomas Gleixner wrote:
>
> Environment: Pre Pentium systems, (boot_cpu_data.wp_works_ok == 0)

This shouldn't be "pre-pentium", afaik. WP-works-ok on i486 too. I think 
only the original i386 had this bug ("feature").

But I agree, it does seem to be broken on such machines (I assume you 
don't actually have one, but just tested by forcing it by hand ;)

> Now __copy_to_user_ll() takes the (boot_cpu_data.wp_works_ok == 0) path,
> which in turn calls 
> 
> down_read(current->mm->mmap_sem) - which might sleep
> 
> and
> 
> get_user_pages() - which has a cond_resched() inside.
> 
> Not sure how to fix that.

I agree. Nasty. But the thing is, it's actually much worse. We use 
"__put_user()" earlier to try to fault it in writably, and that one is 
totally broken on a CPU where wp_works_ok isn't set.

The whole notion that we should do this at access time is broken.

We should go back to doing it at "access_ok()", or we should just state 
that we don't support original-i386 CPU's any more. As it is, we don't do 
it right *anyway*, since we only do the tests properly in 
__copy_to_user(), and totally miss them in __put_user() and friends.

So it's buggy on i386 however you try to fix it. The only way to fix it 
properly is to move the i386 fixup early, into "access_ok()", the way it 
used to be. 

		Linus
