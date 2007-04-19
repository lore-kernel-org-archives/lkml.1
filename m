Return-Path: <linux-kernel-owner+w=401wt.eu-S1766948AbXDSTMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766948AbXDSTMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766950AbXDSTMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:12:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60205 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766951AbXDSTMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:12:36 -0400
Subject: Re: [PATCH 12/13] maps#2: Add /proc/pid/pagemap interface
From: Dave Hansen <hansendc@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <13.469046093@selenic.com>
References: <13.469046093@selenic.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 12:12:29 -0700
Message-Id: <1177009949.12599.154.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 17:03 -0500, Matt Mackall wrote:
> 
> +static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned
> long end,
> +                            void *private)
> +{
> +       struct pagemapread *pm = private;
> +       pte_t *pte;
> +       int err;
> +
> +       pte = pte_offset_map(pmd, addr);
> +       for (; addr != end; pte++, addr += PAGE_SIZE) {
> +               if (addr < pm->next)
> +                       continue;
> +               if (!pte_present(*pte))
> +                       err = add_to_pagemap(addr, -1, pm);
> +               else
> +                       err = add_to_pagemap(addr, pte_pfn(*pte), pm);
> +               if (err)
> +                       return err;
> +       }
> +       pte_unmap(pte - 1);
> +       return 0;
> +} 

Sorry for the horribly late reply. ;)

Would you have any problems with this being extended for the !
pte_present() case to show pages that happen to be in swap?

I'm playing with some process checkpoint/restart code, and using the
existing swap mechanisms to get the current memory contents out of the
process.  I've also created a hackish syscall to make a pretty raw dump
of pte contents.

Perhaps we could steal the high bits of the pfn and have its presence in
swap, plus some handle to which swapfile it is in.  Or, would you rather
I just create a new /proc file that utilizes most of the code you
already put in place, and _just_ deals with swap?

-- Dave

