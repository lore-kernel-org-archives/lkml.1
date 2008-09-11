Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYIKInu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYIKInu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYIKInm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:43:42 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:50762 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbYIKInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:43:41 -0400
From: Frans Pop <elendil@planet.nl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Date: Thu, 11 Sep 2008 10:43:33 +0200
User-Agent: KMail/1.9.9
Cc: davem@davemloft.net, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <20080910.160505.14060698.davem@davemloft.net> <1221088512.13621.58.camel@macbook.infradead.org>
In-reply-To: <1221088512.13621.58.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2oNyILgwPPNticg"
Message-Id: <200809111043.34847.elendil@planet.nl>
X-OriginalArrivalTime: 11 Sep 2008 08:43:37.0300 (UTC) FILETIME=[7B8EC940:01C913EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_2oNyILgwPPNticg
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

David Woodhouse wrote:
> On Wed, 2008-09-10 at 16:05 -0700, David Miller wrote:
>> Tell that to every Debian and Debian derived system on the planet.
>> 
>> To my knowledge, it is only fedora and possibly one or two other dists
>> that put the firmware files in a unary /lib/firmware location, rather
>> than a versioned /lib/firmware/$KERNELRELASE one.

I have to correct David M. here: *official* Debian packages _do_ have 
firmware in /lib/firmware and not in versioned subdirs.

The problem for Debian users is NOT official Debian kernel packages.
The problem is for people, like me, building their own kernels directly 
from upstream source *in the form of Debian packages*. More about this 
later.

It is also about the firmware change breaking *existing* tools used to 
this and *that* has always been the main argument from people like David 
M., Jeff Garzik and me. More about this in my second mail.

> It sounds like a daft arrangement to me -- although of course it's
> possible for the packager to do whatever they like, by overriding
> $(INSTALL_FW_PATH) in their package build.
> 
> It's definitely not something we should be doing upstream though.

David, you clearly fail to see the problem and it seems to me that you 
don't know the first thing about package management.

First let me get something off my chest, and sorry for shouting:
                 !!! THIS IS NOT ABOUT DEBIAN !!!

This has never been about Debian. It is about package management and 
backwards compatibility with existing tools be it package creation, 
package management or udev.

Let me start with a statement about package management.
    Software packages should not overwrite files installed by other
    software packages. Any package management system that allows a
    package to do that without complaining loudly is fundamentally
    broken.

This is a hard requirement in Debian. It is also the main reason why there 
are systems running Debian that have been installed 10 years ago, have 
been upgraded with each new Debian release (i.e. have never been 
reinstalled from scratch) and are still "clean" (without any file or 
library conflicts). In most cases Debian even allows you to _downgrade_ 
packages without any problem.

This is the "raison the existance" for distributions: to ensure software 
from different sources can be co-installed without conflicts. It also 
creates some limitations how packages are to be put together.

Problem description
===================
Premise: different kernel versions should be co-installable.

Consequence of this that different kernel versions will be different 
packages, not versions of the same package.

Example (simplified)
--------------------
Here is how *existing* packaging tools will create Debian kernel packages 
from upstream source for a few different versions.

linux-image-2.6.25_1_i386.deb contains:
/boot/vmlinuz-2.6.25-1
/lib/modules/2.6.25-1/...

linux-image-2.6.26_1_i386.deb contains:
/boot/vmlinuz-2.6.26-1
/lib/modules/2.6.26-1/...

linux-image-2.6.27-rc1_1_i386.deb contains:
/boot/vmlinuz-2.6.27-rc1
/lib/modules/2.6.27-rc1/...
/lib/firmware/firmware.dat

linux-image-2.6.27-rc1_2_i386.deb contains:
/boot/vmlinuz-2.6.27-rc1
/lib/modules/2.6.27-rc1/...
/lib/firmware/firmware.dat

linux-image-2.6.27-rc2_1_i386.deb contains:
/boot/vmlinuz-2.6.27-rc2
/lib/modules/2.6.27-rc2/...
/lib/firmware/firmware.dat

The package name consists of 4 parts; taking the first as example:
- linux-image-2.6.25 : package name, includes kernel version
- 1	: package version
- i386	: architecture
- deb	: extention

It is clear to see that 2.6.25_1, 2.6.26_1 and even 2.6.27-rc1_1 can be 
co-installed without problem: no file conflicts.
It is even possible to upgrade from 2.6.27-rc1_1 to 2.6.27-rc1_2 without 
problem: as the package *name* is the same the package manager will allow 
the firmware.dat file to be overwritten by the new version.

However, the package manager will complain loudly when you try to install 
2.6.27-rc2_1. Attached is a real life example from my own system when I 
try to install rc6 alongside rc5. The most relevant bits are:
<snip>
# dpkg -i linux-2.6.27-rc6_8.g98df367_amd64.deb
Unpacking linux-2.6.27-rc6 dpkg:
 error processing ../linux-2.6.27-rc6_8.g98df367_amd64.deb (--install):
 trying to overwrite `/lib/firmware/kaweth/new_code.bin',
 which is also in package linux-2.6.27-rc5
dpkg-deb: subprocess paste killed by signal (Broken pipe)
Errors were encountered while processing:
 linux-2.6.27-rc6_8.g98df367_amd64.deb
</snip>

The attachment also shows how I've been working around this:
<snip>
# dpkg -i --force-overwrite linux-2.6.27-rc6_8.g98df367_amd64.deb
Unpacking linux-2.6.27-rc6 dpkg - warning, overriding problem 
because --force enabled:
 trying to overwrite `/lib/firmware/kaweth/new_code.bin',
 which is also in package linux-2.6.27-rc5
</snip>
The '--force-overwrite' option disables the "duplicate files" check.

IMPORTANT: the packages in this case were *not* built using some vague 
Debian tool; they were built using the *in tree* option to build a Debian 
package (see scripts/package/builddeb):
$ fakeroot make -j4 deb-pkg

So the current kernel source builds fundamentally broken Debian packages!

Possible solutions
==================
There are two possible solutions to this.

1) Move the firmware files to a versioned directory (avoid the conflict)
This would give:

linux-image-2.6.27-rc1_1_i386.deb contains:
/boot/vmlinuz-2.6.27-rc1
/lib/modules/2.6.27-rc1/...
/lib/firmware/2.6.27-rc1/firmware.dat

linux-image-2.6.27-rc2_1_i386.deb contains:
/boot/vmlinuz-2.6.27-rc2
/lib/modules/2.6.27-rc2/...
/lib/firmware/2.6.27-rc2/firmware.dat

2) Move the firmware files into a separate package
This would give:

linux-image-2.6.27-rc1_1_i386.deb contains:
/boot/vmlinuz-2.6.27-rc1
/lib/modules/2.6.27-rc1/...

linux-firmware_2.6.27-rc1.1_i386.deb contains:
/lib/firmware/firmware.dat

linux-image-2.6.27-rc2_1_i386.deb contains:
/boot/vmlinuz-2.6.27-rc2
/lib/modules/2.6.27-rc2/...

linux-firmware_2.6.27-rc2.1_i386.deb contains:
/lib/firmware/firmware.dat

Note that the kernel version is now part of the package _version_ instead 
of the package _name_. The linux-firmware package can now be upgraded 
from version 2.6.27-rc1.1 to 2.6.27-rc2.1.

Analysis of the solutions
=========================
Oops, seems like we have a problem here.

As you rightly say, option 1) is not acceptable as it is not supported by 
e.g. older udev versions.
And option 2) is not acceptable because *existing* tools to build custom 
(!) kernels just do not split out firmware into a separate package like 
that. Why? Because until 2.6.27 they just did not need to!

And note that option 2) is almost certainly what will be used for 
*official* Debian packages. As others have already shown that method is 
*already* used by Debian for various firmware files, both from out of 
tree sources and split-off from in-tree source.

So the problem is basically that this issue cannot be resolved: existing 
tools will always break one way or the other. The *only* solution that 
allows users to build and run custom kernels using existing tools is to 
provide a compatibility option to build firmware into the kernel AND into 
modules, exactly as has been argued in the previous discussion.

Question to Jeff Garzik
-----------------------
Hi Jeff. You said you were planning on implementing an option to build 
firmware into modules. Care to give an update on that?

FAQ
===
Q: So why use Debian packages at all for custom kernels?
A: Essentially because it helps ensure my system remains clean while
   building, testing and especially removing multiple kernel versions.
   It also simplifies things like creating the initrd and updating the
   bootloader menu and having "upstream" kernels co-installed with
   official Debian kernels.

Q: So why did you not submit a patch to "fix" 'make deb-pkg'?
A: I had a look at implementing solution 1) for deb-pkg at some point,
   but the make complexity defeated my skills. I could not get the
   firmware location to change. Implementing solution 2) is even more
   complex.
   I would be happy to work with others to implement this though.

Cheers,
FJP

P.S. I am not a member of the Debian kernel team.


--Boundary-00=_2oNyILgwPPNticg
Content-Type: text/plain;
  charset="us-ascii";
  name="firmware.madness"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="firmware.madness"

$ sudo dpkg -i ../linux-2.6.27-rc6_8.g98df367_amd64.deb
(Reading database ... 164011 files and directories currently installed.)
Unpacking linux-2.6.27-rc6 (from .../linux-2.6.27-rc6_8.g98df367_amd64.deb) ...
dpkg: error processing ../linux-2.6.27-rc6_8.g98df367_amd64.deb (--install):
 trying to overwrite `/lib/firmware/kaweth/new_code.bin', which is also in package linux-2.6.27-rc5
dpkg-deb: subprocess paste killed by signal (Broken pipe)
arguments: 2.6.27-rc6 abort-install
Searching for GRUB installation directory ... found: /boot/grub
Searching for default file ... found: /boot/grub/default
Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
Searching for splash image ... none found, skipping ...
Found kernel: /vmlinuz-2.6.27-rc5
Found kernel: /vmlinuz-2.6.27-rc4
Found kernel: /vmlinuz-2.6.26.3
Found kernel: /vmlinuz-2.6.26-1-amd64
Found kernel: /vmlinuz-2.6.25-2-amd64
Found kernel: /vmlinuz-2.6.18-4-amd64
Updating /boot/grub/menu.lst ... done

Errors were encountered while processing:
 ../linux-2.6.27-rc6_8.g98df367_amd64.deb

$ sudo dpkg -i --force-overwrite ../linux-2.6.27-rc6_8.g98df367_amd64.deb
(Reading database ... 164011 files and directories currently installed.)
Unpacking linux-2.6.27-rc6 (from .../linux-2.6.27-rc6_8.g98df367_amd64.deb) ...
dpkg - warning, overriding problem because --force enabled:
 trying to overwrite `/lib/firmware/kaweth/new_code.bin', which is also in package linux-2.6.27-rc5
dpkg - warning, overriding problem because --force enabled:
 trying to overwrite `/lib/firmware/kaweth/trigger_code.bin', which is also in package linux-2.6.27-rc5
dpkg - warning, overriding problem because --force enabled:
 trying to overwrite `/lib/firmware/kaweth/new_code_fix.bin', which is also in package linux-2.6.27-rc5
dpkg - warning, overriding problem because --force enabled:
 trying to overwrite `/lib/firmware/kaweth/trigger_code_fix.bin', which is also in package linux-2.6.27-rc5
Setting up linux-2.6.27-rc6 (8.g98df367) ...
arguments: 2.6.27-rc6 configure
update-initramfs: Generating /boot/initrd.img-2.6.27-rc6
Searching for GRUB installation directory ... found: /boot/grub
Searching for default file ... found: /boot/grub/default
Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
Searching for splash image ... none found, skipping ...
Found kernel: /vmlinuz-2.6.27-rc6
Found kernel: /vmlinuz-2.6.27-rc5
Found kernel: /vmlinuz-2.6.27-rc4
Found kernel: /vmlinuz-2.6.26.3
Found kernel: /vmlinuz-2.6.26-1-amd64
Found kernel: /vmlinuz-2.6.25-2-amd64
Found kernel: /vmlinuz-2.6.18-4-amd64
Updating /boot/grub/menu.lst ... done


--Boundary-00=_2oNyILgwPPNticg--
