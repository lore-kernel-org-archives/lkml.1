Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYBTWp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYBTWp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYBTWpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:45:11 -0500
Received: from crca.org.au ([67.207.131.56]:57715 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYBTWpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:45:09 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <47BCAD6E.9080704@nigel.suspend2.net>
Date: Thu, 21 Feb 2008 09:45:02 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com>
In-Reply-To: <200802201344.11643.jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Jesse Barnes wrote:
> Well, it seems like we'll have to fix drivers in either case, and isn't a 
> kexec approach fundamentally more sound and simple, design-wise?  Rafael 
> pointed out some problems with properly setting wakeup states, but I think 
> that could be overcome...

No. AFAICS, kexec is going to be more complex and ugly in many ways.

To summarise, a kexec based hibernation is going to need the following 
additional requirements to just replace what we already have:

- get the original kernel to allocate storage while racing against the 
rest of the system (currently allocation is done post-atomic copy & 
post-freezing - no racing). This makes it potentially slower, too;
- get the original kernel to transfer the information about what swap 
was allocated to the kexec'd kernel, probably together with a lot of 
other information (which pages are nosave etc).
- get the original kernel to keep memory free for the kexec'd kernel 
which would otherwise be usable. Not a biggy on desktops or laptops, but 
think about embedded.
- people keep talking about hibernating to an ext3 fs mounted on fuse as 
a limitation of the freezer. To do that with kexec, you're still going 
to have to bmap the ext3 fs and pass the block list (in which case we 
can also do it without kexec) or umount all the ext3/fuse part and 
remount in the kexec'd kernel. Sort of defeats the purpose, doesn't it?

I also wonder about how much of a pain it's going to be setting up 
userspace for this kexec'd kernel. Will you need a separate partition 
just for it? If not, will the userspace be loaded into memory all the 
time (more memory wasted for normal use), or loaded from ordinary 
partitions at kexec time (how to do safely? - more info to transfer 
between kernels?).

I'd love it if kexec really was the panacea to the freezer issues, but 
problems like these make me think it isn't a viable solution.

Nigel
