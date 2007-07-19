Return-Path: <linux-kernel-owner+w=401wt.eu-S1765462AbXGSWiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765462AbXGSWiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 18:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbXGSWiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 18:38:09 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:59798 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228AbXGSWiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 18:38:07 -0400
Date: Thu, 19 Jul 2007 18:32:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, sparclinux@vger.kernel.org
Subject: Re: Powerpc - Include pagemap.h in asm/powerpc/tlb.h
Message-ID: <20070719223254.GA30383@Krystal>
References: <20070714012033.GC31649@Krystal> <20070718223034.7388e59f.akpm@linux-foundation.org> <D9805F9D-04B0-4422-81F1-958B15482A93@kernel.crashing.org> <20070719131348.170443bb.akpm@linux-foundation.org> <E7820A72-36A3-4B4D-A497-974409D3EBDE@kernel.crashing.org> <20070719143020.5e0b7474.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070719143020.5e0b7474.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:17:57 up 2 days, 16:52,  2 users,  load average: 0.68, 0.31, 0.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 19 Jul 2007 16:04:38 -0500
> Kumar Gala <galak@kernel.crashing.org> wrote:
> 
> > >> Andrew,
> > >>
> > >> Are you sending this to linus directly or should this go via paul and
> > >> me?
> > >>
> > >
> > > I queued it up for Paul.  I can send it over to Linus today if we  
> > > have a
> > > reason for that.  It's just that I dont understand the patch: does  
> > > it fix
> > > -mm-only breakage?  Does it fix something which already got fixed,  
> > > or what?
> > 
> > I'm seeing the same breakage in my tree.
> 
> Oh, OK.  Let's just merge it.
> 
> > > One might think "gee, it's trivial, just slam it in", but these nested
> > > includes are often not-trivial and something else can explode as a  
> > > result.
> > 
> > I'll do a git-bisect and see if I can find the patch that causes this  
> > breakage so we know what's going on.
> 
> eh, don't bother.

Hrm, I still think it's kind of interesting to see what happens there.

So the sane way to make sure it's fixed would be to turn the macros
free_page_and_swap_cache() and free_pages_and_swap_cache() into an
inline function (just to make sure the compiler complains), but that
would require to include linux/pagemap.h from linux/swap.h. But let's
just see what happens on sparc if we include linux/pagemap.h from
swap.h.

I just tested compiling on sparc, here is the result:


  /opt/crosstool/gcc-4.1.1-glibc-2.3.6/sparc-unknown-linux-gnu/bin/sparc-unknown-linux-gnu-gcc -Wp,-MD,init/.main.o.d  -nostdinc -isystem /opt/crosstool/gcc-4.1.1-glibc-2.3.6/sparc-unknown-linux-gnu/lib/gcc/sparc-unknown-linux-gnu/4.1.1/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/autoconf.h -I/home/compudj/git/linux-2.6-lttng/init -Iinit -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os -m32 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7 -fomit-frame-pointer -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(main)"  -D"KBUILD_MODNAME=KBUILD_STR(main)" -c -o init/.tmp_main.o /home/compudj/git/linux-2.6-lttng/init/main.c
In file included from /home/compudj/git/linux-2.6-lttng/include/linux/highmem.h:24,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:10,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/swap.h:9,
                 from include2/asm/pgtable.h:15,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/mm.h:38,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/rmap.h:9,
                 from /home/compudj/git/linux-2.6-lttng/init/main.c:49:
include2/asm/highmem.h: In function 'kmap':
include2/asm/highmem.h:60: error: implicit declaration of function 'PageHighMem'
include2/asm/highmem.h:61: error: implicit declaration of function 'page_address'
include2/asm/highmem.h:61: warning: return makes pointer from integer without a cast
In file included from /home/compudj/git/linux-2.6-lttng/include/linux/swap.h:9,
                 from include2/asm/pgtable.h:15,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/mm.h:38,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/rmap.h:9,
                 from /home/compudj/git/linux-2.6-lttng/init/main.c:49:
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h: In function 'linear_page_index':
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:153: error: dereferencing pointer to incomplete type
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:154: error: dereferencing pointer to incomplete type
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h: In function 'lock_page':
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:168: error: implicit declaration of function 'TestSetPageLocked'
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h: In function 'wait_on_page_locked':
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:198: error: implicit declaration of function 'PageLocked'
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:199: error: 'PG_locked' undeclared (first use in this function)
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:199: error: (Each undeclared identifier is reported only once
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:199: error: for each function it appears in.)
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h: In function 'wait_on_page_writeback':
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:207: error: implicit declaration of function 'PageWriteback'
/home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:208: error: 'PG_writeback' undeclared (first use in this function)
In file included from /home/compudj/git/linux-2.6-lttng/include/linux/rmap.h:9,
                 from /home/compudj/git/linux-2.6-lttng/init/main.c:49:
/home/compudj/git/linux-2.6-lttng/include/linux/mm.h: At top level:
/home/compudj/git/linux-2.6-lttng/include/linux/mm.h:605: error: conflicting types for 'page_address'
include2/asm/highmem.h:61: error: previous implicit declaration of 'page_address' was here

PageHighMem is declared in linux/page-flags.h, which is included in
linux/mm.h with the following comment:

/*
 * FIXME: take this include out, include page-flags.h in
 * files which need it (119 of them)
 */
#include <linux/page-flags.h>

(linux/mm.h is included from linux/highmem.h)

Actually, we get a circular inclusion there:

In file included from /home/compudj/git/linux-2.6-lttng/include/linux/highmem.h:24,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/pagemap.h:10,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/swap.h:9,
                 from include2/asm/pgtable.h:15,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/mm.h:38,
                 from /home/compudj/git/linux-2.6-lttng/include/linux/rmap.h:9,
                 from /home/compudj/git/linux-2.6-lttng/init/main.c:49:


mm.h includes asm-sparc/pgtable.h includes linux/swap.h includes
linux/pagemap.h (which I have added myself) includes linux/highmem.h
includes mm.h.....

Is it me or it all looks like a fubarish mess ? :(

Why is asm-sparc/pgtable.h including linux/swap.h ? Perharps the sparc
devs will be able to enlighten us...

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
