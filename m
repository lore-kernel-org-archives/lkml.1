Return-Path: <linux-kernel-owner+w=401wt.eu-S1759136AbZBYE2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbZBYE2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbZBYE2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:28:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbZBYE2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:28:09 -0500
Date: Tue, 24 Feb 2009 20:26:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
 suspend-resume
In-Reply-To: <m18wnvup53.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.0902242020120.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902232239.05926.rjw@sisk.pl> <m1iqn01ph3.fsf@fess.ebiederm.org> <200902242342.07721.rjw@sisk.pl> <alpine.LFD.2.00.0902241449221.3111@localhost.localdomain> <m18wnvup53.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Feb 2009, Eric W. Biederman wrote:
> The question I was asking is:
> Can we get the broken cpu hotunplug code out of the suspend path?

I think we can move it around. I don't think we can get rid of it.

> If we can get the devices into a low power state and not generating
> interrupts by the time we disable cpus then we do not need to migrate
> irqs from process context and risk hitting the ioapic bugs.

At least one issue is that the actual final "go to sleep" is something 
that has to happen on just one CPU. And I'm pretty sure the others have to 
have gone through the shutdown sequence before that.

And knowing ACPI, the ordering requirements will boil down to something 
insane, like "you have to turn off the other CPU's _before_ you turn off 
some od the core devices, because turning off the other CPU's may involve 
them". 

So if what you would _want_ to do is to move the "turn off CPU's" into the 
very innermost layer, so that different architectures can then decide 
whether they even need to go through that whole thing or not (because 
turning off one core will automatically turn off all the others, simply 
because the power was turned off), I suspect the answer is "no".

So you were probably hoping to never have to have that whole horrible 
issue with moving interrupts around. I'm afraid I'm not seeing it happen. 
But maybe we can have it happen after we've disabled all the non-system 
devices, so that in practice there simply won't be any new interrupts 
coming in any more.

			Linus
