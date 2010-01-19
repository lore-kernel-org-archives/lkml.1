Return-Path: <linux-kernel-owner+w=401wt.eu-S1752167Ab0ASNKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0ASNKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 08:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760Ab0ASNKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 08:10:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:59508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0ASNKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 08:10:16 -0500
Date: Tue, 19 Jan 2010 11:09:58 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: linux-perf-users@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Analysing an ARM perf.data file on a x86-64 workstation
Message-ID: <20100119130958.GG14636@ghostprotocols.net>
References: <20100108115406.GL4179@wear.picochip.com>
 <20100108123035.GA7485@ghostprotocols.net>
 <20100108124244.GO4179@wear.picochip.com>
 <20100108125521.GB7485@ghostprotocols.net>
 <20100118163332.GA5789@wear.picochip.com>
 <20100118171035.GD14636@ghostprotocols.net>
 <20100118202451.GA4167@wear.picochip.com>
 <20100119000134.GE14636@ghostprotocols.net>
 <20100119000345.GF14636@ghostprotocols.net>
 <20100119091231.GC4167@wear.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119091231.GC4167@wear.picochip.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing linux-perf-users, this may be interesting when investigating
similar problems for other arches.

Thanks James, got the vmlinux file and and already found and fixed two
bugs, patches sent CCed to you.

Ok, now how does it look like?

[acme@doppio linux-2.6-tip]$ perf report -i ~/iles/perf.data --vmlinux ~/iles/vmlinux 
Failed to open /lib/ld-2.8.so, continuing without symbols
Failed to open /root/perf, continuing without symbols
Failed to open /lib/libc-2.8.so, continuing without symbols
# Samples: 40653353521
#
# Overhead          Command      Shared Object  Symbol
# ........  ...............  .................  ......
#
    99.94%          swapper           c0020ac4  [k] 0x000000c0020ac4
     0.04%             perf           c0068f48  [k] 0x000000c0068f48
     0.01%             perf  libc-2.8.so        [.] 0x00000000067198
     0.01%            sleep           c00acb44  [k] 0x000000c00acb44
     0.00%             perf  perf               [.] 0x0000000000265c
     0.00%             perf  ld-2.8.so          [.] 0x00000000015fa8
     0.00%            sleep  ld-2.8.so          [.] 0x00000000008ff0
     0.00%             perf  [kernel.kallsyms]  [k] smp_call_function_single
#
# (For a higher level overview, try: perf report --sort comm,dso)
#
[acme@doppio linux-2.6-tip]$

So we manage to decode at least one kernel entry, yay!

To make sure we really did it right, we can use -v to show the address
too:

[acme@doppio linux-2.6-tip]$ perf report -v -i ~/iles/perf.data --vmlinux ~/iles/vmlinux 
Failed to open /lib/ld-2.8.so, continuing without symbols
Failed to open /root/perf, continuing without symbols
Failed to open /lib/libc-2.8.so, continuing without symbols
# Samples: 40653353521
#
# Overhead          Command      Shared Object  Symbol
# ........  ...............  .................  ......
#
    99.94%          swapper           c0020ac4  0x00000000c0020ac4 ! [k] 0x000000c0020ac4
     0.04%             perf           c0068f48  0x00000000c0068f48 ! [k] 0x000000c0068f48
     0.01%             perf  /lib/libc-2.8.so   0x0000000000067198 K [.] 0x00000000067198
     0.01%            sleep           c00acb44  0x00000000c00acb44 ! [k] 0x000000c00acb44
     0.00%             perf  /root/perf         0x000000000000265c K [.] 0x0000000000265c
     0.00%             perf  /lib/ld-2.8.so     0x0000000000015fa8 K [.] 0x00000000015fa8
     0.00%            sleep  /lib/ld-2.8.so     0x0000000000008ff0 K [.] 0x00000000008ff0
     0.00%             perf  [kernel.kallsyms]  0x00000000c0068f48 ! [k] smp_call_function_single
#
# (For a higher level overview, try: perf report --sort comm,dso)
#
[acme@doppio linux-2.6-tip]$

Ok, so smp_call_function_single is 0xc0068f48, lets see if that matches
what is in the vmlinux symtab you provided me:

[acme@doppio linux-2.6-tip]$ file ~/iles/vmlinux 
/home/acme/iles/vmlinux: ELF 32-bit LSB executable, ARM, version 1 (SYSV), statically linked, not stripped
[acme@doppio linux-2.6-tip]$ readelf -s ~/iles/vmlinux | grep smp_call_function_single
 57421: c0068f18    60 FUNC    GLOBAL DEFAULT    3 smp_call_function_single
[acme@doppio linux-2.6-tip]$

Ok, it matches, as 0xc0068f18 <= 0xc0068f48 < (0xc0068f18 + 0x60).

But what about the other addresses for [k]ernel space perf hits such as
0xc0020ac4, 0xc0068f48, etc?

0xc0020ac4 is around here:

   385: 00000000     0 FILE    LOCAL  DEFAULT  ABS process.c
<SNIP>
   411: c0020aa0    40 FUNC    LOCAL  DEFAULT    3 default_idle
   412: c0020ac8     0 NOTYPE  LOCAL  DEFAULT    3 $a

so its well possible that this is really a very idle machine, right?

0xc0068f48 is around here:

  7997: 00000000     0 FILE    LOCAL  DEFAULT  ABS up.c
  7998: c0068f18     0 NOTYPE  LOCAL  DEFAULT    3 $a
  7999: c0068f50     0 NOTYPE  LOCAL  DEFAULT    3 $d

0xc00acb44 around here:

 13645: 00000000     0 FILE    LOCAL  DEFAULT  ABS mmap.c
<SNIP>
 13679: c00aca98   216 FUNC    LOCAL  DEFAULT    3 __vma_link_file
 13680: c00acb70     0 NOTYPE  LOCAL  DEFAULT    3 $a
 13681: c00acb70   428 FUNC    LOCAL  DEFAULT    3 unmap_region

We now need to try to investigate why these things are being
misannotated in the symtab.

- Arnaldo
