Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbYF3WhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbYF3WhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764018AbYF3WhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:37:09 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:15822 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764013AbYF3WhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:37:08 -0400
Date: Tue, 1 Jul 2008 02:37:05 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RT] MPIC edge sensitive issues with hardirq preemption (was:
	Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with
	preemptable hardirqs)
Message-ID: <20080630223705.GA28503@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <20080628005436.GA1956@polina.dev.rtsoft.ru> <1214781974.20711.7.camel@pasglop> <20080630190132.GA6492@polina.dev.rtsoft.ru> <1214863197.20711.57.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1214863197.20711.57.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 07:59:57AM +1000, Benjamin Herrenschmidt wrote:
> > 	
> > Thanks for the idea. With hardirq preempton, fasteoi path does not replay
> > edge interrupts indeed (at least for MPIC).
> > 
> > Here how I tested this: I have external interrupt connected to the button
> > on this board, thus I registered irq handler which is doing exactly this
> > (irq is edge sensitive):
> > 
> > printk("handled\n"); mdelay(2000);
> > 
> > Without hardirq preemption: pressing button twice prints two messages.
> > With hardirq preemption: pressing button twice prints just one message.
> > 
> > This happens because:
> > - irq has come;
> > - fasteoi handler mask()s it, and wakes up the thread;
> 
> Do we eoi first ? We should.

Yup. I just left over this small detail.

Without my patch the code was firstly masking the IRQ, then sending EOI.
Now we don't mask it, but simply send an EOI. If the edge IRQ came again
(while we were processing the same IRQ), non-threaded handler marks IRQ
that it should be replayed, then masks it and sends EOI. When thread
awakes, it unmasks the IRQ before handle_IRQ_event, so that we can catch
next edge IRQ. That is, we handle EOI quite correctly.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
