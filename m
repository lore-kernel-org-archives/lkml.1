Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab0BHDub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:50:31 -0500
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:62853 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0BHDua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:50:30 -0500
Date: Sun, 07 Feb 2010 22:50:26 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: x86 - cpu_relax - why nop vs. pause?
In-reply-to: <4B6F2D59.1070508@majjas.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Joerg Roedel <joro@8bytes.org>
Message-id: <4B6F8A02.2060006@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B6EF853.9090704@majjas.com>
 <1265566470.6280.10.camel@marge.simson.net> <4B6F1DAE.6020407@majjas.com>
 <4B6F2D59.1070508@majjas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/2010 4:15 PM, Michael Breuer wrote:
> On 02/07/2010 03:08 PM, Michael Breuer wrote:
>> On 2/7/2010 1:14 PM, Mike Galbraith wrote:
>> ...
>> Case1 - asm volatile("pause" ::: "memory");
>> 0000000000400480 <main>:
>>   400480:    f3 90                    pause
>>   400482:    c3                       retq
>>   400483:    90                       nop
>>
>> ...
>>
>> Case3 - asm volitile("rep;pause" ::: "memory")
>> 0000000000400480 <main>:
>>   400480:    f3 f3 90                 pause
>>   400483:    c3                       retq
>>   400484:    90                       nop
>> _______
>> Note the difference between opcodes case 1 and case 3, and the mess 
>> made by the compiler in case 2.
>>
>> As to benchmarks  - I've checked a few things, no formal or lasting 
>> stuff... but striking at first glance:
>>
>> 1) At idle, perf top shows time spent in _raw_spin_lock dropping from 
>> ~35% to ~25%.
>> 2) Running a media transcode (single core - handbrakecli): frame rate 
>> increased by about 5-10%.
>> 3) During file-intensive operations (#2, above, or copying large 
>> files - ext4 on software raid6) - latencytop shows a decerase on 
>> writing a page to disc from about 120ms to about 90ms.
>>
> Disregard case 2 - was missing -O3. With -O3 or -O2 rep;nop and pause 
> are identical. The interesting case is rep;pause which is different 
> and seems more efficient.
Just to move away from this... totally perplexed, I retested a bit. 
Seems something else had gone wrong causing me to try 'rep;pause' vs. 
'pause'. The resulting opcode is f3 f3 90, as noted above.

I do see what seems to be a small but noticeable performance improvement 
- no idea if there's a downside, and also no idea what f3 f3 90 does vs. 
f3 90. Might be something interesting, or maybe not.
Test scenario:

Boot clean to single user mode. perform tiotest -8 five times.
%cpu is %usr + %sys as reported by tiotest.

Results:
Writes
pause:         1.14 sec; 72.01MB/sec; 322.44%cpu
rep;pause:   1.12 sec; 70.4MB/sec; 311.58%cpu
Random Writes
pause:         3.7 sec; 8.51MB/sec; 66.48%cpu
rep;pause    3.46sec; 9.04MB/sec; 72.34%cpu
Reads
pause:         11557.48MB/sec; 6040.74%cpu
rep;pause    11620.15MB/sec; 5974.90%cpu
Random Reads
pause:          11416.9MB/sec; 5330.50%cpu
rep;pause     11786.99MB/sec; 5118.66%cpu


