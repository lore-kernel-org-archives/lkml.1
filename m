Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbXEIWHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbXEIWHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbXEIWHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:07:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49217 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXEIWHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:07:02 -0400
Message-ID: <46424602.3090404@garzik.org>
Date: Wed, 09 May 2007 18:06:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, suparna@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: aio is unlikely
References: <200705092101.l49L1CF1023363@hera.kernel.org>
In-Reply-To: <200705092101.l49L1CF1023363@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b8522ead3534c6cd06752b47a3bc380956191a2a
> Commit:     b8522ead3534c6cd06752b47a3bc380956191a2a
> Parent:     b41eeef14d7c73af6d16c7d02b7a939082a137ff
> Author:     Andrew Morton <akpm@osdl.org>
> AuthorDate: Wed May 9 02:34:58 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Wed May 9 12:30:54 2007 -0700
> 
>     aio is unlikely
>     
>     Stick an unlikely() around is_aio(): I assert that most IO is synchronous.
>     
>     Cc: Suparna Bhattacharya <suparna@in.ibm.com>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Cc: Benjamin LaHaise <bcrl@kvack.org>
>     Cc: Zach Brown <zach.brown@oracle.com>
>     Cc: Ulrich Drepper <drepper@redhat.com>
>     Cc: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  include/linux/aio.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index a30ef13..43dc2eb 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -226,7 +226,8 @@ int FASTCALL(io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  		__put_ioctx(kioctx);					\
>  } while (0)
>  
> -#define in_aio() !is_sync_wait(current->io_wait)
> +#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))

Please revert.  Workload-dependent "likelihood" should not cause 
programmers to add such markers.

This is a common misunderstanding about unlikely() and likely().  The 
branch prediction used for each assumes 99% unlikely or 99% likely, 
which is not true at all for workload-dependent code.

Even if only 1% of Linux users use AIO, for that 1%, the 'unlikely' 
marker causes repeated branch mispredictions.

likely() and unlikely() should be used for cases where code is 
likely/unlikely for EVERYBODY.

	Jeff


