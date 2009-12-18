Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbZLRVDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbZLRVDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbZLRVDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:03:14 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:41228 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbZLRVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:03:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GOXUixDbMQe62L3ZwTQOR/oK4xE/OspJhHZVY7r+AVKb/bDQPIbiHPskDy+PPqPLcb
         QJyDbrISiPAxlxp/jcQeOyAgwg/zXPyMfVVbKy5ocHiJrGLwG73mhHeVG32V1n02bFc3
         Jr0NgVGtuTzUH1L6IBXaoWJjwoeTYgX2hMSXI=
MIME-Version: 1.0
In-Reply-To: <x49iqc42t8r.fsf@segfault.boston.devel.redhat.com>
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
	 <4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com>
	 <4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
	 <x49ein6nx9k.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0912081243ra071947if9a3edae77fb3861@mail.gmail.com>
	 <x49ocm8nhn6.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0912110915u209b8923m359d9147cc229fea@mail.gmail.com>
	 <x49iqc42t8r.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 18 Dec 2009 22:03:05 +0100
Message-ID: <4e5e476b0912181303v3efbd846le61a0deacffe6a49@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nBIL4416027754

Thanks Jeff.Your tests show that with the patch, low_latency doesn't penalizewriteback any more on fast hardware, so the goal of the patch isfulfilled. Lowering slice_async doesn't change the picture (I wasexpecting an improvement in seq write bandwidth).I'm still puzzled of why with 2.6.29 your SAN could achieve 300 MB/ssequential writes, and it can't achieve it any more.Can you try lowering slice_idle, trying e.g. 2ms?
ThanksCorrado
On Fri, Dec 18, 2009 at 4:32 PM, Jeff Moyer <jmoyer@redhat.com> wrote:> Corrado Zoccolo <czoccolo@gmail.com> writes:>>> Hi Jeff,>> On Wed, Dec 9, 2009 at 7:09 PM, Jeff Moyer <jmoyer@redhat.com> wrote:>>> Corrado Zoccolo <czoccolo@gmail.com> writes:>>>>>>> The numbers look good. Now, there is no penalty in having low_latency>>>> set for sequential writes, and just a small penalty for random ones.>>>> The fact that random reads are faster with low_latency set is interesting.>>>> Is the test is running with your patched tiobench (so that the number>>>> of random operations is comparable with sequential ones)?>>>>>> No, I forgot all about that.  The number of random operations defaults>>> to 4000, which is pretty low.  I'll re-run the tests with a number>>> comparable to the sequential runs.  Sorry about that.>>>>> N.P.>> if you have time, can you also re-run the test changing:>> iosched/fifo_expire_async to 8 ?>> I hope that reducing the expire_async, will make cfq quicker at switching>> between the different threads, allowing more parallelism for seq>> writers on your hw.>> If this is the case, I think I can try to estimate the>> fifo_expire_async in the autotuning patch.>> Sorry this took so long.  I've been rather busy of late.>> Cheers,> Jeff>> low_latency=1, fifo_expire_async=8>> Unit information> ================> File size = megabytes> Blk Size  = bytes> Rate      = megabytes per second> CPU%      = percentage of CPU used during the test> Latency   = milliseconds> Lat%      = percent of requests that took longer than X seconds> CPU Eff   = Rate divided by CPU% - throughput per cpu load>> Sequential Reads>                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----> 2.6.32                        8192  65536   8   88.39 89.74%    16.388     2032.62   0.00000  0.00000    98> 2.6.32                        8192  65536  16   90.77 185.3%    32.213     2175.99   0.00000  0.00000    49>> Random Reads>                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----> 2.6.32                        8192  65536   8   19.62 25.74%    71.827     3397.26   0.00000  0.00000    76> 2.6.32                        8192  65536  16   23.82 55.01%   103.361     4075.53   0.00000  0.00000    43>> Sequential Writes>                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----> 2.6.32                        8192  65536   8  108.28 1007.%    12.984     5643.55   0.00076  0.00000    11> 2.6.32                        8192  65536  16  112.40 2014.%    25.430     8592.98   0.00839  0.00000     6>> Random Writes>                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----> 2.6.32                        8192  65536   8   63.94 337.7%    22.885     6047.22   0.00076  0.00000    19> 2.6.32                        8192  65536  16   61.94 662.5%    46.997    12759.69   0.15411  0.00000     9>>> low_latency=0, fifo_expire_async=8>> Unit information> ================> File size = megabytes> Blk Size  = bytes> Rate      = megabytes per second> CPU%      = percentage of CPU used during the test> Latency   = milliseconds> Lat%      = percent of requests that took longer than X seconds> CPU Eff   = Rate divided by CPU% - throughput per cpu load>> Sequential Reads>                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----> 2.6.32                        8192  65536   8   89.13 88.30%    15.872     3101.39   0.00000  0.00000   101> 2.6.32                        8192  65536  16   86.78 161.7%    30.794     4909.02   0.00000  0.00000    54>> Random Reads>                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----> 2.6.32                        8192  65536   8   20.21 26.64%    69.863     4285.42   0.00000  0.00000    76> 2.6.32                        8192  65536  16   20.10 52.75%   139.761     5986.94   0.00076  0.00000    38>> Sequential Writes>                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----> 2.6.32                        8192  65536   8  108.74 1020.%    13.070     5331.78   0.00076  0.00000    11> 2.6.32                        8192  65536  16  112.18 2020.%    25.559     7903.16   0.00992  0.00000     6>> Random Writes>                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff> ---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----> 2.6.32                        8192  65536   8   64.53 337.8%    22.671     5388.77   0.00000  0.00000    19> 2.6.32                        8192  65536  16   61.75 668.9%    47.265    13271.37   0.12894  0.00000     9>


-- __________________________________________________________________________
dott. Corrado Zoccolo                          mailto:czoccolo@gmail.comPhD - Department of Computer Science - University of Pisa, Italy--------------------------------------------------------------------------The self-confidence of a warrior is not the self-confidence of the averageman. The average man seeks certainty in the eyes of the onlooker and callsthat self-confidence. The warrior seeks impeccability in his own eyes andcalls that humbleness.                               Tales of Power - C. Castaneda���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
