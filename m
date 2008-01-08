Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbYAHDC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbYAHDC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYAHDCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:02:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:36714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYAHDCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:02:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,255,1196668800"; 
   d="scan'208";a="318227679"
Subject: Re: Suspend code ordering (again)
From: Shaohua Li <shaohua.li@intel.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <47744291.30100@shaw.ca>
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no>
	 <fa.XycBwhGuyvtVl/QW5HONqLwOags@ifi.uio.no> <4773E9EE.40107@shaw.ca>
	 <200712272100.20282.rjw@sisk.pl>  <47744291.30100@shaw.ca>
Content-Type: multipart/mixed; boundary="=-vOebPy0ZK62EbU+isXKW"
Date: Tue, 08 Jan 2008 11:03:14 +0800
Message-Id: <1199761394.28914.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vOebPy0ZK62EbU+isXKW
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 2007-12-28 at 08:25 +0800, Robert Hancock wrote:
> Rafael J. Wysocki wrote: 
> >> Also, as was pointed out, pre-Vista versions of Windows follow ACPI
> 1.0 
> >> and Vista follows 3.0, so 2.0 doesn't really matter since BIOS
> people 
> >> won't test against it. 1.0 specifies that _PTS is to be called
> before 
> >> suspending devices and 3.0 says that the AML must not depend on
> any 
> >> specific device power state, so in both cases it should be safe to
> call 
> >> _PTS before suspending, no? 
> > 
> > Well, IMO, if we take one option only (whichever that is) and there
> are systems 
> > that follow the other one, they will likely break. 
> > 
> > Apart from this, there are BIOSes that openly claim ACPI 2.0 support
> (for 
> > example, the one in my HP nx6325 does that) and they may actually
> prefer the 
> > post-ACPI-1.0 ordering even if they work with the pre-ACPI-2.0 one.
> 
> I doubt they would prefer the later ordering in any way that matters,
> if 
> the Windows version they were designed for uses the earlier ordering.
> 
> It would be best if somebody could manage to find out what ordering 
> Windows XP (and Windows Vista, for good measure) actually use, then
> we 
> could just use that. Virtual machine trickery might be an option -
> the 
> only complication being that it'll be using the DSDT for the fake 
> machine and not the real one..
I modified Qemu and use it to observe how winxp does suspend/resume. So
far, I just get some data for s4 suspend. I did have some interesting
finding.

1. xp seems not save pci config space. Or it appears just save config
PCICMD.
2. the order winxp does looks like
	a. save config (PCICMD), put device to D3 (it appears only for ne2000
NIC)
	b. _PTS
	c. write mem to disk
	d. write ACPI PM1_control register, then system shutdown
3. xp write ACPI GBL_EN bit just after _PTS (for both S4/S5), don't know
why

Attached is the log winxp does s4 suspend, it only includes pci config
read/write and ACPI register read/write.

I managed to make xp enter S3, but fails, so can't get the data for S3
so far. Anybody has other ideas which need to verify winxp, pls let me
know.

Thanks,
Shaohua

--=-vOebPy0ZK62EbU+isXKW
Content-Disposition: attachment; filename=xplog
Content-Type: text/plain; name=xplog; charset=utf-8
Content-Transfer-Encoding: 7bit

PCI NE2000 read addr 4, val 7
PCI NE2000 read addr 50, val 1
PCI NE2000 read addr 52, val c9c2
PCI NE2000 read addr 54, val 8000
PCI NE2000 write addr 54, val 8003
PCI NE2000 read addr 54, val 8003
PCI NE2000 read addr 4, val 7
PCI NE2000 write addr 4, val 0
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PM read addr 0, val 71138086
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PM read addr 64, val 8000000
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PM read addr 0, val 71138086
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PM read addr 64, val 8000000
PCI Cirrus VGA read addr 4, val 7
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PIIX3 IDE read addr 4, val 7
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PM read addr 0, val 71138086
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PM read addr 5c, val 90000000
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PM read addr 0, val 71138086
PCI PIIX3 read addr 0, val 70008086
PCI PIIX3 read addr 4, val 7
PCI PIIX3 read addr 8, val 6010000
PCI PIIX3 read addr c, val 800000
PCI PM read addr 5c, val 90000000
ACPI: DBG: 0x00000002
PM readw port=0x0002 val=0xb002
PM writew port=0x0002 val=0x0020
PM readw port=0x0002 val=0xb002
PM readw port=0x0004 val=0xb004
PM readw port=0x0004 val=0xb004
PM writew port=0x0004 val=0x2801
type 2

--=-vOebPy0ZK62EbU+isXKW--

