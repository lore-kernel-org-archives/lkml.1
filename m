Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXEDPPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXEDPPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXEDPPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:15:31 -0400
Received: from gw.goop.org ([64.81.55.164]:34956 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046AbXEDPP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:15:29 -0400
Message-ID: <463B4E12.50703@goop.org>
Date: Fri, 04 May 2007 08:15:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain> <m1ps5gslfm.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ps5gslfm.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Ok.  Although we can hoist the bss zeroing, if everything needs it.
>   

It will if we're booting out of bzImage; the bss won't be clear in that
case.

> Hmm.  I'm wondering about the segment reload and how much of a problem
> that is.  My memory says that segment reloads are not actually a
> privileged operation, so we may be able to support this even in
> paravirt mode.  How hard would that be to support?  The segment
> we reload is a fixed part of our boot protocol.
>   

The problem is not the reloads themselves, but what you're reloading
them with.  If we come up under Xen, then it will provide a default GDT
and pre-load the segments with flat 4G(-ish) selectors - but the
selectors won't be the normal Linux ones.

So if we reload using a constant selector, then that will break under
Xen. But if we do a:

    mov %cs, %eax
    mov %eax, %ds
    // etc

sequence then it should be fine.  This will work even for loading %ss,
since the %cs CPL will equal the RPL needed for %ss.

    J
