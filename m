Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZGCS5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZGCS5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbZGCS5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:57:42 -0400
Received: from claw.goop.org ([74.207.240.146]:58757 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808AbZGCS5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:57:42 -0400
Message-ID: <4A4E54A8.4030606@goop.org>
Date: Fri, 03 Jul 2009 11:57:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: lkml@MoreThan.org
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org>
In-Reply-To: <200907031314.36243.lkml@morethan.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Missed some recipients. ]

On 07/03/09 11:14, Michael S. Zick wrote:
> Here is one I have found useful in my VIA processor bug hunting:
>
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 3068388..2303d86 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -61,7 +61,7 @@
>
>  /* Enough space to fit pagetables for the low memory linear map */
>  MAPPING_BEYOND_END = \
> -       PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
> +       PAGE_TABLE_SIZE((1<<20) - (__PAGE_OFFSET >> PAGE_SHIFT)) << PAGE_SHIFT
>
>   

These calculations are performed by the assembler, not the
preprocessor.  I think this transformation looks correct (in that its an
identity with the original), but my understanding is that the assembler
does it calculations in arbitrary precision, so there's no need to worry
about limiting the arithmetic to 32-bits.

>  /*
>   * Worst-case size of the kernel mapping we need to make:
>
> = = =
>
> Before:
>
>   #5 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
>   #6 [0000011000 - 0000015000]          BOOTMAP ==> [0000011000 - 0000015000]
>
> After:
>
>   #5 [0000010000 - 000007d000]          PGTABLE ==> [0000010000 - 000007d000]
>   #6 [000007d000 - 0000081000]          BOOTMAP ==> [000007d000 - 0000081000]
>
> Someone who knows mm check which is the reasonable value please.
>   


The PGTABLE reservation seems much too big.  I think 1 page should be
sufficient for a system with large pages.  Even if not, 0x6d000 is way
too large.  And they symptoms of failing to reserve the initial
pagetable are pretty non-subtle.

    J
