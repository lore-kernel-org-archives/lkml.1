Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYGXXC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYGXXC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYGXXCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:02:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:21071 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYGXXCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:02:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,248,1215414000"; 
   d="scan'208";a="421809296"
Date: Thu, 24 Jul 2008 16:02:43 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
Message-ID: <20080724230242.GO14380@linux-os.sc.intel.com>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org> <20080724202728.GL14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org> <20080724212351.GM14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241431180.8109@nehalem.linux-foundation.org> <20080724222523.GN14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 03:43:44PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 24 Jul 2008, Suresh Siddha wrote:
> > >
> > > but the thing is, the only really valid reason for "restore_i387()" to
> > > fail is because the read failed.
> >
> > Not really. It can cause #GP, if someone sets reserved bits of mxcsr
> > in the memory image.
> 
> Ahh, ok, I can imagine that. And I guess we might copy the data from user
> space into the memory image without validating it at points (signal
> handler restore and/or ptrace). Do we?

Today in ptrace (and in 32bit signal handling), we copy the user data and
then clear the reserved bits blindly again ;)

In 64bit signal handling, we do a fxrstor from the live user buffer and
scream then itself if we find an issue.

Andi being paranoid, added more checks for 64bit math_state_restore().

> > But restore_i387() may be in an insane state (we did clts() but doesn't
> > have the proper state in its live registers etc) when it failed to restore fpu.
> > Ideally we should fix this inside restore_i387(). But restore_i387()
> > is in header file and I have to re-arrange some of the code
> > in the header file, to call clear_fpu() from restore_i387().
> 
> Ok, how about we just move restore_i387() out of the header file? I
> realize that the x86 code plays some games with this whole thing (that
> whole '#define restore_i387_ia32 restore_i387'), but that is 32-bit
> specific, and the restore_i387() in the header file is 64-bit specific.
> 
> Hmm. In fact, I think that x86-64 version is actually only used in a
> single place - arch/x86/kernel/signal_64.c. So it's actively *wrong* to
> have that thing in a header file to begin with!
> 
> So how about this patch as a starting point? This is the RightThing(tm) to
> do regardless, and if it then makes it easier to do some other cleanups,
> we should do it first. What do you think?

Sure. You have my Ack. I will request -stable folks to pickup multiple patches
(second patch, I will post shortly on top of yours).

thanks,
suresh
