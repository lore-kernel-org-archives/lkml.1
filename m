Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbYJRM3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbYJRM3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 08:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYJRM3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 08:29:38 -0400
Received: from 1wt.eu ([62.212.114.60]:4827 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYJRM3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 08:29:38 -0400
Date: Sat, 18 Oct 2008 14:28:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081018122851.GB25503@1wt.eu>
References: <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi> <20081018090117.GR24654@1wt.eu> <20081018100401.GA6535@cs181140183.pp.htv.fi> <20081018110826.GA25503@1wt.eu> <20081018115038.GB6535@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018115038.GB6535@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 02:50:38PM +0300, Adrian Bunk wrote:
> > this is becoming off-topic, but there are some points which need to be
> > addressed. Please if you want to reply afterwards, be kind to strip the
> > CC list.
> 
> sorry, but you can't publically spread misinformation (and even repeat 
> wrong things I already replied to earlier in this thread) and then 
> demand to not have the reply public.

It's not about not having it public, it's about not flooding people's
mailboxes with off-topic mails.

> > On Sat, Oct 18, 2008 at 01:04:01PM +0300, Adrian Bunk wrote:
> > I'm not judging that, they build like they want. If they want to build
> > on the final target and have as many build machines as they support,
> > it's their problem. It's just very amateurish.
> 
> Debian does it, it works, and there's nothing amateurish about it - it's 
> much easier than coping with all the problems faced with when trying to 
> cross-compile > 12.000 source packages.

It's easier as long as you have one build environment very close to the
target, which tends not to be possible anymore as time passes or for too
small devices.

> With <= 3 build machines per architecture.

and why not have 3 build machines at all ?

> > > Scratchbox [1], e.g. used for building the software in Nokias Internet 
> > > Tablets [2] or the ARM Linux Internet Platform [3], is a chrooted 
> > > cross-compilation environment.
> > > 
> > > Yes, it works.
> > 
> > I'm not saying it does not work, I'm saying it's far from being practical
> > when you want to support multiple architectures or targets, and that it
> > will do nasty things under you without letting you know.
> 
> Scratchbox easily allows switching between targets, no matter which 
> architectures they are for.
> 
> Can you describe the problems you have experienced more precisely?

Adrian, don't try to make me look like dumb by asking for specific
problems. Problems range from auto-detection of kernel version to
enable or disable feature X or Y, to endian detection and bit width
detection. If you don't believe me, it's just that you're used to
build completely OS-agnostic packages, which is perfectly fine, but
that doesn't seem to be completely the case given that you're feeling
you will get annoyed by breaking the openssl BUILD environment if
you make it run on a different kernel. *That* is the funny part,
since this build environment should not even require to run on Linux
at all! And believe me, I know that openssl is boring to build due
to many hard-coded things which require patching (mainly paths if my
memory is correct). But once that's done, it's done forever.

> > A build environment is what it is, a build environment. It contains
> > compilers, shells to run scripts, various interpreters and build tools,
> > possibily debuggers and editors, versionning systems, etc...
> 
> The build environment in the chroot is the correct release.    

No it isn't because you're saying that some of the packages check for
kernel version which is not the right one. So if you move your chroot
to another machine, it is susceptible to break because it relies on
the host's kernel version. So your chroot is not your build environment,
it's just part of it.

> > > Userspace ABIs of the kernel are usually stable.
> > 
> > Yes but they are not necessarily forward-compatible. If openssl believes
> > some feature is present in 2.6.521 because 521 is bigger than 233, you
> > will build a broken package which will not work with any distro running
> > your long-term 2.6.27 which does not have the feature introduced in .233.
> 
> I already addressed this previously in this thread:
> 
> I'm not even sure whether OpenSSL actually does anything with the 
> information: The script comes from the Apache foundation and
> claims to be "Similar to config.guess but much, much smaller."

You addressed it only for openssl and apache 1.3, that you used as
examples to object to a change of changing kernel version numbering
scheme. So do you have other examples of packages like this which
might break and might be more sensible to build environment's kernel
version ? Because if only apache 1.3 and openssl 0.9.8g are sensible,
the fix will be really quick using something like this in your build
scripts and makefiles :

uname() {
   if [ -n "$KERNEL_TARGET" ]; then
      echo $KERNEL_TARGET
   else
      /bin/uname "$@"
   fi
}

And BTW, if your build environment mimmics so well the target except
for uname, let's fix its uname tool to reflect the target version !

> > And when
> > you know how to fix packages so that chroot is not a problem, then you
> > know how to fix the package not to require a chroot.
> 
> That's complete bullshit:
> 
> Packages do not require fixes for being built inside a chroot.
> 
> Given:
> - some software package of a foobar program
> - Scratchbox on an x86 host
> - an ARM target that mounts the target filesystem from the host
> 
> host   # ./configure && make && make install
> target # foobar
> 
> The build system of the software thinks it gets built on the target 
> architecture.

Quite cool stuff, but I'm really not interested. Having been beat by
a number of packages which try to run target environment commands
during the build when not set for cross-compile, I'd expect pretty
random results.

> And due to transparent usage of qemu or sbrsh it also works when the 
> package uses a program built for the target during the build.
> No matter whether the build system of the package knows anything about
> cross-compilation.

That's the design error you're trying to fix by pushing constraints on
the kernel.

Willy

