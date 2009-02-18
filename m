Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZBRKQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZBRKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZBRKQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:16:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53820 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZBRKQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:16:48 -0500
Message-ID: <499BDFD1.4090706@cn.fujitsu.com>
Date: Wed, 18 Feb 2009 18:15:45 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: CFQ is worse than other IO schedulers in some cases
References: <499BA413.2010705@cn.fujitsu.com> <1234944336.6141.8.camel@marge.simson.net>
In-Reply-To: <1234944336.6141.8.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith said:
> On Wed, 2009-02-18 at 14:00 +0800, Shan Wei wrote:
> 
>> In sysbench(version:sysbench-0.4.10), I confirmed followings.
>>   - CFQ's performance is worse than other IO schedulers when only multiple
>>     threads test.
>>     (There is no difference under single thread test.)
>>   - It is worse than other IO scheduler when
>>     I used read mode. (No regression in write mode).
>>   - There is no difference among other IO schedulers. (e.g noop deadline)
>>
>>
>> The Test Result(sysbench):
>>    UNIT:Mb/sec
>>     __________________________________________________
>>     |   IO       |      thread  number               |  
>>     | scheduler  |-----------------------------------|
>>     |            |  1   |  3    |  5   |   7  |   9  |
>>     +------------|------|-------|------|------|------|
>>     |cfq         | 77.8 |  32.4 | 43.3 | 55.8 | 58.5 | 
>>     |noop        | 78.2 |  79.0 | 78.2 | 77.2 | 77.0 |
>>     |anticipatory| 78.2 |  78.6 | 78.4 | 77.8 | 78.1 |
>>     |deadline    | 76.9 |  78.4 | 77.0 | 78.4 | 77.9 |
>>     +------------------------------------------------+
> ﻿
> My Q6600 box agrees that cfq produces less throughput doing this test,
> but throughput here is ~flat. Disk is external SATA ST3500820AS.
>     _________________________________________________
>     |   IO       |     thread  number               |  
>     | scheduler  |----------------------------------|
>     |            |  1   |  3   |  5   |  7   |  9   |
>     +------------|------|------|------|------|------|
>     |cfq         | 84.4 | 89.1 | 91.3 | 88.8 | 88.8 |
>     |noop        |102.9 | 99.3 | 99.4 | 99.7 | 98.7 | 
>     |anticipatory|100.5 |100.1 | 99.8 | 99.7 | 99.6 | 
>     |deadline    | 97.9 | 98.7 | 99.5 | 99.5 | 99.3 | 
>     +-----------------------------------------------+
> 

Thans for you reply.

My box is X5260, I just test it again setting the number of thread with 1 and 5.
The regression is still present.

The test result: 
     ________________________________
     |   IO       |  thread  number |  
     | scheduler  |------------------
     |            |  1     |  5     |  
     +------------|--------|--------|
     |cfq         | 73.584 | 48.042 | 
     |noop        | 73.653 | 74.055 | 
     |anticipatory| 73.63  | 72.033 |  
     |deadline    | 73.769 | 72.819 | 
     +-------------------------------

lspci shows: 
[root@NUT io-test]# lspci -nn
00:1f.2 IDE interface [0101]: Intel Corporation 631xESB/632xESB/3100 Chipset SATA IDE Controller [8086:2680] (rev 09)
03:00.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS [1000:0056] (rev 04)

Can you confirm the dump command on your box?

Thanks 
Shan Wei

>> Steps to reproduce(sysbench):
>>
>>   (1)#echo cfq > /sys/block/sda/queue/scheduler 
>>
>>   (2)#sysbench --test=fileio --num-threads=1 --file-total-size=10G --file-test-mode=seqrd prepare
>>
>>   (3)#sysbench --test=fileio --num-threads=1 --file-total-size=10G --file-test-mode=seqrd run
>>       [snip]
>>       Operations performed:  655360 Read, 0 Write, 0 Other = 655360 Total
>>       Read 10Gb  Written 0b  Total transferred 10Gb  (77.835Mb/sec)
>>       4981.44 Requests/sec executed                   ~~~~~~~~~~~
>>   (4)#sysbench --test=fileio --num-threads=1 --file-total-size=10G --file-test-mode=seqrd cleanup
>>
>>   (5)#sysbench --test=fileio --num-threads=5 --file-total-size=10G --file-test-mode=seqrd prepare
>>   (6)#sysbench --test=fileio --num-threads=5 --file-total-size=10G --file-test-mode=seqrd run
>>       [snip]
>>       Operations performed:  655360 Read, 0 Write, 0 Other = 655360 Total
>>       Read 10Gb  Written 0b  Total transferred 10Gb  (43.396Mb/sec)
>>       2777.35 Requests/sec executed                   ~~~~~~~~~~~~
>>   (7)#sysbench --test=fileio --num-threads=5 --file-total-size=10G --file-test-mode=seqrd cleanup
>>
>> when doing step 2 or 5, sysbench creats 128 files, and 80M each one. 
>> when doing step 4 or 7, sysbench deletes the files. 
>> when doing step 3 or 6, thread reads these files continuously and 
>> reads file-block-size(default:16Kbyte) at once, just like :
>>
>>        t_0   t_0   t_0   t_0   t_0   t_0   t_0
>>         ^     ^     ^     ^     ^     ^     ^
>>      ---|-----|-----|-----|-----|-----|-----|--------
>> file | 16k | 16k | 16k | 16k | 16k | 16k | 16k | ... 
>>      ------------------------------------------------ 
>>                   (num-threads=1)
>>
>> (t_0 stand for the first thread) 
>>
>>        t_0   t_1   t_2   t_3   t_4   t_0   t_1
>>         ^     ^     ^     ^     ^     ^     ^
>>      ---|-----|-----|-----|-----|-----|-----|--------
>> file | 16k | 16k | 16k | 16k | 16k | 16k | 16k | ... 
>>      ------------------------------------------------ 
>>                   (num-threads=5)
>>
>> (the executed threads are decide by the thread scheduler)
>>
>>
>> The Hardware Infos:
>> Arch    :x86_64
>> CPU     :4cpu; GenuineIntel 3325.087 MHz
>> MEMORY  :4044128kB
>>
>> ---- 
>> Shan Wei
>>
