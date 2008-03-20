Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbYCTXG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbYCTXG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYCTXGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:06:49 -0400
Received: from gw.goop.org ([64.81.55.164]:38749 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbYCTXGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:06:48 -0400
Message-ID: <47E2ECF3.2050606@goop.org>
Date: Thu, 20 Mar 2008 16:02:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: How to avoid spurious lockdep warnings?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a Xen system, when a new pagetable is about to be put in use it is 
"pinned", meaning that each page in the pagetable is registered with the 
hypervisor.  This is done in arch/x86/xen/mmu.c:pin_page().

In order to make this efficient, the hypercalls for pinning are batched, 
so that multiple pages are submitted at once in a single multicall.  
While a page is batched pending the hypercall, its corresponding 
pte_lock is held.

This means that the code can end up holding multiple pte locks at once, 
though it is guaranteed to never try to hold the same lock at once.  
However, because these locks are in the same lock class, I get a 
spurious warning from lockdep.  Is there some way I can get rid of this 
warning?

=============================================
[ INFO: possible recursive locking detected ]
2.6.25-rc6-x86-latest.git-dirty #297
---------------------------------------------
init/1 is trying to acquire lock:
 (__pte_lockptr(page)){--..}, at: [<c0105038>] pin_page+0x6a/0x167

but task is already holding lock:
 (__pte_lockptr(page)){--..}, at: [<c0105038>] pin_page+0x6a/0x167

other info that might help us debug this:
4 locks held by init/1:
 #0:  (&mm->mmap_sem){----}, at: [<c012645c>] copy_process+0x97e/0x122f
 #1:  (&mm->mmap_sem/1){--..}, at: [<c012646c>] copy_process+0x98e/0x122f
 #2:  (&mm->page_table_lock){--..}, at: [<c0104bf5>] xen_dup_mmap+0x11/0x24
 #3:  (__pte_lockptr(page)){--..}, at: [<c0105038>] pin_page+0x6a/0x167

stack backtrace:
Pid: 1, comm: init Not tainted 2.6.25-rc6-x86-latest.git-dirty #297
 [<c0144049>] __lock_acquire+0x821/0xb50
 [<c01443ee>] lock_acquire+0x76/0x9d
 [<c0105038>] ? pin_page+0x6a/0x167
 [<c0454537>] _spin_lock+0x23/0x32
 [<c0105038>] ? pin_page+0x6a/0x167
 [<c0105038>] pin_page+0x6a/0x167
 [<c0104520>] pgd_walk+0x18f/0x1e1
 [<c0104fce>] ? pin_page+0x0/0x167
 [<c0104b20>] xen_pgd_pin+0x46/0x10a
 [<c0104bfd>] xen_dup_mmap+0x19/0x24
 [<c0126619>] copy_process+0xb3b/0x122f
 [<c0126e6d>] do_fork+0xab/0x1dd
 [<c017341b>] ? vfs_write+0xf1/0x108
 [<c010877a>] ? sysenter_past_esp+0xba/0xc8
 [<c0106cd5>] sys_clone+0x1f/0x21
 [<c0108731>] sysenter_past_esp+0x71/0xc8
 =======================


Thanks,
    J
