Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbXIVA11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbXIVA11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 20:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXIVA1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 20:27:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:25719 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXIVA1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 20:27:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,285,1186383600"; 
   d="scan'208";a="317320299"
Date: Fri, 21 Sep 2007 17:27:17 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Howard Chu <hyc@symas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
Message-ID: <20070922002717.GA16353@linux-os.sc.intel.com>
References: <46EAB7DA.10507@symas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EAB7DA.10507@symas.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 09:33:30AM -0700, Howard Chu wrote:
> Hi, was wondering if anyone else has been tripped up by this... I've got
> 4GB of
> RAM in my Asus A8V Deluxe and memory hole mapping enabled in the BIOS. By
> default, my system boots up with these MTRR settings:
> 
> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> reg03: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1
> 
> The X server and various other programs try to add a mapping for my video
> card's buffer, at 0xd0000000, size=256MB, type=write-combining, and this
> always
> fails with a type mismatch error (old type is write-back). Apparently it's
> conflicting with mapping register 0. I can't just disable the existing
> settings
> and re-add them; the system hangs soon after disabling reg01.
> 
> I guess the kernel must be getting the initial setup from the BIOS. I've
> hacked
> around this in mtrr/generic.c by explicitly changing the MTRR state in
> get_mtrr_state to split the first mapping into two; one at base 0 size
> 2048M
> and one at base 2048M size 1024M. So now I have this, which is pretty much
> what
> I wanted:
> 
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg03: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> reg04: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1
> reg05: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1

BTW, having overlapping WC, UC regions make the end result UC. So in this
case, you may not be getting the desired performance.

> 
> So the question is - was there an easier/correct way to do this?
> 
> It might have been nice if the MTRR ioctls allowed the register number to
> be
> specified on the Set commands, though I'm not sure that would have helped
> in
> this case.
