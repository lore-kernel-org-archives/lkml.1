Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbXG0SHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbXG0SHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760025AbXG0SHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:07:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862AbXG0SHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:07:43 -0400
Date: Fri, 27 Jul 2007 11:07:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Kylene Hall <kjhall@us.ibm.com>, tpm@selhorst.net,
       linux-kernel@vger.kernel.org,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for
 tpm_tis
Message-Id: <20070727110701.be3a8459.akpm@linux-foundation.org>
In-Reply-To: <23912.1185542889@turing-police.cc.vt.edu>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<23659.1185400994@turing-police.cc.vt.edu>
	<20070725203737.85871711.akpm@linux-foundation.org>
	<5208.1185508832@turing-police.cc.vt.edu>
	<23912.1185542889@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 09:28:09 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Fri, 27 Jul 2007 00:00:32 EDT, Valdis.Kletnieks@vt.edu said:
> 
> > Apparently, things go pear-shaped in tis_tpm_send(), when they get to the
> > 'if (chip->vendor.irq)' - under 22-rc6-mm1, we never got into this code,
> > because earlier initialization complained it couldn't get IRQ8.  Now, we
> > get IRQ3, and apparently get into this if statement, and then spend 120
> > seconds while wait_for_stat() times out.  So the root cause does look like
> > it's this IRQ8/IRQ3 issue.
> > 
> > I'll try to find time to do a bisect on -rc1-mm1 tomorrow to track down
> > what exactly did this.
> 
> And we have a winner.  In my bisect 'hunt' file, I ended at:
> 
> fs-use-kmem_cache_zalloc-instead.patch GOOD
> # remove-kconfig-setting-config_debug_shirq.patch: Ingo worried
> remove-kconfig-setting-config_debug_shirq.patch BAD

Thanks for working that out.

> Looks like Ingo was right. :)  As a cross-check, I tested a 'GOOD' kernel,
> but rebuilt with CONFIG_DEBUG_SHIRQ=y, and that *also* died. 
> 
> Looks like the problematic code is in tpm_tis.c tpm_tis_init() near here:
> 
>                 for (i = 3; i < 16 && chip->vendor.irq == 0; i++) {
>                         iowrite8(i, chip->vendor.iobase +
>                                     TPM_INT_VECTOR(chip->vendor.locality));
>                         if (request_irq
>                             (i, tis_int_probe, IRQF_SHARED,
>                              chip->vendor.miscdev.name, chip) != 0) {
>                                 dev_info(chip->dev,
>                                          "Unable to request irq: %d for probe\n"
> ,           
>                                          i);
>                                 continue;
>                         }
> 
> This seems to be misbehaving differently for the two different DEBUG_SHIRQ
> cases.
> 
> With DEBUG_SHIRQ=n, it starts at IRQ3, gets to at least 8 (where it complains
> it can't request it for probing), and possibly all the way to 15, without ever
> actually selecting and assigning an IRQ (to refresh memories, in that range
> /proc/interrupts only lists:
> 
>   8:          0          0   IO-APIC-edge      rtc
>   9:          3          0   IO-APIC-fasteoi   acpi
>  12:         94          0   IO-APIC-edge      i8042
>  14:     148166          0   IO-APIC-edge      libata
>  15:         94          0   IO-APIC-edge      libata
> 
> So there's certainly IRQ's available.  No idea why it doesn't choose one. But
> since it never chose one, it never gets into the "wait for the IRQ" protected
> by 'if (chip->vendor.irq)' at the end of tpm_tis_send.
> 
> With DEBUG_SHIRQ=y, It starts at IRQ3, and assigns it (which seems a good thing).
> Unfortunately, this then hits the timeouts in tpm_tis_send.
> 
> Anybody got an idea what *should* be happening here?
> 
> Just for the record, I see this in /sys:
> 
> % cat /sys/bus/pnp/devices/00:0e/id
> BCM0102
> PNP0c31
> 
> The driver is apparently being selected on the basis of PNP0c31.  One of
> the other ID's it looks for is BCM0101 - but this is a BCM0102.  Is this a
> misidentification, or does the driver need to handle a 0102 differently, or
> is something else odd going on?
> 

Fernando, those patches are just too scary for me because of stuff like
this.

Perhaps we should look at implementing this new behaviour on a per-driver
basis?  Pass smoe new flag into request_irq(), perhaps?


