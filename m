Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbXJBWIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbXJBWIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbXJBWI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:08:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577AbXJBWI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:08:28 -0400
Date: Tue, 2 Oct 2007 15:07:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anders =?ISO-8859-1?Q?Bostr=F6m?= <anders@bostrom.dyndns.org>
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       torvalds@linux-foundation.org
Subject: Re: PROBLEM: high load average when idle
Message-Id: <20071002150748.906970bc.akpm@linux-foundation.org>
In-Reply-To: <20071002.233731.119908363.anders@bostrom.dyndns.org>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 23:37:31 +0200 (CEST)
Anders Bostr__m <anders@bostrom.dyndns.org> wrote:

> My computer suffers from high load average when the system is idle,
> introduced by commit 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 .
> 
> Long story:
> 
> 2.6.20 and all later versions I've tested, including 2.6.21 and
> 2.6.22, make the load average high. Even when the computer is totally
> idle (I've tested in single user mode), the load average end up
> at ~0.30. The computer is still responsive, and the only fault seems
> to be the too high load average. All versions up to and including
> 2.6.19.7 is fine, and don't suffer from the problem.
> 
> I git bisect between 2.6.19 and 2.6.20 gave me
> 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 "[PATCH] user of the jiffies
> rounding code: JBD" as the first patch with the
> problem. 2.6.20 with 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 reverted
> works fine. 2.6.23-rc8 with 44d306e1508fef6fa7a6eb15a1aba86ef68389a6
> reverted also works fine.
> 
> This fixes the problem:
> 
> -------------------------- fs/jbd/transaction.c -----------------------------
> index cceaf57..d38e0d5 100644
> @@ -55,7 +55,7 @@ get_transaction(journal_t *journal, transaction_t *transaction)
>  	spin_lock_init(&transaction->t_handle_lock);
>  
>  	/* Set up the commit timer for the new transaction. */
> -	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
> +	journal->j_commit_timer.expires = transaction->t_expires;
>  	add_timer(&journal->j_commit_timer);
>  
>  	J_ASSERT(journal->j_running_transaction == NULL);
> 
> 
> I've only seen this problem on my home desktop computer. My work
> desktop computer and several other computers at work don't suffer from
> this problem. However, all other computers I've tested on is using
> AMD64 as architecture, and not i386 as my home desktop computer.
> 
> Please let me know how I can assist in further debugging of this, if
> needed.

This is unexpected.  High load average is due to either a task chewing a
lot of CPU time or a task stuck in uninterruptible sleep.

Can you please work out which of these is happening?  Run `top' on an idle
system.  Is the CPU less than 1% loaded?

Run

	ps aux | grep " D"

or something like that on an idle system, see if you can spot a task which
is spending time in D state.

If there's a task whcih is spending time in D state, try running

 echo w > /proc/sysrq-trigger ; dmesg -c > foo

the check "foo" to see if it has a task in D state (search foo for " D "). 
If it's not there, do the sysrq again, repeat until you've managed to
capture a trace of the blocked task.

If it turns out that the CPU really is spending excess amounts of time
being busy then a kernel profile would be a good way of finding out where
it is spinning.  Or run sysrq-P from the keyboard a few times.

