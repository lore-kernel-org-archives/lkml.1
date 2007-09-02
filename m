Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXIBCn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXIBCn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbXIBCnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:43:52 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33338 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbXIBCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:43:52 -0400
Date: Sat, 1 Sep 2007 20:43:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] TASK_KILLABLE version 2
Message-ID: <20070902024348.GJ14130@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here's the second version of TASK_KILLABLE.  A few changes since version 1:

 - Don't split up TASK_INTERRUPTIBLE and TASK_UNINTERRUPTIBLE.
   TASK_WAKESIGNAL and TASK_LOADAVG were pretty much equivalent, and since
   we had to keep __TASK_{UN,}INTERRUPTIBLE anyway, splitting them made
   little sense.
 - Instead, I've added some is_task_*() predicates.  I think they
   achieve what Linus wanted without consuming flag bits and without
   checking a metric tonne of code to see whether it wanted
   TASK_UNINTERRUPTIBLE or __TASK_UNINTERRUPTIBLE.
 - Renamed try_lock_page() to lock_page_killable() and change the sense.
   I had envisioned uses being like spin_trylock(), but that turned out
   not to make sense.
 - Fix the bug Trond noticed in wait_on_retry_sync_kiocb() by having the
   callers handle it returning -EINTR
 - Fix the bug I noticed in sync_pages_killable() by adding the new
   function fatal_signal_pending()
 - Audit a lot of uses of TASK_*.  A few seemed dubious and were fixed.

I'd like to see this spend a bit of time in the -mm tree.  I've wasted
a couple of days trying to track down why my machine no longer does
much after starting init, so clearly I'm tampering with stuff I don't
quite understand.

Having said that, I ditched that version of the code and started again
with a much more minimalist approach.  I've also split the patch into
five independent pieces, each of which accomplishes a logical step,
for ease of bisection.

I think patch 1/5 is clearly Right and should be merged ASAP.  Patch 2/5
and 3/5 carry some risk.  4/5 and 5/5 seem less risky to me (and are
independent of each other; both rely on 1-3 being applied first)

I obviously haven't covered every place that can result in a process
sleeping uninterruptibly while attempting an operation.  But sync_page
(patch 4/5) covers about 90% of the times I've attempted to kill cat,
and I hope that by providing the two examples, I can help other people
to fix the cases that they find interesting.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
