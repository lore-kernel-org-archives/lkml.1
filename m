Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbZESIoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbZESIoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZESIny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:43:54 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:47487 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbZESIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:43:54 -0400
Date: Tue, 19 May 2009 17:43:52 +0900 (JST)
Message-Id: <20090519.174352.71107893.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/1] dm-ioband: I/O bandwidth controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090519.173928.226784958.ryov@valinux.co.jp>
References: <20090519.173928.226784958.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 1/1] dm-ioband: I/O bandwidth controller
Date: Tue, 19 May 2009 17:39:28 +0900 (JST)

> Hi Alasdair and all,
> 
> This is the dm-ioband version 1.11.0 release. This patch can be
> applied cleanly to current agk's tree. Alasdair, please give some
> comments and suggestions.
> 
> Changes from the previous release:
> - Classify IOs in sync/async instead of read/write since the IO
>   request allocation/congestion logic were changed to be sync/async
>   based.
> - IOs belong to the real-time class are dispatched in preference to
>   other IOs, regardless of the assigned bandwidth.

I ran your script from the following URL to see IOs belong to the
real-time class take precedence.
http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg08355.html

    Script
    ======
    # /dev/mapper/ioband1 is mounted on /mnt1
    rm /mnt1/aggressivewriter
    sync
    echo 3 > /proc/sys/vm/drop_caches
    # launch an hostile writer
    ionice -c2 -n7 dd if=/dev/zero of=/mnt1/aggressivewriter \
       bs=4K count=524288 conv=fdatasync &
    # Reader
    ionice -c1 -n0 dd if=/mnt1/testzerofile1 of=/dev/null &
    wait $!
    echo "reader finished"

    old dm-ioband
    =============
    First run
    2147483648 bytes (2.1 GB) copied, 100.343 seconds, 21.4 MB/s (Reader)
    reader finished
    2147483648 bytes (2.1 GB) copied, 101.107 seconds, 21.2 MB/s (Writer)

    new dm-ioband v1.11.0
    =====================
    First run
    2147483648 bytes (2.1 GB) copied, 35.0623 seconds, 61.2 MB/s (Reader)
    reader finished
    2147483648 bytes (2.1 GB) copied, 87.6979 seconds, 24.5 MB/s (Writer)

The RT reader took precedence over the aggressive writer, regardless
of assigned bandwidth. However, I think that some sort of limitation
for RT IOs is needed. What do you think?

Thanks,
Ryo Tsuruta
