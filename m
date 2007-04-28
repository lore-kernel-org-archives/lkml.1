Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbXD1AWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbXD1AWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbXD1AWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:22:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757956AbXD1AWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:22:33 -0400
Date: Fri, 27 Apr 2007 17:22:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized
 spinlock. was: Re: 2.6.21-rc7-mm2
Message-Id: <20070427172230.94b82829.akpm@linux-foundation.org>
In-Reply-To: <20070426182519.GA4532@gollum.tnic>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070426182519.GA4532@gollum.tnic>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 20:25:19 +0200
Borislav Petkov <bbpetkov@yahoo.de> wrote:

> 
> Remove build warning mm/memory.c:1491: warning: 'ptl' may be used uninitialized in this function.
> The spinlock pointer is assigned to null since it gets overwritten right away in
> pte_alloc_map_lock().
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
> 
> Index: linux-mm/mm/memory.c
> ===================================================================
> --- linux-mm.orig/mm/memory.c    2007-04-26 19:57:14.000000000 +0200
> +++ linux-mm/mm/memory.c 2007-04-26 20:00:30.000000000 +0200
> @@ -1488,7 +1488,7 @@
>         pte_t *pte;
>         int err;
>         struct page *pmd_page;
> -       spinlock_t *ptl;
> +       spinlock_t *ptl = NULL;
> 
>         pte = (mm == &init_mm) ?
>                 pte_alloc_kernel(pmd, addr) :
> 

yes, I've been staring unhappily at this for some time.

Your change adds seven bytes of text to this function for no runtime
benefit, just to fix a build-time warning.  It's a general problem.


Often we just leave the warning in place and curse gcc each time it flies
past.  Sometimes the code can be restructured in a sensible fashion to
avoid the warning; often it cannot.

But I don't think I want to put up with a warning coming out of core MM all
the time so let's go with the following silliness which adds no additional
runtime cost.

--- a/mm/memory.c~add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix
+++ a/mm/memory.c
@@ -1455,7 +1455,7 @@ static int apply_to_pte_range(struct mm_
 	pte_t *pte;
 	int err;
 	struct page *pmd_page;
-	spinlock_t *ptl;
+	spinlock_t *ptl = ptl;		/* Suppress gcc warning */
 
 	pte = (mm == &init_mm) ?
 		pte_alloc_kernel(pmd, addr) :
_

