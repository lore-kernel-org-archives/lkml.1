Return-Path: <linux-kernel-owner+w=401wt.eu-S1750961AbZHWWSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbZHWWSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 18:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbZHWWSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 18:18:02 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:39596 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZHWWSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 18:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=I99PcxT6QUTuEUM9JgFK9HdDJ2cxsZkijbZ+jKivIkBikiszNiLyM0jwlXkES4RU3W
         h4IOErep7e2DBrcLWrMGvxRF0TGzHVh5SOF+obWrAu9RN3xatOrl0BBMZ60yYXML07Go
         Y6Flfy4LACwzJWF0VQ8Gcccuka2t5NvNjyYxQ=
MIME-Version: 1.0
Date: Sun, 23 Aug 2009 17:18:02 -0500
Message-ID: <7fcc02550908231518m1d35a0c6kd4397b974ac65747@mail.gmail.com>
Subject: kernel/posix-timer.c: Forgot to disable interrupts in 
	sys_timer_settime()?
From: Lin Tan <tammy000@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Did we forget to disable interrupts before calling
posix_cpu_timer_set() in the system call function sys_timer_settime()
(in code literally as SYSCALL_DEFINE4(timer_settime, ...) as shown
below)? The CLOCK_DISPATCH macro invokes posix_cpu_timer_set(), which
requires interrupts to be disabled upon entry of calling. When
posix_cpu_timer_set() was called from other functions such as
do_cpu_nanosleep(), interrupts are disabled.


SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 769                const struct itimerspec __user *, new_setting,
 770                struct itimerspec __user *, old_setting)
 771{
    ...
 792        error = CLOCK_DISPATCH(timr->it_clock, timer_set,
 793                               (timr, flags, &new_spec, rtn)); //
this MACRO invokes posix_cpu_timer_set()
 ...
}


In addition, its block comments also state that we must disable
interrupts before calling it (in posix-cpu-timers.c):

/*
 712 * ...
 713 * This is called with the timer locked and interrupts disabled.
 714 *
 ...
 716 */
 717int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 718                        struct itimerspec *new, struct itimerspec *old)
 719{
  ...
}

Thanks,
Lin
