Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbZBZWL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbZBZWL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZBZWLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:11:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbZBZWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:11:19 -0500
Date: Thu, 26 Feb 2009 14:10:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
 suspend-resume
In-Reply-To: <200902262258.55835.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902261404580.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902261050.50531.rjw@sisk.pl> <d6200be20902261234i5a3896fo78a7f56d16a247c7@mail.gmail.com> <200902262258.55835.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Rafael J. Wysocki wrote:
> 
> Well, how exactly the $subject patch does cause this problem to happen?

Rafael, the problem is that if an interrupt happens while it's disabled - 
but before the CPU has actually turned all interrupts off - the CPU will 
ACK the interrupt (but just set a flag for it being PENDING), so now the 
chipset logic around it will not see it as pending any more, so now the 
chipset won't auto-wake the CPU immediately (or more likely, it won't 
even suspend it).

It's trivial to fix multiple ways, so I wouldn't worry. The most trivial 
way is to just have some sysdev drievr code simply do something like

  static int sysdev_suspend()
  {
	for_each_irq(irq,desc) {
		if (!(desc->flags & IRQF_WAKE))
			continue;
		if (desc->flags & IRQ_PENDING)
			return -EBUSY;
	}
	return 0;
  }

and that should automatically mean that if any irq is pending, the suspend 
will fail and we'll immediately wake up again.

It looks trivial, and I don't understand why Arve can't just do the sysdev 
thing.

		Linus
