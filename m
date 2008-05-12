Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYELW4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYELW4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYELW4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:56:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:60295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbYELW4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:56:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Williams <john.williams@petalogix.com>
Subject: Re: Microblaze toolchain - libc
Date: Tue, 13 May 2008 00:56:12 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       microblaze-uclinux@itee.uq.edu.au,
       Grant Likely <grant.likely@secretlab.ca>
References: <4826FD34.5030009@seznam.cz> <1210545788.5798.273.camel@localhost>
In-Reply-To: <1210545788.5798.273.camel@localhost>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805130056.13950.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX192Zza7nSnkm2/LZHg25vpWmi57UXuoMsA6NZe
 97zJZdFrtILiGKf9uZlctWq5WEO6pet39UeUTpEZekI6g2aUYP
 Wh4KrOFOHdR3xN+V6l3hw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2008, John Williams wrote:
> > is it any movement in libc?
> > I would like clear code around syscalls.
> 
> I can't see anything radical happening with glibc / uClibc in the short
> term.  My suggestion is you make sure the kernel builds with current
> toolchain.  

What happened to the idea of making it an add-on patch for the short
term then?

I think you should use the short generic syscall list in the mainline
series, and add source level support for uClibc back in as an out-of-tree
patch, under an #ifdef.

I guess that you can mostly do this by adding back the currently
required syscalls for uClibc at the end of sys_call_table, and
introducing a new file with the old implementation of the removed
arch specific calls (ipc, vfork, mmap, ...).

BTW: after a private discussion I had with some other kernel hackers,
I believe now that it will be easier for you to leave off_t as
32 bit but instead make sure that you only list the syscalls using
loff_t, e.g. stat64 instead of new_stat, contrary to what I claimed
earlier. You should probably try that yourself and do whatever
is easier to implement in uClibc.

> I'm not personally concerned about minor bloat of adding syscalls like
> openat() that are not currently used - 1 or 2 K for extra entries in
> syscall table, and a few hundred bytes per sys_wrapper really is not on
> the radar if glibc is considered a sensible library for Microblaze +
> MMU!

You still have it backwards -- you need to have openat() anyway because
applications can legally call that function, and if uClibc doesn't have
it, that's just a bug. The discussion was about leaving out the open()
syscall in favour of a libc based implementation based on openat().
Besides, these syscalls don't matter much, as you said those only save
a few bytes.
The real killers are uid16, 32 bit off_t, old style signals and some
minor annoyances things like sys_ipc(). If you change those, you might
just as well get it right because you're breaking compatibility already.

	Arnd <><
