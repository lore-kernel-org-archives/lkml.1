Return-Path: <linux-kernel-owner+w=401wt.eu-S969390AbXEIHL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969390AbXEIHL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 03:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968557AbXEIHKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:10:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968443AbXEIHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:10:48 -0400
Date: Wed, 9 May 2007 00:10:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Cc: linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070509001032.dbb982ca.akpm@linux-foundation.org>
In-Reply-To: <20070508225920.258d8d34.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	<20070430102852.042964000@linutronix.de>
	<20070505003421.00ec45ba.akpm@linux-foundation.org>
	<20070505115127.GA17815@elte.hu>
	<1178463784.31213.46.camel@localhost.localdomain>
	<20070508225920.258d8d34.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 22:59:20 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 06 May 2007 17:03:03 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Andrew,
> > 
> > On Sat, 2007-05-05 at 13:51 +0200, Ingo Molnar wrote:
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > > Fixup the existing users.
> > > > 
> > > > This one makes the Vaio-of-fun hang during suspend to disk.  It gets 
> > > > up to "swsusp: critical section/: done (%d pages copied)" then it 
> > > > freezes.
> > > 
> > > after trying to reproduce it on 2 boxes without success it did trigger 
> > > some sw-suspend weirdness on a third box :) We are debugging it now.
> > 
> > find an updated patch below. It fixes the problem on Ingo's
> > VAIO-of-fun-emulator and I got confirmation from several other affected
> > users, that the patch series is still solving their problems.
> > 
> 
> The machine is still hanging with this patch applied.
> 
> suspend-to-disk gets up to "swsusp: critical section: done (NNN pages copied)"
> 
> No netconsole, no printk-timestamping.
> 
> ho hum, I guess I get to debug this.

It got ugly.

We finish swsusp_save() and a few other functions then we go

	hibernate
	->platform_finish
	  ->acpi_hibernation_finish
	    ->acpi_leave_sleep_state
	      ->acpi_evaluate_object

and there it dies, in this call:

	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);

I wonder how your patch caused that?

<debugs further>

OK, it gets to the last statement in acpi_evaluate_object():

	return_ACPI_STATUS(status);

but doesn't hit the printk on return to the caller,
acpi_leave_sleep_state().

A working theory would be that something we did trashed the stack in
acpi_evaluate_object().

<switches from 8k stacks to 4k. No change>

foo.  I'm not sure what to do now.
