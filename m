Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbZBZWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbZBZWbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZBZWb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:31:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZBZWbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:31:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Thu, 26 Feb 2009 23:30:51 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902262258.55835.rjw@sisk.pl> <alpine.LFD.2.00.0902261404580.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902261404580.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902262330.52390.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Linus Torvalds wrote:
> 
> On Thu, 26 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > Well, how exactly the $subject patch does cause this problem to happen?
> 
> Rafael, the problem is that if an interrupt happens while it's disabled - 
> but before the CPU has actually turned all interrupts off - the CPU will 
> ACK the interrupt (but just set a flag for it being PENDING), so now the 
> chipset logic around it will not see it as pending any more, so now the 
> chipset won't auto-wake the CPU immediately (or more likely, it won't 
> even suspend it).

Ah, I see now, thanks.

> It's trivial to fix multiple ways, so I wouldn't worry. The most trivial 
> way is to just have some sysdev drievr code simply do something like
> 
>   static int sysdev_suspend()
>   {
> 	for_each_irq(irq,desc) {
> 		if (!(desc->flags & IRQF_WAKE))
> 			continue;
> 		if (desc->flags & IRQ_PENDING)
> 			return -EBUSY;
> 	}
> 	return 0;
>   }
> 
> and that should automatically mean that if any irq is pending, the suspend 
> will fail and we'll immediately wake up again.

Yeah.

Thanks,
Rafael
