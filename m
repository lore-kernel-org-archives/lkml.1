Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbXELJBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbXELJBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 05:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXELJBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 05:01:24 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbXELJBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 05:01:23 -0400
Date: Sat, 12 May 2007 02:00:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070512020056.a24cf472.akpm@linux-foundation.org>
In-Reply-To: <1178959563.22481.126.camel@localhost.localdomain>
References: <20070430102837.748238000@linutronix.de>
	<20070511132846.5ebf4437.akpm@linux-foundation.org>
	<200705112302.47726.rjw@sisk.pl>
	<200705112309.15996.rjw@sisk.pl>
	<20070511235607.83ad0eb5.akpm@linux-foundation.org>
	<1178959563.22481.126.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 10:46:03 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 2007-05-11 at 23:56 -0700, Andrew Morton wrote:
> > On Fri, 11 May 2007 23:09:15 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > > > 
> > > > > hm, Fedora don't seem to want to give me an RPM which contains acpidump and
> > > > > all the yum servers are featuring scrogged checksums.  I could build it, I
> > > > > guess, but there's a principle involved ;)
> > > > > 
> > > > > http://userweb.kernel.org/~akpm/dsdt is /proc/acpi/dsdt.  Is that OK?
> > > > 
> > > > Yes, thanks.
> > > 
> > > Hmm, have you tried to do 'echo shutdown > /sys/power/disk' before the
> > > hibernation?
> > 
> > That didn't change the behaviour.
> 
> Andrew,
> 
> can you try the desperate witchcraft patch below ?
> 
> 	tglx
> 
> Index: linux-2.6.21/arch/i386/kernel/apic.c
> ===================================================================
> --- linux-2.6.21.orig/arch/i386/kernel/apic.c
> +++ linux-2.6.21/arch/i386/kernel/apic.c
> @@ -238,9 +238,13 @@ static void lapic_timer_setup(enum clock
>  		break;
>  	case CLOCK_EVT_MODE_UNUSED:
>  	case CLOCK_EVT_MODE_SHUTDOWN:
> -		v = apic_read(APIC_LVTT);
> -		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
> -		apic_write_around(APIC_LVTT, v);
> +
> +		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
> +		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
> +			v = apic_read(APIC_LVTT);
> +			v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
> +			apic_write_around(APIC_LVTT, v);
> +		}
>  		break;
>  	case CLOCK_EVT_MODE_RESUME:
>  		/* Nothing to do here */
> 

Still hangs in the same fashion, sorry.

It's peculiar that the hang happens when acpi_evaluate_object() hits its
return statement.  Any theories there?
