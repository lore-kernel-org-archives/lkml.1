Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbXJAUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbXJAUQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbXJAUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:16:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbXJAUQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:16:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
Date: Mon, 1 Oct 2007 22:30:22 +0200
User-Agent: KMail/1.9.5
Cc: Bill Davidsen <davidsen@tmr.com>, Mark Lord <lkml@rtr.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20070929005453.GA4475@erig.dyndns.org> <200709292308.13593.rjw@sisk.pl> <4701349A.30200@suse.de>
In-Reply-To: <4701349A.30200@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710012230.23650.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 1 October 2007 19:55, Alexey Starikovskiy wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, 29 September 2007 22:47, Bill Davidsen wrote:
> >> Alexey Starikovskiy wrote:
> >>
> >>> -static void
> >>> -acpi_power_off (void)
> >>> -{
> >>> -       printk("%s called\n",__FUNCTION__);
> >>> -       /* Some SMP machines only can poweroff in boot CPU */
> >>> -       set_cpus_allowed(current, cpumask_of_cpu(0));
> >>> ACPI in kernel 2.6.12 did disable non-boot cpus too in powe_off.
> >>> Later only comment was left for some reason...
> >>>
> >> Am I midreading that code, or does it really assume that the boot cpu is 
> >> always zero? Or just that zero will be able to do the power off?
> >>
> >> In any case I have had an SMP machine which did not have a CPU zero, and 
> >> it was discussed here, I believe. Wonder what happens if you set 
> >> affinity to a CPU you don't have...
> > 
> > Good question, but it also caused other problems to appear, IIRC.
> > 
> > IMHO, it's better to call disable_nonboot_cpus() in an appropriate place
> > anyway.
> > 
> > Greetings,
> > Rafael
> Ok, here is commit which removed the code in question from acpi_power_off:
> 
> commit 6660316cb7a1a2c59a73a52870490c0f782f45c1
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Tue Jul 26 12:16:00 2005 -0600
> 
>     [PATCH] acpi_power_off: Don't switch to the boot cpu
> 
>     machine_power_off on i386 and x86_64 now switch to the
>     boot cpu out of paranoia and because the MP Specification indicates it
>     is a good idea on reboot, so for those architectures it is a noop.
>     I can't see anything in the acpi spec that requires you to be on
>     the boot cpu to power off the system, so this should not be an issue
>     for ia64.  In addition ia64 has the altix a massive multi-node
>     system where switching to the boot cpu sounds insane as we may
>     hot removed the boot cpu.
> 
>     Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>

I see. :-)

Anyway, I think we should atually go UP before executing sysdev_shutdown().

How we are going to do that is another matter.

Greetings,
Rafael
