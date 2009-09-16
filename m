Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZIPAvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZIPAvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZIPAvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:51:49 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:21747 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbZIPAvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:51:48 -0400
X-Trace: 259197908/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.4.183/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.4.183
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAI/Tr0pPRQS3/2dsb2JhbACBU94BhBcFgVY
X-IronPort-AV: E=Sophos;i="4.44,393,1249254000"; 
   d="scan'208";a="259197908"
Date: Wed, 16 Sep 2009 01:51:06 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] hwpoison: fix uninitialized warning
In-Reply-To: <20090916002329.GA8476@localhost>
Message-ID: <Pine.LNX.4.64.0909160137270.8639@sister.anvils>
References: <Pine.LNX.4.64.0909152206220.28874@sister.anvils>
 <20090916002329.GA8476@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Wu Fengguang wrote:
> On Wed, Sep 16, 2009 at 05:19:07AM +0800, Hugh Dickins wrote:
> > Fix mmotm build warning, presumably also in linux-next:
> > mm/memory.c: In function `do_swap_page':
> > mm/memory.c:2498: warning: `pte' may be used uninitialized in this function
> > 
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > ---
> > I've only noticed this warning on one machine, the powerpc: certainly it
> > needs CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE to see it, but I thought
> > I had one of those set on other machines - just musing in case it's being
> > masked elsewhere by some other bug...

> The lines was introduced in this patch:
> 
>         entry = pte_to_swp_entry(orig_pte);
> -       if (is_migration_entry(entry)) {
> -               migration_entry_wait(mm, pmd, address);
> +       if (unlikely(non_swap_entry(entry))) {
> +               if (is_migration_entry(entry)) {
> +                       migration_entry_wait(mm, pmd, address);
> +               } else if (is_hwpoison_entry(entry)) {
> +                       ret = VM_FAULT_HWPOISON;
> +               } else {
> +                       print_bad_pte(vma, address, pte, NULL);
> +                       ret = VM_FAULT_OOM;
> +               }
>                 goto out;
>         }
> 
> Given that currently there are only two types of non swap entries:
> migration/hwpoison, the last 'else' block is in fact dead code..

Ah, yes, I think it is dead code on x86 (32 and 64), where the
swp_entry_t is well packed.  But not dead code on ppc64, which has

#define __swp_type(entry)	(((entry).val >> 1) & 0x3f)

which is allowing swap types up to 63, when in fact the highest
we use is 31: that leaves space for 32 more non_swap_entry types.

So the compiler was absolutely right to complain about the
uninitialized variable on ppc64, but not on x86.  It's a little
surprising that ppc64 allows 64 swap types, but nothing wrong.

Thanks,
Hugh
