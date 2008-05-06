Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbYEFXgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbYEFXgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbYEFXgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:36:08 -0400
Received: from simmts8.bellnexxia.net ([206.47.199.166]:54518 "EHLO
	simmts8-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922AbYEFXgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:36:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsBAMeHIEicIp8z/2dsb2JhbAAIim6iQw
Message-ID: <4820EB5C.2010102@gmail.com>
Date: Tue, 06 May 2008 20:35:56 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: linux-next: WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x54()
References: <20080501043313.02205bbd@linux.intel.com>	<481CF3B1.2020307@gmail.com>	<4820B64D.4000805@linux.intel.com> <20080506.133416.241365936.davem@davemloft.net> <4820E529.2030801@gmail.com> <4820EA7B.4050406@linux.intel.com>
In-Reply-To: <4820EA7B.4050406@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Kevin Winchester wrote:
>> David Miller wrote:
>>> From: Arjan van de Ven <arjan@linux.intel.com>
>>> Date: Tue, 06 May 2008 12:49:33 -0700
>>>
>>>> this is weird; something is adding ANOTHER -fstack-protector to the 
>>>> (effective) gcc
>>>> flags.. which might be overriding the -fstack-protector-all setting.
>>>>
>>>> I wonder if this is a distro special ;(
>>> Ubuntu adds -fstack-protector to the GCC command line.
>>>
>>> But I've been able to override it trivially when, for example, doing
>>> GCC builds, by simply adding -fno-stack-protector.
>> I assume adding -fno-stack-protector would not really be an option in 
>> this case (since if I understand correctly it would be appended to the 
>> end of the flags which would turn the option off).
>>
>> I guess I'll be figuring out how to build my own gcc...
> 
> one question (since I don't have an ubuntu system on my desk right now)
> 
> if you do
> 
> make V=1 kernel/panic.o
> 
> (after deleting that file if needed), can you check that -fstack-protector-all is the last
> stack protector option we explicitly give to gcc ?
> (anything else is distro special which we unfortunately cannot fix.. but maybe we can detect)
> 
> 

kevin@alekhine:~/linux/linux-2.6$ make V=1 kernel/panic.o
rm -f include/config/kernel.release
echo 2.6.25-next-20080430 > include/config/kernel.release
set -e; :; mkdir -p include/linux/;     (echo \#define 
LINUX_VERSION_CODE 132633; echo '#define KERNEL_VERSION(a,b,c) (((a) << 
16) + ((b) << 8) + (c))';) < /home/kevin/linux/linux-2.6/Makefile > 
include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s 
include/linux/version.h include/linux/version.h.tmp; then rm -f 
include/linux/version.h.tmp; else :; mv -f include/linux/version.h.tmp 
include/linux/version.h; fi
set -e; :; mkdir -p include/linux/;     if [ `echo -n 
"2.6.25-next-20080430" | wc -c ` -gt 64 ]; then echo 
'"2.6.25-next-20080430" exceeds 64 characters' >&2; exit 1; fi; (echo 
\#define UTS_RELEASE \"2.6.25-next-20080430\";) < 
include/config/kernel.release > include/linux/utsrelease.h.tmp; if [ -r 
include/linux/utsrelease.h ] && cmp -s include/linux/utsrelease.h 
include/linux/utsrelease.h.tmp; then rm -f 
include/linux/utsrelease.h.tmp; else :; mv -f 
include/linux/utsrelease.h.tmp include/linux/utsrelease.h; fi
set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;   \
         if [ -L include/asm ]; then                                     \
                 if [ "$asmlink" != "x86" ]; then                \
                         echo "ERROR: the symlink include/asm points to 
asm-$asmlink but asm-x86 was expected"; \
                         echo "       set ARCH or save .config and run 
'make mrproper' to fix it";             \
                         exit 1;                                         \
                 fi;                                                     \
         else                                                            \
                 echo '  SYMLINK include/asm -> include/asm-x86';          \
                 if [ ! -d include ]; then                               \
                         mkdir -p include;                               \
                 fi;                                                     \
                 ln -fsn asm-x86 include/asm;                              \
         fi
mkdir -p .tmp_versions
make -f scripts/Makefile.build obj=scripts/basic
make -f scripts/Makefile.build obj=.
mkdir -p kernel/
mkdir -p arch/x86/kernel/
make -f scripts/Makefile.build obj=. missing-syscalls
   /bin/bash scripts/checksyscalls.sh gcc -Wp,-MD,./.missing-syscalls.d 
  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.2.3/include 
-D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Os   -fno-stack-protector -m64 
-march=k8 -mno-red-zone -mcmodel=kernel -funit-at-a-time 
-maccumulate-outgoing-args -fstack-protector -DGCC_HAS_SP 
-fstack-protector-all   -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Iinclude/asm-x86/mach-default -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -pg -Wdeclaration-after-statement 
-Wno-pointer-sign     -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)" 
-D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)"
make -f scripts/Makefile.build obj=scripts
make -f scripts/Makefile.build obj=scripts/mod
make -f scripts/Makefile.build obj=kernel kernel/panic.o
   gcc -Wp,-MD,kernel/.panic.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.2.3/include -D__KERNEL__ -Iinclude 
-include include/linux/autoconf.h  -Wall -Wundef -Wstrict-prototypes 
-Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Os   -fno-stack-protector -m64 
-march=k8 -mno-red-zone -mcmodel=kernel -funit-at-a-time 
-maccumulate-outgoing-args -fstack-protector -DGCC_HAS_SP 
-fstack-protector-all   -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Iinclude/asm-x86/mach-default -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -pg -Wdeclaration-after-statement 
-Wno-pointer-sign     -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(panic)" 
-D"KBUILD_MODNAME=KBUILD_STR(panic)" -c -o kernel/panic.o kernel/panic.c
