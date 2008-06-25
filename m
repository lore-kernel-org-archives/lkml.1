Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbYFYO7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbYFYO7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYFYO7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:59:39 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2595 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751921AbYFYO7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:59:39 -0400
Date: Wed, 25 Jun 2008 18:59:37 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
	preempt-able hardirqs
Message-ID: <20080625145937.GA2382@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <486244FF.8060805@ru.mvista.com> <20080625142249.GA21630@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080625142249.GA21630@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 06:22:49PM +0400, Anton Vorontsov wrote:
> On Wed, Jun 25, 2008 at 05:15:43PM +0400, Sergei Shtylyov wrote:
> > Hello.
> >
> > Anton Vorontsov wrote:
> >
> >>>>> IDE interrupt handler relies on the fact that, if necessary, 
> >>>>> hardirqs will re-trigger on ISR exit. With fully preemtable IRQs 
> >>>>> this seems to be not true, since if hardirq thread is currently 
> >>>>> running, and the same IRQ raised again, then this IRQ will be 
> >>>>> simply lost.
> >
> >>>> actually no, that should not happen - if -rt loses an IRQ then 
> >>>> something broke in the threaded IRQ code. It's supposed to be a 
> >>>> drop-in, compatible IRQ flow with no driver changes needed.
> >
> >>> ..just as I thought, the bug somewhere deeper... heh.
> >
> >> Ok, a bit more investigation showed that this is indeed not RT specific
> >> per see, but issue emerges only on RT-style IRQ handlers + alim15x3 IDE
> >> controller (for example, PDC20269 works ok).
> >
> >    Does it happen only with ATAPI devices also or with ATA disks too?
> 
> So far I own two ATAPI devices, IDE disks are quire rare nowadays,
> should find one. ;-)
[...]
> >> Also, further testing showed that this issue isn't drive-specific, i.e.
> >> with a delay inserted before the unmask_irq(), the bug shows with any
> >> drive I have.
> >
> >    So, "shit happens" even with the ATA drives?
> 
> Will try as soon as I'll get one.

Thanks for the drive, and the result is:

hda: irq timeout: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
