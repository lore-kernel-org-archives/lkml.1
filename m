Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXLEBp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXLEBp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 20:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLEBpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 20:45:17 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56144 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXLEBpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 20:45:15 -0500
Date: Tue, 4 Dec 2007 17:45:06 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <gregkh@suse.de>,
       jbeulich@novell.com
Subject: Re: [PATCH] pci: Omit error message for benign allocation failure
Message-ID: <20071205014506.GA6034@us.ibm.com>
References: <4755AC14.20605@ce.jp.nec.com> <20071204214907.GB9194@us.ibm.com> <4755E174.7040106@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4755E174.7040106@ce.jp.nec.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 06:23:32PM -0500, Jun'ichi Nomura wrote:
> Hi Gary,
> 
> Gary Hade wrote:
> > On Tue, Dec 04, 2007 at 02:35:48PM -0500, Jun'ichi Nomura wrote:
> >> On a system with PCI-to-PCI bridges, following errors are observed:
> >>
> >> PCI: Failed to allocate mem resource #8:100000@d8200000 for 0000:02:00.0
> >> PCI: Failed to allocate mem resource #6:10000@0 for 0000:03:01.0
> >>
> >> '#6' is for expansion ROM and '#8' for the bridge where the device
> >> with the expansion ROM is connected.
> > 
> > I believe there is a good chance that may be another instance
> > of the regression caused by my "Avoid creating P2P prefetch
> > window for expansion ROMs" patch that was recently reported by
> > Jan Beulich.
> >   http://marc.info/?l=linux-kernel&m=119555581103023&w=2
> 
> Sorry, I was not clear about that.
> I've seen the above errors even with 2.6.22 and RHEL5, which is
> based on 2.6.18.
> So it's not a regression.

Thats a relief.  Jan's report was embarrassing enough. :)

> 
> > I am working on a better fix for the problem that the patch
> > was attempting to address but this is turning out to be much
> > more difficult than I expected.  If I don't have a solution
> > very soon I plan to publish a revert patch.
> > 
> >> But I think the failure is benign because the allocation is
> >> not necessary for these resources.
> > 
> > This is an interesting idea.  Could you elaborate?  As far
> > as I can tell, the kernel always tries to allocate memory
> > for expansion ROMs which it also exports to user level.
> 
> Kernel always tries to. But it's best effort basis, IMO.
> (Maybe your patch is going to fix that?)

If you are seeing the allocation failures both with and
without my original patch I doubt that an improved version
would work.  In my case, the BIOS had allowed sufficient
resource for the expansion ROMs but was expecting the kernel
to get it from the non-prefetch instead of prefetch window.
In your case, it sounds like there just isn't enough resource
available for expansion ROMs from either window.

> In the 1st stage (pcibios_allocate_resources, etc.),
> it allocates resources based on PCI configuration provided by BIOS,
> except for expansion ROMs.
> In the 2nd stage (pci_assign_unassigned_resources, etc.),
> it allocates resources for unallocated ones including expansion ROMs.
> The 2nd stage doesn't reprogram the bridge settings.
> So if the expansion ROM is under the bridge where other resource
> is already allocated, the allocation failure occurs.
> There are comments in drivers/pci/setup-bus.c:
>   /* Helper function for sizing routines: find first available
>      bus resource of a given type. Note: we intentionally skip
>      the bus resources which have already been assigned (that is,
>      have non-NULL parent resource). */
> 
> Fixing the above might be a better solution.

Like I said above, I doubt that an improved version of my fix
would help your situation.

> But I don't know if there are any users who need it.
> 
> > I have assumed that some drivers or user level apps may
> > need to access this space.  Is this not true?
> 
> I haven't heard of applications which depend on the kernel resource
> allocation for expansion ROMs.
> X is a big user of expansion ROMs but I heard it solves the resource
> conflict itself.
> If there is a counter example, I would like to know it.

Me too. 

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

