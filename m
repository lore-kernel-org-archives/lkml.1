Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZHFTC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZHFTC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZHFTC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:02:56 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:33251
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbZHFTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:02:55 -0400
X-IronPort-AV: E=Sophos;i="4.43,335,1246831200"; 
   d="scan'208";a="44412405"
Message-ID: <4A7B28EA.20903@inria.fr>
Date: Thu, 06 Aug 2009 21:03:06 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu>	 <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr>	 <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr>	 <20090629192913.GA29295@elte.hu>  <4A7B0C02.7060704@inria.fr>	 <1249580428.4975.14.camel@laptop>  <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop>
In-Reply-To: <1249585061.4975.17.camel@laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf report -D |
grep _READ | sort -k5
0x8bb8 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000001e0 494628
0x8fc0 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000002e0 209113
0x9698 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000004e0 307215
0x9cf8 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000008e0 9203221
0x8a08 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000001e0 9210788
0x9020 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000002e0 302344
0x9608 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000004e0 198705
0x9d28 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000008e0 473471
[...]

Now I know which thread actually reads from where.
Looks like we're good to go now! thanks a lot Peter!

Tested-by: Brice Goglin <Brice.Goglin@inria.fr>

Brice



Peter Zijlstra wrote:
> Subject: perf tools: Fix reading of perf.data file header
>
> A silly mistake made us re-read the first attribute for every attribute.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 450384b..95a44bc 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -213,9 +213,10 @@ struct perf_header *perf_header__read(int fd)
>  
>  	for (i = 0; i < nr_attrs; i++) {
>  		struct perf_header_attr *attr;
> -		off_t tmp = lseek(fd, 0, SEEK_CUR);
> +		off_t tmp;
>  
>  		do_read(fd, &f_attr, sizeof(f_attr));
> +		tmp = lseek(fd, 0, SEEK_CUR);
>  
>  		attr = perf_header_attr__new(&f_attr.attr);
>  
>
>
>   

