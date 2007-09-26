Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbXIZP2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbXIZP2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXIZP2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:28:18 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:36429 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXIZP2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:28:16 -0400
Message-ID: <46FA7A86.6090804@hp.com>
Date: Wed, 26 Sep 2007 11:28:06 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Reply-To: Alan.Brunelle@hp.com
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, btrace <linux-btrace@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Linux Kernel Markers - performance characterization with large
 IO load on large-ish system
References: <46F92219.9020406@hp.com> <20070925171349.GA6057@Krystal>
In-Reply-To: <20070925171349.GA6057@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Alan D. Brunelle (Alan.Brunelle@hp.com) wrote:
>> Taking Linux 2.6.23-rc6 + 2.6.23-rc6-mm1 as a basis, I took some sample 
>> runs of the following on both it and after applying Mathieu Desnoyers 
>> 11-patch sequence (19 September 2007).
>>
>>    * 32-way IA64 + 132GiB + 10 FC adapters + 10 HP MSA 1000s (one 72GiB
>>      volume per MSA used)
>>
>>    * 10 runs with each configuration, averages shown below
>>          o 2.6.23-rc6 + 2.6.23-rc6-mm1 without blktrace running
>>          o 2.6.23-rc6 + 2.6.23-rc6-mm1 with blktrace running
>>          o 2.6.23-rc6 + 2.6.23-rc6-mm1 + markers without blktrace running
>>          o 2.6.23-rc6 + 2.6.23-rc6-mm1 + markers with blktrace running
>>
>>    * A run consists of doing the following in parallel:
>>          o Make an ext3 FS on each of the 10 volumes
>>          o Mount & unmount each volume
>>                + The unmounting generates a tremendous amount of writes
>>                  to the disks - thus stressing the intended storage
>>                  devices (10 volumes) plus the separate volume for all
>>                  the blktrace data (when blk tracing is enabled).
>>                + Note the times reported below only cover the
>>                  make/mount/unmount time - the actual blktrace runs
>>                  extended beyond the times measured (took quite a while
>>                  for the blk trace data to be output). We're only
>>                  concerned with the impact on the "application"
>>                  performance in this instance.
>>
>> Results are:
>>
>> Kernel                                 w/out BT   STDDEV     w/ BT    STDDEV
>> -------------------------------------  ---------  ------   ---------  ------
>> 2.6.23-rc6 + 2.6.23-rc6-mm1            14.679982    0.34   27.754796    2.09
>> 2.6.23-rc6 + 2.6.23-rc6-mm1 + markers  14.993041    0.59   26.694993    3.23
>>
>
> Interesting results, although we cannot say any of the solutions has much
> impact due to the std dev.
>
> Also, it could be interesting to add the "blktrace compiled out" as a
> base line.
>
> Thanks for running those tests,
>
> Mathieu
Mathieu:

Here are the results from 6 different kernels (including ones with 
blktrace not configured in), with now performing 40 runs per kernel.

  o  All kernels start off with Linux 2.6.23-rc6 + 2.6.23-rc6-mm1

  o  '- bt cfg' or '+ bt cfg' means a kernel without or with blktrace 
configured respectively.

  o  '- markers' or '+ markers' means a kernel without or with the 
11-patch marker series respectively.

38 runs without blk traces being captured (dropped hi/lo value from 40 runs)

Kernel Options       Min val    Avg val    Max val    Std Dev
------------------  ---------  ---------  ---------  ---------
- markers - bt cfg  15.349127  16.169459  16.372980   0.184417
+ markers - bt cfg  15.280382  16.202398  16.409257   0.191861

- markers + bt cfg  14.464366  14.754347  16.052306   0.463665
+ markers + bt cfg  14.421765  14.644406  15.690871   0.233885

38 runs with blk traces being captured (dropped hi/lo value from 40 runs)

Kernel Options       Min val    Avg val    Max val    Std Dev
------------------  ---------  ---------  ---------  ---------
- markers + bt cfg  24.675859  28.480446  32.571484   1.713603
+ markers + bt cfg  18.713280  27.054927  31.684325   2.857186

  o  It is not at all clear why running without blk trace configured 
into the kernel runs slower than with blk trace configured in. (9.6 to 
10.6% reduction)
    
  o  The data is still not conclusive with respect to whether the marker 
patches change performance characteristics when we're not gathering 
traces. It appears
that any change in performance is minimal at worst for this test.
    
  o  The data so far still doesn't conclusively show a win in this case 
even when we are capturing traces, although, the average certainly seems 
to be in its favor.
    
One concern that I should be able to deal easily with is the choice of 
the IO scheduler being used for both the volume being used to perform 
the test on, as well as the one used for storing blk traces (when 
enabled). Right now I was using the default CFQ, when perhaps NOOP or 
DEADLINE would be a better choice. If there is enough interest in seeing 
how that changes things I could try to get some runs in later this week.

Alan D. Brunelle
Hewlett-Packard / Open Source and Linux Organization / Scalability and 
Performance Group

