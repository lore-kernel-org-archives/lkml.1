Return-Path: <linux-kernel-owner+w=401wt.eu-S934187AbXGRRRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187AbXGRRRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760786AbXGRRR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:17:27 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:51229 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXGRRR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:17:26 -0400
Message-ID: <469E4B22.1020009@grupopie.com>
Date: Wed, 18 Jul 2007 18:17:22 +0100
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slow Soft-RAID 5 performance
References: <469DE3BB.9070604@grupopie.com> <20070718164921.57e86dec@werewolf-wl>
In-Reply-To: <20070718164921.57e86dec@werewolf-wl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



J.A. Magallón wrote:
> On Wed, 18 Jul 2007 10:56:11 +0100, Rui Santos <rsantos@grupopie.com> wrote:
>
>   
>> Hi,
>>
>> I'm getting a strange slow performance behavior on a recently installed
>> Server. Here are the details:
>>
>>     
> ...
>   
>> I can get a write throughput of 60 MB/sec on each HD by issuing the
>> command 'time `dd if=/dev/zero of=test.raw bs=4k count=$(( 1024 * 1024 /
>> 4 )); sync`'
>>
>>     
> ...
>   
>> The RAID device I'm testing on is /dev/md2. Now, by issuing the same
>> command 'dd if=/dev/zero of=test.raw bs=4k count=$(( 1024 * 1024 / 4 ));
>> sync`' on the raid device mount point, I get the following speeds:
>> With stripe_cache_size at default '265': 51 MB/sec
>> With stripe_cache_size at '8192': 73 MB/sec
>>
>>     
>
> I know many people consider this stupid, but can you post some hdparm -tT
> data ?
>   

Of course. Here's the output:

NewServer-RD:~ # hdparm -tT /dev/md2

/dev/md2:
 Timing cached reads:   1738 MB in  2.00 seconds = 868.93 MB/sec
 Timing buffered disk reads:  444 MB in  3.01 seconds = 147.69 MB/sec


NewServer-RD:~ # hdparm --direct -tT /dev/md2

/dev/md2:
 Timing O_DIRECT cached reads:   290 MB in  2.01 seconds = 144.05 MB/sec
 Timing O_DIRECT disk reads:  396 MB in  3.01 seconds = 131.75 MB/sec

> The culprit can be the filesystem+pagecache, the md driver or the disk
> driver, so I think trying just hdparm will show if the disk o md are
> going nuts...
>
> In my case, I have a box with 2 raids, one with SCSI disks and one with
> IDE ones.
>
> Some results:
>
> lsscsi:
> [0:0:0:0]    disk    IBM      DDYS-T18350N     S96H  /dev/sda
> [2:0:0:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sdb
> [2:0:1:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sdc
> [2:0:2:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sdd
> [2:0:3:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sde
> [3:0:0:0]    disk    ATA      ST3120022A       3.06  /dev/sdf
> [3:0:1:0]    cd/dvd  HL-DT-ST DVDRAM GSA-4040B A300  /dev/sr0
> [4:0:0:0]    disk    ATA      ST3120022A       3.76  /dev/sdg
>
>
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Mon Jun 18 13:40:57 2007
>      Raid Level : raid5
>      Array Size : 107522304 (102.54 GiB 110.10 GB)
>   Used Dev Size : 35840768 (34.18 GiB 36.70 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Wed Jul 18 13:31:22 2007
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 256K
>
>            UUID : 51ad72a7:a4d20d15:0f3ea3a1:5ccb49a0
>          Events : 0.2
>
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       33        1      active sync   /dev/sdc1
>        2       8       49        2      active sync   /dev/sdd1
>        3       8       65        3      active sync   /dev/sde1
>
> This is, four scsi disks on a Adaptec U320, doing raid5:
>
> /dev/sdb:
>  Timing cached reads:   904 MB in  2.00 seconds = 451.84 MB/sec
>  Timing buffered disk reads:  228 MB in  3.00 seconds =  75.90 MB/sec
> /dev/sdc:
>  Timing buffered disk reads:  226 MB in  3.01 seconds =  75.01 MB/sec
> /dev/sdd:
>  Timing buffered disk reads:  228 MB in  3.00 seconds =  75.88 MB/sec
> /dev/sde:
>  Timing buffered disk reads:  226 MB in  3.00 seconds =  75.31 MB/sec
>
> /dev/md0:
>  Timing buffered disk reads:  562 MB in  3.01 seconds = 186.88 MB/sec
>
> Nearly 75x3 = 215 Mb/s. And this looks like a small regression, I remember
> to have seen 200Mb on this setup on previous kernels.
> Performance is like 186/215 = 86%.
>
> And /dev/md1, raid0 on 2 IDE disks:
>
> /dev/sdf:
>  Timing buffered disk reads:  148 MB in  3.02 seconds =  48.93 MB/sec
> /dev/sdg:
>  Timing buffered disk reads:  124 MB in  3.00 seconds =  41.33 MB/sec
>
> /dev/md1:
>  Timing buffered disk reads:  204 MB in  3.01 seconds =  67.68 MB/sec
>
> Performance: 67 / 90 = 75%, more or less...not too good.
>
> Now that I read the hdparm man page, perhaps would be better to repeat
> the tests with hdparm --direct.
>
> --
> J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
>                                          \         It's better when it's free
> Mandriva Linux release 2008.0 (Cooker) for i586
> Linux 2.6.21-jam12 (gcc 4.2.1 20070704 (4.2.1-3mdv2008.0)) SMP PREEMPT
> 09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
>
>
>
>   
Thanks for your reply.
Rui Santos

