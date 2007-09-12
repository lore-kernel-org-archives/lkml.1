Return-Path: <linux-kernel-owner+w=401wt.eu-S967241AbXILQai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967241AbXILQai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765692AbXILQaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:30:30 -0400
Received: from outbound-mail-33.bluehost.com ([69.89.18.153]:46992 "HELO
	outbound-mail-33.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765673AbXILQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:30:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Lossy interrupts on x86_64
Date: Wed, 12 Sep 2007 09:29:52 -0700
User-Agent: KMail/1.9.7
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <200709120833.15980.jbarnes@virtuousgeek.org> <20070912090151.97c9a78e.randy.dunlap@oracle.com>
In-Reply-To: <20070912090151.97c9a78e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709120929.52217.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.111.214.98 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 12, 2007, Randy Dunlap wrote:
> On Wed, 12 Sep 2007 08:33:15 -0700 Jesse Barnes wrote:
> > I just narrowed down a weird problem where I was losing more than
> > 50% of my vblank interrupts to what seems to be the hires timers
> > patch.  Stock 2.6.23-rc5 works fine, but the latest (171) kernel
> > from rawhide drops most of my interrupts unless I also have another
> > interrupt source running (e.g. if I hold down a key or move the
> > mouse I get the expected number of vblank interrupts, otherwise I
> > get between 3 and 30 instead of the expected 60 per second).
> >
> > Any ideas?  It seems like it might be bad APIC programming, but I
> > haven't gone through those mods to look for suspects...
>
> Also tickless?  (NO_HZ ?)
>
> I think I've seen some emails about tickless and keystrokes being
> needed to cause interrupts... but I'm not postive about it.
>
> but you said "any ideas"

Yeah, there's NO_HZ in the rawhide kernel too, but I'm getting timer
ticks normally afaict, it's just vblank interrupts that get lost...

/proc/interrupts on this machine (from NO_HZ, hires kernel):

[jbarnes@jbarnes-t61 ~]$ cat /proc/interrupts
           CPU0       CPU1
  0:     290050     289541   IO-APIC-edge      timer
  1:       3862       3956   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc0
  9:       1632       1643   IO-APIC-fasteoi   acpi
 12:     183662     183926   IO-APIC-edge      i8042
 14:      20626      20717   IO-APIC-edge      libata
 15:          0          0   IO-APIC-edge      libata
 16:      46812      46825   IO-APIC-fasteoi   yenta, uhci_hcd:usb3, i915@pci:0000:00:02.0
 17:      63715      63653   IO-APIC-fasteoi   uhci_hcd:usb4, HDA Intel, firewire_ohci, iwl4965
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 19:         52         36   IO-APIC-fasteoi   ehci_hcd:usb7
 20:         43         46   IO-APIC-fasteoi   uhci_hcd:usb1
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 22:          2          1   IO-APIC-fasteoi   ehci_hcd:usb6
2297:        937        944   PCI-MSI-edge      eth0
2298:      12392      12402   PCI-MSI-edge      ahci
NMI:          0          0
LOC:     290913     335027
ERR:          0


