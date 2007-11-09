Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbXKIFcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbXKIFcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 00:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXKIFcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 00:32:25 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49238 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXKIFcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 00:32:24 -0500
Date: Thu, 8 Nov 2007 21:28:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: sam@ravnborg.org
Cc: werner <werner@copaya.yi.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       herbert@gondor.apana.org.au
Subject: Re: Fwd: same problem with 2.6.24-rc2
Message-Id: <20071108212819.a04c65e9.randy.dunlap@oracle.com>
In-Reply-To: <4732B53C.2050509@oracle.com>
References: <1194501449.25336@copaya.yi.org>
	<4732B53C.2050509@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Nov 2007 23:05:32 -0800 Randy Dunlap wrote:

Hi Sam,

This is somewhat of a build regression... a confusing one to me.
Maybe you will know what it's up to.


There's also a kernel boot regression: something in
crypto/xor.c::calibrate_xor_blocks() finds a null pointer.
I can't reproduce it.  [more below]

Werner, for the machine that crashes during boot, please send us
the contents of /proc/cpuinfo.  Thanks.

(BTW, for anyone reading along, vger sees Werner's emails as spam,
so you may receive mail directly from him instead of seeing it on
lkml.)


Werner's kernel-build-script is a large multi-purpose script with
package building capability.  He reported the following build output:


> gcc -m32 -m elf_i386  /usr/src/linux-2.6.24-rc2-i486-1mn/arch/x86/Makefile.o   -o /usr/src/linux-2.6.24-rc2-i486-1mn/arch/x86/Makefile
> gcc: /usr/src/linux-2.6.24-rc2-i486-1mn/arch/x86/Makefile.o: No such file or directory
> gcc: no input files
> make: [/usr/src/linux-2.6.24-rc2-i486-1mn/arch/x86/Makefile] Error 1 (ignored)

which I can easily reproduce by doing (at kernel top-level dir):

make defconfig
make -B

This does not happen in 2.6.23.  Instead, that sequence just loops
forever with:  (this is what I get:)

make -f /tester/linsrc/linux-2623-pv/Makefile silentoldconfig
make -f scripts/Makefile.build obj=scripts/basic
mkdir -p include/linux include/config
make -f scripts/Makefile.build obj=scripts/kconfig silentoldconfig
  cat scripts/kconfig/zconf.tab.c_shipped > scripts/kconfig/zconf.tab.c
  cat scripts/kconfig/lex.zconf.c_shipped > scripts/kconfig/lex.zconf.c
  cat scripts/kconfig/zconf.hash.c_shipped > scripts/kconfig/zconf.hash.c
  gcc -Wp,-MD,scripts/kconfig/.zconf.tab.o.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE -Iscripts/kconfig -c -o scripts/kconfig/zconf.tab.o scripts/kconfig/zconf.tab.c
  gcc  -o scripts/kconfig/conf scripts/kconfig/conf.o scripts/kconfig/zconf.tab.o -lncursesw 
scripts/kconfig/conf -s arch/x86_64/Kconfig
make -f /tester/linsrc/linux-2623-pv/Makefile silentoldconfig
make -f scripts/Makefile.build obj=scripts/basic
mkdir -p include/linux include/config
make -f scripts/Makefile.build obj=scripts/kconfig silentoldconfig
  cat scripts/kconfig/zconf.tab.c_shipped > scripts/kconfig/zconf.tab.c
  cat scripts/kconfig/lex.zconf.c_shipped > scripts/kconfig/lex.zconf.c
  cat scripts/kconfig/zconf.hash.c_shipped > scripts/kconfig/zconf.hash.c
  gcc -Wp,-MD,scripts/kconfig/.zconf.tab.o.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE -Iscripts/kconfig -c -o scripts/kconfig/zconf.tab.o scripts/kconfig/zconf.tab.c
  gcc  -o scripts/kconfig/conf scripts/kconfig/conf.o scripts/kconfig/zconf.tab.o -lncursesw 
scripts/kconfig/conf -s arch/x86_64/Kconfig
make -f /tester/linsrc/linux-2623-pv/Makefile silentoldconfig
make -f scripts/Makefile.build obj=scripts/basic
mkdir -p include/linux include/config

...

I suppose we could argue that the 2.6.24-rcN handling is better than
the 2.6.23 handling.  Werner does not report any problems like this
with 2.6.23, so he's not reporting what I am seeing.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pasted from earlier email from Werner (typed in):

2.6.24-rc1-git10
EIP 0600: <c0407284> EFLAGS 00010212 CPU 0
EIUP is at xor_sse_2+0x34/0x200
EAX: 10 EBX fffedb22 ECX c183f000 EDX c183c000 ESS 8005003b EDI c0929614 EBP c183f000 ESP c1823ef0   
DS 7b ES 7b FS d8 GS 0 SS 68
Process swapper  pid 1  ti: c182200  task c1820000 task.ti c=1822000
Stack:  8x 0    8x 0   fffedb22  0  c04067b3  10  c0849b62  c1030780  c183f000  c183c000
call trace
c0 4067b3 do_xor_speed+0x53/0xd0
   9a9582 calibrate_xor_blocks 0xe2/0x100 (or 1a0 ?)
  191594  register_filesystem =0X44/0X70
  991565 kernel_init+0x125/0x2f0
   10420a  ret_from_fork +0x6/0x1c  (or 0xb ...)
  991440 kernel_init+0x0/0x2f0
       " again
   c0104edf  kernel_thread_helper+0x7/0x18
code  08 89 74 24 44 0f 20 cf 0f 06 (or 0b) 0f 11 04 24 0f 11 4c 34 10 0f 11 54 24 20 0f 11 5c 24 30 0f 18 82 00
01 00 00 0f 18 82 20 01 00 00 <00> 20x 0
EIP c0407284 xor_sse_2+0x34/0x200 SS ESP 068: c1823ef0
kernel panic


and later:

> With 2.6.23-rc2 is the same problem:  it crashed at the beginning:  EIP 060 c03fdea4
> EFLAGS 00010212 EIP is at xor_sse_2+0x34/0x200

---
~Randy
