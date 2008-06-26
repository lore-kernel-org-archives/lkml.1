Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbYFZRwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbYFZRwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYFZRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:52:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYFZRwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:52:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: Microblaze init port v4
Date: Thu, 26 Jun 2008 19:51:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261709.37045.arnd@arndb.de>
In-Reply-To: <200806261709.37045.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261951.12809.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX182uW+vzc0GyQ7xGC/KKj4ZGtpa/jff87h5NKv
 AnesFrtDmvHhDV3xfV+n3kvx/XVBpbINR5BL8k/dlXWOx8EXoF
 v/dJwK3XbG5+nIJxzEzEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Arnd Bergmann wrote:

> That still leaves the problem that a lot of your syscalls have bugs
> copied from other platforms. If you need to maintain backwards compatibility
> with your existing binaries, that's fine, but please fix the code you are
> adding.

Sorry for my harsh words here, I should have read your patch set before
commenting on the introduction.
Most of the interfaces look good now, there are really just details left
now.

So contrary to what we had discussed before, you seem to have decided
to try to maintain source level compatibility with old uClibc versions,
but dropped binary compatibility that does not make much sense on
your architecture (considering that people synthesize their CPU with
a custom instruction set and then build kernel and user space for that),
which sounds reasonable to me, based on the earlier discussion.

On a more detailed level, there are a number of decisions in your
syscall interface, so let me summarize what I see you have done
and please tell me if this was all intentional or just an arbitrary
decision that seemed good at some point:

* off_t is 32 bit, and you use both off_t and loff_t based syscalls:
This is required because uClibc calls both versions of the syscalls,
otherwise you'd need to add a lot of code in uClibc.

* You implement both legacy and rt signal interfaces, just like
everyone else does. It probably seemed like a good idea because
something might actually be using the legacy interfaces in
arch/microblaze/kernel/signal.c, but AFAICT, neither libc nor
uClibc has been using them in a very long time when they are
both present, certainly longer than microblaze has been around.
The fact that you never noticed the missing sigaltstack implementation
is a good indication that this code has never seen any testing
and probably has more bugs.

* You have not implemented the *at() family of syscalls, which seems
to be an accidental misimplementation, and you have consequently
not removed the older versions of these syscalls, which is
correct if you don't want to break source level compatibility.

* Your syscall list follows the exact same numbering as i386,
which is fairly unusual, but not incorrect, despite wasting
a little memory on the unused slots. I suppose you did this
in order to keep some level of binary compatibility with older
user code. Since you are subtly breaking compatibility now,
I would still recommend changing all the numbers so that you
can guarantee that every old binary is obviously broken
instead of showing random problems.

* You are using sys_ipc and sys_socketcall instead of the
broken-out syscalls, which is a direct consequence of following
the i386 numbering scheme.

* You have defined both stat and stat64, with different definitions.
uClibc does have a copy of the two struct definitions, so you can't
easily change them without changing uClibc as well. Otherwise it
would have been good to define struct stat in the same way as
struct stat64, and only provide sys_stat but not sys_stat64 as
a syscall.

* I have already commented on the __ARCH_WANT_SYS_* macros you
define. Independent of the off_t, signal and *at() syscalls, I
think you should reduce the number of them by as much as you
can without breaking uClibc support. You can probably remove
almost all of them (not __ARCH_WANT_SYS_RT_SIGACTION,
__ARCH_WANT_STAT64 and __ARCH_WANT_SYS_SOCKETCALL, as I mentioned).

* Your syscall_table now contains two entries for each of the
uid32 functions, e.g __NR_setreuid32 and __NR_setreuid have
different numbers but both point to sys_setreuid.
No problem here, but a little unusual. As with the other functions
I mentioned, uClibc and glibc always call the *32 variant if that
is defined and the other one if it's not. I would suggest doing either
#define __NR_setreuid32 __NR_setreuid
#define __NR_setreuid 203
or (better)
#undef __NR_setreuid32
#define __NR_setreuid 203
to make the architecture more regular in this regard.

	Arnd <><
