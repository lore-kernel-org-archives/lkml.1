Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZHMTsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZHMTsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZHMTsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:48:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52644
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755599AbZHMTs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:48:28 -0400
Date: Thu, 13 Aug 2009 12:48:38 -0700 (PDT)
Message-Id: <20090813.124838.210334778.davem@davemloft.net>
To: heyongli@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: Sparc miss chance to fix recoverable fault in copy_from_user
From: David Miller <davem@davemloft.net>
In-Reply-To: <505766fa0908111853y7030399ewb07d4cec6829fd16@mail.gmail.com>
References: <505766fa0908111853y7030399ewb07d4cec6829fd16@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hyl <heyongli@gmail.com>
Date: Wed, 12 Aug 2009 09:53:01 +0800

Please post all Sparc patches and questions CC:'d to
sparclinux@vger.kernel.org otherwise no Sparc experts are going to see
it.

> --- a/arch/sparc/kernel/sun4v_tlb_miss.S
> +++ b/arch/sparc/kernel/sun4v_tlb_miss.S
> @@ -124,7 +124,7 @@ sun4v_dtlb_load:
>  	mov	%g3, %o2		! PTE
>  	mov	HV_MMU_DMMU, %o3	! flags
>  	ta	HV_MMU_MAP_ADDR_TRAP
> -	brnz,pn	%o0, sun4v_dtlb_error
> +	brnz,pn	%o0, sun4v_dtlb_prot
>  	 mov	%g2, %o1		! restore %o1
>  	mov	%g1, %o0		! restore %o0
>  	mov	%g5, %o2		! restore %o2
> 
> 
> 
> am i miss understanding the merged sparc/spar64?
> 
> this problem found on sparc64, via a simple module just access address 0
> via copy_from_user. another simple test is kgdb, issue a cmd:
> x 0

That condition should never trigger, the problem is caused
elsewhere.

If the HV_MMU_MAP_ADDR_TRAP hypervisor call gives an error it means:

1) The PTE passed in is invalid

2) The PTE passed in translates to addresses outside of the
   range accessible to the guest

3) The virtual address is invalid

And the kernel should never have such an illegal address or
PTE mapping here.

You need to figure out how the bad mapping gets into the kernel page
tables and/or translations in the first place.
