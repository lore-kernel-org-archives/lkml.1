Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbZGCUHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbZGCUHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZGCUHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:07:03 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:54947 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbZGCUHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ht3VEnDbBDrPuoy5XAxTJ8GNzZKMDx1oDRtiUh0OPb0tK0PWKCYN2Daoix44531qLd
         EDfAYbuWKeZZSkcT3IGvlyTmXVM9WBjvdotc1MtUqRd0MKljpcR9pjsJqfj/omE3Jsqx
         HvfVEKiORQLZJNwW45dkFkz5WZBWxQrh3ttbM=
MIME-Version: 1.0
In-Reply-To: <200907031314.36243.lkml@morethan.org>
References: <200907031314.36243.lkml@morethan.org>
Date: Fri, 3 Jul 2009 13:07:04 -0700
Message-ID: <86802c440907031307s43fca3c0j77d4df78450ff757@mail.gmail.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: lkml@morethan.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 11:14 AM, Michael S. Zick<lkml@morethan.org> wrote:
> Here is one I have found useful in my VIA processor bug hunting:
>
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 3068388..2303d86 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -61,7 +61,7 @@
>
>  /* Enough space to fit pagetables for the low memory linear map */
>  MAPPING_BEYOND_END = \
> -       PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
> +       PAGE_TABLE_SIZE((1<<20) - (__PAGE_OFFSET >> PAGE_SHIFT)) << PAGE_SHIFT
>
>  /*
>  * Worst-case size of the kernel mapping we need to make:
>
> = = =
>
> Before:
>
>  #5 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
>  #6 [0000011000 - 0000015000]          BOOTMAP ==> [0000011000 - 0000015000]
>
> After:
>
>  #5 [0000010000 - 000007d000]          PGTABLE ==> [0000010000 - 000007d000]
>  #6 [000007d000 - 0000081000]          BOOTMAP ==> [000007d000 - 0000081000]
>

that PGTABLE is from early resource. and it is filled by init_memory_mapping()

it mean preallocated pgtable to MAPPING_BEYOND_END is small now after
patch. and init_memory_mapping try to get more.

please send out whole dmesg. with and without your patch. it could
print out initial mapped before e820 allocation is involved for 32bit
        printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
                        max_pfn_mapped<<PAGE_SHIFT);


your patch should be right. except to change that 12 to PAGE_SHIFT

YH
