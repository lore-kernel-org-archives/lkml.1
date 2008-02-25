Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYBYNBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYBYNBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYBYNBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:01:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbYBYNBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:01:34 -0500
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: [PATCH 0/3] xen pvfb: Para-virtual framebuffer, keyboard and pointer
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 25 Feb 2008 14:00:16 +0100
Message-ID: <87tzjx6vj3.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pair of Xen para-virtual frontend device drivers:
drivers/video/xen-fbfront.c provides a framebuffer, and
drivers/input/xen-kbdfront provides keyboard and mouse.

The backends run in dom0 user space.

Differences since last post:

* Required patch fixing 32-on-64 xen-blkfront included.

* Cleanup when xenkbd_probe() fails fixed.

* Don't store event channel in device info.

I started with the Xen version at
http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/ca05cf1a9bdc

Differences to that Xen version, for those who care:

* Rewritten on top of fb deferred I/O

* IRQ handler names visible in /proc and /sys match the driver names.

* Use framebuffer helper functions appropriate for framebuffer in
  system RAM.

* write() refreshes the framebuffer properly.

* off-by-one height of some screen refreshs fixed.

* Crash when register_framebuffer() fails fixed.

* Test for empty ring in input_handler() fixed.

* Deadlock in xen-kbdfront resume fixed.

* Cleanup when xenkbd_probe() fails fixed.

* General clean up.

I have a step-by-step patch series from that Xen version to my
version, if anybody is interested.  Might be useful for reviewers
familiar with the Xen version.

The patch consists of three parts:

1. xen: Make xen-blkfront write its protocol ABI to xenstore

   Could do without, but then I'd have to put the same bug in
   xen-fbfront and xen-kbdfront.

2. fbdev: Make deferred I/O work as advertized

   I need fb deferred I/O, but is utterly broken.  A fix has been
   floating around on linux-fbdev-devel as part of a larger patch,
   which as far as I know has not been merged anywhere, yet.  This is
   just the fix.

2. xen pvfb: Para-virtual framebuffer, keyboard and pointer driver

   The actual drivers.
