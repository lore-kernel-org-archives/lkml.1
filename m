Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYL0JWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYL0JWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYL0JWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:22:33 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:50639 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYL0JWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:22:32 -0500
Date: Sat, 27 Dec 2008 10:24:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, kenchen@google.com,
       paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
Message-ID: <20081227092404.GA10375@uranus.ravnborg.org>
References: <20081222230035.GB4074@uranus.ravnborg.org> <20081222151338.3b6ef997.akpm@linux-foundation.org> <20081223131746.GA7456@uranus.ravnborg.org> <20081227.005452.261413194.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081227.005452.261413194.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 12:54:52AM -0800, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Tue, 23 Dec 2008 14:17:46 +0100
> 
> > It may take a few days before the drivers gets fixed.
> > Christmas is approaching fast by now.
> 
> Even with this and your driver patch applied, the tree
> doesn't build successfully:
> 
> cc1: warnings being treated as errors
> arch/sparc/kernel/psycho_common.c: In function ‘psycho_check_stc_error’:
> arch/sparc/kernel/psycho_common.c:104: warning: format ‘%016lx’ expects type ‘long unsigned int’, but argument 4 has type ‘long long unsigned int’
> 
> Did you remove sparc's -Werror when doing test builds
> of these changes? :-)
No - it is worse than that.
My gcc does not complain about the above.

Just to check that I was not fouled by some preprocessor magic
here is the preprocessed code:

   printk("<3>" "%s: STC_TAG(%d)[PA(%016lx)VA(%08lx)"
          "V(%d)W(%d)]\n",
          pbm->name,
          i,
          ((tagval & 0x0fffffff00000000UL) >> 19UL),
          (tagval & 0x00000000ffffe000UL),
          ((tagval & 0x0000000000000002UL) ? 1 : 0),
          ((tagval & 0x0000000000000001UL) ? 1 : 0));


tagval is u64.

So it looks like my gcc does not promote:
((tagval & 0x0fffffff00000000UL) >> 19UL) to unsigned long long int
but your gcc does?

My gcc (build with Dan Kegel's crosstool):
$ /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc -v
Reading specs from /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/lib/gcc/sparc64-unknown-linux-gnu/3.4.5/specs
Configured with: /home/sam/devel/crosstool-0.43/build/sparc64-unknown-linux-gnu/gcc-3.4.5-glibc-2.3.6/gcc-3.4.5/configure --target=sparc64-unknown-linux-gnu --host=i686-host_pc-linux-gnu --prefix=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu --disable-multilib --with-cpu=ultrasparc3 --enable-cxx-flags=-mcpu=ultrasparc3 --with-headers=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/sparc64-unknown-linux-gnu/include --with-local-prefix=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/sparc64-unknown-linux-gnu --disable-nls --enable-threads=posix --enable-symvers=gnu --enable-__cxa_atexit --enable-languages=c --enable-shared --enable-c99 --enable-long-long
Thread model: posix
gcc version 3.4.5

> 
> Either way these need some work before they should be
> added to any tree.
> 
> Andrew you probably want to toss these from your tree
> since at a minimum they will break the sparc64 build.
> 
> Sam will fix them up and resubmit, and I'll apply them,
> don't worry. :)
Yup - I added Andrew on cc: only as information.

	Sam
