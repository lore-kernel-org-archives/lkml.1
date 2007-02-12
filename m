Return-Path: <linux-kernel-owner+w=401wt.eu-S965350AbXBLTuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350AbXBLTuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965352AbXBLTuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:50:00 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37638 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965350AbXBLTt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:49:58 -0500
Subject: Re: [PATCH -mm] readahead: partial sendfile fix
From: Ram Pai <linuxram@us.ibm.com>
To: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       John Tran <jbtran@ca.ibm.com>, Mike Sullivan <mksully@us.ibm.com>,
       Chris Mason <mason@suse.com>, Steven Pratt <slpratt@austin.ibm.com>,
       Badari Pulavarty <badari@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070210014049.GA11269@mail.ustc.edu.cn>
References: <20070210014049.GA11269@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 11:49:10 -0800
Message-Id: <1171309751.2891.70.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 09:40 +0800, Fengguang Wu wrote:
> Enable readahead to handle partially done read requests, e.g.
> 
>         sendfile(188, 1921, [1478592], 19553028) = 37440
>         sendfile(188, 1921, [1516032], 19515588) = 28800
>         sendfile(188, 1921, [1544832], 19486788) = 37440
>         sendfile(188, 1921, [1582272], 19449348) = 14400
>         sendfile(188, 1921, [1596672], 19434948) = 37440
>         sendfile(188, 1921, [1634112], 19397508) = 37440
> 
> In the above strace log,
>         - some lighttpd is doing _sequential_ reading
>         - every sendfile() returns with only _partial_ work done
> 
> page_cache_readahead() expects that if it returns @next_index, it will
> be
> called exactly at @next_index next time. That's not true here. So the
> pattern
> will be falsely recognized as a random read trace.
> 
> Also documented in "Linux AIO Performance and Robustness for
> Enterprise
> Workloads" section 3.5:
> 
>           sendfile(fd, 0, 2GB, fd2) = 8192,
>             tells readahead about up to 128KB of the read
>           sendfile(fd, 8192, 2GB - 8192, fd2) = 8192,
>             tells readahead about 8KB - 132KB of the read
>           sendfile(fd, 16384, 2GB - 16384, fd2) = 8192,
>             tells readahead about 16KB-140KB of the read
>                ...
>         This confuses the readahead logic about the I/O pattern which
> appears
>         to be 0-128K, 8K-132K, 16K-140K instead of clear sequentiality
> from
>         0-2GB that is really appropriate.
> 
> Retry based AIO shares the same read pattern and readahead problem.
> In this case, simply disabling readahead on restarted aio is not a
> good option:
> we still need to call into readahead in the rare case of (req_size >
> ra_max).

The solution you proposed seems kludgy to me. If you determine that the
its a restarted aio, then start reading from where readahead had left
reading from earlier. To me a simple fix is:

-       if (unlikely(aio_restarted()))
-               next_index = last_index; /* Avoid repeat readahead */

+       if (unlikely(aio_restarted()))
+  		next_index = min(prev_index+1, last_index);


No? 
RP



> 
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  mm/filemap.c   |    3 ---
>  mm/readahead.c |    9 +++++++++
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.20-rc6-mm3.orig/mm/readahead.c
> +++ linux-2.6.20-rc6-mm3/mm/readahead.c
> @@ -581,6 +581,15 @@ page_cache_readahead(struct address_spac
>         int sequential;
> 
>         /*
> +        * A previous read request is partially completed,
> +        * causing the retried/continued read calls into us
> prematurely.
> +        */
> +       if (ra->start < offset &&
> +                       offset < ra->prev_page &&
> +                                ra->prev_page < ra->ahead_start +
> ra->ahead_size)
> +               goto out;
> +
> +       /*
>          * We avoid doing extra work and bogusly perturbing the
> readahead
>          * window expansion logic.
>          */
> --- linux-2.6.20-rc6-mm3.orig/mm/filemap.c
> +++ linux-2.6.20-rc6-mm3/mm/filemap.c
> @@ -915,9 +915,6 @@ void do_generic_mapping_read(struct addr
>         if (!isize)
>                 goto out;
> 
> -       if (unlikely(aio_restarted()))
> -               next_index = last_index; /* Avoid repeat readahead */




> -
>         end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
>         for (;;) {
>                 struct page *page;
> 

