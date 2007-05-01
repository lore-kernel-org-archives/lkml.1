Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXEAU2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXEAU2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965104AbXEAU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:28:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965211AbXEAU2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:28:37 -0400
Message-ID: <4637A29F.6070302@redhat.com>
Date: Tue, 01 May 2007 16:27:11 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: [git pull] New firewire stack
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As you may know, we've been working on a new FireWire stack over on
linux1394-devel.  The main driver behind this work is to get a small,
maintainable and supportable FireWire stack, with an acceptable
backwards compatibility story.

I've been talking to Stefan Richter about it and we feel that the new
stack is ready for inclusion into mainline.  What I'd like to propose
is that we carry both the new and the old stack in mainline for a few
releases.  Once we've reached a satisfactory level of stability and
worked through what regressions there may be, we can consider
deprecating the old stack.  Carrying two FireWire stacks in the kernel
at the same time is not ideal, but it allows for wider testing of the
new stack, while keeping the old stack as a fallback for cases where
regressions make the new stack not usable.

There's a lot of good reasons to switch to the new stack and a lot of
reasons to switch away from the old one.  Highlights:

  - Has been in Fedora rawhide (development branch) and -mm for 3
    months, will be shipping in Fedora 7.

  - Backwards compatible at the library level; existing user space
    libraries have been ported to use the new user space interface.

  - Less than 8k lines of code compared to 30k lines of code in the old
    stack, and a similar size reduction in the sizes of the .ko's.

  - No kernel threads, compared to one subsystem thread and one thread
    per FireWire controller in the old stack.

  - One user space interface to support zero-copy scatter-gather
    streaming, as opposed to the old stacks 4 (was 5) different
    streaming interfaces.

  - Per-device device files, letting userspace set up more finegrained
    access control, such as preventing direct access to FireWire
    storage devices.

Regressions:

  - eth1394 not ported over.  There is nothing preventing this from
    being done, though, but there's a couple of infrastructure bits
    that aren't done yet.

  - No support for the PCILynx chipset.  Nobody has this chipset
    anymore, and the pcilynx driver in the old stack is bit-rotting anyway.

  - Some SBP-2 (storage) devices fail after significant amounts of IO.
    Not clear what the problem is, but I can reproduce it here and am
    working on fixing it.

Please pull from the juju branch in Stefans repo:

git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git juju

thanks,
Kristian

  drivers/Makefile                  |    1 +
  drivers/firewire/Kconfig          |   60 ++
  drivers/firewire/Makefile         |   10 +
  drivers/firewire/fw-card.c        |  544 +++++++++++
  drivers/firewire/fw-cdev.c        |  954 +++++++++++++++++++
  drivers/firewire/fw-device.c      |  781 +++++++++++++++
  drivers/firewire/fw-device.h      |  149 +++
  drivers/firewire/fw-iso.c         |  163 ++++
  drivers/firewire/fw-ohci.c        | 1896 +++++++++++++++++++++++++++++++++++++
  drivers/firewire/fw-ohci.h        |  153 +++
  drivers/firewire/fw-sbp2.c        | 1165 +++++++++++++++++++++++
  drivers/firewire/fw-topology.c    |  519 ++++++++++
  drivers/firewire/fw-topology.h    |   94 ++
  drivers/firewire/fw-transaction.c |  889 +++++++++++++++++
  drivers/firewire/fw-transaction.h |  505 ++++++++++
  drivers/ieee1394/Kconfig          |    2 +
  include/linux/firewire-cdev.h     |  268 ++++++
  17 files changed, 8153 insertions(+), 0 deletions(-)
