Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYJUXLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYJUXLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 19:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYJUXLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 19:11:07 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:52949 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYJUXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 19:11:06 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel thread 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081021164619.341f01d9@lxorguk.ukuu.org.uk>
References: <7123.1224602071@jrobl> <20081021164619.341f01d9@lxorguk.ukuu.org.uk>
Date: Wed, 22 Oct 2008 08:10:54 +0900
Message-ID: <6775.1224630654@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox:
> Calling into the file system code assuming that current->mm is
> NULL isn't safe and hasn't been for a very long time since someone added
> the 3% hack.

I guess
- people don't care overcommit and leave it as default, so they don't
  meet the problem 
- people who cares overcommit has rich memory, and they don't meet the
  problem too.


> The shmem case is actually a bit special so my thoughts are:
> 
> Make security_vm_enough_memory() WARN() if current->mm = NULL
> Make security_vm_enough_memory_mm() WARN() if the passed mm = NULL
> Add security_vm_enough_memory_fs() which does not do the warning test
> 
> All would still call security->ops->vm_enough_memory and then
> __vm_enough_memory() would skip the 3% adjustment when the passed mm was
> NULL
> 
> Does that sound sensible ?

In your first option, write() to the exported tmpfs will produce the
warning on nfs server even if much memory is left. I don't think it is a
good idea.
I'd suggest to make __vm_enough_memory() would skip the 3% adjustment
only.

--- /src/linux-2.6/linux-2.6.27/mm/mmap.c	2008-10-10 07:13:53.000000000 +0900
+++ /tmp/mmap.c	2008-10-22 08:07:09.000000000 +0900
@@ -173,9 +173,10 @@
 		allowed -= allowed / 32;
 	allowed += total_swap_pages;
 
-	/* Don't let a single process grow too big:
+	/* Don't let a single user process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space


Junjiro R. Okajima
