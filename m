Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZBZSvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZBZSvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZBZSvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:51:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbZBZSvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:51:02 -0500
Date: Thu, 26 Feb 2009 19:50:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] signals: don't copy siginfo_t on dequeue
Message-ID: <20090226185053.GD31413@elte.hu>
References: <20090226184433.GA15644@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226184433.GA15644@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >From 60fc9a464377159ab807aec63277d4970019d631 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 26 Feb 2009 19:17:58 +0100
> Subject: [PATCH] signals: don't copy siginfo_t on dequeue
> 
> Instead of copying the siginfo_t whenever a signal is dequeued, just
> get the pointer to the struct sigqueue, which can be freed by the
> caller when the signal has been delivered.
> 
> We can save kernel text (x86, 32-bit):
> 
> $ scripts/bloat-o-meter vmlinux-unpatched vmlinux
> add/remove: 0/0 grow/shrink: 3/7 up/down: 81/-538 (-457)
> function                                     old     new   delta
> get_signal_to_deliver                        871     922     +51
> release_console_sem                          459     481     +22
> generate_resume_trace                        611     619      +8
> send_sigqueue                                257     253      -4
> vma_adjust                                  1101    1093      -8
> sys_rt_sigtimedwait                          548     531     -17
> dequeue_signal                               415     372     -43
> __dequeue_signal                             388     259    -129
> signalfd_read                               1290    1139    -151
> do_notify_resume                            2216    2030    -186
> 
> And we reduce stack pressure; In handle_signal() (in x86 code), we
> replace a siginfo_t (128 bytes) with a pointer (8 bytes on x86_64),
> and the same in signalfd_read().
> 
> There is a slight slowdown (2.02% relative increase in CPU time):
> 
> 		unpatched	patched
> ----------------------------------------
> mean:		3.078500	3.140800
> stddev:	0.074624	0.168989
> 
> (Numbers are: CPU time in seconds, for two processes to 
> ping-pong in total 655360 SIGUSR1/SIGUSR2 signals between each 
> other. This was repeated 100 times for each kernel.)

hm, does this SIGUSR1/SIGUSR2 test actually make use siginfo?

I.e. shouldnt we have seen a speedup, due to not having to copy 
the siginfo structure?

	Ingo
