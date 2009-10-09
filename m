Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbZJILYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbZJILYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 07:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZJILYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 07:24:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44966 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760555AbZJILYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 07:24:19 -0400
Date: Fri, 9 Oct 2009 12:23:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [RFC][PATCH 3/4] PCI / ACPI PM: Platform support for PCI PME
	wake-up (rev. 2)
Message-ID: <20091009112320.GA23990@srcf.ucam.org>
References: <200910090051.50932.rjw@sisk.pl> <200910090054.18693.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910090054.18693.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 12:54:18AM +0200, Rafael J. Wysocki wrote:

> Unfortunately, the subset of PCI devices that have GPEs associated
> with them is quite limited and the other devices have to rely on
> the GPEs associated with their upstream bridges and, possibly, the
> root bridge to generate ACPI wake-up events in response to PMEs from
> them.  Moreover, ACPI devices tend to share wake-up GPEs, in which
> cases it makes sense to install an ACPI notify handler for only one
> of them and "bind" the other devices to it.  Furthermore, ACPI-based
> PCI hotplug also uses ACPI notify handlers that in general may
> conflict with the PM notify handlers, unless this issue is
> specifically taken care of.

I'm not sure this approach is correct - for instance, from a Dell 
system:

        Method (_L0D, 0, NotSerialized)
        {
            Store (SMI (0xC6, 0x00), Local0)
            If (And (Local0, 0x01))
            {
                Notify (\_SB.PCI0.AZAL, 0x02)
            }

            If (And (Local0, 0x02))
            {
                Notify (\_SB.PCI0.EHCI, 0x02)
            }

            If (And (Local0, 0x04))
            {
                Notify (\_SB.PCI0.EHC2, 0x02)
            }
        }

All these devices share a GPE, but registering only one notify handler 
would result in us missing the notification in some cases. I also 
suspect that this should wait until the GPE rework is done.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
