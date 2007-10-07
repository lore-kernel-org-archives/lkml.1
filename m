Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXJGI35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXJGI35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 04:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbXJGI3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 04:29:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46022 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXJGI3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 04:29:47 -0400
Subject: Re: lockdep: how to tell it multiple pte locks is OK?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47087D45.2010904@goop.org>
References: <47087D45.2010904@goop.org>
Content-Type: text/plain
Date: Sun, 07 Oct 2007 10:29:22 +0200
Message-Id: <1191745762.5602.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-06 at 23:31 -0700, Jeremy Fitzhardinge wrote:
> I'm writing some code which is doing some batch processing on pte pages,
> and so wants to hold multiple pte locks at once.  This seems OK, but
> lockdep is giving me the warning:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.23-rc9-paravirt #1673
> ---------------------------------------------
> init/1 is trying to acquire lock:
>  (__pte_lockptr(new)){--..}, at: [<c0102d85>] lock_pte+0x10/0x15
> 
> but task is already holding lock:
>  (__pte_lockptr(new)){--..}, at: [<c0102d85>] lock_pte+0x10/0x15
> 
> other info that might help us debug this:
> 4 locks held by init/1:
>  #0:  (&mm->mmap_sem){----}, at: [<c012999e>] copy_process+0xab4/0x12bf
>  #1:  (&mm->mmap_sem/1){--..}, at: [<c01299ae>] copy_process+0xac4/0x12bf
>  #2:  (&mm->page_table_lock){--..}, at: [<c010334a>] xen_dup_mmap+0x11/0x24
>  #3:  (__pte_lockptr(new)){--..}, at: [<c0102d85>] lock_pte+0x10/0x15
> 
> stack backtrace:
>  [<c0109282>] show_trace_log_lvl+0x1a/0x2f
>  [<c0109d18>] show_trace+0x12/0x14
>  [<c0109d30>] dump_stack+0x16/0x18
>  [<c0147bd0>] __lock_acquire+0x195/0xc5f
>  [<c0148722>] lock_acquire+0x88/0xac
>  [<c035c2a3>] _spin_lock+0x35/0x42
>  [<c0102d85>] lock_pte+0x10/0x15
>  [<c010347d>] pin_page+0x67/0x17e
>  [<c0102d23>] pgd_walk+0x168/0x1ba
>  [<c0103283>] xen_pgd_pin+0x42/0xf8
>  [<c0103352>] xen_dup_mmap+0x19/0x24
>  [<c0129b63>] copy_process+0xc79/0x12bf
>  [<c012a419>] do_fork+0x99/0x1bf
>  [<c0106216>] sys_clone+0x33/0x39
>  [<c010814e>] syscall_call+0x7/0xb
>  =======================
> 
> 
> I presume this is because I'm holding multiple pte locks (class
> "__pte_lockptr(new)").  Is there some way I can tell lockdep this is OK?

Yeah, the typical way is to use spin_lock_nested(lock, nesting_level),
this allows one to annotate these nestings. However, nesting_level must
not be larger than 8, so if your batch is larger than that, we have a
problem.

> I'm presume I'm the first person to try holding multiple pte locks at
> once, so there's no existing locking order for these locks. 

Not quite, things like copy_pte_range() take 2.

>  I'm always
> traversing and locking the pagetable in virtual address order (and this
> seems like a sane-enough rule for anyone else who wants to hold multiple
> pte locks).

I'm quite sure copy_pte_range() could be used so that it violates that
order.

