Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbYCGRfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbYCGRfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 12:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbYCGRfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 12:35:44 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58739 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250AbYCGRfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 12:35:43 -0500
Date: Fri, 7 Mar 2008 11:35:42 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com, serue@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080307173542.GA2552@sergelap.austin.ibm.com>
References: <47CED717.60406@openvz.org> <47CEDA64.1070506@openvz.org> <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307170104.GA24746@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Fri, Mar 07, 2008 at 07:38:51PM +0300, Pavel Emelyanov wrote:
> > Greg KH wrote:
> > > On Fri, Mar 07, 2008 at 12:52:40PM +0300, Pavel Emelyanov wrote:
> > >> Andrew Morton wrote:
> > >>> On Fri, 07 Mar 2008 12:22:01 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> > >>>
> > >>>>> This doesn't include sufficient headers to be compileable.
> > >>>>>
> > >>>>> I'm sure there are lots of headers like this.  But we regularly need
> > >>>>> to fix them.
> > >>>>>
> > >>>> Not sure, whether this is still relevant after Greg's comments, but that's
> > >>>> the -fix patch for this one. (It will cause a conflict with the 9th patch.)
> > >>> Well.  Where do we stand with this?  afaict the state of play is:
> > >>>
> > >>> Greg: do it in udev
> > >>> Pavel: but people want to run old distros in containers
> > >> Actually no.
> > >>
> > >> Greg: Use LSM for this
> > > 
> > > Yes, that is my recommendation.
> > > 
> > >> Pavel: My approach just makes maps per-group, while LSM will
> > >>        bring a new level of filtering/lookup on device open path
> > > 
> > > Huh?  You are still doing that same "filtering/lookup" by modifying the
> > > maps code.  The result should be exactly the same.
> > 
> > No - this lookup was there before to get struct kobject from the dev_t, 
> > I just make it look up in another map.
> > 
> > > Why do you not want to use the LSM interface?  That is exactly what it
> > > is there for, don't go creating new hooks into the kernel for the exact
> > > same functionality.
> > 
> > _No_new_hooks_ - just the map is get from task, not from a static variable.
> 
> The new "hook" is that we now have ways of setting different maps, and
> you added a whole infrastructure to set these permissions from
> userspace, as well as track them within the kernel.  That's a security
> policy that you are putting into place within the kernel, just like LSM
> is supposed to be used for.
> 
> > I have basically three objections against LSM.
> > 
> > 1. LSM is not stackable, so loading this tiny module with devices
> >    access rights will block other security modules;
> 
> Do you really want to run other LSMs within a containerd kernel?  Is
> that a requirement?  It would seem to run counter to the main goal of
> containers to me.

Until user namespaces are complete, selinux seems the only good solution
to offer isolation.

> > 2. Turning CONFIG_SECURITY on immediately causes all the other hooks
> >    to get called. This affects performance on critical paths, like
> >    process creation/destruction, network flow and so on. This impact
> >    is small, but noticeable;
> 
> The last time this was brought up, it was not noticable, except for some
> network paths.  And even then, the number was lost in the noise from
> what I saw.  I think with a containered machine, you have bigger things
> to be worried about :)
> 
> > 3. With LSM turned on we'll have to "virtualize" it, i.e. make its
> >    work safe in a container. I don't presume to judge how much work
> >    will have to be done in this area, so the result patch would be
> >    even larger and maybe will duplicate functionality, which is currently
> >    in cgroups. OTOH, cgroups already provide the ways to correctly 
> >    delegate proper rights to containers.
> 
> No, your lsm would be your "virtualize" policy.  I don't think you would
> have to do any additional work here, but could be wrong.  Would like to
> see the code to prove it.
> 
> > > Opening a dev node is not on any "fast path" that you need to be
> > > concerned about a few extra calls within the kernel.
> > > 
> > > And, I think in the end your patch would be much smaller and easier to
> > > understand and review and maintain overall.
> > 
> > Hardly - the largest part of my patch is cgroup manipulations. The part
> > that makes the char and block layers switch to new map ac check the 
> > permissions is 10-20 lines of new code.
> > 
> > But with LSM I will still need this API.
> 
> Yes, but your LSM hooks will be smaller than the code modifications to
> the map logic :)
> 
> Again, I object to this as you are driving a new security policy
> infrastructure into the device node logic where it does not belong as we
> already have this functionality in the LSM interface today.  Please use
> that one instead and don't clutter up the kernel with "one-off" security
> changes like this one.
> 
> Please try the LSM interface and see what happens.  If, after you have

https://lists.linux-foundation.org/pipermail/containers/2007-November/008589.html

This was just a proof of concept for discussion.

Our conclusion (including my own) was that it would be nicer to have the
controls not be shoed in using lsm but rather at the level Pavel was
doing.

> created a patch, you still have objections, please post it for review
> and I will be glad to revisit my opinion at that time.
> 
> thanks,
> 
> greg k-h
