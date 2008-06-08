Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYFHRUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYFHRUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYFHRTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:19:54 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41468 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbYFHRT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:19:26 -0400
Date: Sun, 8 Jun 2008 21:20:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] TASK_WAKEKILL fixes
Message-ID: <20080608172040.GA10380@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second patch is just an example of how the new helper can be used outside
of schedule(), it doesn't change the behaviour.

I am not sure about the 3rd patch (it doesn't depend on the 1st patch),

	On 06/05, Oleg Nesterov wrote:
	>
	> Please note that while this bug is not likely,
	> it is _not_ theoretical. It does happen that user-space sends the unhandled
	> fatal signals to init.
	>
	> Imho, this is 2.6.26 material. Unless I missed something, of course.

Of course, I missed something. Firstly, init doesn't read files that often.
And, unlike the normal task, init can't be woken by the fatal signal unless
this signal is SIGKILL. I doubt user-space can send SIGKILL to init. So this
problem is minor.

To clarify, this patch doesn't fix the bug. We need changes in signal.c, but
unfortunately it is not as easy as I thought, it needs more thinking. For
example, we can change signal_wake_up() to check SIGNAL_UNKILLABLE before
"|= TASK_WAKEKILL", but this is a) not exactly right (exec), and b) can't
really help. The problem is that __fatal_signal_pending(init) is not right,
but signal_group_exit() needs ->signal and thus isn't useable from schedule().
Of course we can add a check into send_signal(), but this is so nasty...

