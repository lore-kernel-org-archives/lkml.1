Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbZBCEjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbZBCEjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZBCEjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:39:24 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51827 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZBCEjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:39:23 -0500
Date: Tue, 3 Feb 2009 13:38:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Greg KH <greg@kroah.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-Id: <20090203133811.47324d80.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090202220856.GY20323@random.random>
References: <20090128213322.GA15789@kroah.com>
	<20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090130061714.GC31209@kroah.com>
	<20090202220856.GY20323@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 23:08:56 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> Hi Greg!
> 
> > Thanks for the pointers, I'll go read the thread and follow up there.
> 
> If you also run into this final fix is attached below. Porting to
> mainline is a bit hard because of gup-fast... Perhaps we can use mmu
> notifiers to fix gup-fast... need to think more about it then I'll
> post something.
> 
> Please help testing the below on pre-gup-fast kernels, thanks!
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: fork-o_direct-race
> 
> Think a thread writing constantly to the last 512bytes of a page, while another
> thread read and writes to/from the first 512bytes of the page. We can lose
> O_DIRECT reads (or any other get_user_pages write=1 I/O not just bio/O_DIRECT),
> the very moment we mark any pte wrprotected because a third unrelated thread
> forks off a child.
> 
> This fixes it by never wprotecting anon ptes if there can be any direct I/O in
> flight to the page, and by instantiating a readonly pte and triggering a COW in
> the child. The only trouble here are O_DIRECT reads (writes to memory, read
> from disk). Checking the page_count under the PT lock guarantees no
> get_user_pages could be running under us because if somebody wants to write to
> the page, it has to break any cow first and that requires taking the PT lock in
> follow_page before increasing the page count. We are guaranteed mapcount is 1 if
> fork is writeprotecting the pte so the PT lock is enough to serialize against
> get_user_pages->get_page.
> 
> The COW triggered inside fork will run while the parent pte is readonly to
> provide as usual the per-page atomic copy from parent to child during fork.
> However timings will be altered by having to copy the pages that might be under
> O_DIRECT.
> 
> The pagevec code calls get_page while the page is sitting in the pagevec
> (before it becomes PageLRU) and doing so it can generate false positives, so to
> avoid slowing down fork all the time even for pages that could never possibly
> be under O_DIRECT write=1, the PG_gup bitflag is added, this eliminates
> most overhead of the fix in fork.
> 
> Patch doesn't break kABI despite introducing a new page flag.
> 
> Fixed version of original patch from Nick Piggin.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---

Sorry, one more ;)
==
1117                         cond_resched();
1118                         while (!(page = follow_page(vma, start, foll_flags))) {
1119                                 int ret;
1120                                 ret = __handle_mm_fault(mm, vma, start,
1121                                                 foll_flags & FOLL_WRITE);
1122                                 /*
1123                                  * The VM_FAULT_WRITE bit tells us that do_wp_page has
1124                                  * broken COW when necessary, even if maybe_mkwrite
1125                                  * decided not to set pte_write. We can thus safely do
1126                                  * subsequent page lookups as if they were reads.
1127                                  */
1128                                 if (ret & VM_FAULT_WRITE)
1129                                         foll_flags &= ~FOLL_WRITE;
==

>From above, FOLL_WRITE can be dropped and PageGUP() will not be set ?

Thanks,
-Kame


