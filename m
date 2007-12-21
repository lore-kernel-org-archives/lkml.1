Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbXLUQG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbXLUQG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbXLUQGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:06:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:12294 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXLUQGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:06:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hr9qbaGrW941FOzcTt1nCEh4yw05xz41pPF7zaPKQ0wFyMxRAdwnBnEQp7qXZn7NJvmnvgk2FDUvcHXsgDV+UuLI3tC1YK7j+GTJcNddaQQ2q1SsuvaPGO5vo0P0kNgPud/5iGpnStnapvULgNmZWMNSHcPuSsW0s1OxW1phXIE=
Message-ID: <a44ae5cd0712210806i7f020a71k8c552953f7aeef4d@mail.gmail.com>
Date: Fri, 21 Dec 2007 11:06:49 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70 -- (triggered by "cat /proc/iomem" AFTER suspend-to-disk/resume)
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, "Pavel Machek" <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20071220222913.92a2c19f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com>
	 <4769F409.6030300@gmail.com> <4769FF37.5060308@gmail.com>
	 <476A703B.50804@gmail.com>
	 <20071220093206.22f319b0.akpm@linux-foundation.org>
	 <a44ae5cd0712202158u31c8b4e1lf5b0df89dde20e7e@mail.gmail.com>
	 <20071220222913.92a2c19f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 21, 2007 1:29 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 21 Dec 2007 00:58:19 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:
>
> > On Dec 20, 2007 12:32 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > On Thu, 20 Dec 2007 08:38:03 -0500 Miles Lane <miles.lane@gmail.com>
> > > wrote:
> > >
> > > > On further investigation, "cat /proc/iomem" does not trigger the stack
> > > > trace until after a suspend-to-disk/resume cycle has occurred.
> > >
> > > I still can't reproduce this.
> > >
> > > Could you please try this?
> > >
> > > - cat /proc/iomem
> > > - suspend/resume
> > > - do
> > >
> > > while read i
> > > do
> > > echo $i
> > > sleep 1
> > > done < /proc/iomem
> > >
> > > then, with luck, we'll be able to work out which /proc/iomem record
> > > immediately precedes the corrupted one.
> > >
> >
> > miles@syntropy:~$ cat > test.sh
> > while read i
> > do
> > echo $i
> > sleep 1
> > done < /proc/iomem
> > ^C
> > miles@syntropy:~$ sh test.sh
> > 00000000-0009f7ff : System RAM
> > 0009f800-0009ffff : reserved
> > 000a0000-000bffff : Video RAM area
> > 000c0000-000c7fff : Video ROM
> > 000f0000-000fffff : System ROM
> > 00100000-7f68ffff : System RAM
> > 00100000-0039e4b7 : Kernel code
> > 0039e4b8-004f0983 : Kernel data
> > 00553000-007ecdfb : Kernel bss
> > 7f690000-7f698fff : ACPI Tables
> > 7f699000-7f6fffff : ACPI Non-volatile Storage
> > 7f700000-7fffffff : reserved
> > 88000000-8bffffff : PCI CardBus #05
> > 8c000000-8fffffff : PCI CardBus #05
> > Segmentation fault
> >
> > How do I determine what comes next?
> >
>
> By comparing it with the /proc/iomem from prior to suspending the machine.
>

The offending information seems to be "90000000-90000fff : Intel Flush Page"

root@syntropy:~# cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000f0000-000fffff : System ROM
00100000-7f68ffff : System RAM
00100000-0039e4b7 : Kernel code
0039e4b8-004f0983 : Kernel data
00553000-007ecdfb : Kernel bss
7f690000-7f698fff : ACPI Tables
7f699000-7f6fffff : ACPI Non-volatile Storage
7f700000-7fffffff : reserved
88000000-8bffffff : PCI CardBus #05
8c000000-8fffffff : PCI CardBus #05
90000000-90000fff : Intel Flush Page
c0000000-cfffffff : 0000:00:02.0
d0000000-d1ffffff : PCI Bus #02
d2000000-d3ffffff : PCI Bus #03
d4000000-d5ffffff : PCI Bus #02
d4000000-d4003fff : 0000:02:00.0
d4000000-d4003fff : sky2
d6000000-d7ffffff : PCI Bus #03
d6000000-d6000fff : 0000:03:00.0
d6000000-d6000fff : iwl3945
d8000000-d80fffff : PCI Bus #04
d8000000-d8003fff : 0000:04:09.1
d8004000-d8004fff : 0000:04:09.2
d8004000-d8004fff : tifm_7xx1
d8005000-d80057ff : 0000:04:09.1
d8005000-d80057ff : ohci1394
d8006000-d8006fff : 0000:04:09.0
d8006000-d8006fff : yenta_socket
d8100000-d817ffff : 0000:00:02.0
d8180000-d81fffff : 0000:00:02.1
d8200000-d823ffff : 0000:00:02.0
d8240000-d8243fff : 0000:00:1b.0
d8240000-d8243fff : ICH HD audio
d8444000-d84443ff : 0000:00:1d.7
d8444000-d84443ff : ehci_hcd
d8444400-d84447ff : 0000:00:1f.2
d8444400-d84447ff : ahci
e0000000-efffffff : PCI MMCONFIG 0
e0000000-efffffff : reserved
fec00000-fec0ffff : reserved
fed00000-fed003ff : HPET 0
fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
fed1c000-fed8ffff : reserved
fee00000-fee00fff : reserved
ff000000-ffffffff : reserved

~# lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8038
PCI-E Fast Ethernet Controller (rev 14)
03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
Network Connection (rev 02)
04:09.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
04:09.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
IEEE 1394 Host Controller
04:09.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia
Card Reader (SD/MMC/MS/MS PRO/xD)

I hope this helps,
          Miles
