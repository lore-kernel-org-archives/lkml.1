Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZBQMoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZBQMoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZBQMnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:43:52 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:42381 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751627AbZBQMnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:43:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qq8lEWPBXFDHAKjA/sZT91nI97beygIANur2O1GrGTUch5CeYOdD0jfSdtwJuoURy6suF68eKFtmY2y+mdd3rDgf4jKTz2h1RW0YUYTRggxbIFo3suvS3rlECZ54L9Et4IlNAqeWOBvEP0fvIbCYqZ8YiR5ZIeKCh6Rbe7yMU04=  ;
X-YMail-OSG: 7PZrUiUVM1lp3iDFuaHBOfNexyXZOYLXEn5llOLuZxlJ8U1LnknAYsnsHBLZlMVi5dCOyn5umEQatXMDzQKtkrisosO8W24TD.xpmC4TTzAvYz905YMOj5W.gN7NEWK3yNwHDlGWwuByL2x3BYNjLKscvo953RNQkCfxHKdubGq_9dTJMovcpzy_yUS.Mg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] NFS: Pagecache usage optimization on nfs
Date: Tue, 17 Feb 2009 23:43:13 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <6.0.0.20.2.20090217132810.05709598@172.19.0.2>
In-Reply-To: <6.0.0.20.2.20090217132810.05709598@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902172343.13838.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 15:55:12 Hisashi Hifumi wrote:
> Hi, Trond.
>
> I wrote "is_partially_uptodate" aops for nfs client named
> nfs_is_partially_uptodate(). This aops checks that nfs_page is attached to
> a page and read IO to a page is within the range between wb_pgbase and
> wb_pgbase + wb_bytes of the nfs_page. If this aops succeed, we do not have
> to issue actual read IO to NFS server even if a page is not uptodate
> because the portion we want to read are uptodate. So with this patch random
> read/write mixed workloads or random read after random write workloads can
> be optimized and we can get performance improvement.
>
> I did benchmark test using sysbench.
>
> sysbench --num-threads=16 --max-requests=100000 --test=fileio
> --file-block-size=2K --file-total-size=200M --file-test-mode=rndrw
> --file-fsync-freq=0
> --file-rw-ratio=0.5 run
>
> The result was:
>
> -2.6.29-rc4
>
> Operations performed:  33356 Read, 66682 Write, 128 Other = 100166 Total
> Read 65.148Mb  Written 130.24Mb  Total transferred 195.39Mb  (3.1093Mb/sec)
>  1591.97 Requests/sec executed
>
> Test execution summary:
>     total time:                          62.8391s
>     total number of events:              100038
>     total time taken by event execution: 841.7603
>     per-request statistics:
>          min:                            0.0000s
>          avg:                            0.0084s
>          max:                            16.4564s
>          approx.  95 percentile:         0.0446s
>
> Threads fairness:
>     events (avg/stddev):           6252.3750/306.48
>     execution time (avg/stddev):   52.6100/0.38
>
>
> -2.6.29-rc4 + patch
>
> Operations performed:  33346 Read, 66662 Write, 128 Other = 100136 Total
> Read 65.129Mb  Written 130.2Mb  Total transferred 195.33Mb  (5.0113Mb/sec)
>  2565.81 Requests/sec executed
>
> Test execution summary:
>     total time:                          38.9772s
>     total number of events:              100008
>     total time taken by event execution: 339.6821
>     per-request statistics:
>          min:                            0.0000s
>          avg:                            0.0034s
>          max:                            1.6768s
>          approx.  95 percentile:         0.0200s
>
> Threads fairness:
>     events (avg/stddev):           6250.5000/302.04
>     execution time (avg/stddev):   21.2301/0.45
>
>
> I/O performance was significantly improved by following patch.

OK, but again this is not something too sane to do is it (ask for 2K IO
size on 4K page system)? What are the comparison results with 4K IO
size? I guess it will help some cases, but it's probably hard to find
realistic workloads that see such an improvement.

