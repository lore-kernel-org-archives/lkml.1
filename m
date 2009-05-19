Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZESNiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZESNiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZESNiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:38:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbZESNiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:38:01 -0400
Date: Tue, 19 May 2009 09:37:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/1] dm-ioband: I/O bandwidth controller
Message-ID: <20090519133753.GA28679@redhat.com>
References: <20090519.173928.226784958.ryov@valinux.co.jp> <20090519.174352.71107893.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519.174352.71107893.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 05:43:52PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> From: Ryo Tsuruta <ryov@valinux.co.jp>
> Subject: [PATCH 1/1] dm-ioband: I/O bandwidth controller
> Date: Tue, 19 May 2009 17:39:28 +0900 (JST)
> 
> > Hi Alasdair and all,
> > 
> > This is the dm-ioband version 1.11.0 release. This patch can be
> > applied cleanly to current agk's tree. Alasdair, please give some
> > comments and suggestions.
> > 
> > Changes from the previous release:
> > - Classify IOs in sync/async instead of read/write since the IO
> >   request allocation/congestion logic were changed to be sync/async
> >   based.
> > - IOs belong to the real-time class are dispatched in preference to
> >   other IOs, regardless of the assigned bandwidth.
> 
> I ran your script from the following URL to see IOs belong to the
> real-time class take precedence.
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg08355.html
> 
>     Script
>     ======
>     # /dev/mapper/ioband1 is mounted on /mnt1
>     rm /mnt1/aggressivewriter
>     sync
>     echo 3 > /proc/sys/vm/drop_caches
>     # launch an hostile writer
>     ionice -c2 -n7 dd if=/dev/zero of=/mnt1/aggressivewriter \
>        bs=4K count=524288 conv=fdatasync &
>     # Reader
>     ionice -c1 -n0 dd if=/mnt1/testzerofile1 of=/dev/null &
>     wait $!
>     echo "reader finished"
> 
>     old dm-ioband
>     =============
>     First run
>     2147483648 bytes (2.1 GB) copied, 100.343 seconds, 21.4 MB/s (Reader)
>     reader finished
>     2147483648 bytes (2.1 GB) copied, 101.107 seconds, 21.2 MB/s (Writer)
> 
>     new dm-ioband v1.11.0
>     =====================
>     First run
>     2147483648 bytes (2.1 GB) copied, 35.0623 seconds, 61.2 MB/s (Reader)
>     reader finished
>     2147483648 bytes (2.1 GB) copied, 87.6979 seconds, 24.5 MB/s (Writer)
> 
> The RT reader took precedence over the aggressive writer, regardless
> of assigned bandwidth. However, I think that some sort of limitation
> for RT IOs is needed. What do you think?

I think we don't need any limitation for RT tasks. If somebody needs to
limit RT task, then it should be put into a separate group.

Looks like you have started duplicating CFQ infrastrucutre in dm-ioband to
make sure CFQ is not broken. That will lead to interesting interaction
with noop and other IO schedulers at the same time whenever CFQ changes 
behavior you will find it hard to keep up with it. 

Anyway, how are you taking care of priorities with-in same class. How will
you make sure that a BE prio 0 request is not hidden behind BE prio 7
request? Same is true for prio with-in RT class.

Thanks
Vivek
