Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbYEEOJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbYEEOJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYEEOJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:09:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYEEOJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:09:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Williams <john.williams@petalogix.com>
Subject: Re: microblaze syscall list
Date: Mon, 5 May 2008 16:08:59 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, Matthew Wilcox <matthew@wil.cx>,
       Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>, Ulrich Drepper <drepper@redhat.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200805031116.50236.arnd@arndb.de> <481E5E58.8040906@petalogix.com>
In-Reply-To: <481E5E58.8040906@petalogix.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200805051609.01628.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18GQrLMGI62OVWm7ORpLICUs3XoIN7G86cUfsy
 WzkTjDWUCxaGgy33FtMvN0oGBHqz+kGuLkMk3JNxDvpuwNk6dl
 FInOMMyCUnjo+zu5VVrmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, John Williams wrote:
> Arnd Bergmann wrote:

> OK.  Our glibc patches are against 2.3.3.  I realise it's not the most 
> recent, but it's the best we've got for now.

Right, glibc-2.3 was from 2002, 2.3.3 was released in 2004, which is
still pretty ancient.
 
> > What is not yet there is code to implement open() using openat() in the
> > absense of __NR_open.
> 
> >> I guess we need some help to find the other critical ones.
> > 
> > I think your approach is flawed, it doesn't help at all to look at what
> > your libc currently does if you already think that you will need to change
> > the libc code.
> 
> I can't help but feel we've got our wires crossed here.
> 
> If, for example, neither C library has code to use openat in the absence 
> of __NR_open, then surely it is premature to remove __NR_open from any 
> arch, microblaze included?

For any incompatible change of this sort, you have to do it in the kernel
and libc in parallel. What we're talking about here is much closer to
doing a new glibc port based on microblaze linux-2.6.26 and glibc-2.8+
rather than using the existing glibc-2.3.3 port.

I understand that you care most about uClibc, because that is what
practically anyone is using, but glibc is setting the standard
that uClibc is following.

>From what I understand from Uli, he won't add an implementation of
open() based on openat() unless there is any architecture actually
using it, so there is no point in waiting for glibc here.

> > A more relevant question is what changes should be done in glibc for this
> > in the first place, and I would like to hear Ulis opinion on that.
> 
> This is all very reasonable, but it's not clear why broad changes in 
> glibc would be part of MicroBlaze's critical path into kernel.org. 
> There are already N arch's in the kernel using mixture of obsolete and 
> new API's, I don't see the problem with MicroBlaze making it N+1.

You're probably right that it's not fair to microblaze to demand that
you do it right when all existing architectures before did the wrong
thing. For me it's just the pain of reviewing the same bugs being copied
in every single new Linux port, so my agenda here is to be able to point
the next guy at microblaze, telling them to copy from you instead of
from x86 or m68k.

> I'm not interested in a glibc vs uClibc debate. For deeply embedded 
> systems that MicroBlaze targets, uClibc's smaller footprint makes a lot 
> of sense.
>
> The installed base of uClibc vs glibc for MicroBlaze is probably 10000:1 
> or more in uClibc's favour due to our history being entirely !MMU until 
> 2008.  I don't expect that to change much once we get the MMU and ld.so 
> functionality into our uClibc port.

I wasn't trying to argue against uClibc at all, there is nothing wrong
with you using it. My point was that the (architecture independent)
uClibc developers should take a look at your list and implement the
syscalls, so that you can easily port applications using them from glibc.

> egrep -R \ 
> "(\<$syscall\>|_syscall[0-9].*\<${syscall/#__NR_/}\>|INTERNAL_SYSCALL.*\<${syscall/#__NR_/}\>|INLINE_SYSCALL.*\<${syscall/#__NR_/}\>)"
>   $GLIBC_PATH
> 
> Not implemented/referenced in glibc
> __NR_add_key
> __NR_alarm
> __NR_capget

Looking at glibc-2.8, what I found using your method are:

# not in the scope of glibc currently, but may be used elsewhere:
add_key
keyctl
request_key
get_robust_list
set_robust_list
io_cancel
io_destroy
io_getevents
io_setup
io_submit
ioprio_get
ioprio_set
kexec_load
lookup_dcookie

# used under a different name:
newfstat
newlstat
newstat
newuname
pselect7

# used by the kernel itself:
restart_syscall

# obsolete, should not be used anywhere:
sgetmask
ssetmask

All others from your list are referenced in the glibc source somewhere.

	Arnd <><
