Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZG1TIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZG1TIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZG1TIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:08:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZG1TIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:08:43 -0400
Message-ID: <4A6F4C81.10600@vlnb.net>
Date: Tue, 28 Jul 2009 23:07:45 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net> <4A5CD3E2.2060307@vlnb.net>	 <4A5D7794.2070607@vlnb.net>	 <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>	 <4A5F0293.3010206@vlnb.net>	 <a0272b440907170715q72af7bb8l53c9dbd5e553fe2c@mail.gmail.com>	 <4A60C1A8.9020504@vlnb.net> <4A641AAC.9030300@vlnb.net>	 <a0272b440907220144i159baca4u1a1f1f2d0c36193a@mail.gmail.com>	 <4A6DA77B.7080600@vlnb.net> <a0272b440907280251g2dd38df6ja1bf10f3fa38d333@mail.gmail.com>
In-Reply-To: <a0272b440907280251g2dd38df6ja1bf10f3fa38d333@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19zxTP2WlAcVConQyKIqaX0EocuEmy8HAMpk6P
 LengYZi3v3OmakzwsMACzHDMpbKyLH8pZLcnOaf5ihvFa6qqfq
 WIgCulEMItamoPw8AsIFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ronald Moesbergen, on 07/28/2009 01:51 PM wrote:
> 2009/7/27 Vladislav Bolkhovitin <vst@vlnb.net>:
>> Hmm, it's really weird, why the case of 2 threads is faster. There must be
>> some commands reordering somewhere in SCST, which I'm missing, like
>> list_add() instead of list_add_tail().
>>
>> Can you apply the attached patch and repeat tests 5, 8 and 11 with 1 and 2
>> threads, please. The patch will enable forced commands order protection,
>> i.e. with it all the commands will be executed in exactly the same order as
>> they were received.
> 
> The patched source doesn't compile. I changed the code to this:
> 
> @ line 3184:
> 
>         case SCST_CMD_QUEUE_UNTAGGED:
> #if 1 /* left for future performance investigations */
>                 goto ordered;
> #endif
> 
> The results:
> 
> Overall performance seems lower.
> 
> client kernel: 2.6.26-15lenny3 (debian)
> server kernel: 2.6.29.5 with readahead-context, blk_run_backing_dev
> and io_context, forced_order
> 
> With one IO thread:
> 5) client: default, server: default (cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  16.484   16.417   16.068   62.741    0.706    0.980
>  33554432  15.684   16.348   16.011   63.961    1.083    1.999
>  16777216  16.044   16.239   15.938   63.710    0.493    3.982
> 
> 8) client: default, server: 64 max_sectors_kb, RA 2MB (cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  16.127   15.784   16.210   63.847    0.740    0.998
>  33554432  16.103   16.072   16.106   63.627    0.061    1.988
>  16777216  16.637   16.058   16.154   62.902    0.970    3.931
> 
> 11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB (cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  13.417   15.219   13.912   72.405    3.785    1.131
>  33554432  13.868   13.789   14.110   73.558    0.718    2.299
>  16777216  13.691   13.784   10.280   82.898   11.822    5.181
> 
> 11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA
> 2MB (deadline)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  13.604   13.532   13.978   74.733    1.055    1.168
>  33554432  13.523   13.166   13.504   76.443    0.945    2.389
>  16777216  13.434   13.409   13.632   75.902    0.557    4.744
> 
> With two threads:
> 5) client: default, server: default (cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  16.206   16.001   15.908   63.851    0.493    0.998
>  33554432  16.927   16.033   15.991   62.799    1.631    1.962
>  16777216  16.566   15.968   16.212   63.035    0.950    3.940
> 
> 8) client: default, server: 64 max_sectors_kb, RA 2MB (cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  16.017   15.849   15.748   64.521    0.450    1.008
>  33554432  16.652   15.542   16.259   63.454    1.823    1.983
>  16777216  16.456   16.071   15.943   63.392    0.849    3.962
> 
> 11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB (cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  14.109    9.985   13.548   83.572   13.478    1.306
>  33554432  13.698   14.236   13.754   73.711    1.267    2.303
>  16777216  13.610   12.090   14.136   77.458    5.244    4.841
> 
> 11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA
> 2MB (deadline)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  13.542   13.975   13.978   74.049    1.110    1.157
>  33554432   9.921   13.272   13.321   85.746   12.349    2.680
>  16777216  13.850   13.600   13.344   75.324    1.144    4.708

Can you perform the tests 5 and 8 the deadline? I asked for deadline..

What I/O scheduler do you use on the initiator? Can you check if 
changing it to deadline or noop makes any difference?

Thanks,
Vlad
