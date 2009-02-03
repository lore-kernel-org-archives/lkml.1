Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZBCRyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZBCRyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZBCRyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:54:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbZBCRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:54:11 -0500
Date: Tue, 3 Feb 2009 09:53:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <200902031026.34093.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902030949590.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain> <1233633061.16867.41.camel@pasglop> <200902031026.34093.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> 
> As I said, I tend to prefer the "loop of disable_irq()" approach, because it
> would allow us to preserve the current ordering of ACPI operations.  Namely,
> if we do:
> 
> suspend devices (normal suspend)
>   loop of disable_irq()
>     late suspend of devices
>       _PTS
>         disable nonboot CPUs
>           local_irq_disable()
>             sysdev suspend
>               enter sleep state
>               get control from the BIOS
>             sysdev resume
>             (*)
>           local_irq_enable()
>         enable nonboot CPUs
>       _WAK
>     early resume of devices
>   loop of enable_irq()
> resume devices (normal resume)
> 
> the ordering of _PTS with respect to putting devices into low power states and
> disabling the nonboot CPUs will be the same as it is now and the same applies
> to _WAK and putting devices into D0 etc. (I really _really_ wouldn't like to
> change this ordering, since this alone is likely to break things badly).

Yes.

Also, make the "loop of disable/enable_irq()" phase be a helper function 
that also sets system_state to SYSTEM_SUSPENDING/SYSTEM_RUNNING 
respectively, and it should all be pretty clean, and the changes really 
should be pretty minimal.

> Now, there's one subtle problem with resume in this picture.  Namely, before
> running the "early resume of devices" we have to make sure that the interrupts
> will be masked.  However, masking MSI-X, for example, means writing into
> the memory space of the device, so we can't do it at this point.

I really don't think it matters. Why? We simply don't care.

All MSI-X things will still have to go through the regular irq layer, so 
the disable/enable_irq part, so even though we've done the 
"local_irq_enable()", we just don't care.

		Linus 
