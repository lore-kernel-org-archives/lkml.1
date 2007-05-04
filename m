Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbXEDOzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbXEDOzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXEDOzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:55:24 -0400
Received: from ozlabs.org ([203.10.76.45]:34300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbXEDOzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:55:22 -0400
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <m1ps5gslfm.fsf@ebiederm.dsl.xmission.com>
References: <1178283582.23670.67.camel@localhost.localdomain>
	 <1178283724.23670.70.camel@localhost.localdomain>
	 <1178284052.23670.75.camel@localhost.localdomain>
	 <m1ps5gslfm.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 00:55:02 +1000
Message-Id: <1178290502.23670.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 08:38 -0600, Eric W. Biederman wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> > We can no longer assume the launcher has set the bss to zero: we now
> > need to zero it ourselves.
> 
> Ok.  Although we can hoist the bss zeroing, if everything needs it.

Hi Eric!

	Yeah, Jeremy said he wanted it for Xen.  This is the advantage of
having code in front of us tho.

> Are you booting with P=V now?  If not I expect you will run
> into trouble if you set CONFIG_RELOCATABLE.

	Yep... haven't tried CONFIG_RELOCATABLE tho.  It's kinda exotic 8)

> Hmm.  I'm wondering about the segment reload and how much of a problem
> that is.  My memory says that segment reloads are not actually a
> privileged operation, so we may be able to support this even in
> paravirt mode.  How hard would that be to support?  The segment
> we reload is a fixed part of our boot protocol.

It was a PITA because we can't just load $0x18 into %ss: it has to be
$0x19.  I started doing it (read %cs, mask off bottom 2 bits, orl
__BOOT_DS), but between that extra code and the extra code to then
change segments back...  well, we have to skip the cli anyway so it was
easy to skip them all.

I think Jeremy said Xen doesn't start on the boot descriptors either.  I
have to wonder why we don't just run on the boot descriptors forever
(#define __KERNEL_DS __BOOT_DS etc)?

> I guess this works.  You don't handle the old case of set_sectors == 0
> but I guess you don't support any kernels where that is the case.

Yes, I want to clean that up with proper checks for signatures
(currently, if it's not ELF, it's assumed to be a bzImage).  Might as
well at least error out if there's some surprise.

Thanks for the feedback!
Rusty.
Eric

