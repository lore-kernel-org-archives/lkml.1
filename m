Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYAOWQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYAOWQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYAOWQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:16:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:4790 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYAOWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:16:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=neOpI4QWnk5GkRH0TkTfj6t33hgXmiGm+WS4R62cZKetxO0p4hleLv1SpsMhbgAuNQxI7a92/ZgxzRlDEcQZ1sRFRmEnO9QmrToZh3gJTPebkBXNNeObiuEpy8t5qOmtU9FEA7UW+hPQ8K4C1djkQK58bqluftel+PL7ybcxSHM=
Message-ID: <4df4ef0c0801151415w70549cb8n6563ca3604e34a68@mail.gmail.com>
Date: Wed, 16 Jan 2008 01:15:59 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH 0/2] Updating ctime and mtime for memory-mapped files [try #4]
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com
In-Reply-To: <E1JEsNJ-00026T-7B@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
	 <E1JEsNJ-00026T-7B@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/15, Miklos Szeredi <miklos@szeredi.hu>:
> > 1. Introduction
> >
> > This is the fourth version of my solution for the bug #2645:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=2645
> >
> > Changes since the previous version:
> >
> > 1) the case of retouching an already-dirty page pointed out
> >   by Miklos Szeredi has been addressed;
>
> I'm a bit sceptical, as we've also pointed out, that this is not
> possible without messing with the page tables.
>
> Did you try my test program on the patched kernel?

I just tried your test program. Alas, my assumption appears to be wrong.

Thank you for your comment!

Now I start thinking that it is better not to care about
the MS_ASYNC case whatsoever.

>
> I've refreshed the patch, where we left this issue last time.  It
> should basically have equivalent functionality to your patch, and is a
> lot simpler.  There might be performance issues with it, but it's a
> good starting point.
>
> Miklos
> ----
>
> Index: linux/mm/memory.c
> ===================================================================
> --- linux.orig/mm/memory.c      2008-01-09 21:16:30.000000000 +0100
> +++ linux/mm/memory.c   2008-01-15 21:16:14.000000000 +0100
> @@ -1680,6 +1680,8 @@ gotten:
>  unlock:
>         pte_unmap_unlock(page_table, ptl);
>         if (dirty_page) {
> +               if (vma->vm_file)
> +                       file_update_time(vma->vm_file);
>                 /*
>                  * Yes, Virginia, this is actually required to prevent a race
>                  * with clear_page_dirty_for_io() from clearing the page dirty
> @@ -2313,6 +2315,8 @@ out_unlocked:
>         if (anon)
>                 page_cache_release(vmf.page);
>         else if (dirty_page) {
> +               if (vma->vm_file)
> +                       file_update_time(vma->vm_file);
>                 set_page_dirty_balance(dirty_page, page_mkwrite);
>                 put_page(dirty_page);
>         }
>
>
