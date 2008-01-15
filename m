Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYAOU12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYAOU12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYAOU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:27:20 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34481 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYAOU1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:27:19 -0500
To: salikhmetov@gmail.com
CC: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu
In-reply-to: <12004129652397-git-send-email-salikhmetov@gmail.com> (message
	from Anton Salikhmetov on Tue, 15 Jan 2008 19:02:43 +0300)
Subject: Re: [PATCH 0/2] Updating ctime and mtime for memory-mapped files [try #4]
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
Message-Id: <E1JEsNJ-00026T-7B@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Jan 2008 21:27:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. Introduction
> 
> This is the fourth version of my solution for the bug #2645:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=2645
> 
> Changes since the previous version:
> 
> 1) the case of retouching an already-dirty page pointed out
>   by Miklos Szeredi has been addressed;

I'm a bit sceptical, as we've also pointed out, that this is not
possible without messing with the page tables.

Did you try my test program on the patched kernel?

I've refreshed the patch, where we left this issue last time.  It
should basically have equivalent functionality to your patch, and is a
lot simpler.  There might be performance issues with it, but it's a
good starting point.

Miklos
----

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2008-01-09 21:16:30.000000000 +0100
+++ linux/mm/memory.c	2008-01-15 21:16:14.000000000 +0100
@@ -1680,6 +1680,8 @@ gotten:
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (dirty_page) {
+		if (vma->vm_file)
+			file_update_time(vma->vm_file);
 		/*
 		 * Yes, Virginia, this is actually required to prevent a race
 		 * with clear_page_dirty_for_io() from clearing the page dirty
@@ -2313,6 +2315,8 @@ out_unlocked:
 	if (anon)
 		page_cache_release(vmf.page);
 	else if (dirty_page) {
+		if (vma->vm_file)
+			file_update_time(vma->vm_file);
 		set_page_dirty_balance(dirty_page, page_mkwrite);
 		put_page(dirty_page);
 	}

