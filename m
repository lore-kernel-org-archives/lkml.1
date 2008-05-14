Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbYENLVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbYENLVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbYENLVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:21:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40209 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbYENLVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:21:11 -0400
Message-ID: <482ACB24.5080400@firstfloor.org>
Date: Wed, 14 May 2008 13:21:08 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] common implementation of iterative div/mod
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>	<481DF3D8.3010108@shaw.ca>	<a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>	<48217674.8080903@goop.org>	<48231959.4050406@goop.org> <20080513234627.30476c20.akpm@linux-foundation.org> <482A95BB.1000001@goop.org> <482AA3BD.1030600@firstfloor.org> <482AB6FC.7020202@goop.org> <482AC3E4.2050200@firstfloor.org> <482AC467.1060100@goop.org>
In-Reply-To: <482AC467.1060100@goop.org>
Content-Type: multipart/mixed;
 boundary="------------050303090404070208090908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050303090404070208090908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


> It's:
> jeremy@cosworth:~/hg/xen/paravirt/linux-x86_64$ gcc -v
> Reading specs from /usr/lib/gcc/x86_64-linux/3.4.4/specs
> Configured with: ../src/configure -v
> --enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr
> --libexecdir=/usr/lib --with-gxx-include-dir=/usr/include/c++/3.4
> --enable-shared --with-system-zlib --enable-nls
> --without-included-gettext --program-suffix=-3.4 --enable-__cxa_atexit
> --enable-libstdcxx-allocator=mt --enable-clocale=gnu
> --enable-libstdcxx-debug --enable-java-gc=boehm --enable-java-awt=gtk
> --disable-werror x86_64-linux
> Thread model: posix
> gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13)
> 
> I think this is still a supported compiler, isn't it?

Yes. Here's a patch. You probably didn't see problems because you either
don't have a glibc that supports the vdso or none of your programs
gets the timezone from gettimeofday() [that is very obscure obsolete
functionality anyways, normally it should be gotten from the disk locales]

-Andi





--------------050303090404070208090908
Content-Type: text/plain;
 name="vdso-explicit-copy"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vdso-explicit-copy"

Use explicit copy in vdso_gettimeofday()

Jeremy's gcc 3.4 seems to be unable to inline a 8 byte memcpy. But
the vdso doesn't support external references. Copy the structure
members of struct timezone explicitely instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/arch/x86/vdso/vclock_gettime.c
===================================================================
--- linux.orig/arch/x86/vdso/vclock_gettime.c
+++ linux/arch/x86/vdso/vclock_gettime.c
@@ -106,9 +106,9 @@ int __vdso_gettimeofday(struct timeval *
 		do_realtime((struct timespec *)tv);
 		tv->tv_usec /= 1000;
 		if (tz != NULL) {
-			/* This relies on gcc inlining the memcpy. We'll notice
-			   if it ever fails to do so. */
-			memcpy(tz, &gtod->sys_tz, sizeof(struct timezone));
+			/* Don't use memcpy. Some old compilers fail to inline it */
+			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
+			tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
 		}
 		return 0;
 	}

--------------050303090404070208090908--
