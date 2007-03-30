Return-Path: <linux-kernel-owner+w=401wt.eu-S1945964AbXC3K3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945964AbXC3K3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 06:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945968AbXC3K3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 06:29:41 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53099 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945964AbXC3K3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 06:29:39 -0400
Message-ID: <460CE683.700@hitachi.com>
Date: Fri, 30 Mar 2007 19:29:23 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 1/4] coredump: add an interface to control the core dump
    routine
References: <20070329104936.GC5138@ucw.cz> <45E7AAFA.4070402@hitachi.com> 
    <45E7AC6F.8080704@hitachi.com> <20070302093419.GA2001@elf.ucw.cz> 
    <4607C47B.2030909@hitachi.com> <11911.1175195819@redhat.com> 
    <20070329141715.71a6abae.akpm@linux-foundation.org>
In-Reply-To: <20070329141715.71a6abae.akpm@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton wrote:

> On Thu, 29 Mar 2007 20:16:59 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
>>Pavel Machek <pavel@ucw.cz> wrote:
>>
>>>>Userland core dumper is useful because it is relatively easy to be
>>>>customized, but its reliability highly depends on the application
>>>>programs.
>>>
>>>Fix userland core dumper to be reliable, then.
>>
>>I don't think it's that easy.  The userland core dumper, as I understand it,
>>has to work *within* an application program (it's a library), thus the
>>application program my scotch the core dumper in a couple of ways:
> 
> That's no longer necessarily true with the recently-added
> dump-to-an-application feature:
> 
> core_pattern:
>   ...
> . If the first character of the pattern is a '|', the kernel will treat
>   the rest of the pattern as a command to run.  The core dump will be
>   written to the standard input of that program instead of to a file.

I think dumping core over a pipe is almost good.  Filtering and writing
out a core by a separete userspace program can be reliable because it is
independent of the failed user process.  But I have one concern; data
transfer over a pipe is slow.  It took 7 seconds to transfer 2GB
anonymous shared memory (detailed at the last of this mail).

In the case of dumping hundreds processes which share giga bytes memory,
it will take a few minutes even if the huge shared memory is not written
to a disk.  If a user wants to restart the failed application as soon
as possible to keep downtime to a minimum, this extra transfer time will
be a barrier.  So I think in-kernel filtering is still needed.


I performed a simple experiment to confirm the transfer speed:
  1. run a program which allocates 2GB anonymous shared memory
  2. the program receives SIGSEGV
  3. core image is generated and passed to tp_pipe(*) over a pipe
  4. tp_pipe reads the pipe and revokes the received data while
     data arrives
  5. tp_pipe logs time of completing the data transfer
  6. repeat 1 to 5 ten times and calculate the average and standard
     deviation

  (*) test program which I prepared for this experiment

Here is the result:
             Average: 7.041 sec
  Standard deviation: 0.903


And cpuinfo and meminfo of my box:

$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Xeon(TM) CPU 3.20GHz
stepping	: 1
cpu MHz		: 3200.343
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl cid cx16 xtpr
bogomips	: 6404.82
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Xeon(TM) CPU 3.20GHz
stepping	: 1
cpu MHz		: 3200.343
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl cid cx16 xtpr
bogomips	: 6400.75
clflush size	: 64
$ cat /proc/meminfo
MemTotal:      8309240 kB
MemFree:       8216036 kB
Buffers:         11888 kB
Cached:          45200 kB
SwapCached:          0 kB
Active:          42324 kB
Inactive:        26008 kB
HighTotal:     7470896 kB
HighFree:      7405504 kB
LowTotal:       838344 kB
LowFree:        810532 kB
SwapTotal:    16386260 kB
SwapFree:     16386260 kB
Dirty:               4 kB
Writeback:           0 kB
AnonPages:       11232 kB
Mapped:           5828 kB
Slab:            11916 kB
SReclaimable:     5604 kB
SUnreclaim:       6312 kB
PageTables:        896 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:  20540880 kB
Committed_AS:    33540 kB
VmallocTotal:   118776 kB
VmallocUsed:      8324 kB
VmallocChunk:   110408 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     2048 kB

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

