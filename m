Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZEFJFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZEFJFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZEFJFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:05:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:47309 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbZEFJFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:05:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,301,1239001200"; 
   d="scan'208";a="512940251"
Date: Wed, 6 May 2009 17:05:01 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
Subject: Re: kexec defunct -- sd-async-shutdown [mmotm 2009-04-30-17-55]
Message-ID: <20090506090501.GA18677@sli10-desk.sh.intel.com>
References: <200905010114.n411EV3X022247@imap1.linux-foundation.org> <4A000891.3070109@gmail.com> <20090506005101.GA25287@sli10-desk.sh.intel.com> <4A014F53.9000701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A014F53.9000701@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 04:50:27PM +0800, Jiri Slaby wrote:
> On 05/06/2009 02:51 AM, Shaohua Li wrote:
> > On Tue, May 05, 2009 at 05:36:17PM +0800, Jiri Slaby wrote:
> >> On 05/01/2009 02:55 AM, akpm@linux-foundation.org wrote:
> >>> The mm-of-the-moment snapshot 2009-04-30-17-55 has been uploaded to
> >> ...
> >>> sd-async-shutdown.patch
> >> Hi,
> >>
> >> this one causes kexec to hang.
> > Can you give more info about the hang, like the log? Is patch
> > synchronize-device-shutdown.patch applied? kexec takes the same way
> > to shutdown device, so does shutdown work in the system?
> 
> Ah, I though it silently hangs, but no, I had forgotten to switch a
> logging console. There is nobody-cared interrupt 19 followed by plenty
> of sata ports resets. The same happens on reboot.
> 
> According to /proc/interrupts, irq 19 is usb specific:
>  19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7
> 
> But ahci enables the legacy one at 19 too:
> ahci 0000:00:1f.2: version 3.0
>   alloc irq_desc for 19 on cpu 0 node 0
>   alloc kstat_irqs on cpu 0 node 0
> ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>   alloc irq_desc for 27 on cpu 0 node 0
>   alloc kstat_irqs on cpu 0 node 0
> ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
> ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports ? Gbps 0x3f impl SATA
> mode
> ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part ems
> ahci 0000:00:1f.2: setting latency timer to 64
> 
> 
> Is this that ahci frees msi and interrupts at all at the shutdown stage
> and you "schedule" and wait for an interrupt afterwards? (And then the
> interrupt comes, but usb says: no, it's not mine.)
ok, maybe there is ordering issue, sd shutdown is after ahci shutdown, we can't
simplifily make sd sync shutdown. Thanks for pointing out the patch is broken.

Thanks,
Shaohua
