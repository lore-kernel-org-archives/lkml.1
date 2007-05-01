Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXEAT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXEAT7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXEAT7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:59:16 -0400
Received: from echo.digadd.de ([195.47.195.234]:58507 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062AbXEAT7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:59:13 -0400
X-Greylist: delayed 1656 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 15:59:13 EDT
Message-ID: <4637958F.5010405@digadd.de>
Date: Tue, 01 May 2007 21:31:27 +0200
From: Christian Schmidt <lkml@digadd.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070425)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Memory consumption on linux
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I could not find good documentation anywhere on the memory usage of
linux, or rather, how to interpret the output of the various tools
dealing with memory consumption.

First of, generally - there's resident, virtual and shared memory for
each process, and global buffers/cache.

Global cache is easy to understand - file system / inode caches. What
exactly is buffers, though?

How do virtual, resident and shared memory relate to each other, though?
>From my observation I assume:
- Virtual: All of the memory the program has allocated, including
overcommitted heap
- Resident: The actually used memory, including mmap()ed files whether
they are locked into memory or not (?)
- Shared: Dynamic libraries that are shared among multiple programs,
shared memory, and mmap()ed files

How are mmap()ed files handled in the global scheme of the kernel memory
management anyway? It seems they are not deducted from the globally
available memory unless explicitly locked with MAP_LOCKED?

And, how does process memory relate to system memory? Usually the sum of
the resident memory (ps -o rss) is way off from the used memory
displayed by free. I'm posting data from two machines down below, where
you can see discrepancies in either direction, in one case 2G more free
than resident, in the other case 60M less.

Is there a way to get more detailed information on process and kernel
memory usage? I assume that dm-crypto and software-raid use memory that
does not show up anywhere.

Best regards,
Christian

one machine (sum > free):
free:
            total       used       free     shared    buffers     cached
Mem:      4109304    4045820      63484          0     350264    3048268
-/+ buffers/cache:    647288    3462016
swap:      1953120      2724    1950396

ps -aeo rss | awk '{sum+=$1} END {print sum}'
2611756

top (sorted by memory usage, top 4 processes)
Mem:   4109304k total,  4045196k used,    64108k free,   350268k buffers
Swap:  1953120k total,     2724k used,  1950396k free,  3048268k cached
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND


29587 micki     15   0 2033m 1.1g 957m S  135 27.3  28566:57 dynamips

27672 micki     15   0 1981m 1.1g 957m S  158 26.8  31142:47 dynamips

29244 vmware     5 -10  381m 288m 277m S    1  7.2   1169:27 vmware-vmx


24278 root      15   0 19056  14m 4244 S    0  0.4   9:15.99 vmware-serv

dynamips and vmware both mmap() the ram of the emulated machines
(dynamips emulates cisco routers). Still, obviously the majority of the
resident memory is "free", or rather "cached".

another machine (sum < free):
free:
            total       used       free     shared    buffers     cached
Mem:      1024752     978896      45856          0      16768     250908
-/+ buffers/cache:    711220     313532
Swap:           0          0          0

[~]>ps -aeo rss | awk '{sum+=$1} END {print sum}'
658032

top (sorted by memory usage, top 8 processes):
Mem:   1024752k total,   978612k used,    46140k free,    16576k buffers
Swap:        0k total,        0k used,        0k free,   250876k cached
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND

 7217 root      16   0  479m 472m  728 S  0.0 47.2   0:04.17 rpc.mountd

 1699 bofh      15   0 52140  30m 1792 S  0.0  3.0   0:27.46 imapd

 5663 mysql     16   0  146m  29m 5052 S  0.0  3.0   0:05.41 mysqld

 5804 root      16   0  117m  18m 6788 S  0.0  1.8   0:01.30 apache2

12535 apache    18   0  334m  13m 1864 S  0.0  1.4   0:00.00 apache2

12533 apache    18   0  334m  13m 1860 S  0.0  1.4   0:00.00 apache2

12511 apache    18   0  117m  12m  856 S  0.0  1.2   0:00.00 apache2

18861 named     25   0 47592 5976 2128 S  0.0  0.6   0:42.23 named



