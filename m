Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYEUSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYEUSf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYEUSft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:35:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:16246 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYEUSfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Sfa0FZ94nIgNdUdl6hCX23andlXqNPgXOc31B0++bFc6HfV2SIwrZEpe6Zuv3qLDxRDPIwgfxF/PPlIrxypFa7wj0jlg3KaVvaMKfmioIXcXLzIJjjLM32b5NPlSQ05IZXNCZYIusfpSNUYmVx+VkTJm4VjWXRnNBZhsWDl+lYs=
Message-ID: <3efb10970805211135k422a0153i28613e74d42d1ed2@mail.gmail.com>
Date: Wed, 21 May 2008 20:35:45 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: Compile warning rtmutex code on 2.6.24.7-rt8 (CC:LKML added)
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0805201718530.21440@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970805201356x4552859bof5f3f4f56f2ba676@mail.gmail.com>
	 <Pine.LNX.4.58.0805201718530.21440@gandalf.stny.rr.com>
X-Google-Sender-Auth: 47c28e14677f9e64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

> Remy,
> Can you see if this helps,

Yes, this helps. Looks a little weird to add bitmasks to pointers, but
I understand why it has been done here.
BTW: I notice that you already has put it in -rt9.

And some other positive news: 2.6.24.7-rt9 compiles and boots
perfectly on ARM at91sam9261. (There are still a few other warnings,
but these are not RT related)

Now I understood your hint in some other mail, and I am going to take
a look at ftrace for ARM. Just for the fun of it...
I hope it is not too intrusive for these ARM cores (old implementation
was...), these Atmel cores are just not that fast as the common X86's.


Kind Regards,

Remy


2008/5/20 Steven Rostedt <rostedt@goodmis.org>:
>
>
> On Tue, 20 May 2008, Remy Bohmer wrote:
>
>> Hello Steven,
>>
>>  Do you recognise these warnings? I do not know (yet) if these are ARM
>>  specific...
>>
>>   CC      kernel/rtmutex.o
>>  kernel/rtmutex.c: In function 'rt_write_fastlock':
>>  kernel/rtmutex.c:1582: warning: initialization makes pointer from
>>  integer without a cast
>>  kernel/rtmutex.c: In function 'rt_write_fasttrylock':
>>  kernel/rtmutex.c:1622: warning: initialization makes pointer from
>>  integer without a cast
>>
>>  If so, do you have a fix for it?
>
> Remy,
>
> Can you see if this helps,
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>
> ---
>  kernel/rtmutex.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-2.6.24.7-rt9/kernel/rtmutex.c
> ===================================================================
> --- linux-2.6.24.7-rt9.orig/kernel/rtmutex.c    2008-05-20 17:11:29.000000000 -0400
> +++ linux-2.6.24.7-rt9/kernel/rtmutex.c 2008-05-20 17:13:18.000000000 -0400
> @@ -1577,7 +1577,7 @@ rt_write_fastlock(struct rw_mutex *rwm,
>                  void fastcall (*slowfn)(struct rw_mutex *rwm, int mtx),
>                  int mtx)
>  {
> -       unsigned long val = (unsigned long)current | RT_RWLOCK_WRITER;
> +       struct task_struct *val = (void *)((unsigned long)current | RT_RWLOCK_WRITER);
>
>        if (likely(rt_rwlock_cmpxchg(rwm, NULL, val)))
>                rt_mutex_deadlock_account_lock(&rwm->mutex, current);
> @@ -1617,7 +1617,7 @@ static inline int
>  rt_write_fasttrylock(struct rw_mutex *rwm,
>                     int fastcall (*slowfn)(struct rw_mutex *rwm, int mtx), int mtx)
>  {
> -       unsigned long val = (unsigned long)current | RT_RWLOCK_WRITER;
> +       struct task_struct *val = (void *)((unsigned long)current | RT_RWLOCK_WRITER);
>
>        if (likely(rt_rwlock_cmpxchg(rwm, NULL, val))) {
>                rt_mutex_deadlock_account_lock(&rwm->mutex, current);
> @@ -1902,7 +1902,7 @@ rt_write_fastunlock(struct rw_mutex *rwm
>                                            int mtx),
>                    int mtx)
>  {
> -       unsigned long val = (unsigned long)current | RT_RWLOCK_WRITER;
> +       struct task_struct *val = (void *)((unsigned long)current | RT_RWLOCK_WRITER);
>
>        WARN_ON(rt_rwlock_owner(rwm) != current);
>        if (likely(rt_rwlock_cmpxchg(rwm, (struct task_struct *)val, NULL)))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
