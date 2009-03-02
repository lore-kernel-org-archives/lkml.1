Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZCBP7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZCBP7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZCBP7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:59:20 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:36200 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZCBP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:59:19 -0500
MIME-Version: 1.0
In-Reply-To: <1236004353.10055.49.camel@andreas-laptop>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
	 <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	 <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	 <1235216636.7025.1023.camel@andreas-laptop>
	 <1236004353.10055.49.camel@andreas-laptop>
Date: Mon, 2 Mar 2009 16:59:17 +0100
Message-ID: <ac3eb2510903020759j100adbdekf2067d142adbfbbe@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andreas Robinson <andr345@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 15:32, Andreas Robinson <andr345@gmail.com> wrote:
> I have finished testing parallel module loading. It looks like a small
> kernel with a minimal initramfs and running several instances of insmod
> or modprobe in parallel has the best complexity to performance ratio.
>
> Testing shows that a megamodule is slightly slower than parallel
> insmods, so it's not really an option anymore.

That's what I expected, that we would need more changes, to make a
mega-module working, because we need parallel code execution here.

> A monolithic kernel with parallelized initcalls is better - about 200 ms
> faster than parallel insmods on my test system. However, it comes with a
> fairly large set of changes:
>
> * First, you need a 200-line patch in init/main.c (do_initcalls() and
> friends)
>
> * Then the built-in module dependencies must be calculated properly, eg
> with a modified depmod, and added to the build process.
>
> * Finally "soft" dependencies, i.e dependencies that are not implied by
> symbol use, have to be formalized and moved into the kernel somehow.
> Right now they're only defined in "install" commands in modprobe.conf.
>
> So, what do you think, should I keep going? IMHO, the slower userspace
> implementation is acceptable since it's so much simpler.

I think so too, and think we are fine using the current standard
tools. Also the recent modprobe changes make modprobe very fast by
using a binary index to resolve aliases. I think, we can leave the
stuff as it is.

Seems with the queued stop-machine()-removal patch, and possibly with
the minimized-mutex patch Rusty did, we are fine for now -- at least
with the current numbers, and from a distro's point of view.

Most of the "module load delay" distros see, are likely caused by I/O
loading the module from disk into the kernel, at least that's what my
profiles show. I did all the recent tests (which is a real world udev
coldplug) with a ramfs mount containing a copy of the module
directory, before running the module autoloader. I can link 40 modules
in 0.26 seconds into the kernel with the recent kernel patches.

Thanks for all your testing, it was really helpful, and your patches
have been the reason we've found the stop-machine problem. I'm glad
that we have real numbers now to point people to. It seems, that we
don't need to start fiddling around with hacks in userspace or
initramfs tools.

Thanks a lot,
Kay
