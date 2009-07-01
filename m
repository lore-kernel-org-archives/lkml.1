Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZGAIKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZGAIKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZGAIKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:10:02 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56428 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbZGAIJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tRNpz8fI1u5EQmgjC175+kMM20H4w0ms2HJPNskQ4pECfYtUME5qPMkGplE7TcUTRt
         x97uIkIgbx/KNX7YHf2sGtU23GPwusR/ECWuOLUF/tlTsyvJONHmh6rNrOSb8wJXQ+gD
         gIg1l5XtuT21MwR32kzZSv5/Xls3IRlZJTq0Y=
MIME-Version: 1.0
In-Reply-To: <20090701075332.GA17252@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
Date: Wed, 1 Jul 2009 11:10:00 +0300
X-Google-Sender-Auth: 74122966cde9c731
Message-ID: <84144f020907010110u1dc23666y744b09ed17ba2535@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, Jul 1, 2009 at 10:53 AM, Ingo Molnar<mingo@elte.hu> wrote:
> From 5ba1a8143c502f40b976a0ea1df5e5a10056fcc6 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 1 Jul 2009 09:43:53 +0200
> Subject: [PATCH] kmemleak: Fix scheduling-while-atomic bug
>
> One of the kmemleak changes caused the following
> scheduling-while-holding-the-tasklist-lock regression on x86:
>
> BUG: sleeping function called from invalid context at mm/kmemleak.c:795
> in_atomic(): 1, irqs_disabled(): 0, pid: 1737, name: kmemleak
> 2 locks held by kmemleak/1737:
>  #0:  (scan_mutex){......}, at: [<c10c4376>] kmemleak_scan_thread+0x45/0x86
>  #1:  (tasklist_lock){......}, at: [<c10c3bb4>] kmemleak_scan+0x1a9/0x39c
> Pid: 1737, comm: kmemleak Not tainted 2.6.31-rc1-tip #59266
> Call Trace:
>  [<c105ac0f>] ? __debug_show_held_locks+0x1e/0x20
>  [<c102e490>] __might_sleep+0x10a/0x111
>  [<c10c38d5>] scan_yield+0x17/0x3b
>  [<c10c3970>] scan_block+0x39/0xd4
>  [<c10c3bc6>] kmemleak_scan+0x1bb/0x39c
>  [<c10c4331>] ? kmemleak_scan_thread+0x0/0x86
>  [<c10c437b>] kmemleak_scan_thread+0x4a/0x86
>  [<c104d73e>] kthread+0x6e/0x73
>  [<c104d6d0>] ? kthread+0x0/0x73
>  [<c100959f>] kernel_thread_helper+0x7/0x10
> kmemleak: 834 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>
> The bit causing it is highly dubious:
>
> static void scan_yield(void)
> {
>        might_sleep();
>
>        if (time_is_before_eq_jiffies(next_scan_yield)) {
>                schedule();
>                next_scan_yield = jiffies + jiffies_scan_yield;
>        }
> }
>
> It called deep inside the codepath and in a conditional way,
> and that is what crapped up when one of the new scan_block()
> uses grew a tasklist_lock dependency.
>
> This minimal patch removes that yielding stuff and adds the
> proper cond_resched().
>
> The background scanning thread could probably also be reniced
> to +10.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Looks good to me, thanks!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
