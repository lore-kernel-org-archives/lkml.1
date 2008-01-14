Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYANDa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYANDa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYANDaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:30:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYANDaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:30:12 -0500
Message-ID: <478AD713.8060204@redhat.com>
Date: Sun, 13 Jan 2008 22:29:23 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>	<20080111204228.GP18741@parisc-linux.org>	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>	<20080111211753.GR18741@parisc-linux.org>	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>	<20080111213803.GS18741@parisc-linux.org>	<20080111235856.GA16079@jurassic.park.msu.ru>	<20080112002638.GA18710@kroah.com>	<20080112144030.GA19279@jurassic.park.msu.ru>	<20080112094557.71f5382a@laptopd505.fenrus.org>	<20080112214911.GA20102@jurassic.park.msu.ru>	<20080112150120.05f93768@laptopd505.fenrus.org>	<47895767.3090503@redhat.com>	<20080112164006.6f6f7bc2@laptopd505.fenrus.org>	<47896B3B.2000108@redhat.com>	<20080112204248.29abb1dd@laptopd505.fenrus.org>	<478A075F.7010503@redhat.com>	<20080113090311.0a9a1db5@laptopd505.fenrus.org>	<478A8268.6020107@redhat.com>	<20080114005434.48340f84@lxorguk.ukuu.org.uk> <20080113173331.617ac935@laptopd505.fenrus.org>
In-Reply-To: <20080113173331.617ac935@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To all ...

Well, here is what I perceive we've got so far.

. Some PCI Northbridges do not work with MMCONFIG.

. Some PCI BARs can overlap the MMCONFIG area during bus sizing.
   It is hoped that new BIOSes will locate MMCONFIG in an area
   safely out of the way of bus sizing code, but there can be
   no guarantees.

. conf1 is going away in newer x86 implementations in the not
   too distant future.

. The PCI express spec requires platforms to provide access to
   the extended config area, and there are express devices today
   using that area for AER.

. There is no need to provide different PCI config access
   mechanisms at device granularity, since the PCI config access
   mechanism between the CPU and the Northbridge is opaque to
   the devices. PCI config mechanisms only need to differ at
   the Northbridge level.

. We have a flurry of patches all claiming to solve all or some
   of these problems.


Arjan,

I realize it may not be possible for you to answer this question,
but I feel compelled to ask it anyway. Is it possible that future
x86 architectures will be implementing a SAL-like interface to
abstract PCI config access altogether?

Or can we condense these patches down to a set that does the
following?

. If the system is capable of conf1, then PCI config access
   at offsets < 256 should be confined to conf1. This solution
   is most effective for existing and legacy systems.

. If the system does not support MMCONFIG, of if MMCONFIG is
   not working, then accesses to offsets > 256 return -1 and an
   error status.

. For systems, where the conf1 mechanism is NOT available,
   then MMCONFIG should be the PCI access mechanism for all
   offsets. For such systems, we must assume that the BIOS has
   become smart enough to locate MMCONFIG in a region safe from
   encroachment by bus sizing code.



