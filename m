Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZIQQpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZIQQpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbZIQQpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:45:33 -0400
Received: from outbound-mail-305.bluehost.com ([67.222.53.251]:35543 "HELO
	outbound-mail-305.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758537AbZIQQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:45:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cnPA856J9+FaYD1ESuK14QA3ljXJkTe/nv+UsmUhUTOQl6i9qcRnFfnL4pkRqJ0++RZsL+mJo4ys9xeif++ncSFhiot1XA9kzAYPSSkE66v6LFbwc5vQcodb0PJnOXXb;
Date: Thu, 17 Sep 2009 09:45:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Gary Hade <garyhade@us.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: fixing "pci=use_crs"
Message-ID: <20090917094527.051ca4bc@jbarnes-g45>
In-Reply-To: <200909171016.50087.bjorn.helgaas@hp.com>
References: <200909161715.24376.bjorn.helgaas@hp.com>
	<200909171016.50087.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 10:16:49 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Wednesday 16 September 2009 05:15:23 pm Bjorn Helgaas wrote:
> > The user currently has to boot with "pci=use_crs" to make
> > hot-add work on some machines.  I think this is a poor
> > user experience, and I'd like to figure out a better solution.
> > 
> > We tried making "pci=use_crs" the default, which didn't work
> > because it broke machines like Larry's.  I'd like to look
> > at that machine in more detail and figure out what it's doing.
> > 
> > Larry, would you mind collecting the output of:
> > 
> >   # dmesg
> >   # cat /proc/iomem
> >   # lspci -vv
> >   # cd /sys/devices/; grep . pnp*/*/{id,resources}
> > 
> > and attaching them here:
> > 
> >     http://bugzilla.kernel.org/show_bug.cgi?id=14183
> 
> Thanks a lot, Larry.
> 
> It looks like you have an HP box -- what exactly is it and
> what BIOS version do you have?  Maybe I can borrow one to play
> with myself so I don't have to bug you as much.
> 
> You don't happen to have Windows on it also, do you?  If you do,
> I'd like to know what the device manager says about the PCI bridges.
> 
> Your dmesg from LKML
> (http://thread.gmane.org/gmane.linux.kernel/856413/focus=856458)
> suggests that ACPI told us about a whole bunch of resources:
> 
>   pci_bus 0000:00: resource 0 io:  [0x00-0xcf7]
>   pci_bus 0000:00: resource 1 io:  [0xd00-0xffff]
>   pci_bus 0000:00: resource 2 mem: [0x0a0000-0x0bffff]
>   pci_bus 0000:00: resource 3 mem: [0x0c0000-0x0c3fff]
>   pci_bus 0000:00: resource 4 mem: [0x0c4000-0x0c7fff]
>   pci_bus 0000:00: resource 5 mem: [0x0c8000-0x0cbfff]
>   pci_bus 0000:00: resource 6 mem: [0x0cc000-0x0cffff]
>   pci_bus 0000:00: resource 7 mem: [0x0d4000-0x0d7fff]
>   pci_bus 0000:00: resource 8 mem: [0x0d8000-0x0dbfff]
>   pci_bus 0000:00: resource 9 mem: [0x0dc000-0x0dffff]
>   ...
> 
> but the new dmesg (http://bugzilla.kernel.org/attachment.cgi?id=23106)
> only has a few:
> 
>   pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
>   pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
>   pci_bus 0000:01: resource 1 mem: [0xfc100000-0xfc1fffff]
>   pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
>   pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
>   pci_bus 0000:06: resource 0 io:  [0x4000-0x4fff]
>   pci_bus 0000:06: resource 1 mem: [0xf8000000-0xfbffffff]
>   pci_bus 0000:04: resource 1 mem: [0xfc000000-0xfc0fffff]
> 
> The extra resources in the old dmesg could be from "pci=use_crs"
> being the default, but if that were the case, they should be in
> the PNP resource dump.  Did you update the BIOS between those
> boots?

FWIW in the CRS problem thread there were other reports of large
numbers of PNP resources causing problems.  One solution I considered
before we ended up reverting the patch was to increase the number of
bus resources we track.  Rather than a small array of resources per
bus, we could have a linked list, which would allow us to track an
arbitrary number.

We probably want to distinguish between what we read from the hw regs
and what's reported in PNP though, so maybe a new list in addition to
the existing resource set would be the way to go.  That would allow us
to selectively ignore PNP resources on machines where they report bogus
ranges (or selectively look at them, either way).

-- 
Jesse Barnes, Intel Open Source Technology Center
