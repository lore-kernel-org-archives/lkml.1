Return-Path: <linux-kernel-owner+w=401wt.eu-S932727AbZLMBRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbZLMBRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932680AbZLMBRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:17:12 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:42084 "HELO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932246AbZLMBRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:17:09 -0500
Message-ID: <4B243B2B.806@pardus.org.tr>
Date: Sun, 13 Dec 2009 02:54:03 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Poor KVM guest performance on an HP rack server
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have an HP Proliant DL580G5 rack server. It has 4 Intel Xeon X7460(6
core, 2.67GHz, 16MB L3) processor with 32GB of memory. /proc/cpuinfo has
24 x the following entry:

processor       : 23
vendor_id       : GenuineIntel
cpu family      : 6
model           : 29
model name      : Intel(R) Xeon(R) CPU X7460  @ 2.66GHz
stepping        : 1
cpu MHz         : 2666.891
cache size      : 16384 KB
physical id     : 3
siblings        : 6
core id         : 5
cpu cores       : 6
apicid          : 29
initial apicid  : 29
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc arch_perfmon pebs bts xtopology pni dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm tpr_shadow vnmi
flexpriority
bogomips        : 5333.59
clflush size    : 64

---

I'm running 2.6.30.9-pae on top of it. We were actually planning to use
it for a virtualization server for giving people dedicated *guest*
access for their personal compile-farm needs.

For testing purposes, we created a guest VM (2.6.30.9 too) on top of it
with 2GB of virtual memory stored in a raw partition:

qemu-kvm -cpu host -smp 2 -m 2047 -drive
file=/dev/cciss/c1d0p1,if=virtio,cache=none,boot=on -net
nic,model=virtio,macaddr=DE:AD:BE:EF:10:28 -net
tap,ifname=tap0,script=/usr/bin/qemu-ifup -k tr -nographic -daemonize


The problem is that I'm seeing very poor performance within the guest.
I've googled a bit and seen similar bug reports/discussions ending with
some tweaks (setting rotational to 1 for virtio_blk, using cache=none,
etc.) and an explanation from Avi Kivity about the bad scalability of
KVM on pre-Nehalem boxes under high build load.

But I fear that I'm far behind that *bad scalability*. I've made some
comparisons with my QuadCore Q8300 (2MB cache) box. I won't give the
whole numbers but for example,

Running the autotools configure script of CUPS on that KVM guest (I can
easily follow the output of configure line per line, it really really
waits on some checks):

real    0m52.876s
user    0m4.892s
sys     0m55.705s

On the host (while running the guest vm):

real    0m8.193s
user    0m3.099s
sys     0m4.055s

On the quadcore box:

real    0m8.424s
user    0m2.651s
sys     0m2.879s

Both with cold cache (echo 3 > /proc/sys/vm/drop_caches)

So it's not even a high build load. I've tried with -smp 8 (which showed
worse numbers than -smp 2 and 4), with IDE instead of virtio, without
-cpu host parameter but can't get near 30 (I've got 35 seconds with
tuning read_ahead_kb, on top of IDE instead of virtio, etc.) seconds at all.

I've also tried hugetlbfs for backing the memory within the guest.

I'm using the latest kvm-mod-2.6.32 built on top of 2.6.30.9.

So is this huge performance difference should be accepted as normal or
am I missing some big things?


Thanks a lot
Ozan Caglayan
