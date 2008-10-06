Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbYJFIyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbYJFIyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 04:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYJFIxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 04:53:55 -0400
Received: from rs02.intra2net.com ([81.169.173.116]:34551 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYJFIxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 04:53:54 -0400
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Organization: Intra2net AG
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [patch] log fatal signals like SIGSEGV
Date: Mon, 6 Oct 2008 10:53:47 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.26.3-29.fc9.i686; KDE/4.1.1; i686; ; )
References: <200809121502.15264.thomas.jarosch@intra2net.com> <200809201912.40381.thomas.jarosch@intra2net.com> <18646.39701.819497.337394@harpo.it.uu.se>
In-Reply-To: <18646.39701.819497.337394@harpo.it.uu.se>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810061053.48364.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mikael,

>  > Log signals like SIGSEGV, SIGILL, SIGBUS or SIGFPE to aid tracing
>  > of obscure problems. Also logs the sender of the signal.
>
> I believe the approach taken in this patch is broken:
>
> 1. The signal logging decision is taken before signal delivery,
>    which causes *handled* signals in the above list to be logged.
>    So your printk_ratelimit() can be swamped by handled signals
>    causing it to not log unhandled fatal signals.
>
>    Applications that handle SEGV/BUS/ILL/FPE aren't that uncommon.
>
> 2. Fatal signals are only interesting if they are self-generated.
>    Signals sent from other processes or threads are uninteresting,
>    if the purpose is to detect program errors or faulty hardware.

Thanks for your review. We already run the new patch on 500+ boxes and
didn't get any complaints about noisy messages in the logs (yet?).
Some of those boxes run "logcheck" and generate a daily report,
so there should be -something-.

I'm not sure if separating between kernel and process generated signals
makes much of a difference as there should be no log output anyway.
If you can provide me input that this will in fact generate noisy output,
I'll happily change the code.

> 3. Similar functionality already exists in the kernel, except
>    it correctly runs much later in the signal delivery path.
>    Grep for print_fatal_signals and show_unhandled_signals.

print_fatal_signals is debug-only, see the mails
from the first review phase about that.

show_unhandled_signals seems to be implemented on x86 and PPC only.

Concerning x86: Both pieces of code are integrated in 
arch/x86/kernel/traps_32.c: do_general_proection().

Does this code path also get called for SIGABRT or SIGFPE?

>    There's also some trace hooks in the signal delivery path
>    that look like they could log actual fatal signals.

Do you have a particular one in mind?

[Jiri Kosina wrote]
> BTW be aware that for example x86 arch-specific code does this on its own, 
> and therefore with your patch, the information will be duplicated. See 
> page fault handler for x86.

Yes, I like that. The new code is architecture-independant,
perhaps the architecture-dependant code could even be obsoleted
and all platforms would benefit from the new logging.

Thomas

