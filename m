Return-Path: <linux-kernel-owner+w=401wt.eu-S935586AbYEVI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935586AbYEVI6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbYEVI6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:58:04 -0400
Received: from aun.it.uu.se ([130.238.12.36]:36796 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760169AbYEVI6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:58:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18485.13663.51624.694435@harpo.it.uu.se>
Date: Thu, 22 May 2008 10:57:03 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <4834BE39.2000904@zytor.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
	<18477.35703.679574.760417@harpo.it.uu.se>
	<20080518013416.GB30034@linux-os.sc.intel.com>
	<18481.37905.297556.288317@harpo.it.uu.se>
	<20080520015723.GD30034@linux-os.sc.intel.com>
	<4832A173.6020203@firstfloor.org>
	<18482.53246.642835.894623@harpo.it.uu.se>
	<4832E705.2010900@zytor.com>
	<18482.60491.764019.292031@harpo.it.uu.se>
	<20080520175325.GE30034@linux-os.sc.intel.com>
	<4834BE39.2000904@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > Suresh Siddha wrote:
 > >>
 > >> An ugly workaround could be to start clearing one of these fields,
 > >> and say that the data there is only valid for kernels >= 2.6.26.
 > >> (I said it was ugly...)
 > >>
 > >> Or we go back to stashing a flag in uc_flags (which is kosher),
 > >> and try to figure out how to mark non-rt sigframes.
 > > 
 > > This issue of not-zeroing, is present in only 64bit kernels and for 64bit apps,
 > > right?
 > > 
 > > 64bit app signal handling uses only rt_frame, so we can add an uc_flag for
 > > them and for 32bit apps, kernel was always zero'ing the reserved bits
 > > at the end of _fpstate.
 > > 
 > > In short, for non-rt frames, they can check the reserved bits at the end
 > > of fpstate frame and for rt-frames (perhaps even for 32bit rt frame handling)
 > > apps can check for uc_flag aswell, for extended state presence. Is this
 > > good enough?
 > > 
 > 
 > Okay, trying to close on this :)
 > 
 > I would suggest using the uc_flag for the rt frames, and simply rely on 
 > the OSXSAVE flag for non-rt signal frames.  It a rather sucky approach 
 > (as previously discussed), but since any sane user of these fields (as 
 > opposed to just relying on the kernel to save/restore) should use the 
 > SIGINFO frames, I don't see a problem *as long as it's possible to get 
 > the information* -- any solution which demands performance should just 
 > turn on SIGINFO and be happy.

I don't have the luxury to unconditionally change non-rt signal delivery
to rt signal delivery, but using uc_flags plus OSXSAVE or prctl() to
announce these layout changes would work for us. Of course, any existing
sigframe mangling (as opposed to just reading it) code must be updated
to avoid breakage, but that's unavoidable.

 > The biggest potential problem with this that I see is that relying on 
 > CPUID can mess with certain virtualization solutions.  Another option to 
 > accomplish the same thing would be to have a system call (preferrably a 
 > prctl, since it is at least in theory personality-dependent) to query 
 > what information is included in the fpstate data - since it will always 
 > be the same for any particular kernel.
 > 
 > Thoughts?

Ok for me.

/Mikael
