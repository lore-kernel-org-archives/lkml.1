Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXCPQZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXCPQZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXCPQZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:25:22 -0400
Received: from gw.goop.org ([64.81.55.164]:45627 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857AbXCPQZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:25:20 -0400
Message-ID: <45FAC4EF.4060305@goop.org>
Date: Fri, 16 Mar 2007 09:25:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <m17itho10v.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m17itho10v.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I'm not quite familiar with the context.  And I'm to lazy to look right now.
> What is the difference with COMPAT_VDSO that it doesn't do relocation?
> What are we preserving?
>
>   

The issue is that with COMPAT_VDSO, the vdso gets mapped at two places:
one random address, and one fixed address (traditionally 0xffffe000 I
think, but that's not mandatory).  The important point is that the
fixed-address is the same one that the vdso itself is linked for, so
that old broken glibcs that some vendors shipped won't explode (because
they use AT_SYSINFO but not AT_SYSINFO_EHDR, so they don't account for
the difference in link and map address).

The problem with the COMPAT_VDSO with paravirt is that the hypervisor
may steal some of the kernel address space, and so push down the address
where the fixed address vdso can be mapped.

Zach's patch relocates the immobile COMPAT_VDSO version of the vdso page
so that map=link address, regardless of where the kernel's runtime
environment puts the top of the kernel address space.

I guess the other solution is to simply put the compat_vdso mapping at
some low address (like the top of the user address space), and not worry
about it moving.  I don't know if this would work, but I seem to
remember someone mentioning that it had been done in the past.

> The practical question here is if we already have all of the relocation logic
> for the VDSO why do we need to add more?
>   

The kernel doesn't normally ever relocate the vdso; usermode can
generally cope with it where ever it gets mapped.


    J
