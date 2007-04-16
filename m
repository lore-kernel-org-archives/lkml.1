Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbXDPF27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbXDPF27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXDPF27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:28:59 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:42781 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbXDPF26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:28:58 -0400
Message-ID: <46230995.4060003@alcatel-lucent.com>
Date: Mon, 16 Apr 2007 13:28:53 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Wang, Baojun" <wangbj@lzu.edu.cn>
CC: linux-kernel@vger.kernel.org, linuxppc-embedded@ozlabs.org
Subject: Re: PROBLEM: kernel 2.6.20.6 build failed for ppc board chestnut(ibm
 ppc 750GX/FX)
References: <376700739.05606@lzu.edu.cn>
In-Reply-To: <376700739.05606@lzu.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2007 05:28:22.0698 (UTC) FILETIME=[0CC8E0A0:01C77FE8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using eldk4, there are no problems.

Wang, Baojun wrote:
> PROBLEM: linux kernel 2.6.20.6 build failed for ppc board chestnut(ibm ppc 
> 750GX/FX)
>
> STEPS I followed:
> 1) make ARCH=ppc CROSS_COMPILE=ppc_4xx- chestnut_defconfig # toolchain from 
> eldk 4.1
>
> 2) make ARCH=ppc CROSS_COMPILE=ppc_4xx- V=1
>
> ...
>
> make -f scripts/Makefile.build obj=arch/ppc/platforms
>   
> ppc_4xx-gcc -m32 -Wp,-MD,arch/ppc/platforms/.chestnut.o.d  -nostdinc -isystem /opt/eldk/usr/bin/../lib/gcc/powerpc-linux/4.0.0/include -D__KERNEL__ -Iinclude  -include 
> include/linux/autoconf.h -Iarch/ppc -Iarch/ppc/include -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -O2 -Iarch/ppc -msoft-float -pipe -ffixed-r2 -mmultiple  -mno-altivec -mstring -Wa,-maltivec -fomit-frame-pointer  -Wdeclaration-after-statement -Wno-pointer-sign    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(chestnut)"  -D"KBUILD_MODNAME=KBUILD_STR(chestnut)" -c -o 
> arch/ppc/platforms/chestnut.o arch/ppc/platforms/chestnut.c
> arch/ppc/platforms/chestnut.c: In function 'chestnut_setup_mtd':
> arch/ppc/platforms/chestnut.c:435: error: 'physmap_map' undeclared (first use 
> in this function)
> arch/ppc/platforms/chestnut.c:435: error: (Each undeclared identifier is 
> reported only once
> arch/ppc/platforms/chestnut.c:435: error: for each function it appears in.)
> make[1]: *** [arch/ppc/platforms/chestnut.o] Error 1
> make: *** [arch/ppc/platforms] Error 2
>
>
> This PROBLEM should also affect these boards:
> find -name '*.[chS]' -exec grep physmap_map {} \; -print
>         physmap_map.size = CHESTNUT_32BIT_SIZE;
> ./arch/ppc/platforms/chestnut.c
>         physmap_map.size = size;
> ./arch/ppc/platforms/ev64360.c
>         physmap_map.size = size;
> ./arch/ppc/platforms/katana.c
>
> I've veryfied 2.6.15, 2.6.19.2 2.6.20.1 2.6.20.6
>
> ONLY 2.6.15 can build successfully. sounds like the problem is caused by the 
> interface change of mtd.
>
>
> this brute force patch sould solve the problem:
>
> diff -Nru /tmp/linux-2.6.20.6/arch/ppc/platforms/chestnut.c \  
> linux-2.6.20.6/arch/ppc/platforms/chestnut.c
>
> --- /tmp/linux-2.6.20.6/arch/ppc/platforms/chestnut.c   2007-04-07 
> 04:02:48.000000000 +0800
> +++ linux-2.6.20.6/arch/ppc/platforms/chestnut.c        2007-04-13 
> 17:09:03.000000000 +0800
> @@ -432,7 +432,9 @@
>         ptbl.name = "User FS";
>         ptbl.size = CHESTNUT_32BIT_SIZE;
>
> -       physmap_map.size = CHESTNUT_32BIT_SIZE;
> +       // physmap_map.size = CHESTNUT_32BIT_SIZE;
> +       physmap_configure(CHESTNUT_32BIT_BASE, CHESTNUT_32BIT_SIZE, 
> CONFIG_MTD_PHYSMAP_BANKWIDTH, NULL);
> +
>         physmap_set_partitions(&ptbl, 1);
>         return 0;
>  }
>
>   

