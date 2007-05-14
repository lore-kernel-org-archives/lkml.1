Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbXENBR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbXENBR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 21:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758681AbXENBRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 21:17:22 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.7]:4775 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbXENBRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 21:17:22 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: tglx@linutronix.de
Subject: Re: [PATCH] x86-64 highres/dyntick support
Date: Mon, 14 May 2007 02:17:11 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
In-Reply-To: <1178485128.31213.98.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705140217.11515.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 May 2007 21:58:47 Thomas Gleixner wrote:
> I'm pleased to announce the first cut of the final x86_64
> highres/dyntick support, which I did based on Chris Wright's patch set,
> which is again based on Arjan van de Ven's initial work:

I've noticed a few problems with this patch series, which I manually (without 
difficulty) ported to 2.6.22-rc1.

Firstly, the output of /proc/interrupts looks a bit strange. NO_HZ isn't 
enabled, just high resolution timers. HZ was set to 1000.

alistair@damocles:~$ cat /proc/interrupts
           CPU0       CPU1
  0:        195          0   IO-APIC-edge      timer
  1:         21      13698   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 14:        117      51178   IO-APIC-edge      libata
 15:          0          0   IO-APIC-edge      libata
 18:        455     449373   IO-APIC-fasteoi   lan-sky, EMU10K1
 19:          0          3   IO-APIC-fasteoi   yenta, ohci1394
 20:        220      86188   IO-APIC-fasteoi   ohci_hcd:usb2
 21:          0         26   IO-APIC-fasteoi   ehci_hcd:usb1
 22:          0        273   IO-APIC-fasteoi   sata_nv
 23:        928     507781   IO-APIC-fasteoi   sata_nv, lan
NMI:          0          0
LOC:    4723272    4797930
ERR:          0

Only 195 timer interrupts? I only see this on an AMD Opteron, it doesn't occur 
on an Intel Core 2 Duo. Mainline reports this counter regularly increasing 
with or without the acpi_pm clocksource loaded.

Secondly, /proc/cpuinfo seems to be broken:

alistair@damocles:~$ cat /proc/cpuinfo | grep MHz
cpu MHz         : 210779.550
cpu MHz         : 210779.550

Unless my CPU is just under 80 times faster than it used to be, these numbers 
are incorrect. I expect 2700.50, or something similar. cpufreq isn't compiled 
in.

Finally, and possibly related, the dmesg timestamps seem to be totally broken. 
Apparently my machine booted in less than 1 second, with the last messages 
as:

[    0.607862] bridge: topology change detected, propagating
[    0.607862] bridge: port 2(lan-sky) entering forwarding state
[    0.830472] Linux agpgart interface v0.102 (c) Dave Jones

Of course, all of these problems might be PEBKAC, but I'm sceptical.

Find the kernel config, updated patch (for 2.6.22-rc1), dmesg, contents 
of /proc/interrupts and /proc/cpuinfo here:

http://devzero.co.uk/~alistair/2.6.22-rc1-hrt/

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
