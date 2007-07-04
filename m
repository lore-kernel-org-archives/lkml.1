Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXGDLP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXGDLP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbXGDLPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:15:20 -0400
Received: from www.osadl.org ([213.239.205.134]:42136 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755021AbXGDLPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:15:19 -0400
Subject: Re: [PATCH] NTP: remove clock_was_set() call to prevent deadlock
From: Thomas Gleixner <tglx@linutronix.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>
In-Reply-To: <200707041307.01116.zippel@linux-m68k.org>
References: <1183485920.3291.28.camel@chaos>
	 <200707041307.01116.zippel@linux-m68k.org>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 13:15:16 +0200
Message-Id: <1183547716.3291.72.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-04 at 13:06 +0200, Roman Zippel wrote:
> Hi,
> 
> On Tuesday 03 July 2007, Thomas Gleixner wrote:
> 
> > The clock_was_set() call in seconds_overflow() which happens only when
> > leap seconds are inserted / deleted is wrong in two aspects:
> >
> > 1. it results in a call to on_each_cpu() with interrupts disabled
> > 2. it is potential deadlock source vs. call_lock in smp_call_function()
> >
> > The only possible side effect of the removal might be, that an absolute
> > CLOCK_REALTIME timer fires 1 second too late, in the rare case of leap
> > second deletion and an absolute CLOCK_REALTIME timer which expires in
> > the affected time frame. It will never fire too early.
> 
> That's a bit of an easy solution and doesn't fix the real problem. The 
> clock_was_set() calls were correct, what's broken is the locking. Why wasn't 
> that fixed instead?
> I would at least like to see a comment there, why these calls were removed.

We can not fix the locking that late in the cycle. I doubt that we can
fix it at all, as smp_call_function _must_ run with interrupts enabled,
therefor it can not run in interrupt context. It needs to run from
thread context only.

	tglx




