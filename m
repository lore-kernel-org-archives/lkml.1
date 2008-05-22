Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbYEVU4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbYEVU4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbYEVU4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:56:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:60788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837AbYEVU4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:56:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,526,1204531200"; 
   d="scan'208";a="567665952"
Date: Thu, 22 May 2008 13:56:19 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       roland@redhat.com, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080522205619.GB7998@linux-os.sc.intel.com>
References: <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <20080520015723.GD30034@linux-os.sc.intel.com> <4832A173.6020203@firstfloor.org> <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18485.13663.51624.694435@harpo.it.uu.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 10:57:03AM +0200, Mikael Pettersson wrote:
> H. Peter Anvin writes:
>  > Suresh Siddha wrote:
>  > > In short, for non-rt frames, they can check the reserved bits at the end
>  > > of fpstate frame and for rt-frames (perhaps even for 32bit rt frame handling)
>  > > apps can check for uc_flag aswell, for extended state presence. Is this
>  > > good enough?
>  > > 
>  > 
>  > Okay, trying to close on this :)
>  > 
>  > I would suggest using the uc_flag for the rt frames, and simply rely on 
>  > the OSXSAVE flag for non-rt signal frames.  It a rather sucky approach 
>  > (as previously discussed), but since any sane user of these fields (as 
>  > opposed to just relying on the kernel to save/restore) should use the 
>  > SIGINFO frames, I don't see a problem *as long as it's possible to get 
>  > the information* -- any solution which demands performance should just 
>  > turn on SIGINFO and be happy.
> 
> I don't have the luxury to unconditionally change non-rt signal delivery
> to rt signal delivery, but using uc_flags plus OSXSAVE or prctl() to
> announce these layout changes would work for us. Of course, any existing
> sigframe mangling (as opposed to just reading it) code must be updated
> to avoid breakage, but that's unavoidable.
> 
>  > The biggest potential problem with this that I see is that relying on 
>  > CPUID can mess with certain virtualization solutions.  Another option to 

hpa, What is the virtualization problem? Are you referring to perf problem?
As you noted, regular non-rt signal handlers won't need this cpuid check. It's
needed only for those who manually look at non-rt signal frames and interpret it.
And also, they can do this check only once and not everytime.

To me, prtcl() just seems to be an overkill.

While restoring from the user, kernel also need to find out what layout
the user is passing. So it's bi-directional. I prefer the same mechanism
(using cookies/magic numbers etc inaddition to uc_flags or cpuid checks) to
interpret the fpstate for both user/kernel.

ARM also seem to be using similar things while extending their ucontext_t,
with out other kernel interfaces to indicate the layout.

BTW, how come 32bit kernel doesn't have the X86_FXSR_MAGIC checks, while restoring
the extended fxsave data from _fpstate?

thanks,
suresh

>  > accomplish the same thing would be to have a system call (preferrably a 
>  > prctl, since it is at least in theory personality-dependent) to query 
>  > what information is included in the fpstate data - since it will always 
>  > be the same for any particular kernel.
>  > 
>  > Thoughts?
> 
> Ok for me.
> 
> /Mikael
