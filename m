Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbYBHFZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbYBHFZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYBHFZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:25:13 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:63078 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYBHFZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yz8RK94a1GpC7nAAWfZsuLZ8BUQRqOiD246A5JlISU1UN1DrtM0RLjZm0sx4YV7kvLZzDUMgqY2BAricsS2QJV/ew7gcRveLOByPOdndb5DVN15wd3vPJDuFOz+1ERteMf2xF/wLzc9A41P+T0dmCwnr2cvjq0BOauW/dHfXL2k=
Message-ID: <8bd0f97a0802072125l16e3fc5cw91a92eed299f82e8@mail.gmail.com>
Date: Fri, 8 Feb 2008 00:25:06 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: blackfin compile error
Cc: "Matt Mackall" <mpm@selenic.com>, "Adrian Bunk" <bunk@kernel.org>,
       bryan.wu@analog.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Howells" <dhowells@redhat.com>
In-Reply-To: <200802061412.50675.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206151830.GI505@cs181133002.pp.htv.fi>
	 <1202315015.17934.242.camel@cinder.waste.org>
	 <200802061412.50675.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 6, 2008 2:12 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Wed 6 Feb 2008 11:23, Matt Mackall pondered:
> > On Wed, 2008-02-06 at 17:18 +0200, Adrian Bunk wrote:
> > > Commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773 broke blackfin:
> > >
> > > <--  snip  -->
> > >
> > > ...
> > >   CC      mm/vmscan.o
> > > In file included from
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'
> > > make[2]: *** [mm/vmscan.o] Error 1
> >
> > This suggests that no one's tried to compile -mm on Blackfin since
> > before September, I think.
>
> Or any other nommu arch's either, since looking at the include files, FRV
> (when configured as noMMU) and m68knommu does not include it either...
>
> > Is there somewhere more appropriate to move it? I can't find one.
> > Failing that, we can wrap it in CONFIG_MMU, I suppose.
>
> Or just add to the the following:
>
> ./include/asm-blackfin
> ./include/asm-frv/ (only when configured as !MMU)
> ./include/asm-h8300
> ./include/asm-m68knommu
> ./include/asm-v850
>
> Others seem to have it in include/asm-xxxxx/pgtable.h as #define, inline
> function, or extern.

looks like only MMU code currently uses the function, but to keep
things nice, we may want something like:
static inline int is_swap_pte(pte_t pte)
{
#ifdef CONFIG_MMU
    return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
#else
    return 0;
#endif
}

the header is also lacking an #include <asm/pgtable.h> at the top ...
-mike
