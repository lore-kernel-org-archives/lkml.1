Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYJKQST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYJKQST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 12:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYJKQSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 12:18:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:58907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYJKQSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 12:18:07 -0400
Date: Sat, 11 Oct 2008 09:18:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: when spin_lock_irq (as opposed to spin_lock_irqsave) is
 appropriate?
Message-ID: <20081011091806.2c8eb2d4@infradead.org>
In-Reply-To: <200810111929.01927.arvidjaar@mail.ru>
References: <200810111929.01927.arvidjaar@mail.ru>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008 19:29:01 +0400
Andrey Borzenkov <arvidjaar@mail.ru> wrote:

> Logically, one piece of kernel code has no way to know whether another
> piece of kernel code (or may be hard-/firmware) has disabled some
> interrupt line. So it looks like spin_lock_irq should not even exist,
> except may be for very specific cases (where we are sure no other
> piece of kernel code may run concurrently)?
> 
> Sorry for stupid question, I an not actually a HW type of person ...

Hi,

_irq versus _irqsave has nothing to do with hardware, and everything
with the code design.
_irqsave is a little more expensive than _irq, so for really high
performance critical pieces of code, if you know it's ok (more on that
below), it's nicer to use _irq than _irqsave.

Now.. when can you use the _irq versions? The answer is simple to
write, but hard to do in practice:

If you know that when the lock is always taken in this place in a
condition where interrupts are not disabled, you can use _irq. 

This is
because the unlock path for the _irq case will unconditionally enable
interrupts (after all, it didn't save what it was before, so all it can
do is blindly enable it); it's generally not right to enable interrupts
in unlock if they weren't enabled at lock time.
(yes someone could find an exception or two in the kernel, but those
are very very special and carefully crafted places).

Typical cases where interrupts are not enabled when you get called
* You or some other code did a spin_lock_irq/spin_lock_irqsave before,
and this lock just nests inside the outer lock. This can be deliberate
or accidental.
* Your code is used during the suspend/resume paths; these tend to
(partially) run with irqs disabled
* Your code is used in interrupt context; interrupt handlers may run
with interrupts disabled, depending on many conditions.
* During early boot interrupts are off too for some duration

there are more, the list I gave is not exhaustive.

But if you KNOW interrupts will be on (for example, because you just
did a sleeping operation in the same function) you can safely use the
_irq version.


Does this answer your question?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
