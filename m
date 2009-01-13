Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZAMJOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZAMJOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbZAMJOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:14:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33104 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbZAMJOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:14:23 -0500
Date: Tue, 13 Jan 2009 18:13:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       yinghan@google.com, mikew@google.com, hugh@veritas.com
Subject: Re: mmotm 2009-01-12-16-53 uploaded
Message-Id: <20090113181317.48e910af.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200901130053.n0D0rhev023334@imap1.linux-foundation.org>
References: <200901130053.n0D0rhev023334@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009 16:53:43 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-01-12-16-53 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 

After rtc compile fix, the kernel boots.

But with CONFIG_DEBUG_VM, I saw BUG_ON() at 

fork() -> ...
	-> copy_page_range() ...
		-> copy_one_pte()
			->page_dup_rmap()
				-> __page_check_anon_rmap().

BUG_ON(page->index != linear_page_index(vma, address)); 
fires. (from above, the page is ANON.)

It seems page->index == 0x7FFFFFFE here and the page seems to be
the highest address of stack.

This is caused by
 fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes.patch 


This is a fix.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

pgoff is *not* vma->vm_start >> PAGE_SHIFT.
And no adjustment is necessary (when it maps the same start
before/after adjust vma.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Jan12/fs/exec.c
===================================================================
--- mmotm-2.6.29-Jan12.orig/fs/exec.c
+++ mmotm-2.6.29-Jan12/fs/exec.c
@@ -509,7 +509,7 @@ static int shift_arg_pages(struct vm_are
 	unsigned long length = old_end - old_start;
 	unsigned long new_start = old_start - shift;
 	unsigned long new_end = old_end - shift;
-	unsigned long new_pgoff = new_start >> PAGE_SHIFT;
+	unsigned long new_pgoff = vma->vm_pgoff;
 	struct mmu_gather *tlb;
 
 	BUG_ON(new_start > new_end);

