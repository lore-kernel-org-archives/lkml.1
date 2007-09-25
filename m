Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbXIYNrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbXIYNrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXIYNrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:47:01 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4557 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbXIYNrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:47:00 -0400
Date: Tue, 25 Sep 2007 14:46:53 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc8-mm1 -- powerpc link failure
Message-ID: <20070925134653.GB8447@shadowen.org>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-rc6-mm1, 2.6.23-rc7-mm1 and 2.6.23-rc8-mm1 all fail to link
correctly on a powerpc machine (elm3b19) in our test grid.  It fails as
below:

    LD      vmlinux.o
  ld: dynreloc miscount for fs/built-in.o, section .opd
  ld: can not edit opd Bad value
  make: *** [vmlinux.o] Error 1

Compiler versions and linker versions as below:

root@elm3b19:~/apw/linux-2.6.22# gcc -v
Using built-in specs.
Target: powerpc-linux-gnu
Configured with: ../src/configure -v
--enable-languages=c,c++,java,f95,objc,ada,treelang --prefix=/usr
--with-gxx-include-dir=/usr/include/c++/4.0.2 --enable-shared
--with-system-zlib --libexecdir=/usr/lib --enable-nls
--without-included-gettext --enable-threads=posix --program-suffix=-4.0
--enable-__cxa_atexit --enable-libstdcxx-allocator=mt
--enable-clocale=gnu --enable-libstdcxx-debug --enable-java-gc=boehm
--enable-java-awt=gtk-default --enable-gtk-cairo
--with-java-home=/usr/lib/jvm/java-1.4.2-gcj-4.0-1.4.2.0/jre
--enable-mpfr --disable-softfloat
--enable-targets=powerpc-linux,powerpc64-linux --with-cpu=default32
--disable-werror --enable-checking=release powerpc-linux-gnu
Thread model: posix
gcc version 4.0.2 20050808 (prerelease) (Ubuntu 4.0.1-4ubuntu9)
root@elm3b19:~/apw/linux-2.6.22# ld -v
GNU ld version 2.16.1 Debian GNU/Linux

As suggested elsewhere I have had a go at tracking this down.  Previous
problems of this kind were introduced as a result of using 'weak'
declarations to provide default implementations.  This investigation led
me to the following commit:

  commit c60473b5d32ea6cf4561232bc852bacd3a513528
  Author: Jiri Kosina <jkosina@suse.cz>
  Date:   Sat Sep 15 01:49:49 2007 +0000

    i386-and-x86_64-randomize-brk

Backing this change out seems to get us past this problem.  If we are to
support compilers of this age, and I believe we currently do, then we
probabally need to avoid the weak declarations and use the Kconfig
system to provide the alternatives here.

Jiri?

-apw
