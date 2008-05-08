Return-Path: <linux-kernel-owner+w=401wt.eu-S1764198AbYEHQim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764198AbYEHQim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbYEHQic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:38:32 -0400
Received: from mga10.intel.com ([192.55.52.92]:18347 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754015AbYEHQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:38:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,455,1204531200"; 
   d="scan'208";a="325968218"
Date: Thu, 8 May 2008 09:45:04 -0700
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, jbarnes@virtuousgeek.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: intel-iommu: CONFIG_DMAR*=y kills my box
Message-ID: <20080508164504.GA20080@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <48133A64.7020702@googlemail.com> <4813660E.8080609@googlemail.com> <20080429002901.GC31157@linux.intel.com> <481677D3.5070800@googlemail.com> <20080429225348.GA1672@linux.intel.com> <4817A98D.8080007@googlemail.com> <20080506131554.4adb3f9c.akpm@linux-foundation.org> <20080508144301.GA19589@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508144301.GA19589@linux.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 07:43:01AM -0700, mark gross wrote:
> On Tue, May 06, 2008 at 01:15:54PM -0700, Andrew Morton wrote:
> > On Wed, 30 Apr 2008 01:04:45 +0200
> > Gabriel C <nix.or.die@googlemail.com> wrote:
> > >
> > 
> > > > I think your bios is goofy / unprepared to support IOMMU / VT-d and
> > > > doing strange things with enumerated a parallel port on a PCIE bus with
> > > > VTD is turned on...
> > > 
> > > I will contact ASUS peoples about the BIOS but it has for sure VT-d support and it is enabled.
> > 
> > So..  what happened here?  It seems like a pretty fatal problem, and
> > personally I don't think that contacting vendors about BIOS upgrades is a
> > suitable general solution.  It would be much better to find a kernel-based
> > fix or workaround?
> >
> 
> I just got some expert advice on this issue.  I will try again and look
> for a problem with the iommu code getting executed before the USB / PCI
> bus is fully initialized.
> 
> also, I just realized that I was attempting to reproduce the failure on
> the MM tree, and re-reading the report I see its on the linux-next tree.
> 
> I'm retesting it this am.
>

linux-next works fine on my system :(  with intel-iommu on.

root@mtgsdv1:~# lspci
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express Integrated Graphics Controller (rev 02)
00:03.0 Communication controller: Intel Corporation 82G33/G31/P35/P31 Express MEI Controller (rev 02)
00:03.2 IDE interface: Intel Corporation 82G33/G31/P35/P31 Express PT IDER Controller (rev 02)
00:03.3 Serial controller: Intel Corporation 82G33/G31/P35/P31 Express Serial KT Controller (rev 02)
00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network Connection (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) 00:1f.0 ISA bridge: Intel Corporation Unknown device 2910 (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port SATA IDE Controller (rev 02)

Gabriel,

The idea that perhaps something changed in the boot order, resulting in
the DMAR initialization code getting executed before all of the PCI
stuff is set up makes sense, but I don't have a good way of testing it
at the moment. I'm going to try a few more config options (like building
everything as modules instead of mostly built-ins)

--mgross


