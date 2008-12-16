Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYLPApL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYLPApL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 19:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYLPAo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 19:44:56 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:7043 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYLPAoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 19:44:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mDdjpvL72CCMcnaq40XwIQ60PPVBb2KlPmVnQJbv63KMMy0CVZcn3uduU/81c2V3aC
         R0+I3gsi2DZaBnnhpXu7FUxwPt2yPQdkX3vFScoFNEoOUhgXZTzsjgfIfhjipWB5W8Gn
         mbecAhti6r4fUFCdD4qjuuRq39w2DoUIjwiNY=
Message-ID: <e9c3a7c20812151644p7c1038cajd7254a963f9038a2@mail.gmail.com>
Date: Mon, 15 Dec 2008 17:44:55 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.27.8: OOM killer: [swapper: page allocation failure]
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       "Alan Piszcz" <ap@solarrain.com>
In-Reply-To: <alpine.DEB.1.10.0812120708080.9826@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0812120708080.9826@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 5:14 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Kernel: 2.6.27.8
>
> I have a RAID-6 volume with 6 disks:
> mdadm --create -v /dev/md0 --level=6 -n 6 -e 0.90 /dev/sd[e-j]1
>
> While it is building...
>
> # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md0 : active raid6 sdj1[5] sdi1[4] sdh1[3] sdg1[2] sdf1[1] sde1[0]
>      1562834944 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>      [===>.................]  resync = 19.0% (74237440/390708736)
> finish=346.7min speed=15208K/sec
>
> unused devices: <none>
>
> During this time, I am copying files to it at ~60-100MiB/s using 2 rsyncs
> over NFS from 2 separate machines => this one [over the network] (on a pci-e
> x1 / built-in to the motherboard).
>
> top output:
> top - 07:10:06 up 12:32, 30 users,  load average: 3.46, 4.49, 4.39
> Tasks: 316 total,   2 running, 313 sleeping,   1 stopped,   0 zombie
> Cpu(s): 12.1%us,  3.7%sy,  0.0%ni, 32.5%id, 49.2%wa,  1.1%hi,  1.2%si,
>  0.0%st
> Mem:   8100836k total,  8057480k used,    43356k free,        0k buffers
> Swap: 16787884k total,      144k used, 16787740k free,  6609412k cached
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  5349 root      15  -5     0    0    0 R   10  0.0  11:59.94 md0_raid5
>    1 root      20   0 10312  748  620 S    0  0.0   0:02.14 init
>
> I see this over and over in the kernel log (maybe it will stop when the
> RAID6
> rebuild is completed)?  So far, my rsyncs are continuing just fine and
> nothing except klogd/swapper processes have been killed.
>
> [44893.846532] swapper: page allocation failure. order:0, mode:0x20
[..]
>
> Raid optimizations used:
>
> # cat oraid.sh |grep -v ^#|grep .
> . /etc/profile
> echo "Optimizing RAID Arrays..."
> cd /sys/block
> DISKS=$(/bin/ls -1d sd[e-j])
> echo "Setting read-ahead to 32 MiB for /dev/md0"
> blockdev --setra 65536 /dev/md0
> echo "Setting stripe_cache_size to 16 MiB for /dev/md0"
> echo 16384 > /sys/block/md0/md/stripe_cache_size
>

If you set the stripe_cache_size high enough you can strangle the
system.  Do you really need 384MiB of raid cache?
