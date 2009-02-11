Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbZBKEnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbZBKEnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 23:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZBKEm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 23:42:59 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:28145 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZBKEm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 23:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=IEfKdnOAwNFkMoDNf3M1IrqPNJzRYnqQemhleFKir4nFuiZV8EybDPiKfVeh8xD2iG
         7F55hWJgsmc3jsC9tvMloCSNavgHgL91E+0OlyDPfB7jVAfb6ROR8xjibfgTLktPyCCW
         4+XAFNcSepSaYVrwxIT4XjfAq1/vFp8JHfNf4=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <cfd18e0f0902091636p36e12111yd053b9870816d126@mail.gmail.com>
References: <alpine.DEB.1.10.0902091525590.8503@alien.or.mcafeemobile.com>
	 <cfd18e0f0902091636p36e12111yd053b9870816d126@mail.gmail.com>
Date: Wed, 11 Feb 2009 17:42:56 +1300
Message-ID: <cfd18e0f0902102042i677322d3t32ccb7d3a8d5659@mail.gmail.com>
Subject: Re: [patch] timerfd add flags check
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 1:36 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> On Tue, Feb 10, 2009 at 12:31 PM, Davide Libenzi
> <davidel@xmailserver.org> wrote:
>> Like Michael requested, this patch adds a missing check for valid flags in
>> timerfd_settime(), and make it return EINVAL in case some extra bits are
>> set.
>>
>> Michael said:
>> If this is to be any use to userland apps that want to check flag
>> support (perhaps it is too late already), then the sooner we get it
>> into the kernel the better: 2.6.29 would be good; earlier stables as
>> well would be even better.
>>
>> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
>>
>>
>> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
>
> Davide, one question: is the TFD_FLAGS_SET constant below needed?

Davide, Ping!  I see Andrew already took the patch, which seems to
define this unnecessary macro.

Cheers,

Michael

>
>> ---
>>  fs/timerfd.c            |   12 ++++++------
>>  include/linux/timerfd.h |   17 ++++++++++++++---
>>  2 files changed, 20 insertions(+), 9 deletions(-)
>>
>> Index: linux-2.6.mod/fs/timerfd.c
>> ===================================================================
>> --- linux-2.6.mod.orig/fs/timerfd.c     2009-02-08 18:36:45.000000000 -0800
>> +++ linux-2.6.mod/fs/timerfd.c  2009-02-08 18:53:32.000000000 -0800
>> @@ -186,10 +186,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
>>        BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
>>        BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
>>
>> -       if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
>> -               return -EINVAL;
>> -       if (clockid != CLOCK_MONOTONIC &&
>> -           clockid != CLOCK_REALTIME)
>> +       if ((flags & ~TFD_CREATE_FLAGS) ||
>> +           (clockid != CLOCK_MONOTONIC &&
>> +            clockid != CLOCK_REALTIME))
>>                return -EINVAL;
>>
>>        ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>> @@ -201,7 +200,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
>>        hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
>>
>>        ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
>> -                              flags & (O_CLOEXEC | O_NONBLOCK));
>> +                              flags & TFD_SHARED_FCNTL_FLAGS);
>>        if (ufd < 0)
>>                kfree(ctx);
>>
>> @@ -219,7 +218,8 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
>>        if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
>>                return -EFAULT;
>>
>> -       if (!timespec_valid(&ktmr.it_value) ||
>> +       if ((flags & ~TFD_SETTIME_FLAGS) ||
>> +           !timespec_valid(&ktmr.it_value) ||
>>            !timespec_valid(&ktmr.it_interval))
>>                return -EINVAL;
>>
>> Index: linux-2.6.mod/include/linux/timerfd.h
>> ===================================================================
>> --- linux-2.6.mod.orig/include/linux/timerfd.h  2009-02-08 18:36:45.000000000 -0800
>> +++ linux-2.6.mod/include/linux/timerfd.h       2009-02-08 18:41:22.000000000 -0800
>> @@ -11,13 +11,24 @@
>>  /* For O_CLOEXEC and O_NONBLOCK */
>>  #include <linux/fcntl.h>
>>
>> -/* Flags for timerfd_settime.  */
>> +/*
>> + * CAREFUL: Check include/asm-generic/fcntl.h when defining
>> + * new flags, since they might collide with O_* ones. We want
>> + * to re-use O_* flags that couldn't possibly have a meaning
>> + * from eventfd, in order to leave a free define-space for
>> + * shared O_* flags.
>> + */
>>  #define TFD_TIMER_ABSTIME (1 << 0)
>> -
>> -/* Flags for timerfd_create.  */
>>  #define TFD_CLOEXEC O_CLOEXEC
>>  #define TFD_NONBLOCK O_NONBLOCK
>>
>> +#define TFD_SHARED_FCNTL_FLAGS (TFD_CLOEXEC | TFD_NONBLOCK)
>> +/* Flags for timerfd_create.  */
>> +#define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
>> +/* Flags for timerfd_settime.  */
>> +#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
>> +#define TFD_FLAGS_SET (TFD_SHARED_FCNTL_FLAGS | TFD_TIMER_ABSTIME)
>> +
>>
>>  #endif /* _LINUX_TIMERFD_H */
>>
>>
>
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
> man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
> Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
