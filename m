Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYJXMxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYJXMxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYJXMww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:52:52 -0400
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:17170
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbYJXMwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:52:51 -0400
X-Trace: 98104217/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEACBiAUnDlSwG/2dsb2JhbACBdr9Kg1A
X-IronPort-AV: E=Sophos;i="4.33,477,1220223600"; 
   d="scan'208";a="98104217"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.28-rc1
Date: Fri, 24 Oct 2008 13:52:45 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.28-rc1-damocles; KDE/4.1.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <200810241224.38541.alistair@devzero.co.uk> <200810241345.04966.rjw@sisk.pl>
In-Reply-To: <200810241345.04966.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241352.45745.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 12:45:04 Rafael J. Wysocki wrote:
> On Friday, 24 of October 2008, Alistair John Strachan wrote:
> > On Friday 24 October 2008 05:10:29 Linus Torvalds wrote:
> > > It's been two weeks, so it's time to close the merge window. A
> > > 2.6.28-rc1 is out there, and it's hopefully all good.
> >
> > It seems if you have a broken asm/ symlink in include/ (which happened as
> > a result of the x86 header moves, for me) the kernel won't try to update
> > it appropriately, and this breaks "make prepare".
> >
> > $ make    ARCH=x86_64 prepare
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   GEN     include/asm/asm-offsets.h
> > /bin/sh: include/asm/asm-offsets.h: No such file or directory
> > make[1]: *** [include/asm/asm-offsets.h] Error 1
> > make: *** [prepare0] Error 2
> >
> > rm -f include/asm fixes it
> >
> > This was just from taking a 2.6.27 tree, git clean -d -f, git pull, make
> > oldconfig. Might be a nice thing to fix?
>
> Hm, I didn't have any problems with compiling .28-rc1 on x86_64.
>
> [Confused.]

This should reproduce it (whether or not it's a use-case we care about is 
another matter). First, make sure your include/asm symlink has been removed, 
then execute the following sequence:

git reset --hard v2.6.27 ; git clean -d -f
git status ("Nothing to commit")

cp /path/to/config .config
make oldconfig prepare
git clean -d -f ; git reset --hard
git status ("Nothing to commit")

Observe at this point that include/asm is valid and points to include/asm-x86, 
despite the clean and reset (I guess this file is being ignored). Now:

git reset --hard v2.6.28-rc1 (Or whatever other method you might choose)
git clean -d -f (Removes include/asm-x86)

Observe at this point that include/asm is now invalid, and still points to the 
removed include/asm-x86 directory.

cp /path/to/config .config
make oldconfig prepare

Should fail at this point:

scripts/kconfig/conf -o arch/x86/Kconfig
#
# configuration written to .config
#
scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
/bin/sh: include/asm/asm-offsets.h: No such file or directory
make[2]: *** [include/asm/asm-offsets.h] Error 1
make[1]: *** [prepare0] Error 2
make: *** [prepare] Error 2

Can you confirm?

I checked out Makefile and I believe it occurs because the current checks only 
make sure a symlink exists, and if it does exist that its target matches up 
with the selected architecture. It doesn't actually check the destination of 
the symlink is valid.

I'd suggest that it should do that too, and if the destination doesn't exist, 
re-write the symlink when it does "mkdir include/asm-x86" further down, but 
I'm not a kbuild expert.

-- 
Cheers,
Alistair.
