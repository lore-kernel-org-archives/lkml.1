Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYEWVyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYEWVyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 17:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbYEWVyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 17:54:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:49234 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812AbYEWVyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 17:54:14 -0400
In-Reply-To: <20080523095623.5678a34f.akpm@linux-foundation.org>
References: <48313D8E.7020109@de.ibm.com> <20080523011213.690363c7.akpm@linux-foundation.org> <ab1f935148982762bae55734ffb8acc7@kernel.crashing.org> <20080523095623.5678a34f.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7b1023f2a9cf769f8bc047c0116be9dd@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>, ltp-coverage@lists.sourceforge.net
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/7] gcov kernel support
Date: Fri, 23 May 2008 23:52:43 +0200
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sounds like your toolchain was built without biarch support, but  
>> you're
>> using it for the 32-bit parts of the kernel anyway.  Which works as  
>> long
>> as you're not using any libraries, but now you need libgcov.a .
>
> ok..
>
>> What does
>>
>> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/bin/
>> powerpc64-unknown-linux-gnu-gcc -v
>>
>> say?
>
> y:/home/akpm>  
> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/bin/ 
> powerpc64-unknown-linux-gnu-gcc -v
> Using built-in specs.
> Target: powerpc64-unknown-linux-gnu
> Configured with:  
> /home/axboe/crosstool-0.43/build/powerpc64-unknown-linux-gnu/gcc 
> -4.1.0-glibc-2.3.6/gcc-4.1.0/configure  
> --target=powerpc64-unknown-linux-gnu  
> --host=x86_64-host_unknown-linux-gnu  
> --prefix=/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux- 
> gnu

> --disable-multilib

That's the culprit.  I believe 4.1.0 enables multilib by default on  
PowerPC
compilers that target 64-bit by default (the patch for that is dated  
almost
a full year before the 4.1.0 release).  I have no idea why crosstool
disables this support; perhaps there were some problems with some older
GCC version (or this one, even; it's ancient as well).

>> Or, what does
>>
>> find
>> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/ 
>> 4.1.0/
>> -name libgcov.a
>>
>> say?  (It should usually find three versions: 64-bit, 32-bit, 32-bit  
>> no
>> float).
>
> Only a single hit:

Right, as expected.

>> You *can* build with a non-biarch compiler, but then you need to point
>> the kernel build system at a 32-bit toolchain to use for the 32-bit
>> parts (via CROSS32_COMPILE).
>
> Jens built this one, using crosstool.  It is
> http://userweb.kernel.org/~akpm/cross-compilers/power64-cross.tar.bz2
>
> It was all working happily until gcov came along :(

You were lucky, yes.  If your compiler would have been just a little
bit older it wouldn't have been able to build 32-bit at all.

Do you have a separate 32-bit PowerPC compiler?  If so, just set
CROSS32_COMPILE to it; if not, you'll need a new toolchain.  In
that case, it's probably worthwhile to upgrade to 4.1.2 at least...


Segher

