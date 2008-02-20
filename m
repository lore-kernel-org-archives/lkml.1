Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbYBTRvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbYBTRvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbYBTRvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:51:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:42320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202AbYBTRvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:51:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="521735342"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 09:50:52 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
In-Reply-To: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200950.53591.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 9:17 am Jeff Chua wrote:
> On Feb 20, 2008 2:19 PM, Jeff Chua
>
> > I'll try the "idle=poll" to see if that works and will try some printk
>
> I don't know what exactly the i915_suspend() and i915_resume() are
> supposed to do because it works better without them.
>
> After inserting "return 0;" right at the top of those two functions,
> suspend (and power-off properly), and resume (without green screen) works
> just fine.
>
> I would like to know what they're for.

They're for saving and restoring GPU state across suspend/resume.  They're 
particularly useful if your machine doesn't re-POST at resume time.  In that 
case your GPU may be totally uninitialized, so either the kernel or X has to 
set it up for you (X only does that partially).

> Tested suspend-to-ram, and suspend-to-disk, both console and X on notebook
> internal LCD display, all works without these two functions.
>
> But, anyway, got down to just one line in i915_drv.c causing the hang
> during suspend. "pci_set_power_state(dev->pdev, PCI_D3hot);".

Interesting, which chipset do you have?  AFAIK that shouldn't cause a hang.

> And green screen problem during resume is caused by i915_restore_vga(dev);

I know I fixed that problem in at least one configuration...  Can you try:
  # echo test > /sys/power/disk
  # echo disk > /sys/power/state
and see if that also turns your screen green?

Also, getting a GPU register dump would be helpful.  The intel_reg_dumper tool 
is built as part of the xf86-video-driver build 
(git://anongit.freedesktop.org/git/xorg/driver/xf86-video-intel), can you 
pull that down and try it out?

Thanks,
Jesse
