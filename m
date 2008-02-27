Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYB0TGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYB0TGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbYB0TFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:05:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55217
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757446AbYB0TFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:05:54 -0500
Date: Wed, 27 Feb 2008 11:05:38 -0800 (PST)
Message-Id: <20080227.110538.160750982.davem@davemloft.net>
To: tglx@linutronix.de
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc3 hangs in early boot on Sun Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0802270858450.7583@apollo.tec.linutronix.de>
References: <20080226.164900.193701385.davem@davemloft.net>
	<20080226.170613.107688605.davem@davemloft.net>
	<alpine.LFD.1.00.0802270858450.7583@apollo.tec.linutronix.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 27 Feb 2008 09:02:22 +0100 (CET)

> On Tue, 26 Feb 2008, David Miller wrote:
> > What the FUTEX checking code is doing now is doing a "user" access
> > with set_fs(KERNEL_DS) since it runs from the kernel bootup early init
> > sequence.  And this is illegal according to the existing checks.
> > 
> > When we do set_fs(KERNEL_DS) then pass a "user" pointer down
> > into a system call or something like that, we give it a pointer
> > that "cannot fault".  So if we get into the fault handling
> > path here for a case like that we really do want to scream and
> > print out an OOPS message in my opinion.
> 
> So it would be correct to set_fs(USER_DS) then do the check and switch
> back to KERNEL_DS ?

No, I'm saying it would be better not to take faults purposefully in
the kernel address space.  We don't have a usable user address space
setup at this point in the boot, so using USER_DS would be even worse.

I think I'll just add a different version of the sanity check to this
sparc64 code later on, one that will take into consideration this
KERNEL_DS case because I can see how it could be useful in other
circumstances.

> > Did this FUTEX change go into -stable too?
> 
> It's queued, AFAIK

Crap, I'll need to push my fix there too.
