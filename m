Return-Path: <linux-kernel-owner+w=401wt.eu-S934684AbZGQOPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbZGQOPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934691AbZGQOPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:15:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:7798 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934689AbZGQOPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WcDbr82xYPjLAafqSJxIpqxk+JkWKTrvpNN6bgPyW+Oknfb+dKj0pZFCkgapX5mKv+
         MioV4FO7Wivua41JuFIx7uUkXjNF2o/jiVjOQTVVwvVdHIt8Zfc3y9GeXKixTgDHuUFX
         59F7h+pMKOr438yofbrzvB3D7LtDl01i4P0hs=
MIME-Version: 1.0
In-Reply-To: <4A5F0293.3010206@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net> <4A5493A8.2000806@vlnb.net>
	 <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>
	 <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net>
	 <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com>
	 <4A5CD3E2.2060307@vlnb.net> <4A5D7794.2070607@vlnb.net>
	 <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>
	 <4A5F0293.3010206@vlnb.net>
Date: Fri, 17 Jul 2009 16:15:49 +0200
Message-ID: <a0272b440907170715q72af7bb8l53c9dbd5e553fe2c@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/16 Vladislav Bolkhovitin <vst@vlnb.net>:
>
> Ronald Moesbergen, on 07/16/2009 11:32 AM wrote:
>>
>> 2009/7/15 Vladislav Bolkhovitin <vst@vlnb.net>:
>>>>
>>>> The drop with 64 max_sectors_kb on the client is a consequence of how
>>>> CFQ
>>>> is working. I can't find the exact code responsible for this, but from
>>>> all
>>>> signs, CFQ stops delaying requests if amount of outstanding requests
>>>> exceeds
>>>> some threshold, which is 2 or 3. With 64 max_sectors_kb and 5 SCST I/O
>>>> threads this threshold is exceeded, so CFQ doesn't recover order of
>>>> requests, hence the performance drop. With default 512 max_sectors_kb
>>>> and
>>>> 128K RA the server sees at max 2 requests at time.
>>>>
>>>> Ronald, can you perform the same tests with 1 and 2 SCST I/O threads,
>>>> please?
>>
>> Ok. Should I still use the file-on-xfs testcase for this, or should I
>> go back to using a regular block device?
>
> Yes, please
>
>> The file-over-iscsi is quite
>> uncommon I suppose, most people will export a block device over iscsi,
>> not a file.
>
> No, files are common. The main reason why people use direct block devices is
> a not supported by anything believe that comparing with files they "have
> less overhead", so "should be faster". But it isn't true and can be easily
> checked.
>
>>> With context-RA patch, please, in those and future tests, since it should
>>> make RA for cooperative threads much better.
>>>
>>>> You can limit amount of SCST I/O threads by num_threads parameter of
>>>> scst_vdisk module.
>>
>> Ok, I'll try that and include the blk_run_backing_dev,
>> readahead-context and io_context patches.

The results:

client kernel: 2.6.26-15lenny3 (debian)
server kernel: 2.6.29.5 with readahead-context, blk_run_backing_dev
and io_context

With one IO thread:

5) client: default, server: default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.990   15.308   16.689   64.097    2.259    1.002
 33554432  15.981   16.064   16.221   63.651    0.392    1.989
 16777216  15.841   15.660   16.031   64.635    0.619    4.040

6) client: default, server: 64 max_sectors_kb, RA default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  16.035   16.024   16.654   63.084    1.130    0.986
 33554432  15.924   15.975   16.359   63.668    0.762    1.990
 16777216  16.168   16.104   15.838   63.858    0.571    3.991

7) client: default, server: default max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  14.895   16.142   15.998   65.398    2.379    1.022
 33554432  16.753   16.169   16.067   62.729    1.146    1.960
 16777216  16.866   15.912   16.099   62.892    1.570    3.931

8) client: default, server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.923   15.716   16.741   63.545    1.715    0.993
 33554432  16.010   16.026   16.113   63.802    0.180    1.994
 16777216  16.644   16.239   16.143   62.672    0.827    3.917

9) client: 64 max_sectors_kb, default RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.753   15.882   15.482   65.207    0.697    1.019
 33554432  15.670   16.268   15.669   64.548    1.134    2.017
 16777216  15.746   15.519   16.411   64.471    1.516    4.029

10) client: default max_sectors_kb, 2MB RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.639   14.360   13.654   73.795    1.758    1.153
 33554432  13.584   13.938   14.538   73.095    2.035    2.284
 16777216  13.617   13.510   13.803   75.060    0.665    4.691

11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.428   13.541   14.144   74.760    1.690    1.168
 33554432  13.707   13.352   13.462   75.821    0.827    2.369
 16777216  14.380   13.504   13.675   73.975    1.991    4.623

With two threads:
5) client: default, server: default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  12.453   12.173   13.014   81.677    2.254    1.276
 33554432  12.066   11.999   12.960   83.073    2.877    2.596
 16777216  13.719   11.969   12.569   80.554    4.500    5.035

6) client: default, server: 64 max_sectors_kb, RA default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  12.886   12.201   12.147   82.564    2.198    1.290
 33554432  12.344   12.928   12.007   82.483    2.504    2.578
 16777216  12.380   11.951   13.119   82.151    3.141    5.134

7) client: default, server: default max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  12.824   13.485   13.534   77.148    1.913    1.205
 33554432  12.084   13.752   12.111   81.251    4.800    2.539
 16777216  12.658   13.035   11.196   83.640    5.612    5.227

8) client: default, server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  12.253   12.552   11.773   84.044    2.230    1.313
 33554432  13.177   12.456   11.604   82.723    4.316    2.585
 16777216  12.471   12.318   13.006   81.324    1.878    5.083

9) client: 64 max_sectors_kb, default RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  14.409   13.311   14.278   73.238    2.624    1.144
 33554432  14.665   14.260   14.080   71.455    1.211    2.233
 16777216  14.179   14.810   14.640   70.438    1.303    4.402

10) client: default max_sectors_kb, 2MB RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.401   14.107   13.549   74.860    1.642    1.170
 33554432  14.575   13.221   14.428   72.894    3.236    2.278
 16777216  13.771   14.227   13.594   73.887    1.408    4.618

11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  10.286   12.272   10.245   94.317    7.690    1.474
 33554432  10.241   10.415   13.374   91.624   10.670    2.863
 16777216  10.499   10.224   10.792   97.526    2.151    6.095

The last result comes close to 100MB/s!

Ronald.
