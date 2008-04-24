Return-Path: <linux-kernel-owner+w=401wt.eu-S1763675AbYDXPlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763675AbYDXPlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbYDXPkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:40:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42478 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbYDXPkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:40:53 -0400
Message-ID: <4810A9E6.1080201@garzik.org>
Date: Thu, 24 Apr 2008 11:40:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org> <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org> <20080423000529.GG28933@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org> <480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org> <alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org> <m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org> <alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The absolutely _only_ piece of reliably information we have that is 
> architecture- and irq-controller neutral is the exact information we pass 
> in to "request_irq()". That is: irq number, the name, and the device 
> cookie thing. Nothing more.

Agreed.

However, it does not follow that an int is what _must_ be passed around. 
  We already have design patterns like

	cookie_pointer = ioremap(raw bus resource)

Not that I am the one pushing for that, just noting.

Overall this is all wild-assed speculation based on a thought 
exploration (#irq-remove) that a several kernel hackers seemed to like.


>  - the "device cookie". This is the thing that the system itself doesn't 
>    care about, and is _entirely_ under control of the driver, so the 
>    driver can pass its own interrupt controller some helpful instance 
>    pointers.
> 
> So of the three, "device cookie" is the one that we absolutely have to 
> have. The irq number is not necessary, but it does actually have some 
> meaning especially for legacy devices (eg ISA), and it is at least 
> _sensible_ to pass around (ie it has no downsides, and it's not 
> fundamentally broken). And the name would be just stupid.

Agreed.


> EVERYTHING else would be architecture-specific. And that is exactly what 
> we do not want. EVER. 

Not true -- you have metadata/OOB data like MSI messages, where you are 
passed a value from the PCI hardware in the PCI message, not just an 
"interrupt asserted" condition.  Or s/value/values/ if you enable PCI 
MSI's multiple message support.

The PCI devices themselves are moving from sending a single bit of 
information ("irq!") to sending actual messages.

That is not arch-specific at all, but a new model for "interrupt" (i.e. 
event) notification being pushed upon us.

	Jeff


