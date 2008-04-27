Return-Path: <linux-kernel-owner+w=401wt.eu-S1764728AbYD0UQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764728AbYD0UQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763445AbYD0UPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:15:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:57755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763404AbYD0UPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:15:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: microblaze syscall list
Date: Sun, 27 Apr 2008 22:15:31 +0200
User-Agent: KMail/1.9.9
Cc: microblaze-uclinux@itee.uq.edu.au, Matthew Wilcox <matthew@wil.cx>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <4813DF3E.6080800@itee.uq.edu.au> <4814A153.3040600@seznam.cz>
In-Reply-To: <4814A153.3040600@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804272215.32862.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ynDQCZnyaao2DvnhEeoVgTfaw4mOMA1PHCSw
 4XwVe2h++HS+wcCwZbqFRjOEfhCc26OkTgt/TF0pk/1CvE5n1T
 LmSpDooi6LHP48mgDKPjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 April 2008, Michal Simek wrote:
> Arnd commented current syscall table and send me long email about(Thanks again).
> On the base on this email I did converted table for future use - for porting old
> application to new version. Below is my table with syscalls and there is a short
> description. (or http://www.monstr.eu/wiki/doku.php?id=kernel:syscall)
> 
> I counted how big impact will be syscall change to programs which are in John W
> distribution
> all programs
> mknod - 174
> rmdir - 488
> mkdir - 1128
> symlink - 404
> rename - 1536
> access - 1664
> chmod -  1122
> open - 22583 (crazy)
> ipc - 26
> 
> Only busybox
> open - 667
> chmod 44
> access 52
> rename 32
> symlink 8
> mkdir 19
> rmdir 9
> mknod 16
> 
> I thing you understand that we can't change all application per night. This is
> not possible. But we have to start with change this.

Note that the only thing you should need to change is the libc implementation
(any version of it: glibc, uclibc, klibc, ...), but not any application source
code, as the applications just call the functions that are defined in the libc.
If you have binaries that are statically linked with their libc, you'd have
to recompile or at least relink them. If you redefine data structures or
types that are used in application code, like struct stat or off_t, you
also need to recompile all user code.

Of course, as Alan and others have mentioned, even without changing any
application source code, the amount of work for that is significantly more 
than just changing the kernel.

I think you have three options here:

1. Keep the old syscall interface and just add new syscalls for the stuff
that you are currently missing. Don't change userspace at all, but live
with somewhat bloated kernels and libc forever and maintain a larger
code base in the kernel.

2. Change the syscall interface in the kernel in the way we have discussed,
and adapt the libc code along with it. Break all backwards compatibility
and start out with a new leaner ABI. Old applications can still use
your old out-of-tree kernels, or forks of that.

3. Merge only the ABI as in 2. into the mainline kernel, but use new
syscall numbers for that. Maintain an out-of-tree patch that adds the
old ABI for backwards compatibility so you can run old and new code
on one kernel if you build with that patch, but eventually phase
out the old ABI.

I won't try to force you to go either route, it's your own decision,
but you should understand the tradeoffs. I don't think there is any
value in trying to deprecate just part of the ABI and break some
binaries but not others, this will only cause hard to find bugs. Make
sure that if you decide to break backwards compatibility, you break it
in an obvious way and get the most benefit out of it.

	Arnd <><
