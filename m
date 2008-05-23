Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYEWQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYEWQ6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYEWQ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:58:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYEWQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:58:11 -0400
Date: Fri, 23 May 2008 09:56:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>, ltp-coverage@lists.sourceforge.net
Subject: Re: [PATCH 0/7] gcov kernel support
Message-Id: <20080523095623.5678a34f.akpm@linux-foundation.org>
In-Reply-To: <ab1f935148982762bae55734ffb8acc7@kernel.crashing.org>
References: <48313D8E.7020109@de.ibm.com>
	<20080523011213.690363c7.akpm@linux-foundation.org>
	<ab1f935148982762bae55734ffb8acc7@kernel.crashing.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 13:06:00 +0200 Segher Boessenkool <segher@kernel.crashing.org> wrote:

> >> This is version #2 of the gcov kernel support patch set
> >
> > powerpc blew up:
> >
> > /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/ 
> > gcc/powerpc64-unknown-linux-gnu/4.1.0/../../../../powerpc64-unknown- 
> > linux-gnu/bin/ld: skipping incompatible  
> > /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/ 
> > gcc/powerpc64-unknown-linux-gnu/4.1.0/./libgcov.a when searching for  
> > -lgcov
> > /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/ 
> > gcc/powerpc64-unknown-linux-gnu/4.1.0/../../../../powerpc64-unknown- 
> > linux-gnu/bin/ld: cannot find -lgcov
> > collect2: ld returned 1 exit status
> > make[2]: *** [arch/powerpc/kernel/vdso32/vdso32.so.dbg] Error 1
> > make[1]: *** [arch/powerpc/kernel/vdso32] Error 2
> 
> Sounds like your toolchain was built without biarch support, but you're
> using it for the 32-bit parts of the kernel anyway.  Which works as long
> as you're not using any libraries, but now you need libgcov.a .

ok..

> What does
> 
> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/bin/ 
> powerpc64-unknown-linux-gnu-gcc -v
> 
> say?

y:/home/akpm> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/bin/powerpc64-unknown-linux-gnu-gcc -v
Using built-in specs.
Target: powerpc64-unknown-linux-gnu
Configured with: /home/axboe/crosstool-0.43/build/powerpc64-unknown-linux-gnu/gcc-4.1.0-glibc-2.3.6/gcc-4.1.0/configure --target=powerpc64-unknown-linux-gnu --host=x86_64-host_unknown-linux-gnu --prefix=/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu --disable-multilib --with-sysroot=/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/powerpc64-unknown-linux-gnu/sys-root --with-local-prefix=/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/powerpc64-unknown-linux-gnu/sys-root --disable-nls --enable-threads=posix --enable-symvers=gnu --enable-__cxa_atexit --enable-languages=c --enable-shared --enable-c99 --enable-long-long
Thread model: posix
gcc version 4.1.0

>  (Or whatever the correct path to that compiler is, the directory
> structure is a bit unusual here it seems).  There shouldn't be a
> --disable-biarch there.
> 
> Or, what does
> 
> find  
> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/4.1.0/  
> -name libgcov.a
> 
> say?  (It should usually find three versions: 64-bit, 32-bit, 32-bit no  
> float).

Only a single hit:

/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/gcc/powerpc64-unknown-linux-gnu/4.1.0/libgcov.a

and it contains

y:/home/akpm/ppc> ar x libgcov.a 
y:/home/akpm/ppc> l
total 316
-rw-r--r-- 1 akpm akpm  44192 May 23 09:53 _gcov.o
-rw-r--r-- 1 akpm akpm   8448 May 23 09:53 _gcov_execl.o
-rw-r--r-- 1 akpm akpm   8584 May 23 09:53 _gcov_execle.o
-rw-r--r-- 1 akpm akpm   8456 May 23 09:53 _gcov_execlp.o
-rw-r--r-- 1 akpm akpm   7384 May 23 09:53 _gcov_execv.o
-rw-r--r-- 1 akpm akpm   7544 May 23 09:53 _gcov_execve.o
-rw-r--r-- 1 akpm akpm   7392 May 23 09:53 _gcov_execvp.o
-rw-r--r-- 1 akpm akpm   7264 May 23 09:53 _gcov_fork.o
-rw-r--r-- 1 akpm akpm   7240 May 23 09:53 _gcov_interval_profiler.o
-rw-r--r-- 1 akpm akpm   7464 May 23 09:53 _gcov_merge_add.o
-rw-r--r-- 1 akpm akpm   8544 May 23 09:53 _gcov_merge_delta.o
-rw-r--r-- 1 akpm akpm   8488 May 23 09:53 _gcov_merge_single.o
-rw-r--r-- 1 akpm akpm   6976 May 23 09:53 _gcov_one_value_profiler.o
-rw-r--r-- 1 akpm akpm   6856 May 23 09:53 _gcov_pow2_profiler.o
-rw-r--r-- 1 akpm akpm 146492 May 23 09:52 libgcov.a
y:/home/akpm/ppc> file _gcov_merge_delta.o
_gcov_merge_delta.o: ELF 64-bit MSB relocatable, 64-bit PowerPC or cisco 7500, version 1 (SYSV), not stripped

> 
> You *can* build with a non-biarch compiler, but then you need to point
> the kernel build system at a 32-bit toolchain to use for the 32-bit
> parts (via CROSS32_COMPILE).

Jens built this one, using crosstool.  It is
http://userweb.kernel.org/~akpm/cross-compilers/power64-cross.tar.bz2

It was all working happily until gcov came along :(
