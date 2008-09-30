Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYI3Piv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYI3Piv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYI3Pim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:38:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41718 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYI3Pim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:38:42 -0400
Date: Tue, 30 Sep 2008 10:38:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov, morgan@kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] capability: WARN when invalid capability is requested
	rather than BUG/panic
Message-ID: <20080930153820.GA28616@us.ibm.com>
References: <1222782946.28251.63.camel@localhost.localdomain> <alpine.LRH.1.10.0810010008130.2068@tundra.namei.org> <1222785389.28251.83.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222785389.28251.83.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> On Wed, 2008-10-01 at 00:23 +1000, James Morris wrote:
> > On Tue, 30 Sep 2008, Eric Paris wrote:
> > 
> > > This patch adds a WARN_ONCE() to cap_capable() so we will stop
> > > dereferencing random spots of memory and will cleanly tell the obviously
> > > broken driver that it doesn't have that ridiculous permissions.  No idea
> > > if the driver is going to handle EPERM but anything that calls capable
> > > and doesn't expect a denial has got to be the worst piece of code ever
> > > written.....  I could return EINVAL, but I think its clear that noone
> > > has capabilities over 64 so clearly they don't have that permission.
> > > 
> > > This 'could' be considered a regression since 2.6.24.  Neither SELinux
> > > nor the capabilities system had a problem with ginormous request values
> > > until we got 64 bit support, although this is OBVIOUSLY a bug with the
> > > out of tree closed source driver....
> > 
> > An issue here is whether we should be adding workarounds in the mainline 
> > kernel for buggy closed drivers.  Papering over problems rather than 
> > getting them fixed does not seem like a winning approach.  Especially 
> > problems which are unexpectedly messing with kernel security APIs.
> 
> I don't know, looking at the feelings on "Can userspace bugs be kernel
> regressions" leads me to believe that when we break something that once
> worked we are supposed to fix it.
> 
> http://lwn.net/Articles/292143/
> 
> I don't think the proprietary closed source nature of the driver makes
> it any less our problem

The kernel-space nature of the driver is the distinction here.

> to not make changes which cause the kernel to
> esplode.
> 
> > Also, won't this encourage vendors of such drivers to continue with this 
> > behavior, while discouraging those vendors who are doing the right thing?
> 
> Discouraging people who open source their drivers and put them in the
> kernel?  obviously not.  encouraging crap?  well, I hope we fix
> regressions no matter how they are found...
> 
> > Do we know if this even really helps the user?  For all we know, the 
> > driver may simply crash differently with an -EPERM.
> 
> Well, before the 64 bit capabilities change we did:
> 
> (cap_t(c) & CAP_TO_MASK(flag))
> 
> so a huge value for "flag" got masked off.
> 
> After 64 bit capabilities we do:
> 
> ((c).cap[CAP_TO_INDEX(flag)] & CAP_TO_MASK(flag))

Perhaps we should have CAP_TO_INDEX mask itself?

#define CAP_TO_INDEX(x)		(((x) >> 5) & _KERNEL_CAPABILITY_U32S)

Though I still think it's not unreasonable to simply ask for the driver
to be fixed.

> so a huge flag causes an array index out of bounds and either explodes
> here or continues onto SELinux where it BUG().
> 
> So this is regression.  It would have gotten an EPERM, now it gets a
> BUG/panic.
> 
> Yes ATI needs to fix their driver, but we broke it and I don't remember
> the driver not working on 2.6.24 and earlier....
> 
> -Eric
