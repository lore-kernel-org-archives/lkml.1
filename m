Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbXC0Q0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbXC0Q0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXC0Q0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:26:11 -0400
Received: from lucidpixels.com ([75.144.35.66]:35588 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbXC0QZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:25:53 -0400
Date: Tue, 27 Mar 2007 12:25:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux@horizon.com
cc: htejun@gmail.com, jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
In-Reply-To: <20070327161616.31448.qmail@science.horizon.com>
Message-ID: <Pine.LNX.4.64.0703271224400.5965@p34.internal.lan>
References: <20070327161616.31448.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007, linux@horizon.com wrote:

> Here's some more data.
>
> 6x ST3400832AS (Seagate 7200.8) 400 GB drives.
> 3x SiI3232 PCIe SATA controllers
> 2.2 GHz Athlon 64, 1024k cache (3700+), 2 GB RAM
> Linux 2.6.20.4, 64-bit kernel
>
> Tested able to sustain reads at 60 MB/sec/drive simultaneously.
>
> RAID-10 is across 6 drives, first part of drive.
> RAID-5 most of the drive, so depending on allocation policies,
> may be a bit slower.
>
> The test sequence actually was:
> 1) raid5ncq
> 2) raid5noncq
> 3) raid10noncq
> 4) raid10ncq
> 5) raid5ncq
> 6) raid5noncq
> but I rearranged things to make it easier to compare.
>
> Note that NCQ makes writes faster (oh... I have write cacheing turned off;
> perhaps I should turn it on and do another round), but no-NCQ seems to have
> a read advantage.  %$%@#$@#ing bonnie++ overflows and won't print file
> read times; I haven't bothered to fix that yet.
>
> NCQ seems to have a pretty significant effect on the file operations,
> especially deletes.
>
> Update: added
> 7) wcache5noncq - RAID 5 with no NCQ but write cache enabled
> 8) wcache5ncq - RAID 5 with NCQ and write cache enabled
>
>
> RAID=5, NCQ
> Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
>                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> raid5ncq      7952M 31688  53  34760 10 25327   4 57908  86 167680 13 292.2   0
> raid5ncq      7952M 30357  50  34154 10 24876   4 59692  89 165663 13 285.6   0
> raid5noncq    7952M 29015  48  31627  9 24263   4 61154  91 185389 14 286.6   0
> raid5noncq    7952M 28447  47  31163  9 23306   4 60456  89 198624 15 293.4   0
> wcache5ncq    7952M 32433  54  35413 10 26139   4 59898  89 168032 13 303.6   0
> wcache5noncq  7952M 31768  53  34597 10 25849   4 61049  90 193351 14 304.8   0
> raid10ncq     7952M 54043  89 110804 32 48859   9 58809  87 142140 12 363.8   0
> raid10noncq   7952M 48912  81  68428 21 38906   7 57824  87 146030 12 358.2   0
>
>                    ------Sequential Create------ --------Random Create--------
>                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>    16:100000:16/64  1351  25 +++++ +++   941   3  2887  42 31526  96   382   1
>    16:100000:16/64  1400  18 +++++ +++   386   1  4959  69 32118  95   570   2
>    16:100000:16/64   636   8 +++++ +++   176   0  1649  23 +++++ +++   245   1
>    16:100000:16/64   715  12 +++++ +++   164   0   156   2 11023  32  2161   8
>    16:100000:16/64  1291  26 +++++ +++  2778  10  2424  33 31127  93   483   2
>    16:100000:16/64  1236  26 +++++ +++   840   3  2519  37 30366  91   445   2
>    16:100000:16/64  1714  37 +++++ +++  1652   6   789  11  4700  14 12264  48
>    16:100000:16/64   634  11 +++++ +++  1035   3   338   4 +++++ +++  1349   5
>
> raid5ncq,7952M,31688,53,34760,10,25327,4,57908,86,167680,13,292.2,0,16:100000:16/64,1351,25,+++++,+++,941,3,2887,42,31526,96,382,1
> raid5ncq,7952M,30357,50,34154,10,24876,4,59692,89,165663,13,285.6,0,16:100000:16/64,1400,18,+++++,+++,386,1,4959,69,32118,95,570,2
> raid5noncq,7952M,29015,48,31627,9,24263,4,61154,91,185389,14,286.6,0,16:100000:16/64,636,8,+++++,+++,176,0,1649,23,+++++,+++,245,1
> raid5noncq,7952M,28447,47,31163,9,23306,4,60456,89,198624,15,293.4,0,16:100000:16/64,715,12,+++++,+++,164,0,156,2,11023,32,2161,8
> wcache5ncq,7952M,32433,54,35413,10,26139,4,59898,89,168032,13,303.6,0,16:100000:16/64,1291,26,+++++,+++,2778,10,2424,33,31127,93,483,2
> wcache5noncq,7952M,31768,53,34597,10,25849,4,61049,90,193351,14,304.8,0,16:100000:16/64,1236,26,+++++,+++,840,3,2519,37,30366,91,445,2
> raid10ncq,7952M,54043,89,110804,32,48859,9,58809,87,142140,12,363.8,0,16:100000:16/64,1714,37,+++++,+++,1652,6,789,11,4700,14,12264,48
> raid10noncq,7952M,48912,81,68428,21,38906,7,57824,87,146030,12,358.2,0,16:100000:16/64,634,11,+++++,+++,1035,3,338,4,+++++,+++,1349,5
>

I would try with write-caching enabled.
Also, the RAID5/RAID10 you mention seems like each volume is on part of
the platter, a strange setup you got there :)

Also you are disabling NCQ on/off via the /sys/block device, e.g., setting 
it to 1 (off) and 31 (on) during testing, yes?

Justin.
