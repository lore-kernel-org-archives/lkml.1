Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYLWWWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYLWWWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 17:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLWWWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 17:22:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:50166 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYLWWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 17:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dO5k4SOpFNnOVdJPtt6nyo8FphYPdAXn3oNuuPGF+PJ9ySXOnfJ1+vw+FuyZ3FWsWl
         vSUjdKFD0bwaUPEDNP941Zd122rJkpp1Wisd9m74gfPQIZ1qspZZXh4XGEPSHMojbF0i
         HT00+W7kPD2+X6wYlCuvZdKktPthTjTZ86qIE=
Message-ID: <961aa3350812231422u39adc12dna71060186f9026e0@mail.gmail.com>
Date: Wed, 24 Dec 2008 07:22:31 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Johannes Weiner" <hannes@cmpxchg.org>
Subject: Re: [PATCH] fix unmap_vmas() with NULL vma
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <20081223150618.GB3215@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081223103820.GB7217@localhost.localdomain>
	 <20081223150618.GB3215@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why bail out this late?  We can save the other stuff in exit_mmap() as
> well if we have no mmaps.
>
> Granted, the path is dead cold so the extra call overhead doesn't
> matter but I think the check is logically better placed in
> exit_mmap().

Looks good, this patch should go in.

>        Hannes
>
> ---
> Subject: mm: check for no mmaps in exit_mmap()
>
> When dup_mmap() ooms we can end up with mm->mmap == NULL.  The error
> path does mmput() and unmap_vmas() gets a NULL vma which it
> dereferences.
>
> In exit_mmap() there is nothing to do at all for this case, we can
> cancel the callpath right there.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index d4855a6..b9d1636 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2091,6 +2091,9 @@ void exit_mmap(struct mm_struct *mm)
>        arch_exit_mmap(mm);
>        mmu_notifier_release(mm);
>
> +       if (!mm->mmap)
> +               return;
> +
>        if (mm->locked_vm) {
>                vma = mm->mmap;
>                while (vma) {
>
