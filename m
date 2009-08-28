Return-Path: <linux-kernel-owner+w=401wt.eu-S1750898AbZH1ArF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbZH1ArF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 20:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbZH1ArE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 20:47:04 -0400
Received: from www.tglx.de ([62.245.132.106]:32994 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZH1ArD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 20:47:03 -0400
Date: Fri, 28 Aug 2009 02:44:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <cfriesen@nortel.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <4A971C18.7050109@nortel.com>
Message-ID: <alpine.LFD.2.00.0908280238290.2888@localhost.localdomain>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org> 
 <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org> 
 <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
 <4A971C18.7050109@nortel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Chris Friesen wrote:

> On 08/27/2009 03:09 PM, Thomas Gleixner wrote:
> 
> > That's just the wrong approach. All you need is a way to tell the
> > kernel that CPUx can switch off the scheduler tick when only one
> > thread is running and that very thread is running in user space. Once
> > another thread arrives on that CPU or the single thread enters the
> > kernel for a blocking syscall the scheduler tick has to be
> > restarted.
> 
> That's an elegant approach...I like it.
> 
> How would you deal with per-cpu kernel threads (softirqs, etc.) or
> softirq processing while in the kernel?

If you have pinned an interrupt to that CPU then you need to process
the softirq for it as well. If that's the device your very single user
space thread is talking to then you better want that, if you are not
interested then simply pin that device irq to some other CPU: no irq
-> no softirq.

> Switching off the timer tick isn't sufficient because the scheduler
> will be triggered on the way back to userspace in a syscall.

If there is just one user space thread why is the NOOP call to the
scheduler interesting ? If you go into the kernel you have some
overhead anyway, so why would the few instructions to call schedule()
and return with the same task (as it is the only runnable) matter ?

Thanks,

	tglx
