Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbYDCFw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbYDCFw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYDCFwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:52:51 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:53365 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYDCFwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WOhPSEFk/TP261W60Wv4N8l6a4momJoj4JOQggmh/K4MetcAyeXyuBXMVi68maeEmP86q1peRTFAAStZsroz3j5zLPcQhWE/3SqEQ0cxwkTAQgg6B/z1r1d0AIoGmeYh6lwVbVRhM2ZaKBfvaHQoMk4hUaOzZzOJJjf4cRTNTJ4=
Message-ID: <86802c440804022252q71af08fere6619271dfe17ee@mail.gmail.com>
Date: Wed, 2 Apr 2008 22:52:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [Patch 003/005](memory hotplug) make alloc_bootmem_section()
Cc: "Badari Pulavarty" <pbadari@us.ibm.com>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080403144027.D1FC.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403140221.D1F2.E1E9C6FF@jp.fujitsu.com>
	 <20080403144027.D1FC.E1E9C6FF@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 10:41 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> alloc_bootmem_section() can allocate specified section's area.
>  This is used for usemap to keep same section with pgdat by later patch.
>
>  Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
>   include/linux/bootmem.h |    2 ++
>   mm/bootmem.c            |   25 +++++++++++++++++++++++++
>   2 files changed, 27 insertions(+)
>
>  Index: current/include/linux/bootmem.h
>  ===================================================================
>  --- current.orig/include/linux/bootmem.h        2008-04-01 20:56:39.000000000 +0900
>  +++ current/include/linux/bootmem.h     2008-04-01 20:59:02.000000000 +0900
>  @@ -101,6 +101,8 @@
>   extern void free_bootmem_node(pg_data_t *pgdat,
>                               unsigned long addr,
>                               unsigned long size);
>  +extern void *alloc_bootmem_section(unsigned long size,
>  +                                  unsigned long section_nr);
>
>   #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
>   #define alloc_bootmem_node(pgdat, x) \
>  Index: current/mm/bootmem.c
>  ===================================================================
>  --- current.orig/mm/bootmem.c   2008-04-01 20:56:39.000000000 +0900
>  +++ current/mm/bootmem.c        2008-04-01 20:59:02.000000000 +0900
>  @@ -540,6 +540,31 @@
>         return __alloc_bootmem(size, align, goal);
>   }
>
>  +void * __init alloc_bootmem_section(unsigned long size,
>  +                                   unsigned long section_nr)
>  +{
>  +       void *ptr;
>  +       unsigned long limit, goal, start_nr, end_nr, pfn;
>  +       struct pglist_data *pgdat;
>  +
>  +       pfn = section_nr_to_pfn(section_nr);
>  +       goal = PFN_PHYS(pfn);
>  +       limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
>  +       pgdat = NODE_DATA(early_pfn_to_nid(pfn));
>  +       ptr = __alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
>  +                                  limit);
>  +
>  +       start_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr)));
>  +       end_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr) + size));
>  +       if (start_nr != section_nr || end_nr != section_nr) {
>  +               printk(KERN_WARNING "alloc_bootmem failed on section %ld.\n",
>  +                      section_nr);
>  +               free_bootmem_core(pgdat->bdata, __pa(ptr), size);
>  +               ptr = NULL;
>  +       }

how about __alloc_bootmem_core return NULL?

YH
