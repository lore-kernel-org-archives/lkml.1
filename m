Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZGVIo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZGVIo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZGVIo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:44:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:55845 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZGVIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WXaCv2HVG06EkjtYnUMKsq96qpxegxv9bgzwPFWiQFUbs+/7/bTufDqjz1ixtICZuz
         bSWBJbhrXLLEzhTqxmtumkx99JhsbmzZNg1yOMjksmGQ/eMpaCcoOXgeFh4kwwBZxPrz
         7IFO2IH7s+L6JlKzfuQDx1zdQSw2hYAqUn2ys=
MIME-Version: 1.0
In-Reply-To: <4A641AAC.9030300@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net> <4A570981.5080803@vlnb.net>
	 <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com>
	 <4A5CD3E2.2060307@vlnb.net> <4A5D7794.2070607@vlnb.net>
	 <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>
	 <4A5F0293.3010206@vlnb.net>
	 <a0272b440907170715q72af7bb8l53c9dbd5e553fe2c@mail.gmail.com>
	 <4A60C1A8.9020504@vlnb.net> <4A641AAC.9030300@vlnb.net>
Date: Wed, 22 Jul 2009 10:44:24 +0200
Message-ID: <a0272b440907220144i159baca4u1a1f1f2d0c36193a@mail.gmail.com>
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

2009/7/20 Vladislav Bolkhovitin <vst@vlnb.net>:
>>>
>>> The last result comes close to 100MB/s!
>>
>> Good! Although I expected maximum with a single thread.
>>
>> Can you do the same set of tests with deadline scheduler on the server?
>
> Case of 5 I/O threads (default) will also be interesting. I.e., overall,
> cases of 1, 2 and 5 I/O threads with deadline scheduler on the server.

Ok. The results:

Cfq seems to perform better in this case.

client kernel: 2.6.26-15lenny3 (debian)
server kernel: 2.6.29.5 with readahead-context, blk_run_backing_dev
and io_context
server scheduler: deadline

With one IO thread:
5) client: default, server: default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  16.067   16.883   16.096   62.669    1.427    0.979
 33554432  16.034   16.564   16.050   63.161    0.948    1.974
 16777216  16.045   15.086   16.709   64.329    2.715    4.021

6) client: default, server: 64 max_sectors_kb, RA default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.851   15.348   16.652   64.271    2.147    1.004
 33554432  16.182   16.104   16.170   63.397    0.135    1.981
 16777216  15.952   16.085   16.258   63.613    0.493    3.976

7) client: default, server: default max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.814   16.222   16.650   63.126    1.327    0.986
 33554432  16.113   15.962   16.340   63.456    0.610    1.983
 16777216  16.149   16.098   15.895   63.815    0.438    3.988

8) client: default, server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  16.032   17.163   15.864   62.695    2.161    0.980
 33554432  16.163   15.499   16.466   63.870    1.626    1.996
 16777216  16.067   16.133   16.710   62.829    1.099    3.927

9) client: 64 max_sectors_kb, default RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.498   15.474   15.195   66.547    0.599    1.040
 33554432  15.729   15.636   15.758   65.192    0.214    2.037
 16777216  15.656   15.481   15.724   65.557    0.430    4.097

10) client: default max_sectors_kb, 2MB RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.480   14.125   13.648   74.497    1.466    1.164
 33554432  13.584   13.518   14.272   74.293    1.806    2.322
 16777216  13.511   13.585   13.552   75.576    0.170    4.723

11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.356   13.079   13.488   76.960    0.991    1.203
 33554432  13.713   13.038   13.030   77.268    1.834    2.415
 16777216  13.895   13.032   13.128   76.758    2.178    4.797

With two threads:
5) client: default, server: default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  12.661   12.773   13.654   78.681    2.622    1.229
 33554432  12.709   12.693   12.459   81.145    0.738    2.536
 16777216  12.657   14.055   13.237   77.038    3.292    4.815

6) client: default, server: 64 max_sectors_kb, RA default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.300   12.877   13.705   77.078    1.964    1.204
 33554432  13.025   14.404   12.833   76.501    3.855    2.391
 16777216  13.172   13.220   12.997   77.995    0.570    4.875

7) client: default, server: default max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.365   13.168   12.835   78.053    1.308    1.220
 33554432  13.518   13.122   13.366   76.799    0.942    2.400
 16777216  13.177   13.146   13.839   76.534    1.797    4.783

8) client: default, server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  14.308   12.669   13.520   76.045    3.788    1.188
 33554432  12.586   12.897   13.221   79.405    1.596    2.481
 16777216  13.766   12.583   14.176   76.001    3.903    4.750

9) client: 64 max_sectors_kb, default RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  14.454   12.537   15.058   73.509    5.893    1.149
 33554432  15.871   14.201   13.846   70.194    4.083    2.194
 16777216  14.721   13.346   14.434   72.410    3.104    4.526

10) client: default max_sectors_kb, 2MB RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.262   13.308   13.416   76.828    0.371    1.200
 33554432  13.915   13.182   13.065   76.551    2.114    2.392
 16777216  13.223   14.133   13.317   75.596    2.232    4.725

11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  18.277   17.743   17.534   57.380    0.997    0.897
 33554432  18.018   17.728   17.343   57.879    0.907    1.809
 16777216  17.600   18.466   17.645   57.223    1.253    3.576

With five threads:
5) client: default, server: default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  12.915   13.643   12.572   78.598    2.654    1.228
 33554432  12.716   12.970   13.283   78.858    1.403    2.464
 16777216  14.372   13.282   13.122   75.461    3.002    4.716

6) client: default, server: 64 max_sectors_kb, RA default
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.372   13.205   12.468   78.750    2.421    1.230
 33554432  13.489   13.352   12.883   77.363    1.533    2.418
 16777216  13.127   12.653   14.252   76.928    3.785    4.808

7) client: default, server: default max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.135   13.031   13.824   76.872    1.994    1.201
 33554432  13.079   13.590   13.730   76.076    1.600    2.377
 16777216  12.707   12.951   13.805   77.942    2.735    4.871

8) client: default, server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.030   12.947   13.538   77.772    1.524    1.215
 33554432  12.826   12.973   13.805   77.649    2.482    2.427
 16777216  12.751   13.007   12.986   79.295    0.718    4.956

9) client: 64 max_sectors_kb, default RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  13.236   13.349   13.833   76.034    1.445    1.188
 33554432  13.481   14.259   13.582   74.389    1.836    2.325
 16777216  14.394   13.922   13.943   72.712    1.111    4.545

10) client: default max_sectors_kb, 2MB RA. server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  18.245   18.690   17.342   56.654    1.779    0.885
 33554432  17.744   18.122   17.577   57.492    0.731    1.797
 16777216  18.280   18.564   17.846   56.186    0.914    3.512

11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.241   16.894   15.853   64.131    2.705    1.002
 33554432  14.858   16.904   15.588   65.064    3.435    2.033
 16777216  16.777   15.939   15.034   64.465    2.893    4.029

Ronald.
