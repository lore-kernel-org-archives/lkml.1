Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbYFZPKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbYFZPKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYFZPJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:09:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:1967 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYFZPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A3eGEkyHzl2iw2k7GXb5sSPkOMePOQfmeuwG4M6OUVKumuIDpQGwl41l881hZ3/z5r
         e7/pbceDWMPkb2GZvJu4ftOlRhn3urHf+XGEeOeCAGYGiqI6TSG1La7m+mV+Kr0JFBdN
         tqPXSFiu0f5YQQWJUTNUjx02rBogPXqB0Jo0c=
Message-ID: <cfd18e0f0806260809n4370c6eqc07c05ff93029658@mail.gmail.com>
Date: Thu, 26 Jun 2008 17:09:48 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [patch] make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bart Van Assche" <bart.vanassche@gmail.com>,
       "Roland McGrath" <roland@redhat.com>
In-Reply-To: <20080625153806.GA499@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806250749od875635r9e533d9f834bd8c4@mail.gmail.com>
	 <20080625153806.GA499@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 5:38 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> On 06/25, Michael Kerrisk wrote:
>>
>> --- /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c.orig    2008-06-24
>> 16:20:39.000000000 +0200
>> +++ /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c 2008-06-24
>> 16:22:17.000000000 +0200
>> @@ -1379,10 +1379,9 @@
>>
>>       info.si_uid = tsk->uid;
>>
>> -     /* FIXME: find out whether or not this is supposed to be c*time. */
>> -     info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
>> +     info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
>>                                                      tsk->signal->utime));
>> -     info.si_stime = cputime_to_jiffies(cputime_add(tsk->stime,
>> +     info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
>>                                                      tsk->signal->stime));
>>
>>       info.si_status = tsk->exit_code & 0x7f;
>> @@ -1450,9 +1449,8 @@
>>
>>       info.si_uid = tsk->uid;
>>
>> -     /* FIXME: find out whether or not this is supposed to be c*time. */
>> -     info.si_utime = cputime_to_jiffies(tsk->utime);
>> -     info.si_stime = cputime_to_jiffies(tsk->stime);
>> +     info.si_utime = cputime_to_clock_t(tsk->utime);
>> +     info.si_stime = cputime_to_clock_t(tsk->stime);
>>
>>       info.si_code = why;
>>       switch (why) {
>
> This looks like the obviously good fix to me.

Tested now, and it does what I expect.

> The patch also deletes the comment about signal_struct->cXtime,
> this also looks right: why should we use cutime/cstime ?

Hmmm -- maybe I was wrong to delete that comment.  I think the point
of the comment was: should the time returned vie these fields of the
signinfo structure also include the times for (grand)children of the
process that had terminated and been wait()ed for.  My first take on
that was "no".  But now I'm not 100% sure.  A quick test on Solaris 8
suggests that these fields *do* include the times of waited for
children.  (None of this is specified in POSIX.1, which doesn't
specify si_utime and si_stime.)  I've not yet tested FreeBSD (not sure
if it supports these fields or not).

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
