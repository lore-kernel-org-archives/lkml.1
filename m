Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0BBTpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:45:12 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35385 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab0BBTpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:45:10 -0500
Date: Tue, 2 Feb 2010 20:45:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: Do not idle on async queues
Message-ID: <20100202194509.GE5733@kernel.dk>
References: <20100202184834.GC3922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202184834.GC3922@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02 2010, Vivek Goyal wrote:
> Hi Jens,
> 
> Few weeks back, Shaohua Li had posted similar patch. I am reposting it
> with more test results.
> 
> This patch does two things.
> 
> - Do not idle on async queues.
> 
> - It also changes the write queue depth CFQ drives (cfq_may_dispatch()).
>   Currently, we seem to driving queue depth of 1 always for WRITES. This is
>   true even if there is only one write queue in the system and all the logic
>   of infinite queue depth in case of single busy queue as well as slowly
>   increasing queue depth based on last delayed sync request does not seem to
>   be kicking in at all.
> 
> This patch will allow deeper WRITE queue depths (subjected to the other
> WRITE queue depth contstraints like cfq_quantum and last delayed sync
> request).
> 
> Shaohua Li had reported getting more out of his SSD. For me, I have got
> one Lun exported from an HP EVA and when pure buffered writes are on, I
> can get more out of the system. Following are test results of pure
> buffered writes (with end_fsync=1) with vanilla and patched kernel. These
> results are average of 3 sets of run with increasing number of threads.
> 
> AVERAGE[bufwfs][vanilla]
> -------
> job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)
> ---       --- --  ------------   -----------    -------------  -----------
> bufwfs    3   1   0              0              95349          474141
> bufwfs    3   2   0              0              100282         806926
> bufwfs    3   4   0              0              109989         2.7301e+06
> bufwfs    3   8   0              0              116642         3762231
> bufwfs    3   16  0              0              118230         6902970
> 
> AVERAGE[bufwfs] [patched kernel]
> -------
> bufwfs    3   1   0              0              270722         404352
> bufwfs    3   2   0              0              206770         1.06552e+06
> bufwfs    3   4   0              0              195277         1.62283e+06
> bufwfs    3   8   0              0              260960         2.62979e+06
> bufwfs    3   16  0              0              299260         1.70731e+06
> 
> I also ran buffered writes along with some sequential reads and some
> buffered reads going on in the system on a SATA disk because the potential
> risk could be that we should not be driving queue depth higher in presence
> of sync IO going to keep the max clat low.
> 
> With some random and sequential reads going on in the system on one SATA
> disk I did not see any significant increase in max clat. So it looks like
> other WRITE queue depth control logic is doing its job. Here are the
> results.
> 
> AVERAGE[brr, bsr, bufw together] [vanilla]
> -------
> job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)
> ---       --- --  ------------   -----------    -------------  -----------
> brr       3   1   850            546345         0              0
> bsr       3   1   14650          729543         0              0
> bufw      3   1   0              0              23908          8274517
> 
> brr       3   2   981.333        579395         0              0
> bsr       3   2   14149.7        1175689        0              0
> bufw      3   2   0              0              21921          1.28108e+07
> 
> brr       3   4   898.333        1.75527e+06    0              0
> bsr       3   4   12230.7        1.40072e+06    0              0
> bufw      3   4   0              0              19722.3        2.4901e+07
> 
> brr       3   8   900            3160594        0              0
> bsr       3   8   9282.33        1.91314e+06    0              0
> bufw      3   8   0              0              18789.3        23890622
> 
> AVERAGE[brr, bsr, bufw mixed] [patched kernel]
> -------
> job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)
> ---       --- --  ------------   -----------    -------------  -----------
> brr       3   1   837            417973         0              0
> bsr       3   1   14357.7        591275         0              0
> bufw      3   1   0              0              24869.7        8910662
> 
> brr       3   2   1038.33        543434         0              0
> bsr       3   2   13351.3        1205858        0              0
> bufw      3   2   0              0              18626.3        13280370
> 
> brr       3   4   913            1.86861e+06    0              0
> bsr       3   4   12652.3        1430974        0              0
> bufw      3   4   0              0              15343.3        2.81305e+07
> 
> brr       3   8   890            2.92695e+06    0              0
> bsr       3   8   9635.33        1.90244e+06    0              0
> bufw      3   8   0              0              17200.3        24424392
> 
> So looks like it might make sense to include this patch.

Yep agree, I'll get it pushed for 2.6.33. Thanks.

-- 
Jens Axboe

