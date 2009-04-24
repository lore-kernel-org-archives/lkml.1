Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZDXA1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZDXA1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZDXA1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:27:01 -0400
Received: from www.sr71.net ([198.145.64.142]:43543 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZDXA1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:27:00 -0400
Subject: Re: 2.6.30-rc2 soft lockups: ACPI?  clock source problem?
From: Dave Hansen <dave@sr71.net>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, lenb@kernel.org
In-Reply-To: <1240513827.7224.2.camel@localhost.localdomain>
References: <1240335038.11194.11.camel@nimitz>
	 <20090422204557.10c3cc37.akpm@linux-foundation.org>
	 <1240511508.10627.159.camel@nimitz>
	 <1240513827.7224.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 17:26:58 -0700
Message-Id: <1240532818.8035.8.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As John suggested, booting with clocksource=acpi_pm works around the
issue.

I couldn't reproduce this at all when I boot with init=/bin/sh.  That
happens both on 2.6.30-rc2 and -rc3.

This actually happens relatively late in boot.  I also noticed that it
seems to always happen during the ACPI messages in that "power states"
area.  So, I tried booting to /bin/sh again, waiting a few seconds, and
doing 'modprobe processor'.  Bingo.  I got the trace right when I did
the modprobe.

It doesn't look like it comes from the prinks themselves though:

                printk(KERN_INFO PREFIX "CPU%d (power states:", pr->id);
                for (i = 1; i <= pr->power.count; i++)
                        if (pr->power.states[i].valid)
                                printk(" C%d[C%d]", i,
                                       pr->power.states[i].type);
                printk(")\n");

Any ideas?

Apr 23 09:04:47 nimitz kernel: [   13.208679] sd 6:0:0:0: [sdc] Attached SCSI disk
Apr 23 09:04:47 nimitz kernel: [   13.653314] ACPI: SSDT bf6e1b32 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
Apr 23 09:04:47 nimitz kernel: [   13.669448] ACPI: SSDT bf6e1e7b 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
Apr 23 09:04:47 nimitz kernel: [  299.093892] ACPI: CPU0 (power states:<3>BUG: soft lockup - CPU#1 stuck for 266s! [modprobe:3193]
Apr 23 09:04:47 nimitz kernel: [  299.100292] Modules linked in: button(+) processor(+) ohci1394 ieee1394 uhci_hcd ehci_hcd thermal fan fuse usb_storage usb_libusual usbcore
Apr 23 09:04:47 nimitz kernel: [  299.100302] 
Apr 23 09:04:47 nimitz kernel: [  299.100305] Pid: 3193, comm: modprobe Not tainted (2.6.30-rc3-dirty #327) 7659A71
Apr 23 09:04:47 nimitz kernel: [  299.100308] EIP: 0073:[<08049942>] EFLAGS: 00000246 CPU: 1
Apr 23 09:04:47 nimitz kernel: [  299.100311] EIP is at 0x8049942
Apr 23 09:04:47 nimitz kernel: [  299.100313] EAX: 0000006b EBX: 0000002f ECX: 0000006b EDX: 0804e198
Apr 23 09:04:47 nimitz kernel: [  299.100315] ESI: 0804e268 EDI: 000000a1 EBP: bf8f73b8 ESP: bf8f7390


-- Dave

