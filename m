Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXDYMxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXDYMxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXDYMxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:53:07 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:46714
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965632AbXDYMxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:53:05 -0400
Date: Wed, 25 Apr 2007 14:56:01 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Oliver Neukum <oneukum@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in RocketPort driver
Message-ID: <20070425125600.GJ6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Satyam Sharma <satyam.sharma@gmail.com>,
	Robert Hancock <hancockr@shaw.ca>, Oliver Neukum <oneukum@suse.de>,
	linux-kernel@vger.kernel.org
References: <fa.CH+7gvaumSAVtl/1QOSoYPsXewg@ifi.uio.no> <fa.NPDKv3GAx73J43g63faobz7IZVo@ifi.uio.no> <fa.ZWnvY4ypIcIOxuu79yJn6cBDr8M@ifi.uio.no> <462E9885.1010605@shaw.ca> <a781481a0704242206i569e4768oe4b34272181f1ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0704242206i569e4768oe4b34272181f1ce@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Apr 25, 2007 at 10:36:38AM +0530 Satyam Sharma ha dit:

> Hi Matthias,
> 
> On 4/25/07, Robert Hancock <hancockr@shaw.ca> wrote:
> >Matthias Kaehlcke wrote:
> >> El Tue, Apr 24, 2007 at 07:53:04PM +0200 Oliver Neukum ha dit:
> >>
> >>> Am Dienstag, 24. April 2007 19:49 schrieb Matthias Kaehlcke:
> >>>> @@ -1706,7 +1706,7 @@ static int rp_write(struct tty_struct *tty,
> >>>>         if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
> >>>>                 return 0;
> >>>>
> >>>> -       down_interruptible(&info->write_sem);
> >>>> +       mutex_lock_interruptible(&info->write_mtx);
> >>> This is a bug. It is also present in the current code, but nevertheless
> >>> it is a bug. If you use an interruptible lock, you must be ready to deal
> >>> with interrupts, which are ignored by this code.
> >> [...]
> >> i'm a bit confused now about the interruptible locks, i thought using
> >> them means that the process will be waked up when receiving a
> >> signal. what role are playing interrupts when using interruptible locks?
> >
> >You are correct, interrupts aren't involved. However if the wait is
> >interrupted by a signal, mutex_lock_interruptible will return a nonzero
> >return code which needs to be checked for (and likely -ERESTARTSYS or
> >-EINTR returned), otherwise the code will blindly continue as though it
> >has locked the mutex even though it has not.
> 
> Think I'll elaborate Robert's explanation for your benefit :-) Unlike
> mutex_lock() and down() that put the task to TASK_UNINTERRUPTIBLE
> sleep if the lock can't be acquired immediately,
> mutex_lock_interruptible() and down_interruptible() sleep in
> TASK_INTERRUPTIBLE state. So the task _can_ be woken up (without even
> acquiring the lock) by incoming signals. When that happens, we can't
> just blindly go on ... so the return values of the _interruptible()
> versions of the locking functions *must* be checked for success and if
> not, the task should return with error.
> 
> Use -ERESTARTSYS if a previous intermediate caller checks this return
> value and tries and restarts the whole operation. If no such previous
> caller exists (and/or introducing it would involve a change in kernel
> behaviour as seen from userspace), you can safely use -EINTR. The goal
> is that userspace must not get to see -ERESTARTSYS.

thanks to both of you for your explications, i think i understand the
problem much better now

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      The assumption that what currently exists must necessarily
        exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
