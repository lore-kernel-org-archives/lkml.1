Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbZDNGP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbZDNGP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZDNGPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:15:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40767 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZDNGPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:15:47 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <aarcange@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/6] IO pinning(get_user_pages()) vs fork race fix
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090414151204.C647.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 15:15:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linux Device Drivers, Third Edition, Chapter 15: Memory Mapping and DMA says

	get_user_pages is a low-level memory management function, with a suitably complex
	interface. It also requires that the mmap reader/writer semaphore for the address
	space be obtained in read mode before the call. As a result, calls to get_user_pages
	usually look something like:

		down_read(&current->mm->mmap_sem);
		result = get_user_pages(current, current->mm, ...);
		up_read(&current->mm->mmap_sem);

	The return value is the number of pages actually mapped, which could be fewer than
	the number requested (but greater than zero).

but, it isn't true. mmap_sem isn't only used for vma traversal, but also prevent vs-fork race.
up_read(mmap_sem) mean end of critical section, IOW after up_read() code is fork unsafe.
(access_process_vm() explain proper get_user_pages() usage)

Oh well, We have many wrong caller now. What is the best fix method?

Nick Piggin and Andrea Arcangeli proposed to change get_user_pages() semantics as caller expected.
  see "[PATCH] fork vs gup(-fast) fix" thead in linux-mm
but Linus NACKed it.

Thus I made caller change approach patch series. it is made for discuss to compare Nick's approach.
I don't hope submit it yet.

Nick, This version fixed vmsplice and aio issue (you pointed). I hope to hear your opiniton ;)



ChangeLog:
  V2 -> V3
   o remove early decow logic
   o introduce prevent unmap logic
   o fix nfs-directio
   o fix aio
   o fix bio (only bandaid fix)

  V1 -> V2
   o fix aio+dio case

TODO
  o implement down_write_killable()
  o fix kvm (need?)
  o fix get_arg_page() (Why this function don't use mmap_sem?)


