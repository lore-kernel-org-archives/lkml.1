Return-Path: <linux-kernel-owner+w=401wt.eu-S1764266AbYETNWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764266AbYETNWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYETNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:21:55 -0400
Received: from aun.it.uu.se ([130.238.12.36]:64821 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbYETNVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:21:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18482.53246.642835.894623@harpo.it.uu.se>
Date: Tue, 20 May 2008 15:19:58 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Andi Kleen <andi@firstfloor.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <4832A173.6020203@firstfloor.org>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
	<18477.35703.679574.760417@harpo.it.uu.se>
	<20080518013416.GB30034@linux-os.sc.intel.com>
	<18481.37905.297556.288317@harpo.it.uu.se>
	<20080520015723.GD30034@linux-os.sc.intel.com>
	<4832A173.6020203@firstfloor.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen writes:
 > Suresh Siddha wrote:
 > > On Mon, May 19, 2008 at 04:52:01PM +0200, Mikael Pettersson wrote:
 > >>> But we can
 > >>> use some what similar magic, if the fxsave/fxrstor give away
 > >>> some of the fields at the end of fxsave image (today it is reserved
 > >>> and ignored during fxsave/fxrstor) for software use.
 > >>> We can then use these fields at the end of fpstate, to indicate the presence of
 > >>> xstate. But this requires some architecture changes like giving
 > >>> away this space for SW use. We can take this to architects and
 > >>> see what they think.
 > >> If the HW doesn't store anything valuable there, we could store
 > >> SW flags/cookies there on signal delivery, and clear them before
 > >> fxrstor (unless the HW is known to ignore those fields).
 > >> But it depends on how forgiving the HW is.
 > > 
 > > Ok. CPU folks are planning to make some of the bytes at the end of fxsave
 > > image, SW usable.
 > 
 > Are they always zeroed in earlier CPUs though?  If not that wouldn't
 > work 100% reliably because whatever cookie you put in could have been
 > there before by chance.

I wrote a test program (fill an area with zeroes, fxsave, inspect
reserved fields, then fill it with ones, fxsave, inspect again),
and all processors appear to just not write anything to the reserved
fields after the last xmm register. (Tested on an old Mobile Athlon64,
Opteron 280, P4 Xeon, Pentium-D, and C2 Xeon E5345.)

So the question now is what if anything has the Linux kernel written
to those reserved fields. (Looking..) Hmm, signal delivery on x86-64
seems to do fxsave directly to the fxsave area in the user's sigframe,
which would imply that the reserved fields have unpredictable values.

/Mikael
