Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYIVP0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYIVP0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYIVPZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:25:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:33784 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYIVPZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:25:50 -0400
Date: Tue, 23 Sep 2008 00:25:24 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
	option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080922111730.GF5987@elte.hu>
References: <20080920060059.GA25713@elte.hu>
	<20080920225705C.fujita.tomonori@lab.ntt.co.jp>
	<20080922111730.GF5987@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080923002516R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 13:17:30 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > But, in general, it's pretty pointless to add boot options for 
> > > anything but debugging - nobody will use them unless there's a 
> > > _problem_ with the default. So the right approach is to not add boot 
> > > options and to make sure that the defaults are sane and intelligent.
> > 
> > In general (or ideally), I agreed. But we can't do that in some cases.
> > 
> > And IOMMUs has some options for non general cases. For example, the 
> > option, we are talking about, 'fullflush' for disabling lazy IOTLB 
> > flushing, has no correct setting for everyone. It's kinda policy. The 
> > boot option changes the policy that the IOMMU maintainer set by 
> > default.
> 
> yes. But boot options really have a lot less relevance in practice. In 
> 99.99% of cases they are only used if things go wrong. They are almost 
> never used to tune production systems. (yes, there are exceptions - in 
> 0.01% of the cases)
> 
> so ... i'd really suggest for you to get the bootup defaults right, and 
> then just to give enough boot option flexibility to turn something off 
> that might break in practice.

Well, in general we agreed, I think. We should get the bootup defaults
right but we can't do that in some cases.

Another example about x86 IOMMU is a kernel couldn't even know using
an IOMMU is good for users or not.

In the case of max_pfn < MAX_DMA32_PFN, probably, the majority of
users doesn't want IOMMU since IOMMU leads performance drop. But if an
user plans to use something like kvm, he might want to enable VT-d (or
AMD IOMMU) for something like a passthrough feature.


Well, anyway, we don't need to discuss this issue further.

 
> Otherwise, dont bother - if you want to offer advanced performance 
> tuning then at _minimum_ it should be debugfs or sysctl exposed. It's 
> totally PITA to performance-tune a system via a boot option.

I guess that there are some things that a kernel can set up only
at startup.


> > > So could we work towards removing unnecessary boot options please? _If_ 
> > > we want any strategy switch then that should be runtime anyway - nobody 
> > > sane will reboot a server just to tune it slightly, and no distro will 
> > > litter the boot commandline with hardware dependent tunings either. So 
> > > it's only the default that matters, plus boot parameters for debugging.
> > 
> > Ok, though I still think that deprecating and removing the existing 
> > kernel parameter is bad for users.
> 
> yes - the solution could be as easy as to add back that single option to 
> the affected iommu alone. (i.e. create a compatibility alias in essence)
> 
> > Joerg's patch does two things, adding fullflush and nofullflush to the 
> > generic option. The former needs more discussion though it might be a 
> > correct idea. The latter is clearly wrong (as Joerg agreed).
> > 
> > I sent you the patch to revert his patch. But If you like to fix 
> > things in a different way, then it's fine.
> 
> well, i'd like you two to agree on how to proceed.

I'm not sure we can because he has a quite different opinion on this,
he thinks that the IOMMU parameters are unimportant and minor issue.


> Could you send a 
> patch please that adds back the option that Joerg's patch removed? I 
> certainly dont argue with the point that we should preserve existing 
> options.

Joerg's patch adds two generic IOMMU parameters (he said move two GART
parameters to generic but the result is same).

I'm against adding new generic IOMMU parameters without serious
consideration. Joerg thinks that we can clean up the parameters like
adding some for 2.6.28, then add some for 2.6.X, then rename some, in
an ad-hoc way.

That's exactly we have done in the past. As we saw in another thread
[1], now the IOMMUs parameters are too complicated so that even IOMMU
maintainers can't understand them properly. A simple task like
disabling IOMMUs is too complicated. Especially, adding a generic
IOMMU parameter needs serious consideration since it leads lots of new
combinations with IOMMUs specific parameters.

Unlike the past, we support many IOMMUs now. We should have a better
idea about what we need. I think that we need to discuss and serious
consideration of the last picture of all the IOMMUs parameters we need
BEFORE starting to modify (add, rename, delete) the current IOMMU
parameters. Otherwise, we would have the similar situation as we are
in now.

That's why I asked you to the patch to revert the generic IOMMU
parameters he added.


[1] http://lkml.org/lkml/2008/9/22/154
