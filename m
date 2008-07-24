Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYGXPap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYGXPap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYGXPah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:30:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYGXPag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:30:36 -0400
Subject: Re: [PATCH 1/2] posix-timers: fix posix_timer_event() vs
	dequeue_signal() race
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20080723165205.GA4292@tv-sign.ru>
References: <20080723165205.GA4292@tv-sign.ru>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 16:23:03 +0100
Message-Id: <1216912983.15657.1.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 20:52 +0400, Oleg Nesterov wrote:
> The bug was reported and analysed by Mark McLoughlin <markmc@redhat.com>,
> the patch is based on his and Roland's suggestions.
> 
> posix_timer_event() always rewrites the pre-allocated siginfo before sending
> the signal. Most of the written info is the same all the time, but memset(0)
> is very wrong. If ->sigq is queued we can race with collect_signal() which
> can fail to find this siginfo looking at .si_signo, or copy_siginfo() can
> copy the wrong .si_code/si_tid/etc.
> 
> In short, sys_timer_settime() can in fact stop the active timer, or the user
> can receive the siginfo with the wrong .si_xxx values.
> 
> Move "memset(->info, 0)" from posix_timer_event() to alloc_posix_timer(),
> change send_sigqueue() to set .si_overrun = 0 when ->sigq is not queued.
> It would be nice to move the whole sigq->info initialization from send to
> create path, but this is not easy to do without uglifying timer_create()
> further.
> 
> As Roland rightly pointed out, we need more cleanups/fixes here, see the
> "FIXME" comment in the patch. Hopefully this patch makes sense anyway, and
> it can mask the most bad implications.
> 
> Reported-by: Mark McLoughlin <markmc@redhat.com>

I've re-tested and can confirm that the patch fixes the test case at:

  http://markmc.fedorapeople.org/test-posix-timer-race.c

Cheers,
Mark.

