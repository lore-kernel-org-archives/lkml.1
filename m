Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbZKLAZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbZKLAZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759798AbZKLAZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:25:12 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54209 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759821AbZKLAZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:25:09 -0500
MIME-Version: 1.0
In-Reply-To: <4e5e476b0911110300nb25785eqf7998ad1fe3ed537@mail.gmail.com>
References: <40e92d5b0911101608t4baf75bo83c5780f24761781@mail.gmail.com>
	 <4e5e476b0911110300nb25785eqf7998ad1fe3ed537@mail.gmail.com>
Date: Thu, 12 Nov 2009 01:25:13 +0100
Message-ID: <40e92d5b0911111625sf692589u8678b03264c1b31d@mail.gmail.com>
Subject: Re: SATA NCQ - blessing for throughput, curse for latency?
From: =?UTF-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/11 Corrado Zoccolo <czoccolo@gmail.com>:
> 2009/11/11 Przemysław Pawełczyk <przemyslaw@pawelczyk.it>:
>> [snip] I wrote a script (that is pasted
>> at the end), which using zcav from bonnie++ (and unbuffer from expect
>> to work properly if output is redirected to a file) reads up to 64 GB
>> of the disk, but after a first few gigabytes (depending on how many GB
>> of memory you have) cats kernel sources with binary files up to the
>> second level of directory depth. What is measured? The real time of
>> the cat to /dev/null operation. Why not the kernel sources alone?
>> Because if we build kernel, especially with -jX (where X > 1), then
>> both inodes and contents of the corresponding files within these
>> directories generally won't be consecutive. Time for the results with
>> some background information. In my tests I have used 2.6.31.5 built
>> with debuginfo (using debian's make-kpkg).
>>
>>[summarized the relevant numbers]
>> *** NCQ turned on ***
>> real 752.30
>> user 0.20
>> sys 1.83
>>
>>
>> *** NCQ turned off *** (kernel booted with noncq parameter)
>> real 62.30
>> user 0.27
>> sys 1.59
>>
>> [snip]
>>
>> Can anyone confirm analogous NCQ-dependant behavior with other
>> disk/controller variants? Any suggestions for improvements other than
>> turning off NCQ or switching to anticipatory (in typical cases cfq is
>> better, so it's not the best option)?
>
> The NCQ latency problem is well known, and should be fixed in 2.6.32.
> You can try building the latest rc.

Thank you for this information. Could you provide fixing commit's sha?
Just for the record.

Bunch of numbers from my laptop, to show how it improved in my case:

model name: Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz
mem total:  3087012 kB

[    8.656966] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD3200BJKT-0 11.0 PQ: 0 ANSI: 5
[    8.657771] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks:
(320 GB/298 GiB)

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM
(ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
        Kernel driver in use: ahci

** 2.6.31.5 NCQ **

Did not end while was reading first 64 GB of the disk. Result:
real 807.06
user 0.14
sys 2.06

** 2.6.32-rc6 NCQ **

0.00 82.33 12.437
1.00 82.47 12.417
2.00 82.51 12.411
3.00 82.31 12.441
Concurrent read will start in 1 second...
4.00 57.30 17.870
5.00 41.49 24.680
6.00 38.76 26.421
real 79.48
user 0.24
sys 1.43
7.00 53.64 19.092
8.00 82.51 12.411

** 2.6.32-rc6 noncq **

0.00 82.33 12.437
1.00 82.47 12.417
2.00 82.40 12.427
3.00 81.87 12.508
Concurrent read will start in 1 second...
4.00 42.17 24.285
5.00 37.91 27.010
real 62.94
user 0.18
sys 1.64
6.00 52.70 19.431
7.00 82.51 12.410

With noncq second read is faster, but the difference is now acceptable I think.

Thanks.

-- 
Przemysław Pawełczyk
