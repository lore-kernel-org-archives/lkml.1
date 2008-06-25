Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYFYMep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYFYMep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYFYMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:34:37 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2262 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754113AbYFYMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:34:36 -0400
Date: Wed, 25 Jun 2008 16:34:31 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
	preempt-able hardirqs
Message-ID: <20080625123431.GA25452@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080624000016.GA12547@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 04:00:16AM +0400, Anton Vorontsov wrote:
> On Tue, Jun 24, 2008 at 01:51:41AM +0200, Ingo Molnar wrote:
> > 
> > * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > 
> > > IDE interrupt handler relies on the fact that, if necessary, hardirqs 
> > > will re-trigger on ISR exit. With fully preemtable IRQs this seems to 
> > > be not true, since if hardirq thread is currently running, and the 
> > > same IRQ raised again, then this IRQ will be simply lost.
> > 
> > actually no, that should not happen - if -rt loses an IRQ then something 
> > broke in the threaded IRQ code. It's supposed to be a drop-in, 
> > compatible IRQ flow with no driver changes needed.
> 
> ..just as I thought, the bug somewhere deeper... heh.

Ok, a bit more investigation showed that this is indeed not RT specific
per see, but issue emerges only on RT-style IRQ handlers + alim15x3 IDE
controller (for example, PDC20269 works ok).

The difference is that that with RT: low-level (non-threaded) IRQ
handler masks IDE IRQ, then wakes up appropriate IRQ thread, which calls
IDE handler, and then, after IDE handler exits, thread routine unmasks
IDE IRQ.

Without RT: low-level non-threaded IRQ handler does not mask specific
IRQ, but disables local interrupts, and calls IDE handler directly.

The bug, as I see it, in the alim15x3 (ULi M5228) hardware: for some
reason it does not hold IRQ line, but rises it for some short period
of time (while the drive itself rises and holds it correctly -- I'm
seeing it via oscilloscope).

So this scheme does not work:
mask_irq()
...do something that will trigger IDE interrupt...
unmask_irq()

Because at the unmask_irq() time IDE IRQ is gone already, and interrupt
controller could not notice it (interrupts are level sensitive).

I did following test: disable RT + insert mask/unmask sequence in the
IDE IRQ handler, and I got the same behaviour as with RT enabled.

Also, further testing showed that this issue isn't drive-specific, i.e.
with a delay inserted before the unmask_irq(), the bug shows with any
drive I have.

So, in summary: I think that the patch is still correct as a hw bug
workaround (I'll need to correct its comments and description though).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
