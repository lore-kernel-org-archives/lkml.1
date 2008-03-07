Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbYCGSPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbYCGSPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbYCGSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:15:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40911 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbYCGSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:15:07 -0500
Date: Fri, 7 Mar 2008 10:14:31 -0800
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080307181431.GA4915@kroah.com>
References: <47CED717.60406@openvz.org> <47CEDA64.1070506@openvz.org> <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com> <20080307173542.GA2552@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307173542.GA2552@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 11:35:42AM -0600, Serge E. Hallyn wrote:
> > Do you really want to run other LSMs within a containerd kernel?  Is
> > that a requirement?  It would seem to run counter to the main goal of
> > containers to me.
> 
> Until user namespaces are complete, selinux seems the only good solution
> to offer isolation.

Great, use that instead :)

> > > 2. Turning CONFIG_SECURITY on immediately causes all the other hooks
> > >    to get called. This affects performance on critical paths, like
> > >    process creation/destruction, network flow and so on. This impact
> > >    is small, but noticeable;
> > 
> > The last time this was brought up, it was not noticable, except for some
> > network paths.  And even then, the number was lost in the noise from
> > what I saw.  I think with a containered machine, you have bigger things
> > to be worried about :)
> > 
> > > 3. With LSM turned on we'll have to "virtualize" it, i.e. make its
> > >    work safe in a container. I don't presume to judge how much work
> > >    will have to be done in this area, so the result patch would be
> > >    even larger and maybe will duplicate functionality, which is currently
> > >    in cgroups. OTOH, cgroups already provide the ways to correctly 
> > >    delegate proper rights to containers.
> > 
> > No, your lsm would be your "virtualize" policy.  I don't think you would
> > have to do any additional work here, but could be wrong.  Would like to
> > see the code to prove it.
> > 
> > > > Opening a dev node is not on any "fast path" that you need to be
> > > > concerned about a few extra calls within the kernel.
> > > > 
> > > > And, I think in the end your patch would be much smaller and easier to
> > > > understand and review and maintain overall.
> > > 
> > > Hardly - the largest part of my patch is cgroup manipulations. The part
> > > that makes the char and block layers switch to new map ac check the 
> > > permissions is 10-20 lines of new code.
> > > 
> > > But with LSM I will still need this API.
> > 
> > Yes, but your LSM hooks will be smaller than the code modifications to
> > the map logic :)
> > 
> > Again, I object to this as you are driving a new security policy
> > infrastructure into the device node logic where it does not belong as we
> > already have this functionality in the LSM interface today.  Please use
> > that one instead and don't clutter up the kernel with "one-off" security
> > changes like this one.
> > 
> > Please try the LSM interface and see what happens.  If, after you have
> 
> https://lists.linux-foundation.org/pipermail/containers/2007-November/008589.html
> 
> This was just a proof of concept for discussion.

I don't see the LSM patch in that posting, only a Makefile change that
adds it to the build.

> Our conclusion (including my own) was that it would be nicer to have the
> controls not be shoed in using lsm but rather at the level Pavel was
> doing.

Why?  What is the difference?  I don't see that discussion anywhere in
that post.

Why add add-hock security stuff to the kernel all over the place and not
use the LSM interface that we already have?  If LSM doesn't provide the
exact right hooks needed, we can always change it (and no, we should not
be adding kobj_maps hooks to LSM).

thanks,

greg k-h
