Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbZK3W6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbZK3W6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZK3W6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:58:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZK3W6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:58:35 -0500
Date: Mon, 30 Nov 2009 17:56:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com
Subject: Re: Block IO Controller V4
Message-ID: <20091130225640.GO11670@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com> <20091130160024.GD11670@redhat.com> <4e5e476b0911301334o2440ea8fi7444aa7d5a688ed1@mail.gmail.com> <1259618433.2701.31.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259618433.2701.31.camel@cail>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 05:00:33PM -0500, Alan D. Brunelle wrote:
> FYI: Results today from my test suite - haven't had time to parse them
> in any depth...

Thanks Alan. I am trying to parse the results below. s0 and s8 still mean
slice idle enabled disabled? Instead of that we can try group_isolation
enabled or disabled for all the tests. 

> 
> ---- ---- - --------- --------- ---------
> Mode RdWr N   base      i1,s8     i1,s0
> ---- ---- - --------- --------- ---------
> rnd  rd   2      43.3      50.6      43.3
> rnd  rd   4      40.9      55.8      41.1
> rnd  rd   8      36.7      61.6      36.9

I am assuming that base still means no io controller patches applied. Also
assuming that base must have run with slice_idle=8.

If yes, above is surprising. After applying the patches, performance
of random reads have become much better with slice_idle=8. May be you
ran the base with slice_idle=0 that's why results more or less match
with ioc patches applied with slice_idle=0.

> 
> rnd  wr   2      69.2      68.1      69.4
> rnd  wr   4      66.0      62.7      66.0
> rnd  wr   8      60.5      47.8      61.3

If you ran base with slice_idle=0, then first and third columns match.
Can't conclude much about i1,s8 case. I am curious though why performance
dropped when number of writers reached 8.

> 
> rnd  rdwr 2      54.3      49.1      54.3
> rnd  rdwr 4      50.3      41.7      50.4
> rnd  rdwr 8      45.9      30.4      46.2

Same as random write.

> 
> seq  rd   2     613.7     606.0     602.8
> seq  rd   4     617.3     606.7     606.1
> seq  rd   8     618.3     602.9     605.0
> 

This is surprising again. if s0 means slice_idle=0, then in that case
performance should have sucked with N=8 as we should have been seeking
all over the place.

> seq  wr   2     670.3     725.9     703.9
> seq  wr   4     680.0     722.0     627.0
> seq  wr   8     685.3     710.4     631.3
> 
> seq  rdwr 2     703.4     665.3     680.2
> seq  rdwr 4     677.5     656.8     639.9
> seq  rdwr 8     683.3     646.4     633.7
> 
> ===============================================================
> 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
> Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
> base        rnd  rd   2  21.7  21.5
> base        rnd  rd   4  11.3  11.4   9.4   8.8
> base        rnd  rd   8   2.7   2.9   7.0   7.2   4.2   4.3   4.6   3.8
> 
> base        rnd  wr   2  34.2  34.9
> base        rnd  wr   4  18.2  18.3  15.3  14.2
> base        rnd  wr   8   3.9   3.8  16.8  17.3   4.7   4.6   5.1   4.3
> 
> base        rnd  rdwr 2  27.1  27.2
> base        rnd  rdwr 4  13.8  13.3  11.8  11.4
> base        rnd  rdwr 8   2.9   2.8   9.9   9.6   4.9   5.4   5.7   4.6
> 
> 
> base        seq  rd   2 306.9 306.8
> base        seq  rd   4 160.6 161.0 147.5 148.1
> base        seq  rd   8  78.3  78.9  76.7  77.6  76.1  75.8  77.8  77.1
> 
> base        seq  wr   2 335.2 335.1
> base        seq  wr   4 170.7 171.5 168.7 169.0
> base        seq  wr   8  87.7  88.3  85.4  85.0  81.9  84.2  85.6  87.2
> 
> base        seq  rdwr 2 350.6 352.8
> base        seq  rdwr 4 180.3 181.4 157.7 158.2
> base        seq  rdwr 8  85.8  86.2  87.2  86.8  82.6  81.5  85.3  88.0
> 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
> Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
> i1,s8       rnd  rd   2  20.6  30.0
> i1,s8       rnd  rd   4   2.0   4.8  26.1  22.8
> i1,s8       rnd  rd   8   0.7   1.3   3.5   4.6  15.2  16.1  10.0  10.2
> 

These are rates MB/s? I think we need to look at the disk time also because
we try to provide fairness in terms of disk time. In many a cases it
very closely maps to rates also but not always.

Is group_isolation enabled for these test cases. If not, these results are
surprising as I would expect all the random readers to be in root group
and then almost match base results.

But these seem to be very different from base results. So may be
group_isolation=1. If that's the case, then we do see service
differentiation but this does not seem too proportionate in terms of
weight.

Looking at disk.time and disk.dequeue file will help here.

Stopping parsing till I you get a chance to let me know some of the
parameters.

Thanks
Vivek


> i1,s8       rnd  wr   2  18.5  49.6
> i1,s8       rnd  wr   4   1.0   2.1  19.7  40.0
> i1,s8       rnd  wr   8   0.5   0.7   0.9   1.2   1.6   3.2  15.1  24.5
> 
> i1,s8       rnd  rdwr 2  16.4  32.7
> i1,s8       rnd  rdwr 4   1.2   3.5  16.2  20.8
> i1,s8       rnd  rdwr 8   0.6   0.8   1.1   1.6   2.1   3.6   9.3  11.3
> 
> 
> i1,s8       seq  rd   2 202.8 403.2
> i1,s8       seq  rd   4  91.9 115.3 181.9 217.7
> i1,s8       seq  rd   8  39.1  76.1  73.7  74.6  74.9  75.6  84.6 104.3
> 
> i1,s8       seq  wr   2 246.8 479.1
> i1,s8       seq  wr   4 108.1 157.4 201.9 254.6
> i1,s8       seq  wr   8  52.2  81.0  80.8  83.0  90.9  95.6 108.6 118.3
> 
> i1,s8       seq  rdwr 2 226.9 438.4
> i1,s8       seq  rdwr 4 103.4 139.4 186.4 227.7
> i1,s8       seq  rdwr 8  53.4  77.4  77.4  77.9  79.7  82.1  93.5 105.1
> 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
> Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
> i1,s0       rnd  rd   2  21.7  21.6
> i1,s0       rnd  rd   4  12.4  12.0   9.7   7.0
> i1,s0       rnd  rd   8   2.7   2.8   7.4   7.6   4.4   4.1   4.4   3.5
> 
> i1,s0       rnd  wr   2  35.4  34.0
> i1,s0       rnd  wr   4  19.9  19.9  13.7  12.4
> i1,s0       rnd  wr   8   4.0   3.8  17.5  19.8   4.4   3.9   4.5   3.5
> 
> i1,s0       rnd  rdwr 2  27.4  26.9
> i1,s0       rnd  rdwr 4  14.1  14.8  10.6  10.9
> i1,s0       rnd  rdwr 8   2.7   3.1  10.3  10.5   5.6   4.7   5.1   4.1
> 
> 
> i1,s0       seq  rd   2 301.4 301.3
> i1,s0       seq  rd   4 157.8 156.9 145.1 146.2
> i1,s0       seq  rd   8  76.4  76.4  75.2  74.9  76.7  75.4  74.3  75.7
> 
> i1,s0       seq  wr   2 351.5 352.4
> i1,s0       seq  wr   4 156.5 156.4 156.1 158.1
> i1,s0       seq  wr   8  80.3  79.7  81.3  80.8  75.8  76.2  77.7  79.4
> 
> i1,s0       seq  rdwr 2 340.6 339.6
> i1,s0       seq  rdwr 4 162.5 161.7 157.9 157.8
> i1,s0       seq  rdwr 8  77.2  77.1  80.1  80.4  78.6  79.1  80.8  80.3
> 
