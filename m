Return-Path: <linux-kernel-owner+w=401wt.eu-S933343AbYDVXtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbYDVXtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYDVXtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:49:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56659 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbYDVXtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:49:04 -0400
Message-ID: <480E796E.4070001@garzik.org>
Date: Tue, 22 Apr 2008 19:49:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: Re: [git patch] free_irq() fixes
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 22 Apr 2008, Jeff Garzik wrote:
>> (note, for mwave I couldn't use pSettings, since that might fail the ambiguity
>> test)
> 
> Ok, so using the pointer to inside a specific pSettings field is fine.
> 
> But can you also explain to me why that insane driver does this:
> 
> 	 static irqreturn_t UartInterrupt(int irq, void *dev_id)
> 	 {
> 	-       int irqno = (int)(unsigned long) dev_id;
> 	+       unsigned short *irqno = dev_id;
> 		...
> 		*irqno, dev_id);
> 
> instead of just ignoring "dev_id" entirely, and then just using that "irq" 
> argument directly?

That was noted briefly in the push email:

> In my review of every single interrupt handler in the Linux, while
> working on another project (jgarzik/misc-2.6.git#irq-remove), I've
[...]
> Since the #irq-remove project involves removal of the 'irq' argument
> from interrupt handlers (unused 99.8% of the time),
[...]

After going over every irq handler (read: almost every driver in the 
kernel, plus arch code), my #irq-remove branch has confirmed what my gut 
already knew -- the 'irq' argument is completely unused for almost every 
driver.  So I was taking that line of thought as far as it went.

I found less than 10 cases (out of ~1100) that actually did something 
useful with the value _and_ did not have the value already stashed 
somewhere in a reached data structure.

Those cases are easily handled a la pt_regs change -- via a 
get_irqfunc_irq() -- as a quick fix, or the preferred cleanup would be 
to pass info properly via the standard method for passing info to irq 
handlers:  dev_id

	Jeff



