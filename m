Return-Path: <linux-kernel-owner+w=401wt.eu-S965304AbXA3Mhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965304AbXA3Mhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965305AbXA3Mhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:37:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:25547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965304AbXA3Mhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:37:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,257,1167638400"; 
   d="scan'208"; a="193636130:sNHT19925017"
Date: Tue, 30 Jan 2007 20:36:32 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: Pavel Machek <pavel@ucw.cz>, andi@lisas.de, davej@codemonkey.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: intel-agp PM experiences (was: 2.6.20-rc5: usb mouse breaks suspend to ram)
Message-ID: <20070130123632.GA28177@zhen-devel.sh.intel.com>
Mail-Followup-To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>,
	Pavel Machek <pavel@ucw.cz>, andi@lisas.de, davej@codemonkey.org.uk,
	kernel list <linux-kernel@vger.kernel.org>
References: <20070116135727.GA2831@elf.ucw.cz> <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070122044519.GA24398@zhen-devel.sh.intel.com> <20070129213053.GA14881@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129213053.GA14881@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.01.29 22:30:53 +0000, Andreas Mohr wrote:
> > I've post a patch which trys to resolve pci config restore issue, see
> > http://lkml.org/lkml/2007/1/16/297. It resolves s3 issue with my 965G machine,
> > that my X can come back to live after s3, but I wasn't aware of the issues Andreas
> > has noted. It'll be good if more people could try this out. 
> 
> [sorry, somewhat late, had complete and utter heating failure at home]
> 
> I employed a variant of your patch (added a static i815_dev
> to support my i815 chipset). It didn't help, X hung on resume.
> PCI IDs of i815 are 0x1130, 0x1131, 0x1132.
> I'm having 0x1130 and 0x1131, IOW an i815 system in
> "external AGP graphics" mode:
> 00:00.0 Host bridge: Intel Corporation 82815 815 Chipset Host Bridge and Memory Controller Hub (rev 02)
> 00:01.0 PCI bridge: Intel Corporation 82815 815 Chipset AGP Bridge (rev 02)
> 
> so I need to query 0x1131 instead of PCI_DEVICE_ID_INTEL_82815_CGC
> (0x1132) for resume of the proper device, right??
> Or am I supposed to restore the PCI space of my *non-builtin*
> 01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility M4 AGP
> card instead?

Sorry I don't have 815G board nowadays, this board seems has two
pci devs, one for AGP bridge, another for integrated gfx card if no add-in card.
So have you tried both cases? 

> 
> The diff below (against 2.6.19-ck2 or in fact plain 2.6.19)
> shows what I changed from my (working!) version to what I think I
> had to do to be compatible with your intentions. OK, not quite,
> I now merely disabled the suspend/restore of the full PCI space,
> several other parts remained the same.
> 
> IOW, suspending/restoring the *full* PCI space of my Host Bridge
> helped, whereas restoring the standard PCI space of my Host Bridge
> plus restoring the PCI space of the AGP bridge as you suggested
> did NOT.
> 
> Can we conclude from that that I'm having rather different issues
> than you?
> 
> I think this means that we are required/supposed to backup
> the entire PCI space of host bridges, right? How to actually implement
> this cleanly? Oh, and of course my patch manages to fix the X11
> lockup only, actual video is still garbled and requires
> vbetool magic to get it fixed, too...

ok, just see the AGP tables bits definition for intel_i815_driver,
/* Intel registers */
#define INTEL_APSIZE    0xb4
#define INTEL_ATTBASE   0xb8
#define INTEL_AGPCTRL   0xb0
...
And this could explain why your patch can make X come back to live on
i815, as default suspend saves 64bytes. We need suspend func to handle
this, but for now mainline intel integrated gfx, this's not needed. 
Would you send out a cleanup patch later?

Thanks.
-zhen
