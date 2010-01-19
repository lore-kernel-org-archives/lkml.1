Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948Ab0ASNu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0ASNu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 08:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639Ab0ASNu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 08:50:56 -0500
Received: from mail2.picochip.com ([82.111.145.34]:58602 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548Ab0ASNuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 08:50:55 -0500
Date: Tue, 19 Jan 2010 13:51:45 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jamie Iles <jamie.iles@picochip.com>, linux-perf-users@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Analysing an ARM perf.data file on a x86-64 workstation
Message-ID: <20100119135145.GG4167@wear.picochip.com>
References: <20100108123035.GA7485@ghostprotocols.net> <20100108124244.GO4179@wear.picochip.com> <20100108125521.GB7485@ghostprotocols.net> <20100118163332.GA5789@wear.picochip.com> <20100118171035.GD14636@ghostprotocols.net> <20100118202451.GA4167@wear.picochip.com> <20100119000134.GE14636@ghostprotocols.net> <20100119000345.GF14636@ghostprotocols.net> <20100119091231.GC4167@wear.picochip.com> <20100119130958.GG14636@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119130958.GG14636@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Tue, 19 Jan 2010 13:50:27 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, Jan 19, 2010 at 11:09:58AM -0200, Arnaldo Carvalho de Melo wrote:
> CCing linux-perf-users, this may be interesting when investigating
> similar problems for other arches.
> 
> Thanks James, got the vmlinux file and and already found and fixed two
> bugs, patches sent CCed to you.
> 
> Ok, now how does it look like?
Well, with both patches applied, I still don't see any kernel symbols in perf
top (even the raw addresses) or resolved names in report if I specify a
vmlinux or if one gets autodetected.

For example, when keeping the CPU busy with 'dd if=/dev/zero of=/dev/null', If
I record with 'perf record -af -- sleep 1' then:

root@picopc7302:~# ./perf record -af -- sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.071 MB perf.data (~3092 samples) ]
root@picopc7302:~# ./perf report --vmlinux=/tmp/vmlinux -v | head -10
no symbols found in /bin/busybox, maybe install a debug package?
# Samples: 435596970
#
# Overhead          Command           Shared Object  Symbol
# ........  ...............  ......................  ......
#   
    81.14%               dd                c0020ac8  0x00000000c0020ac8 ! [k] 0x000000c0020ac8
     9.26%             perf                c0071bfc  0x00000000c0071bfc ! [k] 0x000000c0071bfc
     3.53%               dd  /bin/busybox            0x000000000001d6f4 K [.] 0x0000000001d6f4
     1.55%            sleep                c006c3a0  0x00000000c006c3a0 ! [k] 0x000000c006c3a0
     1.38%               dd  /lib/libc-2.8.so        0x00000000000b4a2c d [.] __GI___libc_read
root@picopc7302:~# mv /boot/vmlinux /boot/vmlinux
root@picopc7302:~# mv /boot/vmlinux /boot/v
root@picopc7302:~# ./perf report -v | head -10
Looking at the vmlinux_path (5 entries long)
no symbols found in /bin/busybox, maybe install a debug package?
# Samples: 435596970
#
# Overhead          Command           Shared Object  Symbol
# ........  ...............  ......................  ......
#   
    32.57%               dd  [kernel.kallsyms]       0x00000000c02aaef0 k [k] _raw_spin_unlock_irqrestore
    12.30%               dd  [kernel.kallsyms]       0x00000000c006b5c4 k [k] lock_acquire
     6.23%               dd  [kernel.kallsyms]       0x00000000c006c220 k [k] lock_release
     5.38%               dd  [kernel.kallsyms]       0x00000000c006b9f0 k [k] lock_acquired
     5.04%               dd  [kernel.kallsyms]       0x00000000c0020ac8 k [k] vector_swi
> 
[snip]
> 
> But what about the other addresses for [k]ernel space perf hits such as
> 0xc0020ac4, 0xc0068f48, etc?
> 
> 0xc0020ac4 is around here:
> 
>    385: 00000000     0 FILE    LOCAL  DEFAULT  ABS process.c
> <SNIP>
>    411: c0020aa0    40 FUNC    LOCAL  DEFAULT    3 default_idle
>    412: c0020ac8     0 NOTYPE  LOCAL  DEFAULT    3 $a
> 
> so its well possible that this is really a very idle machine, right?
Yes, the run I sent you was pretty much just idling away.

Jamie
