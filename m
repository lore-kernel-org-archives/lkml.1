Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYB0Tzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYB0Tzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758277AbYB0Tzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:55:42 -0500
Received: from www.tglx.de ([62.245.132.106]:43804 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173AbYB0Tzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:55:42 -0500
Date: Wed, 27 Feb 2008 20:55:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc3 hangs in early boot on Sun Ultra5
In-Reply-To: <20080227.110538.160750982.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0802272049580.7583@apollo.tec.linutronix.de>
References: <20080226.164900.193701385.davem@davemloft.net> <20080226.170613.107688605.davem@davemloft.net> <alpine.LFD.1.00.0802270858450.7583@apollo.tec.linutronix.de> <20080227.110538.160750982.davem@davemloft.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, David Miller wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 27 Feb 2008 09:02:22 +0100 (CET)
> 
> > On Tue, 26 Feb 2008, David Miller wrote:
> > > What the FUTEX checking code is doing now is doing a "user" access
> > > with set_fs(KERNEL_DS) since it runs from the kernel bootup early init
> > > sequence.  And this is illegal according to the existing checks.
> > > 
> > > When we do set_fs(KERNEL_DS) then pass a "user" pointer down
> > > into a system call or something like that, we give it a pointer
> > > that "cannot fault".  So if we get into the fault handling
> > > path here for a case like that we really do want to scream and
> > > print out an OOPS message in my opinion.
> > 
> > So it would be correct to set_fs(USER_DS) then do the check and switch
> > back to KERNEL_DS ?
> 
> No, I'm saying it would be better not to take faults purposefully in
> the kernel address space.

I would have preferred not to. The hassle is that we need to figure
out, whether it works or not _before_ any user space program can use
the interfaces. We could omit the check for archs where the
in_atomic_cmpxchg is guaranteed to be functional.

> We don't have a usable user address space
> setup at this point in the boot, so using USER_DS would be even worse.

Ouch, yes. Stupid me.

> I think I'll just add a different version of the sanity check to this
> sparc64 code later on, one that will take into consideration this
> KERNEL_DS case because I can see how it could be useful in other
> circumstances.

Ok.
 
Thanks,
	tglx
