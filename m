Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXA3Xjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXA3Xjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXA3Xjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:39:37 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:46648 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbXA3Xjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:39:36 -0500
Date: Wed, 31 Jan 2007 00:39:35 +0100
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, Pavel Machek <pavel@ucw.cz>,
       andi@lisas.de, davej@codemonkey.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: intel-agp PM experiences (was: 2.6.20-rc5: usb mouse breaks suspend to ram)
Message-ID: <20070130233935.GA31689@rhlx01.hs-esslingen.de>
References: <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070122044519.GA24398@zhen-devel.sh.intel.com> <20070129213053.GA14881@rhlx01.hs-esslingen.de> <20070130123632.GA28177@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130123632.GA28177@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 30, 2007 at 08:36:32PM +0800, Wang Zhenyu wrote:
> ok, just see the AGP tables bits definition for intel_i815_driver,
> /* Intel registers */
> #define INTEL_APSIZE    0xb4
> #define INTEL_ATTBASE   0xb8
> #define INTEL_AGPCTRL   0xb0
> ...
> And this could explain why your patch can make X come back to live on
> i815, as default suspend saves 64bytes. We need suspend func to handle
> this, but for now mainline intel integrated gfx, this's not needed. 
> Would you send out a cleanup patch later?

OK, I just spent an entire evening on this tiresome procedure
of trying, not quite successful, machine killed, rebooting, adapting,
trying, hang, ...

My conclusions:
- never forget about stup@#$@#$% PCI posting! (hours wasted
  due to register values NOT restored after resume...)
- those 3 registers above are not sufficient, since AGP status is
  completely broken, not even such basic things as 4x mode or sideband
  addressing bits get restored, so these need proper care as well.
- backing up about 10 registers properly (all those that have
  different state after resume) makes it work fine without going
  over the whole extended PCI register range needlessly

I'm going to spend more time on this, so...:

Questions (in order of fine-grainedness):
- is intel-agp the right place to reinit such things, or should
  something be changed in a more global way? Would other drivers
  be responsible for that instead? x.org?
- should we have infrastructure available which records AGP state
  in all its nicety in various variables, with chipset-specific
  access functions (AGP mode, memory setup, ...)?
  That way we'd be able to implement one chipset-agnostic
  suspend/resume, which could be a heavenly thing
  considering the amount of different chipsets...
  (IOW, we should perhaps focus on maintaining an abstract device state
   tracking, not blindly push those I/O instructions out to the
   device and forget about actual device state)
- should we just implement a plain'n stupid I/O register array
  for each chipset which denotes the registers that need resume
  maintenance and also records their pre-suspend values? (DUMB)
- or even (shudder) simply always recover the entire PCI I/O space
  no matter which chipset it is?

I really want to get this improved, so any ideas how it should
best be updated to get a nice clean generic suspend/resume functionality
for all chipsets? (at least Intel, or even better for all types)

And it would be very useful to add a generic function for those
repeated agp_bridge->dev->device == PCI_DEVICE_... checks
which takes a PCI ID array input... (inline or real function, doesn't matter).

Thanks!

Andreas Mohr
