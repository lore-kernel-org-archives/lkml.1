Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbXKORg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbXKORg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbXKORgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:36:17 -0500
Received: from palrel13.hp.com ([156.153.255.238]:51132 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbXKORgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:36:15 -0500
Date: Thu, 15 Nov 2007 10:36:13 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071115173613.GG7541@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115004039.GC6269@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

[I'm gonna take the points in your mail a little out of order]

> No, acpiphp should (and did before your changes) register all
> hotplug capable slots.  All 6 slots (2 PCI-X, 4 PCIe) in that
> system are hotplug capable.  Emptyness shouldn't matter.  If
> the empty slots are not registered it is not be possible to
> successfully hotplug cards to them.

Of course, you are right. I am not sure what I was thinking when
I wrote that email yesterday, but I pretty much got it exactly
wrong. I think I confused myself between empty/populated vs
hp/non-hp. In any case, thanks for the patient explanation.

I went back and looked at a vanilla kernel on my machine that has
the following hardware configuration:

HP rx6600
Slot 1-2: PCI-X under PCI root bridges
Slot 3-6: PCIe under transparent P2P bridges
Slot 7-10: PCI-X under PCI root bridges
Slot 1: PCI-X,  !populated, !hp
Slot 2: PCI-X,  populated, !hp
Slot 3: PCIe,   populated, hp
Slot 4: PCIe,   populated, hp
Slot 5: PCIe,   !populated, hp
Slot 6: PCIe,   populated, hp
Slot 7: PCI-X,  !populated, hp
Slot 8: PCI-X,  !populated, hp
Slot 9: PCI-X,  !populated, hp
Slot 10: PCI-X, !populated, hp

On a kernel without my changes, we see:

[root@canola slots]# modprobe acpiphp
[root@canola slots]# ls
10  3  4  5  6  7  8  9
[root@canola slots]# for i in * ; do ls $i ; done
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
[root@canola slots]# for i in * ; do cat $i/address ; done
0000:01:02
0000:8b:00
0000:52:00
0000:c5:00
0000:10:00
0000:0a:01
0000:4a:01
0000:01:01

This confirms that you were right -- we see all the hp slots show
up, even though many of them are non-populated. Also, the correct
hp entries show up, just like you'd expect.

Ok, so all that said, after re-implementing my ACPI-PCI slot
driver, we get all the correct answers, but with the additional
appearance of slots 1 and 2 (which aren't hotpluggable):

[root@canola slots]# ls
1  10  2  3  4  5  6  7  8  9
[root@canola slots]# for i in * ; do ls $i ; done
address
adapter  address  attention  latch  power
address
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
adapter  address  attention  latch  power
[root@canola slots]# for i in * ; do cat $i/address ; done
0000:49:01
0000:01:02
0000:49:02
0000:8b:00
0000:52:00
0000:c5:00
0000:10:00
0000:0a:01
0000:4a:01
0000:01:01

Bonus points because all that noise during boot went away too.
Life is much better when you actually copy an algorithm correctly
rather than coming up with some half-assed solution on one's own.
;)

So if you could try out v2 of my patch series when you get access
to your machine back, I'd much appreciate it. I feel a lot better
about it compared to v1.

> > > Have you possibly considered a kernel option as a kinder
> > > and gentler way of introducing the changes?
> > 
> > That is a good idea. I will work on that.
> 
> Thanks.  This will allow everyone to focus on the systems where
> the changes are most beneficial and not waste a bunch of time
> trying to test everywhere.

I will work on this for v3.

Thanks!

/ac

Here is some dmesg and lspci -vt output in case you want to
double-check my work:

ACPI: PCI Root Bridge [L000] (0000:00)
ACPI: PCI Root Bridge [L001] (0000:01)
ACPI: PCI Root Bridge [L002] (0000:0a)
ACPI: PCI Root Bridge [L003] (0000:0f)
ACPI: PCI Root Bridge [L004] (0000:49)
ACPI: PCI Root Bridge [L005] (0000:4a)
ACPI: PCI Root Bridge [L006] (0000:4f)
ACPI: PCI Root Bridge [L007] (0000:c4)

[root@canola slots]# lspci -vt
-+-[0000:c4]---00.0-[0000:c5-fe]--
 +-[0000:4f]---00.0-[0000:50-c3]----00.0-[0000:51-c3]--+-00.0-[0000:52-8a]----00.0  Hewlett-Packard Company Smart Array Controller
 |                                                     \-01.0-[0000:8b-c3]----00.0  Hewlett-Packard Company Smart Array Controller
 +-[0000:49]-+-02.0  Intel Corporation 82546GB Gigabit Ethernet Controller
 |           \-02.1  Intel Corporation 82546GB Gigabit Ethernet Controller
 +-[0000:0f]---00.0-[0000:10-48]----00.0  Hewlett-Packard Company Smart Array Controller
 \-[0000:00]-+-01.0  Hewlett-Packard Company RMP-3 (Remote Management Processor)
             +-01.1  Hewlett-Packard Company RMP-3 Shared Memory Driver
             +-01.2  Hewlett-Packard Company Diva Serial [GSP] Multiport UART
             +-02.0  NEC Corporation USB
             +-02.1  NEC Corporation USB
             +-02.2  NEC Corporation USB 2.0
             \-04.0  ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]
