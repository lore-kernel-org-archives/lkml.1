Return-Path: <linux-kernel-owner+w=401wt.eu-S1762849AbYAaTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbYAaTMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 14:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbYAaTMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 14:12:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:2712 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbYAaTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 14:12:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VWewc3XEySqkr5ONcs0JP3EINH7yt9IppO8ODAByCzCJIGYCwyfgOkAlm++f/Fgaxzhw891e9cNV3W3hjgIhT2GAI0L48VIMxzZSSQzmGEK2m/TQYOKlHrEu9Ig7gEN60no+xCgkPM1wVjkrW2wD1odXrA3nIayJ0if9mwVxwsU=
Message-ID: <5a4c581d0801311112s61c8fedfsad51de89c0cd7ff1@mail.gmail.com>
Date: Thu, 31 Jan 2008 20:12:09 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] 2.6.24-git8 (and earlier): Multiple processes stuck in D states after logout from KDE
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200801310042.07910.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801302338.25365.rjw@sisk.pl> <200801310042.07910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/31 Rafael J. Wysocki <rjw@sisk.pl>:
> Update.
>
> On Wednesday, 30 of January 2008, Rafael J. Wysocki wrote:
> > Hi,
> >
> > Recently I've been observing problems with unmounting the /home fs on reboot
> > and/or shutdown on two test boxes.
> >
> > After some more investigation I've found that this is due to some KDE processes
> > stuck in D states after their owner has logged out.
> >
> > This happens 100% of the time if there's a suspend/resume cycle before the user
> > logs out (ie. the user logs into KDE, works for some time, suspends the box to
> > RAM and resmes one or more times and then logs out).  Still, I also observe the
> > symptoms on a box that's never suspended.
> >
> > I'm not sure how to debug this, so please advise.
>
> After reverting:
>
> commit 37bb6cb4097e29ffee970065b74499cbf10603a3
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:32 2008 +0100
>
>     hrtimer: unlock hrtimer_wakeup
>
> I no longer get processes in the D state, but there still is a problem with
> artswrapper (this is an openSUSE 10.3 system, x86-64).  Namely,
> after a suspend/resume cycle and logging out/logging in the user,
> artswrapper gets stuck somewhere, apparently in the running (R) state.
> For this reason it blocks any subsequent attempts to suspend.
>
> Here's the relevant trace (from show_state()):
>
> [  522.474919] artswrapper   R  running task        0  4805      1
> [  522.474922]  ffff810074cd1f70 0000000000000082 0000000000000296 ffff810074cd1ed8
> [  522.474926]  ffffffff80311769 ffff810074cd1f20 ffffffff80701240 ffffffff80701240
> [  522.474930]  ffffffff80701240 ffffffff80701240 ffffffff80701240 ffffffff80701240
> [  522.474933] Call Trace:
> [  522.474940]  [<ffffffff80311769>] ? __up_read+0x8f/0x97
> [  522.474963]  [<ffffffff8020c5cf>] retint_careful+0xd/0x21
>
> where, according to gdb,
>
> (gdb) l *__up_read+0x8f
> 0xffffffff80311769 is in __up_read (/home/rafael/src/linux-2.6/lib/rwsem-spinlock.c:273).
> 268
> 269             if (--sem->activity == 0 && !list_empty(&sem->wait_list))
> 270                     sem = __rwsem_wake_one_writer(sem);
> 271
> 272             spin_unlock_irqrestore(&sem->wait_lock, flags);
> 273     }
> 274
> 275     /*
> 276      * release a write lock on the semaphore
> 277      */
>
> What gives?

In recent kernels, I had a hard hang in -git6 on my Fedora8-based
 Dell D610 (x86, UP) - and since at least -git4 I can't shutdown my
 Oracle 11.1 instance, with the VKTM thread remaining in R state,
 while taking up no CPU at all:

[root@sandman ~]# ps ax | grep vktm
 3211 ?        Rs     0:00 ora_vktm_t111

 additionally, VKTM is

 - non-straceable (strace hangs)
 - non-gdb'able (gdb hangs)
 - non-pstack'able (pstack returns empty)
 - non-killable (kill -9 doesn't kill it)

echo'ing 't' in /proc/sysrq-trigger, I have (2.6.24-git8):

Jan 31 20:04:31 sandman kernel:  =======================
Jan 31 20:04:31 sandman kernel: oracle        R running   2668  3211      1
Jan 31 20:04:31 sandman kernel:        f1462fb0 00000082 f1f1aa54
f172dd80 c01055f6 00000000 0ef609ac bf8532ec
Jan 31 20:04:31 sandman kernel:        00000000 f1462000 c0103e26
0ef609ac bf853388 b79906a4 bf8532ec 00000000
Jan 31 20:04:31 sandman kernel:        bf850140 bf850068 0000007b
0000007b c0320000 ffffffff 08f53d02 00000073
Jan 31 20:04:31 sandman kernel: Call Trace:
Jan 31 20:04:31 sandman kernel:  [<c01055f6>] ? do_IRQ+0xac/0xc1
Jan 31 20:04:31 sandman kernel:  [<c0103e26>] work_resched+0x5/0x16
Jan 31 20:04:31 sandman kernel:  [<c0320000>] ? tg3_init_one+0xe76/0x10e0
Jan 31 20:04:31 sandman kernel:  =======================

Once I'm done with a largish FTP I'll try and find out where
 this exactly began.

--alessandro

 "We act as though comfort and luxury were the chief requirements
   of life, when all that we need to make us really happy is
   something to be enthusiastic about."

   (Charles Kingsley)
