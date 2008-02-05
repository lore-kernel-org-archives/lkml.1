Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYBEKyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYBEKyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbYBEKx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:53:56 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:41778 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYBEKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C9fDNF26cygESPWOA5At+SQYPCEvLaY+ieF3b0D84ZbJvsRyelT4/ikCkUmLKmRJcCvFX1ZQ2OJA9LJuBA6alsQXkDTxnAreG1Sb3S2IDgXm80Jkmy2yh628/MrAC7vYdHeqiFklRuAx6bU6WyrsGtp5T2ob9y6laFRxyK7uj8A=
Message-ID: <d00698fb0802050253wec42754s359633415587d500@mail.gmail.com>
Date: Tue, 5 Feb 2008 11:53:52 +0100
From: noah <noah123@gmail.com>
To: "Martin Knoblauch" <knobi@knobisoft.de>
Subject: Re: Performance problems when writing large files on CCISS hardware
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, iss_storagedev@hp.com
In-Reply-To: <195127.4908.qm@web32605.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <195127.4908.qm@web32605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/23, Martin Knoblauch <spamtrap@knobisoft.de>:
> Please CC me on replies, as I am not subscribed.
>
> Hi,
>
>  for a while now I am having problems writing large files sequentially to EXT2 filesystems on CCISS based boxes. The problem is that writing multiple files in parallel is extremely slow compared to a single file in non-DIO mode. When using DIO, the scaling is almost "perfect". The problem manifests itself in RHEL4 kernels (2.6.9-X) and any mainline kernel up to 2.6.24-rc8.
>
>  The systems in question are HP/DL380G4 with 2 cpus, 8 GB memory, SmartArray6i (CCISS) with BBWC and 4x72GB@10krpm disks in RAID5 configuration. Environment is 64-bit RHEL4.3.

I've seen similar problems on HP DL380 G4 (SmartArray 6i) and HP DL385
G5 (SmartArray P400).


RHEL 4, kernel 2.6.9 and reiserfs had siginifcantly worse I/O
performance than a Gentoo box running 2.6.18 (iirc) when I did some
I/O-test with different distributions on a HP DL380 G4 before
deploying the machine in production. Switching I/O-schedulers on RHEL4
didn't help either.


Also, I'm having awful I/O-performance with a DL385 G2/2x2.6GH/4GB
running MySQL 5 on Ubuntu 7.10 (kernel 2.6.22). It previously ran
Ubuntu 7.04 (kernel 2.6.20) which had the same issue. On this server
MySQL stalls for a long time waiting for I/O after SQL updates that
causes lots of writes.

I've been trying to mitigate the problems by adding 512MB
Batterybacked Writecache and lately also switching from RAID1 to RAID
1+0 (4x72GB 15k SAS disks). It's better but there are still issues.

I think after switching to RAID 1+0 I'm now getting around 50-70 MB/s,
which is 1.5-2.0 times the performance I had before.


Running sync on any of the servers while there are dirty pages to be
written (according to /proc/meminfo) virtually kills all I/O until the
sync completes.


I don't have much experience with other RAID controllers than the
SmartArray and naturally don't know what to expect, but I sure think
it should be better.

I'm getting much better performance out of an ordinary "home computer"
that has 4 standard disks in RAID 1+0 configuration (software; Linux
md) and AES encryption with dm-crypt.



Below are some numbers.

HP DL385 G5, 2x2.6GHz/2GB/4x72GB in RAID1+0, kernel 2.6.22 (Ubuntu 7.10 x64)
====
# sync; time sh -c "dd if=/dev/zero of=/data/test bs=1024k count=8192;sync"
dd: writing `/data/test': No space left on device
6187+0 records in
6186+0 records out
6487523328 bytes (6.5 GB) copied, 113.756 seconds, 57.0 MB/s

real    1m56.916s
user    0m0.050s
sys     0m31.040s


HP DL385 G5, 2x2.6GHz/4GB/4x72GB in RAID1+0 512MB BBWC, kernel 2.6.22
(Ubuntu 7.10 x64)
===
# sync; time sh -c "dd if=/dev/zero of=/data/test bs=1024k count=8192;sync"
8192+0 records in
8192+0 records out
8589934592 bytes (8.6 GB) copied, 120.797 seconds, 71.1 MB/s

real    2m1.883s
user    0m0.020s
sys     0m26.530s


  -- noah
