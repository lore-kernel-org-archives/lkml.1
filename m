Return-Path: <linux-kernel-owner+w=401wt.eu-S934125AbYD1Mbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125AbYD1Mbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765164AbYD1Mbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:31:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:54360 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765378AbYD1Mbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:31:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Williams <jwilliams@itee.uq.edu.au>
Subject: Re: microblaze syscall list
Date: Mon, 28 Apr 2008 14:31:25 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, microblaze-uclinux@itee.uq.edu.au,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200804272215.32862.arnd@arndb.de> <48151726.9000204@itee.uq.edu.au>
In-Reply-To: <48151726.9000204@itee.uq.edu.au>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281431.26570.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+3fKbQef1YZhUOwmB7Sj3IZ0SwyxW2YlyAeRB
 Z0p4isDFXjW2h213Wv+laS8k5IC8ABfgwzt87GXCRh+nC5bKxI
 kra6y1apuyLIGiE36sakg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, John Williams wrote:
> 
> Until very recently with the MMU support added to the CPU (and upcoming 
> MMU support patches for MicroBlaze), all apps were statically linked 
> anyway. So, this is not too much of an issue I don't think.
> 
> Because the CPU is so configurable re: instruction set and features, it 
> is common to rebuild your entire userland and libs + kernel in one go. 
> If you add support for HW integer mul or div, barrel shift etc, you need 
> to rebuild not just the kernel but apps and libs as well.  Or rather, 
> rebuild apps, and relink against a different multilib'd libc.

If this is the common case, that is a good argument for breaking the ABI
completely now. You will just require a new libc build with a new kernel.

> So, the issue seems not so much that there's a bunch of legacy binaries 
> out there that will break, but rather that there will be a dead-zone 
> period in which the kernel is exporting an ABI that is simply not 
> available in the C libs and existing toolchains.  We should be doing all 
> we can to encourage individual developers and distro maintainers (like 
> PetaLogix) to base from the kernel.org tree.

As far as I can tell, these distrbutions typically come with both
kernel and libc source code together. It would be logical to just
require updating both here as well.

> Maybe I misunderstand, but is there an option 1(a) where we keep the 
> old, add the new, and suffer the bloat for a short period until the 
> toolchains and C libs catch up and we remove out the old interfaces?
>
> Are the old and new syscalls necessarily overloaded onto the same 
> numbers?  We'd obviously like to be as "standard" as reasonably possible 
> regarding syscall numbers

It's more than just the syscall numbers that should ideally change.
The other changes I would recommend include moving to large file
types (64 bit off_t), 32 bit UIDs, cleaned up sysV-IPC types, and a
few others. All these break the user code in the same way that changing
the instruction set does, which is the reason that we can't change
any of the existing architectures that started out in the old days.

The syscall numbers are entirely arbitrary, that's why I suggested
in my approach 3. that you introduce a new set of syscall numbers for
the new ABI, and keep compatibility with the old calls in their existing
numbers as an out-of-tree patch.

If you assume that the user recompiles the libc and the kernel together,
you can obviously change syscall numbers and data types in any way you
please, but still I'd suggest you don't change them after the kernel
gets merged upstream.

How about this strategy then:
* Change all the data types and syscall numbers in the -for-2.6.27
branch to only include the minimal set, and a modern ABI
* Add the old interfaces as an out-of-tree patch that adds source
level compatibility with the old libc, but does not modify any
of the new interfaces, so that a patched kernel can run all binaries
built for the upstream version.
* phase out the old source interface gradually, as all users update
their libc source code.

This way, early adopters suffer the pain of incompatibility twice, but
get the clean kernel port quickly.

	Arnd <><
