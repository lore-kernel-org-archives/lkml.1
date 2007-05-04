Return-Path: <linux-kernel-owner+w=401wt.eu-S1030882AbXEDPuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030882AbXEDPuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030878AbXEDPuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:50:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030882AbXEDPuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:50:11 -0400
Message-ID: <463B55F6.5030306@zytor.com>
Date: Fri, 04 May 2007 08:49:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>	 <1178283724.23670.70.camel@localhost.localdomain>	 <1178284052.23670.75.camel@localhost.localdomain>	 <m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <1178290502.23670.111.camel@localhost.localdomain>
In-Reply-To: <1178290502.23670.111.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 
> It was a PITA because we can't just load $0x18 into %ss: it has to be
> $0x19.  I started doing it (read %cs, mask off bottom 2 bits, orl
> __BOOT_DS), but between that extra code and the extra code to then
> change segments back...  well, we have to skip the cli anyway so it was
> easy to skip them all.
> 
> I think Jeremy said Xen doesn't start on the boot descriptors either.  I
> have to wonder why we don't just run on the boot descriptors forever
> (#define __KERNEL_DS __BOOT_DS etc)?
> 

You can't do that once you define your own layout, or you introduce a
nasty intermodule dependency which shouldn't exist.

The rule should be:

- You MUST NOT reload segments before LGDT.
  (One can possibly get away with declaring that DS = CS+8 by
  protocol and load dynamic values, but that's not a good thing.)
- After LGDT, you MUST load your own segment values.

Anything else is just broken.

	-hpa
