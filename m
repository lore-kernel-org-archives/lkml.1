Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZGON1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZGON1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZGON1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:27:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZGON1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:27:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: access_ok macor
Date: Wed, 15 Jul 2009 15:27:07 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: John Williams <jwilliams@itee.uq.edu.au>, monstr@monstr.eu,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
References: <4A5C8068.6020203@monstr.eu> <200907151214.52369.arnd@arndb.de> <20090715120512.GA2752@linux-mips.org>
In-Reply-To: <20090715120512.GA2752@linux-mips.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907151527.08341.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18E4/8vYTU4YS0VfOuZSlHBsrK7tj+N7OJ2LlY
 ucfw+BLZhL6CYT38L6VCXMpL5p238UTcJWOSc2ws69QXrqRftR
 MqdW99ExUGHwJpNQ5OgDw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 July 2009, Ralf Baechle wrote:
 
> > I think in step 4. AFIACT, the kernel must do a number of checks on accesses
> > to random pointers.
>
> Yes; but the checks that unaligned.c does on MIPS are no different from
> any other get_user(), that is it ensures that the entire 8/16/32/64-bit
> access is in userspace.  That's done using access_ok().

Well, access_ok() plus the fixup code for unmapped or write-protected user
pages, I guess. But I agree, there are no checks beyond what get/put_user
does. In particular, the access_ok() check should only be needed for
faults from user space, while any fault coming from kernel space is
either some kernel code accessing its own data (as you mention below) or
a __get_user/__put_user that has already checked access permissions.

In my example, I got the case from kernel space wrong, it should not
check access_ok() if !user_space(regs), or it needs to do set_fs(KERNEL_DS)
first, like the mips code does.

> We've moved on.  Handling miss-alignment is no longer a very relavent part
> of the syscall interface.  So I think for the definition of the Linux
> ABI this should just be left as implementation defined behaviour but
> whatever an architecture does, it should be done consistently for all
> system interfaces.

Ok, thanks, for explanation.

I guess for the microblaze unaligned handler, both cases mean that
it needs to do a fixup table lookup for the original fault and
it needs to handle fixups on its own emulation code. The only difference
between disallowing unaligned accesses in the ABI and allowing them
is which of the two ways (check fixup table, emulate instruction) it
tries first.

	Arnd <><
