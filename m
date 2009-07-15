Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbZGOGap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbZGOGap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZGOGao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:30:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZGOGan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:30:43 -0400
Message-ID: <4A5D7794.2070607@vlnb.net>
Date: Wed, 15 Jul 2009 10:30:44 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, hifumi.hisashi@oss.ntt.co.jp,
       linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com,
       randy.dunlap@oracle.com, Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net>	 <a0272b440907060737n59d4b155lb40c1c6d38ee96dd@mail.gmail.com>	 <4A5238EC.1070505@vlnb.net>	 <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com>	 <4A5395FD.2040507@vlnb.net>	 <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com>	 <4A5493A8.2000806@vlnb.net>	 <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>	 <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net> <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com> <4A5CD3E2.2060307@vlnb.net>
In-Reply-To: <4A5CD3E2.2060307@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18P8v7XDUJh0FPtAx30ZjCP6i2sk36Cfg47+5H
 BEr76SUr3ZXoUO0RWNrSghS1pXIb5+XbwmqPJ+3MbsgFYznTVu
 mlrQK/DZOx9boe+3uNw/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin, on 07/14/2009 10:52 PM wrote:
> Ronald Moesbergen, on 07/13/2009 04:12 PM wrote:
>> 2009/7/10 Vladislav Bolkhovitin <vst@vlnb.net>:
>>> Vladislav Bolkhovitin, on 07/10/2009 12:43 PM wrote:
>>>> Ronald Moesbergen, on 07/10/2009 10:32 AM wrote:
>>>>>> I've also long ago noticed that reading data from block devices is
>>>>>> slower
>>>>>> than from files from mounted on those block devices file systems. Can
>>>>>> anybody explain it?
>>>>>>
>>>>>> Looks like this is strangeness #2 which we uncovered in our tests (the
>>>>>> first
>>>>>> one was earlier in this thread why the context RA doesn't work with
>>>>>> cooperative I/O threads as good as it should).
>>>>>>
>>>>>> Can you rerun the same 11 tests over a file on the file system, please?
>>>>> I'll see what I can do. Just te be sure: you want me to run
>>>>> blockdev-perftest on a file on the OCFS2 filesystem which is mounted
>>>>> on the client over iScsi, right?
>>>> Yes, please.
>>> Forgot to mention that you should also configure your backend storage as a
>>> big file on a file system (preferably, XFS) too, not as direct device, like
>>> /dev/vg/db-master.
>> Ok, here are the results:
>>
>> client kernel: 2.6.26-15lenny3 (debian)
>> server kernel: 2.6.29.5 with readahead patch
>>
>> Test done with XFS on both the target and the initiator. This confirms
>> your findings, using files instead of block devices is faster, but
>> only when using the io_context patch.
> 
> Seems, correct, except case (2), which is still 10% faster.
> 
>> Without io_context patch:
>> 1) client: default, server: default
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  18.327   18.327   17.740   56.491    0.872    0.883
>>  33554432  18.662   18.311   18.116   55.772    0.683    1.743
>>  16777216  18.900   18.421   18.312   55.229    0.754    3.452
>>   8388608  18.893   18.533   18.281   55.156    0.743    6.895
>>   4194304  18.512   18.097   18.400   55.850    0.536   13.963
>>   2097152  18.635   18.313   18.676   55.232    0.486   27.616
>>   1048576  18.441   18.264   18.245   55.907    0.267   55.907
>>    524288  17.773   18.669   18.459   55.980    1.184  111.960
>>    262144  18.580   18.758   17.483   56.091    1.767  224.365
>>    131072  17.224   18.333   18.765   56.626    2.067  453.006
>>     65536  18.082   19.223   18.238   55.348    1.483  885.567
>>     32768  17.719   18.293   18.198   56.680    0.795 1813.766
>>     16384  17.872   18.322   17.537   57.192    1.024 3660.273
>>
>> 2) client: default, server: 64 max_sectors_kb, RA default
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  18.738   18.435   18.400   55.283    0.451    0.864
>>  33554432  18.046   18.167   17.572   57.128    0.826    1.785
>>  16777216  18.504   18.203   18.377   55.771    0.376    3.486
>>   8388608  22.069   18.554   17.825   53.013    4.766    6.627
>>   4194304  19.211   18.136   18.083   55.465    1.529   13.866
>>   2097152  18.647   17.851   18.511   55.866    1.071   27.933
>>   1048576  19.084   18.177   18.194   55.425    1.249   55.425
>>    524288  18.999   18.553   18.380   54.934    0.763  109.868
>>    262144  18.867   18.273   18.063   55.668    1.020  222.673
>>    131072  17.846   18.966   18.193   55.885    1.412  447.081
>>     65536  18.195   18.616   18.482   55.564    0.530  889.023
>>     32768  17.882   18.841   17.707   56.481    1.525 1807.394
>>     16384  17.073   18.278   17.985   57.646    1.689 3689.369
>>
>> 3) client: default, server: default max_sectors_kb, RA 2MB
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  18.658   17.830   19.258   55.162    1.750    0.862
>>  33554432  17.193   18.265   18.517   56.974    1.854    1.780
>>  16777216  17.531   17.681   18.776   56.955    1.720    3.560
>>   8388608  18.234   17.547   18.201   56.926    1.014    7.116
>>   4194304  18.057   17.923   17.901   57.015    0.218   14.254
>>   2097152  18.565   17.739   17.658   56.958    1.277   28.479
>>   1048576  18.393   17.433   17.314   57.851    1.550   57.851
>>    524288  18.939   17.835   18.972   55.152    1.600  110.304
>>    262144  18.562   19.005   18.069   55.240    1.141  220.959
>>    131072  19.574   17.562   18.251   55.576    2.476  444.611
>>     65536  19.117   18.019   17.886   55.882    1.647  894.115
>>     32768  18.237   17.415   17.482   57.842    1.200 1850.933
>>     16384  17.760   18.444   18.055   56.631    0.876 3624.391
>>
>> 4) client: default, server: 64 max_sectors_kb, RA 2MB
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  18.368   17.495   18.524   56.520    1.434    0.883
>>  33554432  18.209   17.523   19.146   56.052    2.027    1.752
>>  16777216  18.765   18.053   18.550   55.497    0.903    3.469
>>   8388608  17.878   17.848   18.389   56.778    0.774    7.097
>>   4194304  18.058   17.683   18.567   56.589    1.129   14.147
>>   2097152  18.896   18.384   18.697   54.888    0.623   27.444
>>   1048576  18.505   17.769   17.804   56.826    1.055   56.826
>>    524288  18.319   17.689   17.941   56.955    0.816  113.910
>>    262144  19.227   17.770   18.212   55.704    1.821  222.815
>>    131072  18.738   18.227   17.869   56.044    1.090  448.354
>>     65536  19.319   18.525   18.084   54.969    1.494  879.504
>>     32768  18.321   17.672   17.870   57.047    0.856 1825.495
>>     16384  18.249   17.495   18.146   57.025    1.073 3649.582
>>
>> With io_context patch:
>> 5) client: default, server: default
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  12.393   11.925   12.627   83.196    1.989    1.300
>>  33554432  11.844   11.855   12.191   85.610    1.142    2.675
>>  16777216  12.729   12.602   12.068   82.187    1.913    5.137
>>   8388608  12.245   12.060   14.081   80.419    5.469   10.052
>>   4194304  13.224   11.866   12.110   82.763    3.833   20.691
>>   2097152  11.585   12.584   11.755   85.623    3.052   42.811
>>   1048576  12.166   12.144   12.321   83.867    0.539   83.867
>>    524288  12.019   12.148   12.160   84.568    0.448  169.137
>>    262144  12.014   12.378   12.074   84.259    1.095  337.036
>>    131072  11.840   12.068   11.849   85.921    0.756  687.369
>>     65536  12.098   11.803   12.312   84.857    1.470 1357.720
>>     32768  11.852   12.635   11.887   84.529    2.465 2704.931
>>     16384  12.443   13.110   11.881   82.197    3.299 5260.620
>>
>> 6) client: default, server: 64 max_sectors_kb, RA default
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  13.033   12.122   11.950   82.911    3.110    1.295
>>  33554432  12.386   13.357   12.082   81.364    3.429    2.543
>>  16777216  12.102   11.542   12.053   86.096    1.860    5.381
>>   8388608  12.240   11.740   11.789   85.917    1.601   10.740
>>   4194304  11.824   12.388   12.042   84.768    1.621   21.192
>>   2097152  11.962   12.283   11.973   84.832    1.036   42.416
>>   1048576  12.639   11.863   12.010   84.197    2.290   84.197
>>    524288  11.809   12.919   11.853   84.121    3.439  168.243
>>    262144  12.105   12.649   12.779   81.894    1.940  327.577
>>    131072  12.441   12.769   12.713   81.017    0.923  648.137
>>     65536  12.490   13.308   12.440   80.414    2.457 1286.630
>>     32768  13.235   11.917   12.300   82.184    3.576 2629.883
>>     16384  12.335   12.394   12.201   83.187    0.549 5323.990
>>
>> 7) client: default, server: default max_sectors_kb, RA 2MB
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  12.017   12.334   12.151   84.168    0.897    1.315
>>  33554432  12.265   12.200   11.976   84.310    0.864    2.635
>>  16777216  12.356   11.972   12.292   83.903    1.165    5.244
>>   8388608  12.247   12.368   11.769   84.472    1.825   10.559
>>   4194304  11.888   11.974   12.144   85.325    0.754   21.331
>>   2097152  12.433   10.938   11.669   87.911    4.595   43.956
>>   1048576  11.748   12.271   12.498   84.180    2.196   84.180
>>    524288  11.726   11.681   12.322   86.031    2.075  172.062
>>    262144  12.593   12.263   11.939   83.530    1.817  334.119
>>    131072  11.874   12.265   12.441   84.012    1.648  672.093
>>     65536  12.119   11.848   12.037   85.330    0.809 1365.277
>>     32768  12.549   12.080   12.008   83.882    1.625 2684.238
>>     16384  12.369   12.087   12.589   82.949    1.385 5308.766
>>
>> 8) client: default, server: 64 max_sectors_kb, RA 2MB
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  12.664   11.793   11.963   84.428    2.575    1.319
>>  33554432  11.825   12.074   12.442   84.571    1.761    2.643
>>  16777216  11.997   11.952   10.905   88.311    3.958    5.519
>>   8388608  11.866   12.270   11.796   85.519    1.476   10.690
>>   4194304  11.754   12.095   12.539   84.483    2.230   21.121
>>   2097152  11.948   11.633   11.886   86.628    1.007   43.314
>>   1048576  12.029   12.519   11.701   84.811    2.345   84.811
>>    524288  11.928   12.011   12.049   85.363    0.361  170.726
>>    262144  12.559   11.827   11.729   85.140    2.566  340.558
>>    131072  12.015   12.356   11.587   85.494    2.253  683.952
>>     65536  11.741   12.113   11.931   85.861    1.093 1373.770
>>     32768  12.655   11.738   12.237   83.945    2.589 2686.246
>>     16384  11.928   12.423   11.875   84.834    1.711 5429.381
>>
>> 9) client: 64 max_sectors_kb, default RA. server: 64 max_sectors_kb, RA 2MB
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  13.570   13.491   14.299   74.326    1.927    1.161
>>  33554432  13.238   13.198   13.255   77.398    0.142    2.419
>>  16777216  13.851   13.199   13.463   75.857    1.497    4.741
>>   8388608  13.339   16.695   13.551   71.223    7.010    8.903
>>   4194304  13.689   13.173   14.258   74.787    2.415   18.697
>>   2097152  13.518   13.543   13.894   75.021    0.934   37.510
>>   1048576  14.119   14.030   13.820   73.202    0.659   73.202
>>    524288  13.747   14.781   13.820   72.621    2.369  145.243
>>    262144  14.168   13.652   14.165   73.189    1.284  292.757
>>    131072  14.112   13.868   14.213   72.817    0.753  582.535
>>     65536  14.604   13.762   13.725   73.045    2.071 1168.728
>>     32768  14.796   15.356   14.486   68.861    1.653 2203.564
>>     16384  13.079   13.525   13.427   76.757    1.111 4912.426
>>
>> 10) client: default max_sectors_kb, 2MB RA. server: 64 max_sectors_kb, RA 2MB
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  20.372   18.077   17.262   55.411    3.800    0.866
>>  33554432  17.287   17.620   17.828   58.263    0.740    1.821
>>  16777216  16.802   18.154   17.315   58.831    1.865    3.677
>>   8388608  17.510   18.291   17.253   57.939    1.427    7.242
>>   4194304  17.059   17.706   17.352   58.958    0.897   14.740
>>   2097152  17.252   18.064   17.615   58.059    1.090   29.029
>>   1048576  17.082   17.373   17.688   58.927    0.838   58.927
>>    524288  17.129   17.271   17.583   59.103    0.644  118.206
>>    262144  17.411   17.695   18.048   57.808    0.848  231.231
>>    131072  17.937   17.704   18.681   56.581    1.285  452.649
>>     65536  17.927   17.465   17.907   57.646    0.698  922.338
>>     32768  18.494   17.820   17.719   56.875    1.073 1819.985
>>     16384  18.800   17.759   17.575   56.798    1.666 3635.058
>>
>> 11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB
>> blocksize       R        R        R   R(avg,    R(std        R
>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  20.045   21.881   20.018   49.680    2.037    0.776
>>  33554432  20.768   20.291   20.464   49.938    0.479    1.561
>>  16777216  21.563   20.714   20.429   49.017    1.116    3.064
>>   8388608  21.290   21.109   21.308   48.221    0.205    6.028
>>   4194304  22.240   20.662   21.088   48.054    1.479   12.013
>>   2097152  20.282   21.098   20.580   49.593    0.806   24.796
>>   1048576  20.367   19.929   20.252   50.741    0.469   50.741
>>    524288  20.885   21.203   20.684   48.945    0.498   97.890
>>    262144  19.982   21.375   20.798   49.463    1.373  197.853
>>    131072  20.744   21.590   19.698   49.593    1.866  396.740
>>     65536  21.586   20.953   21.055   48.314    0.627  773.024
>>     32768  21.228   20.307   21.049   49.104    0.950 1571.327
>>     16384  21.257   21.209   21.150   48.289    0.100 3090.498
> 
> The drop with 64 max_sectors_kb on the client is a consequence of how 
> CFQ is working. I can't find the exact code responsible for this, but 
> from all signs, CFQ stops delaying requests if amount of outstanding 
> requests exceeds some threshold, which is 2 or 3. With 64 max_sectors_kb 
> and 5 SCST I/O threads this threshold is exceeded, so CFQ doesn't 
> recover order of requests, hence the performance drop. With default 512 
> max_sectors_kb and 128K RA the server sees at max 2 requests at time.
> 
> Ronald, can you perform the same tests with 1 and 2 SCST I/O threads, 
> please?

With context-RA patch, please, in those and future tests, since it 
should make RA for cooperative threads much better.

> You can limit amount of SCST I/O threads by num_threads parameter of 
> scst_vdisk module.
> 
> Thanks,
> Vlad
> 

