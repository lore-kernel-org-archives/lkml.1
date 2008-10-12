Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYJLWVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYJLWVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 18:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYJLWVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 18:21:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60730 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbYJLWVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 18:21:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: when spin_lock_irq (as opposed to spin_lock_irqsave) is appropriate?
Date: Mon, 13 Oct 2008 00:21:37 +0200
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810111929.01927.arvidjaar@mail.ru> <20081011091806.2c8eb2d4@infradead.org> <200810121548.05644.arvidjaar@mail.ru>
In-Reply-To: <200810121548.05644.arvidjaar@mail.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810130021.37811.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18QCsIgfT6CF9LZTdxEYyX8mwuWENp2P8UynRQ
 BZdK8dEJf1ABvI219QYMaz42PLoulEgsI5nW8yqwOsKHsYv/4N
 xh2t0wGIX1SmK4sdLCOPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 October 2008, Andrey Borzenkov wrote:
> This leaves me with a question - how can I know whether interrupts may
> (not) be disabled at particular point? In particular, is it safe to 
> assume that any place marked at "code may sleep" has interrupts enabled?

Yes, that is safe. The only times you know that interrupts are disabled
are:

1. If you have disabled interrupts yourself using local_irq_{disable,save}
or spin_lock_irq{,save}.

2. If you get called from an interface that is documented to have interrupts
disabled. The only common example of this is the interrupt handler function
you register with request_irq().

In all other cases, interrupts are disabled, though in some places you may
not sleep, e.g. because of spin_lock(), preempt_disable() or softirq
context (timer, tasklet, ...). The question of whether you may sleep
or not is irrelevant to whether or not you can use spin_lock_irq.

The rules are:

* If you know that interrupts are disabled, use spin_lock().
* If you know that interrupts are enabled and you might race against
an interrupt handler, use spin_lock_irq().
* If you cannot race against a hard interrupt handler, but can race
against a softirq, use spin_lock_bh().
* If you cannot race against either hardirq or softirq context but cannot
sleep, use spin_lock().
* If you can sleep in all places that take the spinlock, replace the
spinlock with a mutex.
* If you cannot tell whether interrupts are enabled or disabled, but
you can race against a hardirq, use spin_lock_irqsave.

Some people interpret the last rule as "If I can't be bothered to find
out who is calling me, use spin_lock_irqsave", but I much prefer to
be explicit (besides efficient) to give the reader a better indication
of what the lock actually does.

	Arnd <><
