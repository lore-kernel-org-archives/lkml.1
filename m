Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYBLFic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYBLFic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYBLFiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:38:24 -0500
Received: from verein.lst.de ([213.95.11.210]:53468 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbYBLFiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:38:22 -0500
Date: Tue, 12 Feb 2008 06:37:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Christoph Hellwig <hch@lst.de>, dsdt@gaugusch.at, len.brown@intel.com,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       trenn@suse.de
Subject: Re: acpi dsts loading and populate_rootfs
Message-ID: <20080212053730.GA15347@lst.de>
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de> <47AEE6D1.4070402@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AEE6D1.4070402@tremplin-utc.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[skipping the populate_rootfs discussion as it seems you have a better
 handle on that than me]

On Sun, Feb 10, 2008 at 12:58:09PM +0100, Eric Piel wrote:
> >And while we're at it the file reading thing in there is utter crap
> >aswell.  You really should be using the firmware loader which works
> >perfectly fine if you initramfs is set up for it.  So please folks,
> >back to the drawing board, do it properly and send it out to lkml
> >for review please.
> Christoph, if you have seen this part of the code, you have probably 
> also read the big fat warning explaining why this cannot be done by 
> firmware loader (ie: userspace cannot be run at this early time, 
> corresponding to acpi_early_init()). However, you probably know the 
> kernel ten times better than me. Could you explain what I misunderstood 
> when writing this warning, and give me some hints about how to use the 
> firmware loader in this case?

Sorry, I misparsed the comment.  I took it for the usual I'm too lazy
to put something that could load firmware into initramfs excuse.

But thinking about it is there a reason acpi initialization needs to
happen so early that we can't even have userspace in initramfs running?

But if we can't use real userspace this could should at least be written
like the pseudo-userspace in init/do_mounts*.c, using the sys_ syscall
implementations.

As an additional comment the stat + open approach is racy and not a good
idea.  Please just open the file using sys_open, it will tell you
if the file doesn't exist and then use fstat on it to find the
length.  It would also be useful if this kind of code is not hidden
inside acpi but rather done somewhere close to the early init code
because that's where people would expect this kind of nastiness._
syscall
implementations.

As an additional comment the stat + open approach is racy and not a good
idea.  Please just open the file using sys_open, it will tell you
if the file doesn't exist and then use fstat on it to find the
length.  It would also be useful if this kind of code is not hidden
inside acpi but rather done somewhere close to the early init code
because that's where people would expect this kind of nastiness.
