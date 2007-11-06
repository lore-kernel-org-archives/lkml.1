Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbXKFNkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbXKFNkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXKFNjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:39:53 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42197 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXKFNjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:39:52 -0500
Message-ID: <47306E9C.4090202@linux.vnet.ibm.com>
Date: Tue, 06 Nov 2007 19:09:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: linuxppc-dev@ozlabs.org, johannes@sipsolutions.net, sam@ravnborg.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1-git15 Kernel build fails on powerpc - Unrecognized
 opcode: `dssall'
References: <47304343.2010709@linux.vnet.ibm.com> <661de9470711060246s3040f68drf0a6310aeec4e1e8@mail.gmail.com> <1194346486.4066.13.camel@johannes.berg> <20071106.031001.189578769.davem@davemloft.net> <47304FE5.2010309@linux.vnet.ibm.com>
In-Reply-To: <47304FE5.2010309@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> David Miller wrote:
>> From: Johannes Berg <johannes@sipsolutions.net>
>> Date: Tue, 06 Nov 2007 11:54:46 +0100
>>
>>>>>   CHK     include/linux/compile.h
>>>>>   AS      arch/powerpc/kernel/swsusp_32.o
>>>>> arch/powerpc/kernel/swsusp_32.S: Assembler messages:
>>>>> arch/powerpc/kernel/swsusp_32.S:138: Error: Unrecognized opcode: `dssall'
>>>>> make[1]: *** [arch/powerpc/kernel/swsusp_32.o] Error 1
>>>>> make: *** [arch/powerpc/kernel] Error 2
>>>>>
>>>> Looks suspiciously like an altivec issue. Could you compile with make
>>>> V=1 and/or do a git bisect and see what broke?
>>> Looks more like a toolchain issue to me.
>> Or, this is another instance of the "CFLAGS environment variable"
>> problem.
>>
>> For a few days, the kbuild stuff would integrate any CFLAGS,
>> AFLAGS, etc. settings you might have set in your environment.
> 
> Hi Balbir,
> 
> The Build error of kernel compilation with V=1
> 
> make -f scripts/Makefile.build obj=arch/powerpc/kernel
> make -f scripts/Makefile.build obj=arch/powerpc/kernel/vdso32
>   gcc -m32 -Wp,-MD,arch/powerpc/kernel/.swsusp_32.o.d  -nostdinc -isystem /usr/lib/gcc/ppc64-redhat-linux/4.1.2/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Iarch/powerpc -D__ASSEMBLY__ -Iarch/powerpc -Wa,-m405 -gdwarf-2     -c -o arch/powerpc/kernel/swsusp_32.o arch/powerpc/kernel/swsusp_32.S
> arch/powerpc/kernel/swsusp_32.S: Assembler messages:
> arch/powerpc/kernel/swsusp_32.S:138: Error: Unrecognized opcode: `dssall'
> make[1]: *** [arch/powerpc/kernel/swsusp_32.o] Error 1
> make: *** [arch/powerpc/kernel] Error 2
> 

I looked at your .config and now your  build. It looks like you select
CONFIG_4xx (I see -Wa,-m405) and compile swsusp_32.S. The
compiler/toolchain does not enable altivec instructions for CONFIG_4xx.
If CONFIG_HIBERNATION is enabled as in your case, it compiles
swsusp_32.S which assumes that ALTIVEC is enabled (see CPU_FTR_ALTIVEC).

You ideally need to have -Wa,-maltivec passed in your CFLAGS.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
