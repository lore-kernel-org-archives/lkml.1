Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYCQCTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYCQCTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYCQCTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 22:19:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:9327 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbYCQCTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 22:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XIUmcvqc+ZEOtVk67kcLy2sXSOh730lbb95aQu90bSnYFragToC2NZghOH2VZLPR3AZqmHvP6Pwi+yLOvSISsevUBuAYKoqhFOpKaCa0NXezZ1xjtybc9tnrzqEg9cibwXnxTPXKw6kCNcEQL0kK1iRP4sFEeNZ8OXXlj9qy/bw=
Message-ID: <86802c440803161919h20ed9f78k6e3798ef56668638@mail.gmail.com>
Date: Sun, 16 Mar 2008 19:19:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <20080317015825.0C0171B41E0@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317258.659191058@firstfloor.org>
	 <20080317015825.0C0171B41E0@basil.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 6:58 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
>  Without this fix bootmem can return unaligned addresses when the start of a
>  node is not aligned to the align value. Needed for reliably allocating
>  gigabyte pages.
>  Signed-off-by: Andi Kleen <ak@suse.de>
>
>  ---
>   mm/bootmem.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
>  Index: linux/mm/bootmem.c
>  ===================================================================
>  --- linux.orig/mm/bootmem.c
>  +++ linux/mm/bootmem.c
>  @@ -197,6 +197,7 @@ __alloc_bootmem_core(struct bootmem_data
>   {
>         unsigned long offset, remaining_size, areasize, preferred;
>         unsigned long i, start = 0, incr, eidx, end_pfn;
>  +       unsigned long pfn;
>         void *ret;
>
>         if (!size) {
>  @@ -239,12 +240,13 @@ __alloc_bootmem_core(struct bootmem_data
>         preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
>         areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
>         incr = align >> PAGE_SHIFT ? : 1;
>  +       pfn = PFN_DOWN(bdata->node_boot_start);
>
>   restart_scan:
>         for (i = preferred; i < eidx; i += incr) {
>                 unsigned long j;
>                 i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
>  -               i = ALIGN(i, incr);
>  +               i = ALIGN(pfn + i, incr) - pfn;
>                 if (i >= eidx)
>                         break;
>                 if (test_bit(i, bdata->node_bootmem_map))
>  --

node_boot_start is not page aligned?

YH
