Return-Path: <linux-kernel-owner+w=401wt.eu-S1423210AbXDYFGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423210AbXDYFGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423214AbXDYFGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:06:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:21918 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423210AbXDYFGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y6XbGNgPHy2gv4JsjmuUf5eEzkQIPB+SamBKqtlOGmvDJwUfs//AJXrVVfWQB4GoZ8qxJ5ENChN1HxId843hfedSJ+jXVg1/XYtvlW5L2/ZkczZv927/VvAIPWIfB2yCP5vEjz/SilnvvczleKoOp95e3Owe4vwhwR2lzsdZRkU=
Message-ID: <a781481a0704242206i569e4768oe4b34272181f1ce@mail.gmail.com>
Date: Wed, 25 Apr 2007 10:36:38 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PATCH] use mutex instead of semaphore in RocketPort driver
Cc: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>,
       "Oliver Neukum" <oneukum@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <462E9885.1010605@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.CH+7gvaumSAVtl/1QOSoYPsXewg@ifi.uio.no>
	 <fa.NPDKv3GAx73J43g63faobz7IZVo@ifi.uio.no>
	 <fa.ZWnvY4ypIcIOxuu79yJn6cBDr8M@ifi.uio.no> <462E9885.1010605@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

On 4/25/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Matthias Kaehlcke wrote:
> > El Tue, Apr 24, 2007 at 07:53:04PM +0200 Oliver Neukum ha dit:
> >
> >> Am Dienstag, 24. April 2007 19:49 schrieb Matthias Kaehlcke:
> >>> @@ -1706,7 +1706,7 @@ static int rp_write(struct tty_struct *tty,
> >>>         if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
> >>>                 return 0;
> >>>
> >>> -       down_interruptible(&info->write_sem);
> >>> +       mutex_lock_interruptible(&info->write_mtx);
> >> This is a bug. It is also present in the current code, but nevertheless
> >> it is a bug. If you use an interruptible lock, you must be ready to deal
> >> with interrupts, which are ignored by this code.
> > [...]
> > i'm a bit confused now about the interruptible locks, i thought using
> > them means that the process will be waked up when receiving a
> > signal. what role are playing interrupts when using interruptible locks?
>
> You are correct, interrupts aren't involved. However if the wait is
> interrupted by a signal, mutex_lock_interruptible will return a nonzero
> return code which needs to be checked for (and likely -ERESTARTSYS or
> -EINTR returned), otherwise the code will blindly continue as though it
> has locked the mutex even though it has not.

Think I'll elaborate Robert's explanation for your benefit :-) Unlike
mutex_lock() and down() that put the task to TASK_UNINTERRUPTIBLE
sleep if the lock can't be acquired immediately,
mutex_lock_interruptible() and down_interruptible() sleep in
TASK_INTERRUPTIBLE state. So the task _can_ be woken up (without even
acquiring the lock) by incoming signals. When that happens, we can't
just blindly go on ... so the return values of the _interruptible()
versions of the locking functions *must* be checked for success and if
not, the task should return with error.

Use -ERESTARTSYS if a previous intermediate caller checks this return
value and tries and restarts the whole operation. If no such previous
caller exists (and/or introducing it would involve a change in kernel
behaviour as seen from userspace), you can safely use -EINTR. The goal
is that userspace must not get to see -ERESTARTSYS.
