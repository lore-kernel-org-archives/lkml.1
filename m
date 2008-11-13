Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYKMSdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYKMSdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYKMSde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:33:34 -0500
Received: from voyager.telenet.dn.ua ([195.39.211.35]:48431 "EHLO
	voyager.telenet.dn.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYKMSdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:33:33 -0500
Message-ID: <491C72F8.9030605@telenet.dn.ua>
Date: Thu, 13 Nov 2008 20:33:28 +0200
From: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
User-Agent: Thunderbird 2.0.0.17 (X11/20081011)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua>	<20081110104423.GA26778@kernel.dk>	<x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>	<20081110135618.GI26778@kernel.dk>	<x491vxgkd61.fsf@segfault.boston.devel.redhat.com>	<491BCF0D.8050502@telenet.dn.ua> <x49skpvg0hw.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49skpvg0hw.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:

>> It's 2.6.18-openvz-rhel5 kernel gives me 9MB/s, and with 2.6.27 I get ~40-50MB/s
>> instead of 80-90 MB/s as there should be no bottlenecks except the network.
> 
> Reading back through your original problem report, I'm not seeing what
> your numbers were with deadline; you simply mentioned that it "fixed"
> the problem.  Are you sure you'll get 80-90MB/s for this?  The local
> disks in my configuration, when performing a dd on the server system,
> can produce numbers around 85 MB/s, yet the NFS performance is around 65
> MB/s (and this is a gigabit network).

I have pair of 1TB HDDs and each of them is able to deliver around
100MB/s for sequental reads and PCI-E Ethernet adapter not sharing
a bus with SATA controller.

2.6.18-openvz-rhel5, loopback mounted nfs with deadline gives
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 7.12014 s, 147 MB/s

and same system via network:
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 14.3197 s, 73.2 MB/s

and network+cfq:
dd if=samefile of=/dev/null bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 59.3116 s, 17.7 MB/s

and network+file cached on server side:
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 12.4204 s, 84.4 MB/s

Well, 73 is still not 80, but way much better than 17 (or,
even worse - 9)

I have 8 NFS threads by default here.

I got 17 MB here because of HZ=1000, also 2.6.27 performed
better in every heavy-nfs-transfer test so far

Changed network parateters:

net.core.wmem_default = 1048576
net.core.wmem_max = 1048576
net.core.rmem_default = 1048576
net.core.rmem_max = 1048576

net.ipv4.tcp_mem = 1048576 1048576 4194304
net.ipv4.tcp_rmem = 1048576 1048576 4194304
net.ipv4.tcp_rmem = 1048576 1048576 4194304
net.ipv4.tcp_wmem = 1048576 1048576 4194304
net.ipv4.tcp_wmem = 1048576 1048576 4194304

MTU: 6000

Sorry, I didn't mention these in original post.

>>> Single dd performing a cold cache read of a 1GB file from an
>>> nfs server.  read_ahead_kb is 128 (the default) for all tests.
>>> cfq-cc denotes that the cfq scheduler was patched with the close
>>> cooperator patch.  All numbers are in MB/s.
>>>
>>> nfsd threads|   1  |  2   |  4   |  8  
>>> ----------------------------------------
>>> deadline    | 65.3 | 52.2 | 46.7 | 46.1
>>> cfq         | 64.1 | 57.8 | 53.3 | 46.9
>>> cfq-cc      | 65.7 | 55.8 | 52.1 | 40.3
>>>
>>> So, in my configuration, cfq and deadline both degrade in performance as
>>> the number of nfsd threads is increased.  The close cooperator patch
>>> seems to hurt a bit more at 8 threads, instead of helping;  I'm not sure
>>> why that is.
>> Interesting, I'll try to change nfsd threads number and see how it performs
>> on my setup. Setting it to 1 seems like a good idea for cfq and a non-high-end
>> hardware.
> 
> I think you're looking at this backwards.  I'm no nfsd tuning expert,
> but I'm pretty sure that you would tune the numbe,r of threads based on
> the number of active clients and the amount of memory on the server
> (since each thread has to reserve memory for incoming requests).

I understand this. It's just one of the parameters I completely missed
out of my sight :)

>> I'll look into it this evening.
> 
> The real reason I tried varying the number of nfsd threads was to show,
> at least for CFQ, that spreading a sequential I/O load across multiple
> threads would result in suboptimal performance.  What I found, instead,
> was that it hurt performance for cfq *and* deadline (and that the close
> cooperator patches did not help in this regard).  This tells me that
> there is something else which is affecting the performance.  What that
> something is I don't know, I think we'd have to take a closer look at
> what's going on on the server to figure it out.
> 

I've tested it also...

loopback:
nfsd threads |  1 |  2 |  4 |  8 |  16
----------------------------------------
deadline-vz  |  97|  92| 128| 145| 148
deadline     | 145| 160| 173| 170| 150
cfq-cc       | 137| 150| 167| 157| 133
cfq          |  26|  28|  34|  38|  38

network:
nfsd threads |  1 |  2 |   4|   8|  16
----------------------------------------
deadline-vz  |  68|  69|  75|  73|  72
deadline     |  91|  89|  87|  88|  84
cfq-cc       |  91|  89|  88|  82|  74
cfq          |  25|  28|  32|  36|  34


deadline-vz - deadline with 2.6.18-openvz-rhel5 kernel
deadline, cfq, cfq-cc - linux-2.6.27.5

Yep, it's not that simple as I thought...

-- 
Regards,
Vitaly
