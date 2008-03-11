Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYCKIMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYCKIMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYCKILy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:11:54 -0400
Received: from www.tglx.de ([62.245.132.106]:35946 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYCKILw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:11:52 -0400
Date: Tue, 11 Mar 2008 09:11:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
cc: linux-kernel@vger.kernel.org, alan-jenkins@tuffmail.co.uk, devzero@web.de,
       mingo@elte.hu
Subject: Re: Kernel Linux 2.6.23.16 hangs when run updatedb
In-Reply-To: <47D54A8B.2020303@mandic.com.br>
Message-ID: <alpine.LFD.1.00.0803110803280.3781@apollo.tec.linutronix.de>
References: <47D54A8B.2020303@mandic.com.br>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Renato S. Yamane wrote:
> > > How can I fix this? Is safe run reiserfsck?
> > 
> > 
> > I think he's wrong.
> > 
> > Looking at the call trace, the BUG happens during an interrupt.  It
> > could be a coincidence that the interrupt happened during this
> > particular system call.
> > 
> > It looks like a timer callback has been corrupted / set to an invalid
> > value.  The BUG is due to accessing the invalid address 61060fe0
> > within enqueue_hrtimer, and the EIP (instruction pointer) is also
> > equal to 61060fe0.  This would be consistent with the source code of
> > enqueue_hrtimer.  It's not an obvious reiserfs issue.

It's pretty inconsistent with the source code of enqueue_hrtimer().

The only possibility to have a callback from enqueue_hrtimer() is in
hrtimer_enqueue_reprogram() in the HRTIMER_CB_IRQSAFE_NO_RESTART
case. Such timers can not be requeued in interrupt context, hence the
name HRTIMER_CB_IRQSAFE_NO_RESTART :)

Also in hrtimer_interrupt context, hrtimer_enqueue() is called with
reprogram = 0, which ensures that we do not call
hrtimer_enqueue_reprogram().

> > I don't know how to find out where this corruption is happening, but
> > it's worth asking the hrtimers people.
 
Let's gather some more information. 

Renato, some questions:

1) is this fully reproducible with updatedb ?

2) are you sure that this is the first stacktrace you captured, there
might be some BUG before that which scrolled out of sight. Any chance
to use a serial console ?

3) Can you please recompile the kernel with CONFIF_DEBUG_INFO set
and then run the following addresses from the backtrace through
addr2line with the new vmlinux:

# addr2line -e vmlinux 0xc013dad9 0xc0107c3b

Please provide the output.

4) Looking at your .config it seems you have some more patches applied
aside of the .16 stable. Can you please upload a full patch queue
somewhere ?

Thanks,

	tglx
