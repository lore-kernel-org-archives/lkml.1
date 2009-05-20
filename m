Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbZETR5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbZETR5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZETR5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:57:18 -0400
Received: from claw.goop.org ([74.207.240.146]:58401 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbZETR5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:57:18 -0400
Message-ID: <4A14447E.9060607@goop.org>
Date: Wed, 20 May 2009 10:57:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <20090519123548.GA26439@elte.hu>
In-Reply-To: <20090519123548.GA26439@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Since they are not performance critical, then why doesnt Xen catch 
> the IO-APIC accesses, and virtualizes the device?
>
> If you want to hook into the IO-APIC code at such a low level, why 
> dont you hook into the _hardware_ API - i.e. catch those 
> setup/routing modifications to the IO-APIC space. No Linux changes 
> are needed in that case.
>   

Yes, these changes aren't for a performance reason.  It's a case where a 
few lines change in Linux saves many hundreds or thousands of lines 
change in Xen.

Xen doesn't have an internal mechanism for emulating devices via 
pagefaults (that's generally handled by a qemu instance running as part 
of a guest domain), so there's no mechanism to map and emulate the 
io-apic.  Putting such support into Xen would mean adding a pile of new 
infrastructure to support this case.

Unlike the mtrr discussion, where the msr read/write ops would allow us 
to emulate the mtrr within the Xen-specific parts of the kernel, the 
io-apic ops are just accessed via normal memory writes which we can't 
hook, so it would have to be done within Xen.

The other thing I thought about was putting a hook in the Linux 
pagefault handler, so we could emulate the ioapic at that level.  But 
putting a hook in a very hot path to avoid code changes in a cold path 
doesn't make any sense.  (Same applies to doing PF emulation within Xen; 
that's an even hotter path than Linux's.)

    J
