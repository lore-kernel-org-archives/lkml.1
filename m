Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZKEOyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZKEOyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZKEOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:54:12 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36984 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbZKEOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UJ6BMmidRT9ABmXhGLTCvqA7YzdSESjOA0kQfAGy2635Vk8M9rOQhjEYEJJZC8DTc/
         etXkGE3GJgZ14zxInkEY5cXGFECrmb2Anz60oRapq/8Rw3gKVEYN5s8pyK40cJVomabK
         eSebVqn6B/lNrLsweCQrNDFIoc86zjs1WVjXU=
MIME-Version: 1.0
In-Reply-To: <20091105141055.GA17350@redhat.com>
References: <6417.1257351084@turing-police.cc.vt.edu>
	 <200911051941.03401.rusty@rustcorp.com.au>
	 <20091105141055.GA17350@redhat.com>
Date: Thu, 5 Nov 2009 15:54:15 +0100
Message-ID: <6e0cfd1d0911050654q2e1f23e6o2b47edfdcf3137cb@mail.gmail.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
From: Martin Schwidefsky <schwidefsky@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is imho caused by this patch snippet from the linux-next.patch from mmotd:

diff -puN arch/x86/kernel/tsc.c~linux-next arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~linux-next
+++ a/arch/x86/kernel/tsc.c
@@ -763,14 +763,12 @@ void mark_tsc_unstable(char *reason)
 {
        if (!tsc_unstable) {
                tsc_unstable = 1;
-               printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
+               printk("Marking TSC unstable due to %s\n", reason);
                /* Change only the rating, when not registered */
                if (clocksource_tsc.mult)
-                       clocksource_mark_unstable(&clocksource_tsc);
-               else {
-                       clocksource_tsc.flags |= CLOCK_SOURCE_UNSTABLE;
+                       clocksource_change_rating(&clocksource_tsc, 0);
+               else
                        clocksource_tsc.rating = 0;
-               }
        }
 }


The upstream variant of mark_tsc_unstable uses clocksource_mark_unstable
which does not take the mutex. The reason is the clocksource mutex vs. the
cpu_add_remove_lock spinlock.

-- 
blue skies,
  Martin
