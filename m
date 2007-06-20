Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbXFTUAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbXFTUAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbXFTUA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:00:28 -0400
Received: from main.gmane.org ([80.91.229.2]:53847 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054AbXFTUA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:00:27 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Adam Jackson <ajackson@redhat.com>
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
Date: Wed, 20 Jun 2007 19:48:03 +0000 (UTC)
Message-ID: <loom.20070620T212046-804@post.gmane.org>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com>  <20070603205653.GE25869@devserv.devel.redhat.com>  <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>  <1181075666.3978.31.camel@localhost.localdomain>  <Line.LNX.4.64.0706051658170.23379@d.namei>  <20070605211616.GE23291@devserv.devel.redhat.com> <1181111433.3978.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 66.187.230.200 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070417 Fedora/2.0.0.3-4.fc7 Firefox/2.0.0.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis <at> redhat.com> writes:
> On Tue, 2007-06-05 at 17:16 -0400, Alan Cox wrote:
> > On Tue, Jun 05, 2007 at 05:00:51PM -0400, James Morris wrote:
> > > This should be an unsigned long.
> > > 
> > > I wonder if the default should be for this value to be zero (i.e. preserve 
> > > existing behavior).  It could break binaries, albeit potentially insecure 
> > 
> > Agreed - DOSemu type apps and lrmi need to map at zero for vm86
> 
> And so it shall be!

X also needs to be able to map at zero for vm86, which makes this a lot less
useful.  In particular, the interrupt vectors need to point to the right place
within the VBIOS we're calling into, so we have to be able to map the zero page.
(And often write to it, if we're posting a non-primary card.)  Obviously this
isn't so much an issue for non-x86, where you have to use the emulator anyway.
And I'm pretty convinced that calling vm86 in a SMP environment is just suicide
so you _ought_ to use the emulator even on real x86.

We've already got the infrastructure in place to completely fake the real mode
address space for the emulator.  IWBNI we had some way of presenting a set of
virtual-address-space pages as contiguous to the vm86 task, since if we had that
we could just malloc 1M, copy in the bits we need, and go.  I don't know if vm86
mode supports that in silicon; it certainly isn't exposed in the API.  Anyone
know?

Actually it's a little worse than that.  Some chips have an escape hatch where
they remap banks of registers into the 64k VGA aperture, and the BIOS relies on
this.  So some of the pages need to be backed by device mappings, and some by
plain memory.  You'd really need either an array of pointers to userspace pages,
or a trap handler like how vm86 handles I/O cycles.  Again, I don't know offhand
whether vm86 can do this, but if it does then fixing X to take advantage of it
is pretty easy.

- ajax

