Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYJXNKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYJXNKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYJXNK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:10:27 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:54034 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbYJXNK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=njWLi82F7cCZPTDy7iJVb1SbLY/I52blTG3hFoFEez10MdnFiqmeBmk5oLXjuHrxJg
         1Z8KpXQomGE9tsonzQbHpkXyIT88kesJHLxivKgU1rYhinm3yIIaBmXpsbJbets4+98V
         W8xuGNr14ococtvreWrnFg9Qy3hpjKeYQUshQ=
Date: Fri, 24 Oct 2008 17:13:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc1
Message-ID: <20081024131340.GB24358@x200.localdomain>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <200810241224.38541.alistair@devzero.co.uk> <200810241345.04966.rjw@sisk.pl> <200810241352.45745.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810241352.45745.alistair@devzero.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 01:52:45PM +0100, Alistair John Strachan wrote:
> On Friday 24 October 2008 12:45:04 Rafael J. Wysocki wrote:
> > On Friday, 24 of October 2008, Alistair John Strachan wrote:
> > > On Friday 24 October 2008 05:10:29 Linus Torvalds wrote:
> > > > It's been two weeks, so it's time to close the merge window. A
> > > > 2.6.28-rc1 is out there, and it's hopefully all good.
> > >
> > > It seems if you have a broken asm/ symlink in include/ (which happened as
> > > a result of the x86 header moves, for me) the kernel won't try to update
> > > it appropriately, and this breaks "make prepare".
> > >
> > > $ make    ARCH=x86_64 prepare
> > >   CHK     include/linux/version.h
> > >   CHK     include/linux/utsrelease.h
> > >   GEN     include/asm/asm-offsets.h
> > > /bin/sh: include/asm/asm-offsets.h: No such file or directory
> > > make[1]: *** [include/asm/asm-offsets.h] Error 1
> > > make: *** [prepare0] Error 2
> > >
> > > rm -f include/asm fixes it
> > >
> > > This was just from taking a 2.6.27 tree, git clean -d -f, git pull, make
> > > oldconfig. Might be a nice thing to fix?
> >
> > Hm, I didn't have any problems with compiling .28-rc1 on x86_64.
> >
> > [Confused.]
> 
> This should reproduce it (whether or not it's a use-case we care about is 
> another matter). First, make sure your include/asm symlink has been removed, 
> then execute the following sequence:
> 
> git reset --hard v2.6.27 ; git clean -d -f
> git status ("Nothing to commit")
> 
> cp /path/to/config .config
> make oldconfig prepare
> git clean -d -f ; git reset --hard
> git status ("Nothing to commit")
> 
> Observe at this point that include/asm is valid and points to include/asm-x86, 
> despite the clean and reset (I guess this file is being ignored). Now:
> 
> git reset --hard v2.6.28-rc1 (Or whatever other method you might choose)
> git clean -d -f (Removes include/asm-x86)
> 
> Observe at this point that include/asm is now invalid, and still points to the 
> removed include/asm-x86 directory.
> 
> cp /path/to/config .config
> make oldconfig prepare
> 
> Should fail at this point:
> 
> scripts/kconfig/conf -o arch/x86/Kconfig
> #
> # configuration written to .config
> #
> scripts/kconfig/conf -s arch/x86/Kconfig
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   CC      kernel/bounds.s
>   GEN     include/linux/bounds.h
>   CC      arch/x86/kernel/asm-offsets.s
>   GEN     include/asm/asm-offsets.h
> /bin/sh: include/asm/asm-offsets.h: No such file or directory
> make[2]: *** [include/asm/asm-offsets.h] Error 1
> make[1]: *** [prepare0] Error 2
> make: *** [prepare] Error 2
> 
> Can you confirm?
> 
> I checked out Makefile and I believe it occurs because the current checks only 
> make sure a symlink exists, and if it does exist that its target matches up 
> with the selected architecture. It doesn't actually check the destination of 
> the symlink is valid.
> 
> I'd suggest that it should do that too, and if the destination doesn't exist, 
> re-write the symlink when it does "mkdir include/asm-x86" further down, but 
> I'm not a kbuild expert.

Use this script for super-clean project-agnostic clean:

	$ cat ~/bin/git-mrproper
	#!/bin/sh
	git-ls-files -o --directory -z | xargs -0 rm -rf


I'd say nothing should be done here, include/asm symlink autochange
because of different ARCH was unsupported due to it being "big" event, and
headers move is equally "big" event.
