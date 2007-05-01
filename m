Return-Path: <linux-kernel-owner+w=401wt.eu-S1423682AbXEAVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423682AbXEAVf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423690AbXEAVf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:35:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44463 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423682AbXEAVf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:35:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4637B271.8020701@s5r6.in-berlin.de>
Date: Tue, 01 May 2007 23:34:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [git pull] New firewire stack
References: <4637A29F.6070302@redhat.com>
In-Reply-To: <4637A29F.6070302@redhat.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
...
> Carrying two FireWire stacks in the kernel
> at the same time is not ideal, but it allows for wider testing of the
> new stack, while keeping the old stack as a fallback for cases where
> regressions make the new stack not usable.

IMO, giving the new stack full exposure will get us the required input
from developers and users so that a migration schedule can be prepared.

> There's a lot of good reasons to switch to the new stack and a lot of
> reasons to switch away from the old one.  Highlights:
> 
>  - Has been in Fedora rawhide (development branch) and -mm for 3
>    months, will be shipping in Fedora 7.

There were also a few enthusiasts who gave the new stack a spin via
patchkits which I used to publish.

>  - Backwards compatible at the library level; existing user space
>    libraries have been ported to use the new user space interface.
> 
>  - Less than 8k lines of code compared to 30k lines of code in the old
>    stack, and a similar size reduction in the sizes of the .ko's.
> 
>  - No kernel threads, compared to one subsystem thread and one thread
>    per FireWire controller in the old stack.
> 
>  - One user space interface to support zero-copy scatter-gather
>    streaming, as opposed to the old stacks 4 (was 5) different
>    streaming interfaces.
> 
>  - Per-device device files, letting userspace set up more finegrained
>    access control, such as preventing direct access to FireWire
>    storage devices.

Or in short, Kristian has been addressing a number of big TODOs of the
old stack with his reimplementation in a relatively short timeframe,
TODOs which haven't been worked on in the existing stack for years,
literally.  There are also some smaller but effective features in the
new stack like gap count optimization for better asynchronous
throughput, something which I never got around to implement for the
mainline stack because I have been busy with bugfixing and janitorial work.

> Regressions:
> 
>  - eth1394 not ported over.  There is nothing preventing this from
>    being done, though, but there's a couple of infrastructure bits
>    that aren't done yet.

Actually that's one of the reasons why I started to work on eth1394
recently.

>  - No support for the PCILynx chipset.  Nobody has this chipset
>    anymore, and the pcilynx driver in the old stack is bit-rotting anyway.
> 
>  - Some SBP-2 (storage) devices fail after significant amounts of IO.
>    Not clear what the problem is, but I can reproduce it here and am
>    working on fixing it.
> 
> Please pull from the juju branch in Stefans repo:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git juju
> 
> thanks,
> Kristian

Linus,

the juju branch is branched off v2.6.21-rc3, and it contains a linear
series of 121 commits:

Adrian Bunk (1)
Andrew Morton (4)
Kristian Høgsberg (91)
Marc Butler (1)
Randy Dunlap (1)
Stefan Richter (22)
Thomas Gleixner (1)

If you would rather have it rebased on e.g. 2.6.21 or otherwise
reorganized, or want to have the resulting diff posted for everyone to
look at, I'd gladly do that.

The stat as I get to see it locally and at master.kernel.org:

 drivers/Makefile                  |    1 +
 drivers/firewire/Kconfig          |   60 +
 drivers/firewire/Makefile         |   10 +
 drivers/firewire/fw-card.c        |  544 ++++++++
 drivers/firewire/fw-cdev.c        |  954 ++++++++++++++
 drivers/firewire/fw-device.c      |  782 +++++++++++
 drivers/firewire/fw-device.h      |  149 +++
 drivers/firewire/fw-iso.c         |  163 +++
 drivers/firewire/fw-ohci.c        | 1896 +++++++++++++++++++++++++++
 drivers/firewire/fw-ohci.h        |  153 +++
 drivers/firewire/fw-sbp2.c        | 1165 ++++++++++++++++
 drivers/firewire/fw-topology.c    |  519 ++++++++
 drivers/firewire/fw-topology.h    |   94 ++
 drivers/firewire/fw-transaction.c |  889 +++++++++++++
 drivers/firewire/fw-transaction.h |  505 +++++++
 drivers/ieee1394/Kconfig          |    2 +
 include/linux/firewire-cdev.h     |  268 ++++
 17 files changed, 8154 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firewire/Kconfig
 create mode 100644 drivers/firewire/Makefile
 create mode 100644 drivers/firewire/fw-card.c
 create mode 100644 drivers/firewire/fw-cdev.c
 create mode 100644 drivers/firewire/fw-device.c
 create mode 100644 drivers/firewire/fw-device.h
 create mode 100644 drivers/firewire/fw-iso.c
 create mode 100644 drivers/firewire/fw-ohci.c
 create mode 100644 drivers/firewire/fw-ohci.h
 create mode 100644 drivers/firewire/fw-sbp2.c
 create mode 100644 drivers/firewire/fw-topology.c
 create mode 100644 drivers/firewire/fw-topology.h
 create mode 100644 drivers/firewire/fw-transaction.c
 create mode 100644 drivers/firewire/fw-transaction.h
 create mode 100644 include/linux/firewire-cdev.h

-- 
Stefan Richter
-=====-=-=== -=-= ----=
http://arcgraph.de/sr/
