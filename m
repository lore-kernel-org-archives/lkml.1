Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbYD1AQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbYD1AQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYD1AQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:16:06 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:34647 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYD1AQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:16:04 -0400
X-ClientAddr: 220.233.82.121
Message-ID: <48151726.9000204@itee.uq.edu.au>
Date: Mon, 28 Apr 2008 10:15:34 +1000
From: John Williams <jwilliams@itee.uq.edu.au>
User-Agent: Thunderbird 1.5.0.12 (X11/20080403)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: monstr@seznam.cz, microblaze-uclinux@itee.uq.edu.au,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <4813DF3E.6080800@itee.uq.edu.au> <4814A153.3040600@seznam.cz> <200804272215.32862.arnd@arndb.de>
In-Reply-To: <200804272215.32862.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: jwilliams@itee.uq.edu.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann wrote:
> On Sunday 27 April 2008, Michal Simek wrote:

>> I thing you understand that we can't change all application per night. This is
>> not possible. But we have to start with change this.
> 
> Note that the only thing you should need to change is the libc implementation
> (any version of it: glibc, uclibc, klibc, ...), but not any application source
> code, as the applications just call the functions that are defined in the libc.
> If you have binaries that are statically linked with their libc, you'd have
> to recompile or at least relink them. If you redefine data structures or
> types that are used in application code, like struct stat or off_t, you
> also need to recompile all user code.

Until very recently with the MMU support added to the CPU (and upcoming 
MMU support patches for MicroBlaze), all apps were statically linked 
anyway. So, this is not too much of an issue I don't think.

Because the CPU is so configurable re: instruction set and features, it 
is common to rebuild your entire userland and libs + kernel in one go. 
If you add support for HW integer mul or div, barrel shift etc, you need 
to rebuild not just the kernel but apps and libs as well.  Or rather, 
rebuild apps, and relink against a different multilib'd libc.

So, the issue seems not so much that there's a bunch of legacy binaries 
out there that will break, but rather that there will be a dead-zone 
period in which the kernel is exporting an ABI that is simply not 
available in the C libs and existing toolchains.  We should be doing all 
we can to encourage individual developers and distro maintainers (like 
PetaLogix) to base from the kernel.org tree.

> I think you have three options here:
> 
> 1. Keep the old syscall interface and just add new syscalls for the stuff
> that you are currently missing. Don't change userspace at all, but live
> with somewhat bloated kernels and libc forever and maintain a larger
> code base in the kernel.
> 
> 2. Change the syscall interface in the kernel in the way we have discussed,
> and adapt the libc code along with it. Break all backwards compatibility
> and start out with a new leaner ABI. Old applications can still use
> your old out-of-tree kernels, or forks of that.
> 
> 3. Merge only the ABI as in 2. into the mainline kernel, but use new
> syscall numbers for that. Maintain an out-of-tree patch that adds the
> old ABI for backwards compatibility so you can run old and new code
> on one kernel if you build with that patch, but eventually phase
> out the old ABI.

Maybe I misunderstand, but is there an option 1(a) where we keep the 
old, add the new, and suffer the bloat for a short period until the 
toolchains and C libs catch up and we remove out the old interfaces?

Are the old and new syscalls necessarily overloaded onto the same 
numbers?  We'd obviously like to be as "standard" as reasonably possible 
regarding syscall numbers

> I won't try to force you to go either route, it's your own decision,
> but you should understand the tradeoffs. I don't think there is any
> value in trying to deprecate just part of the ABI and break some
> binaries but not others, this will only cause hard to find bugs. Make
> sure that if you decide to break backwards compatibility, you break it
> in an obvious way and get the most benefit out of it.

No argument there.

John


