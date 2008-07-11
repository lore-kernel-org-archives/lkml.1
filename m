Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYGKCXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYGKCXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 22:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYGKCXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 22:23:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134AbYGKCXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 22:23:36 -0400
Date: Thu, 10 Jul 2008 19:22:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807101855020.2936@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807101908330.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org> <20080710224256.AD038154218@magilla.localdomain> <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
 <20080711005243.ADE90154218@magilla.localdomain> <alpine.LFD.1.10.0807101824150.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807101855020.2936@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Linus Torvalds wrote:
> 
> So now I'm considering just putting it in before the 2.6.26 release after 
> all ;)

.. and having looked at the code, and thought about it some more, I'm 
definitely off the patch again.

The reason is actually exactly the same bug that showed up when you did 
this for x86-32 three years ago, and that may in fact still be lurking.

The endless loop of "call do_notify_resume until all the work flags are 
zero" is very fragile: it will immediately cause a hard lockup if there is 
some circumstance where do_notify_resume will not clear the flag.

And when it comes to signals, there are several cases that can cause 
TIF_SIGPENDING to not be cleared:

 - confusion about user/kernel mode, where "do_signal()" will return 
   without doing anything at all if we're in user mode.

   This was the bug we hit back in 2005 with a out-of-tree kernel-based 
   vm86 model (which hopefully has since died a painful death).

 - get_signal_to_deliver() returning and not handling the signal. 
   dequeue_signal() will do this for that collect_signal() case and for 
   the whole DRI notifier thing. The DRI notifier() case actually clears 
   TIF_SIGPENDING, but then we do "recalc_sigpending()" in the caller, so 
   it might get set again.

   I do hate that code (I know you do too), and the code _should_ block 
   the signal that gets ignored (so recalc_sigpending() should keep it 
   cleared), but it's not entirely obvious. Maybe it gets into an endless 
   loop of calling the notifier if this case ever triggers?

 - recalc_sigpending() expressly does not clear the TIF_SIGPENDING flag if 
   we hit the "freezing(current)" case. So TIF_SIGPENDING stays set for 
   freezing() processes. I think (and *hope*) they all get caught by other 
   means anyway in that whole do_notify_resume() loop, but this is another 
   of those "the freezer code is insane, I'm not going to try to think it 
   through" cases.

In short, I think your patch is fine now, but I'm also nervous enough 
about it that I'm not going to apply it. Any bugs it could expose look 
very unlikely, and if they exist they are probably bugs on 32-bit as we 
speak, but call me a worry-wart.

		Linus
