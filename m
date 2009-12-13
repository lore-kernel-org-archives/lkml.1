Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZLMKNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZLMKNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 05:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZLMKNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 05:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5158 "HELO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751979AbZLMKNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 05:13:43 -0500
Message-ID: <4B24BE52.6060703@redhat.com>
Date: Sun, 13 Dec 2009 12:13:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: Poor KVM guest performance on an HP rack server
References: <4B243B2B.806@pardus.org.tr>
In-Reply-To: <4B243B2B.806@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-MIME-Autoconverted: from 8bit to quoted-printable by mx1.redhat.com id nBDADd67023699
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2009 02:54 AM, Ozan Çağlayan wrote:
> Hi,
>
> We have an HP Proliant DL580G5 rack server. It has 4 Intel Xeon X7460(6
> core, 2.67GHz, 16MB L3) processor with 32GB of memory. /proc/cpuinfo has
> 24 x the following entry:
>
> I'm running 2.6.30.9-pae on top of it. We were actually planning to use
> it for a virtualization server for giving people dedicated *guest*
> access for their personal compile-farm needs.
>    

First, as Jeremy notes, large memory machines want an x86_64 kernel.  
But that doesn't explain the slowness.

> For testing purposes, we created a guest VM (2.6.30.9 too) on top of it
> with 2GB of virtual memory stored in a raw partition:
>
> qemu-kvm -cpu host -smp 2 -m 2047 -drive
> file=/dev/cciss/c1d0p1,if=virtio,cache=none,boot=on -net
> nic,model=virtio,macaddr=DE:AD:BE:EF:10:28 -net
> tap,ifname=tap0,script=/usr/bin/qemu-ifup -k tr -nographic -daemonize
>
>
> The problem is that I'm seeing very poor performance within the guest.
> I've googled a bit and seen similar bug reports/discussions ending with
> some tweaks (setting rotational to 1 for virtio_blk, using cache=none,
> etc.) and an explanation from Avi Kivity about the bad scalability of
> KVM on pre-Nehalem boxes under high build load.
>    

-smp 2 should work perfectly well.

> But I fear that I'm far behind that *bad scalability*. I've made some
> comparisons with my QuadCore Q8300 (2MB cache) box. I won't give the
> whole numbers but for example,
>
> Running the autotools configure script of CUPS on that KVM guest (I can
> easily follow the output of configure line per line, it really really
> waits on some checks):
>
> real    0m52.876s
> user    0m4.892s
> sys     0m55.705s
>
> On the host (while running the guest vm):
>
> real    0m8.193s
> user    0m3.099s
> sys     0m4.055s
>
> On the quadcore box:
>
> real    0m8.424s
> user    0m2.651s
> sys     0m2.879s
>
> Both with cold cache (echo 3>  /proc/sys/vm/drop_caches)
>
> So it's not even a high build load. I've tried with -smp 8 (which showed
> worse numbers than -smp 2 and 4), with IDE instead of virtio, without
> -cpu host parameter but can't get near 30 (I've got 35 seconds with
> tuning read_ahead_kb, on top of IDE instead of virtio, etc.) seconds at all.
>
> I've also tried hugetlbfs for backing the memory within the guest.
>
> I'm using the latest kvm-mod-2.6.32 built on top of 2.6.30.9.
>
> So is this huge performance difference should be accepted as normal or
> am I missing some big things?
>    

First, are you sure that kvm is enabled?  'info kvm' in the monitor.

Second, is the workload cpu bound or I/O bound?  Both from the guest's 
and host's point of view.

-- 
error compiling committee.c: too many arguments to function

