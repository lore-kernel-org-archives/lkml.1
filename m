Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbYEXUGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbYEXUGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYEXUGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:06:38 -0400
Received: from www.tglx.de ([62.245.132.106]:58698 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbYEXUGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:06:37 -0400
Date: Sat, 24 May 2008 22:05:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <alpine.LFD.1.10.0805242149170.3295@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Daniel Walker wrote:
> > There is no kernel side controlled handover of a normal futex. The
> > woken up waiters race for it and a low prio thread on another CPU can
> > steal it even if there is a high prio waiter woken up.
> 
> After reading futex_wake, Doesn't it depend how many waiters are woken?
> Given that comes from userspace, glibc could wake a single waiter and
> obtain a priority ordering, couldn't it?

It could and it does. Still this does not protect against another
lower prio task taking the futex before the woken waiter can do it,
which is happening way more often than your theoretical setscheduler
case. Again, setscheduler is called in startup code of a program not
at arbitrary points during runtime, which rely on lock ordering.

> > The plist add on works correct in most of the cases, nothing else. To
> > achieve full correctness there is much more necessary than this
> > setscheduler issue. The plist changes were accepted because the
> > overhead is really minimal, but achieving full correctness would hurt
> > performance badly.
> 
> If that's the requirement then code that cleans up the corner case that
> I've identified, which is also minimal should be acceptable .. Since
> it's meeting the same requirement you layed out above for the original
> plist changes.

Your code solves the least to worry about corner case and hurts
performance for nothing. You take extra locks in the hot path for no
benefit.

Aside of that it introduces lock order problems and we can really do
without extra useless complexity in the futex code.

You can argue in circles. This is not going anywhere near mainline.

Thanks,
	tglx
