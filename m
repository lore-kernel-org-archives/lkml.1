Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYIJVjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYIJVjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYIJVjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:39:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58993 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbYIJVjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:39:01 -0400
Subject: Re: [RFC v4][PATCH 4/9] Memory management (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 14:38:58 -0700
Message-Id: <1221082738.6781.59.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
> array chain
> + */
> +static int cr_vma_scan_pages(struct cr_ctx *ctx, struct vm_area_struct *vma)
> +{
> +       unsigned long addr = vma->vm_start;
> +       unsigned long end = vma->vm_end;
> +       struct cr_pgarr *pgarr;
> +       int nr, total = 0;
> +
> +       while (addr < end) {
> +               pgarr = cr_pgarr_prep(ctx);
> +               if (!pgarr)
> +                       return -ENOMEM;
> +               nr = cr_vma_fill_pgarr(ctx, pgarr, vma, &addr);
> +               if (nr < 0)
> +                       return nr;
> +               pgarr->nr_free -= nr;
> +               pgarr->nr_used += nr;
> +               total += nr;
> +       }
> +
> +       cr_debug("total %d\n", total);
> +       return total;
> +}

This confuses me.  cr_vma_fill_pgarr() if it runs into an error attempts
to free up the pgarr references from the current pgarr that was just
filled.  But, that could only be a portion of a large VMA.  If it can't
free up the entire VMA worth of references (at least), why does it even
try to free a portion?  Why not just return since the upper levels need
to clean up the other portions anyway?

Also, is it really necessary to track the total amount filled in here?
I kinda gums up the code.

-- Dave

