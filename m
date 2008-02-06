Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYBFTLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYBFTLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbYBFTLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:11:31 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:26247 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYBFTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:11:30 -0500
X-IronPort-AV: E=Sophos;i="4.25,313,1199682000"; 
   d="scan'208";a="61692384"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: blackfin compile error
Date: Wed, 6 Feb 2008 14:12:50 -0500
User-Agent: KMail/1.9.5
Cc: "Adrian Bunk" <bunk@kernel.org>, bryan.wu@analog.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Howells" <dhowells@redhat.com>
References: <20080206151830.GI505@cs181133002.pp.htv.fi> <1202315015.17934.242.camel@cinder.waste.org>
In-Reply-To: <1202315015.17934.242.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802061412.50675.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Feb 2008 19:11:23.0957 (UTC) FILETIME=[10950650:01C868F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 6 Feb 2008 11:23, Matt Mackall pondered:
> 
> On Wed, 2008-02-06 at 17:18 +0200, Adrian Bunk wrote:
> > Commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773 broke blackfin:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      mm/vmscan.o
> > In file included from 
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'
> > make[2]: *** [mm/vmscan.o] Error 1
> 
> This suggests that no one's tried to compile -mm on Blackfin since
> before September, I think.

Or any other nommu arch's either, since looking at the include files, FRV
(when configured as noMMU) and m68knommu does not include it either...

> Is there somewhere more appropriate to move it? I can't find one.
> Failing that, we can wrap it in CONFIG_MMU, I suppose.

Or just add to the the following:

./include/asm-blackfin
./include/asm-frv/ (only when configured as !MMU)
./include/asm-h8300
./include/asm-m68knommu
./include/asm-v850

Others seem to have it in include/asm-xxxxx/pgtable.h as #define, inline 
function, or extern.

> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> diff -r 50a6e531a9f2 include/linux/swapops.h
> --- a/include/linux/swapops.h	Mon Feb 04 20:23:02 2008 -0600
> +++ b/include/linux/swapops.h	Wed Feb 06 10:21:32 2008 -0600
> @@ -42,11 +42,13 @@
>  	return entry.val & SWP_OFFSET_MASK(entry);
>  }
>  
> +#ifdef CONFIG_MMU
>  /* check whether a pte points to a swap entry */
>  static inline int is_swap_pte(pte_t pte)
>  {
>  	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
>  }
> +#endif
>  
>  /*
>   * Convert the arch-dependent pte representation of a swp_entry_t into
> an
> 
