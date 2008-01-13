Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYAMBhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYAMBhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 20:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYAMBhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 20:37:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYAMBhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 20:37:41 -0500
Message-ID: <47896B3B.2000108@redhat.com>
Date: Sat, 12 Jan 2008 20:36:59 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
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
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>	<20080111204228.GP18741@parisc-linux.org>	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>	<20080111211753.GR18741@parisc-linux.org>	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>	<20080111213803.GS18741@parisc-linux.org>	<20080111235856.GA16079@jurassic.park.msu.ru>	<20080112002638.GA18710@kroah.com>	<20080112144030.GA19279@jurassic.park.msu.ru>	<20080112094557.71f5382a@laptopd505.fenrus.org>	<20080112214911.GA20102@jurassic.park.msu.ru>	<20080112150120.05f93768@laptopd505.fenrus.org>	<47895767.3090503@redhat.com> <20080112164006.6f6f7bc2@laptopd505.fenrus.org>
In-Reply-To: <20080112164006.6f6f7bc2@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Arjan.

The problem we have been experiencing has to do with Northbridges,
not with devices.

As far as the device is concerned, after the Northbridge translates
the config access into PCI bus cycles, the device has no idea what
mechanism drove the Northbridge to the translation.

That is to say, the device does not know whether the config cycle
on the bus was caused by an MMCONFIG cycle or a legacy Port IO
cycle delivered to the Northbridge.

In systems that had Northbridges that did not respond correctly to
MMCONFIG cycles, like the AMD 8132, we (HP & RH) were blacklisting
whole platforms to limit them to Port IO PCI config.

However, when platforms emerged using both legacy PCI and PCI express,
the platforms that were limited to Port IO config cycles were not
express compliant, since the express spec requires the platform to
be able to address the full 4096 byte region of config space to
be considered express-compliant.

The patch I devised concerned itself with Northbridges and separated
MMCONFIG-compliant buses from those that could not handle MMCONFIG.

Therefore, the express bus in the platform could happily employ
MMCONFIG to access the entire 4K region, while the legacy bus
with the non-compliant Northbridge could be restricted to Port IO
config.

However, even with my patch, the problem remained where devices
requiring large displacements could overlap the BIOS-mapped
MMCONFIG region. In such a situation, where the bus has passed
the MMCONFIG test, the MMCONFIG region can get doubly mapped by
bus-sizing code, causing the system to hang.

The remedy proposed by Loic and implemented by Ivan is actually
quite elegant, in that it addresses all these problems quite
effectively while eliminating a ration of specialized and somewhat
obscure code.

In my humble opinion, Port IO config access is here to stay, having
been defined as an architected mechanism in the PCI 2.1 spec.

This is most especially true for x86.

In other words, for x86, I don't think we need to worry about Port
IO config access ever going away at all.
